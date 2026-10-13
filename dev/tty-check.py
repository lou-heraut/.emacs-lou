#!/usr/bin/env python3
"""Verifie qu'Emacs en terminal recoit les touches de la config.

Lance un daemon Emacs nomme "tty-check" sur la config, ouvre un cadre
`emacsclient -t` dans un pseudo-terminal, lui envoie les sequences qu'un
terminal produit pour chaque touche, et affiche ce qu'Emacs en a compris.
Le daemon est arrete a la fin ; le daemon habituel n'est pas touche.

Ce test mesure le cote Emacs. Ce que le terminal envoie vraiment pour une
touche se verifie a la main, dans ce terminal : `cat -v`, puis la touche.

Le lancer sur la vraie config. Sur une copie placee ailleurs, Emacs
recompile les paquets (eln-cache est indexe par chemin) et affiche des
avertissements de compilation qui ne viennent pas de la config.

Usage : python3 dev/tty-check.py [dossier-de-config]
        (par defaut, le depot qui contient ce script)
"""
import os
import pty
import select
import struct
import subprocess
import sys
import tempfile
import time

import fcntl
import termios

SOCKET = "tty-check"

# (touche attendue, sequence envoyee, origine de la sequence)
KEYS = [
    ("C-z",          b"\x1a",           "tout terminal"),
    ("S-<left>",     b"\x1b[1;2D",      "xterm, Konsole, kitty"),
    ("S-<right>",    b"\x1b[1;2C",      "xterm, Konsole, kitty"),
    ("S-<down>",     b"\x1b[1;2B",      "xterm, Konsole, kitty"),
    ("C-<up>",       b"\x1b[1;5A",      "xterm, Konsole, kitty"),
    ("C-<prior>",    b"\x1b[5;5~",      "xterm, Konsole, kitty"),
    ("C-x C-<left>", b"\x18\x1b[1;5D",  "xterm, Konsole, kitty"),
    ("C-<tab>",      b"\x1b[27;5;9~",   "Konsole"),
    ("C-<tab>",      b"\x1b[9;5u",      "protocole clavier kitty"),
    ("C-<return>",   b"\x1b[27;5;13~",  "xterm modifyOtherKeys"),
    ("C-<return>",   b"\x1b[13;5u",     "protocole clavier kitty"),
    ("C-S-<return>", b"\x1b[13;6u",     "protocole clavier kitty"),
    ("C-<return>",   b"\r",             "Konsole par defaut"),
]

PROBE = r"""
(defvar tty-check-log (getenv "TTY_CHECK_LOG"))
(defun tty-check-write (s)
  (with-temp-buffer (insert s) (append-to-file (point-min) (point-max) tty-check-log)))
(defun tty-check-record ()
  (tty-check-write (format "KEY\t%s\t%s\t%S\n"
                           (key-description (this-command-keys-vector))
                           (if this-command-keys-shift-translated "shift" "")
                           this-command)))
(add-hook 'pre-command-hook #'tty-check-record)
(defun tty-check-dump ()
  (tty-check-write
   (format "COLORS\t%d\n" (display-color-cells)))
  (when (get-buffer "*Warnings*")
    (tty-check-write (concat "WARNINGS\n" (with-current-buffer "*Warnings*" (buffer-string)))))
  (with-current-buffer "*Messages*"
    (dolist (line (split-string (buffer-string) "\n"))
      (when (string-match-p "\\(?:Warning\\|Error\\|error\\)" line)
        (tty-check-write (concat "MESSAGE\t" line "\n"))))))
"""


def drain(fd, seconds):
    end = time.time() + seconds
    while time.time() < end:
        ready, _, _ = select.select([fd], [], [], 0.1)
        if ready:
            try:
                os.read(fd, 65536)
            except OSError:
                return


def emacsclient(*args):
    return subprocess.run(["emacsclient", "-s", SOCKET, *args],
                          stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


def main():
    here = os.path.dirname(os.path.abspath(__file__))
    config = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else os.path.dirname(here))
    tmp = tempfile.mkdtemp(prefix="tty-check-")
    probe, log = os.path.join(tmp, "probe.el"), os.path.join(tmp, "log.txt")
    with open(probe, "w") as f:
        f.write(PROBE)
    open(log, "w").close()
    env = dict(os.environ, TTY_CHECK_LOG=log)

    started = subprocess.run(["emacs", f"--daemon={SOCKET}", "--init-directory", config,
                              "-l", probe], env=env,
                             stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    if started.returncode != 0:
        sys.exit(f"Le daemon {SOCKET} n'a pas demarre (deja lance ?).")
    try:
        pid, fd = pty.fork()
        if pid == 0:
            os.environ.update(TERM="xterm-256color", COLORTERM="truecolor")
            os.execvp("emacsclient", ["emacsclient", "-s", SOCKET, "-t"])
        fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack("HHHH", 40, 120, 0, 0))
        drain(fd, 4)
        for _, seq, _ in KEYS:
            os.write(fd, seq)
            drain(fd, 1.0)
        emacsclient("-e", "(tty-check-dump)")
    finally:
        emacsclient("-e", "(kill-emacs)")

    lines = open(log).read().splitlines()
    received = [l.split("\t") for l in lines if l.startswith("KEY\t")]
    print(f"Config : {config}\n")
    print(f"{'Touche attendue':<16}  {'Origine de la sequence':<24}  {'Recue par Emacs':<18}  Commande")
    for (expected, _, origin), got in zip(KEYS, received + [None] * len(KEYS)):
        if got is None:
            print(f"{expected:<16}  {origin:<24}  {'(rien)':<18}")
            continue
        _, desc, shift, command = got
        shown = f"S-{desc}" if shift == "shift" and not desc.startswith("S-") else desc
        mark = "ok" if shown == expected else "DIFFERENT"
        print(f"{expected:<16}  {origin:<24}  {shown:<18}  {command}  [{mark}]")
    print()
    for l in lines:
        if l.startswith(("COLORS", "MESSAGE")):
            print(l.replace("\t", " : ", 1))
    if any(l.startswith("WARNINGS") for l in lines):
        print("Des avertissements (*Warnings*) sont apparus :", log)


if __name__ == "__main__":
    main()
