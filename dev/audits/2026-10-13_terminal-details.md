# État des lieux, suite : Emacs, kitty et Claude Code dans le détail

13 octobre 2026, second passage le même jour, après relecture du code en jeu
et deux séries de mesures. Complète `2026-10-13_terminal.md` et le corrige sur
un point : Emacs 30.2 n'est plus la dernière version. Ce document ne change
plus ; les choix qui en sortent sont dans `dev/decisions.md`, la suite dans
`dev/plans/2026-10-13_terminal.md`.

## 1. Le poste et la façon de travailler aujourd'hui

Constaté sur le poste :

- Dolphin ouvre les fichiers texte avec `emacs.desktop` (« Emacs (GUI) »,
  `/usr/bin/emacs %F`, lu dans `~/.config/mimeapps.list`) : chaque clic lance
  un nouveau processus Emacs, avec sa propre copie des buffers.
- Aucun daemon Emacs n'est lancé au quotidien. Le service systemd fourni avec
  Emacs existe (`/usr/lib/systemd/user/emacs.service`, `--fg-daemon`) mais
  reste désactivé ; l'entrée « Emacs (Client) » du menu démarrerait un daemon
  au premier appel (`--alternate-editor=`).
- Police Hack installée ; carte Intel Arc (Meteor Lake), OpenGL 4.6 (kitty
  demande 3.3) ; session X11 ; clavier `fr`, variante `latin9`.

Dit par Lou : l'édition de texte et la programmation se font dans Emacs, la
gestion des fichiers dans Dolphin, Claude Code, git et les sessions SSH vers
les VM dans Konsole, sans Emacs. Il manque un point d'entrée unique par projet
pour naviguer dans les fichiers, ouvrir l'éditeur, Claude Code et une zone
d'exécution, et passer d'une session active à l'autre.

## 2. Les versions disponibles, hors snap

| Logiciel | apt 24.04 | Ubuntu 26.04 | Autre source                       | Dernière                  |
| -------- | --------- | ------------ | ---------------------------------- | ------------------------- |
| Emacs    | 29.3      | 30.2         | PPA ubuntuhandbook1 : 30.2 (noble) | 31.1 (24 août 2026)       |
|          |           |              | sources GNU : 31.1, à compiler     |                           |
| kitty    | 0.32.2    | 0.45.0       | binaire officiel : 0.49.2          | 0.49.2 (1er octobre 2026) |

- Depuis 2024, le paquet kitty de 24.04 n'a reçu que des recompilations et
  deux petits correctifs d'installation (`apt changelog kitty`) : il restera en
  0.32.2.
- La faille CVE-2026-54057 (injection de commande par la réponse aux
  requêtes de couleur OSC 21), corrigée dans kitty 0.47.3, ne touche pas
  la version de 24.04 selon Ubuntu.
- Le snap fournit Emacs 31.1 depuis le 22 septembre 2026 (`snap info emacs`) :
  écarté, voir `dev/decisions.md`.
- Ubuntu 26.04 change aussi d'environnement de bureau : Plasma 6.6
  (`plasma-workspace` 6.6.6), contre 5.27 ici.

## 3. Ce qu'Emacs 31 change pour le terminal

Lu dans le NEWS et le `term/xterm.el` de la branche `emacs-31`, pas mesuré :

| Point                       | Emacs 29.3                             | Emacs 31.1                                       |
| --------------------------- | -------------------------------------- | ------------------------------------------------ |
| Couleurs 24 bits dans kitty | seulement si le daemon a `COLORTERM`   | lues dans le terminfo (`setrgbf`, `setrgbb`)     |
| Presse-papier OSC 52        | jamais activé avec kitty (mesuré, §4)  | activé si le terminal annonce `52` (requête DA1) |
| Souris                      | `xterm-mouse-mode` (déjà dans init.el) | activée d'office pour kitty (requête XTVERSION)  |
| Protocole clavier kitty     | paquet `kkp`                           | paquet `kkp` : rien dans le cœur                 |
| Popups en terminal          | non                                    | cadres enfants (Corfu, posframe)                 |

- Monet, qui relie Claude Code à Emacs, demande Emacs 30 ou plus.
- `init.el` n'a pas de cookie `lexical-binding` en tête : Emacs 31 le signale
  par un avertissement.
- Un même `~/.emacs.d` pour deux versions : des paquets recompilés par la
  plus récente peuvent ne plus se charger dans l'ancienne. Tout essai se fait
  sur une copie (`--init-directory`).

## 4. Le presse-papier (mesuré et lu)

**Emacs 29 décide de l'OSC 52 d'après la requête d'identification DA2.**
kitty 0.32.2 y répond `\e[>1;4000;32c` (`setup.py` : 4000 plus la version
majeure, puis la mineure). Simulé devant `emacs -Q` dans un pseudo-terminal :

| Réponse simulée            | OSC 52 | modifyOtherKeys |
| -------------------------- | ------ | --------------- |
| kitty 0.32.2 (`1;4000;32`) | non    | non             |
| xterm 390 (`41;390;0`)     | oui    | oui             |
| aucune                     | non    | non             |

Emacs 31 ajoute la requête DA1 : un terminal qui y annonce `52` reçoit l'OSC
52. kitty récent répond `?62;52;c` quand `clipboard_control` permet l'écriture
(c'est le cas par défaut : `write-clipboard write-primary read-clipboard-ask
read-primary-ask`) ; kitty 0.32.2 répond `?62;c`, sans `52`.

**Le paquet `xclip` (1.11.1)** choisit sa méthode au chargement : le programme
`xclip`, `xsel`, `wl-copy`, puis la méthode `emacs` si Emacs a le support X et
que `DISPLAY` existe, et enfin `xclip` par défaut.

- Sur ce poste, sans le programme `xclip`, c'est la méthode `emacs` : un cadre
  X invisible ouvert sur `DISPLAY`, qui parle au presse-papier X dans les deux
  sens, donc à Klipper. À mesurer dans un cadre terminal.
- Il désactive exprès l'OSC 52 d'Emacs (`xclip.el`, ligne 304, commentaire
  « BIG UGLY HACK »).
- Sans `DISPLAY` ni programme, il retombe sur `xclip`, introuvable, et
  `(xclip-mode 1)` échoue au démarrage.

Conséquence : tant qu'Emacs tourne sur ce poste (TRAMP pour les serveurs),
`xclip` suffit et l'OSC 52 ne sert pas.

## 5. Les couleurs 24 bits d'un cadre `emacsclient -t` (mesuré, Emacs 29.3)

| Daemon lancé avec                     | Client lancé avec     | Couleurs   |
| ------------------------------------- | --------------------- | ---------- |
| sans `COLORTERM`                      | `COLORTERM=truecolor` | 256        |
| `COLORTERM=truecolor`                 | sans `COLORTERM`      | 16 777 216 |
| sans, puis `(setenv "COLORTERM" ...)` | sans                  | 256        |
| sans, `tty-color-mode` à 16777216     | sans                  | 256        |

Seul compte l'environnement réel du processus daemon ; aucun réglage dans la
config ne le remplace (dernières lignes : `default-frame-alist` et
`tty-setup-hook` donnent le même résultat). L'environnement de systemd
(`systemctl --user show-environment`) contient `DISPLAY` et `XAUTHORITY`, pas
`COLORTERM`.

Le terminfo de kitty (`terminfo.py` 0.32.2) déclare `Tc`, `setrgbf`,
`setrgbb` et `Ms`, mais ni `RGB` ni `setf24`/`setb24`, les seuls qu'Emacs 29
sait lire.

`dev/tty-check.py` ne voit pas ce cas : il lance son daemon depuis un shell
qui a déjà `COLORTERM`.

Avec `emacs -Q`, faute de réponse du terminal, `frame-background-mode` vaut
`light` ; à vérifier avec la config, dont `early-init.el` impose un fond
sombre.

## 6. Les touches que kitty prend par défaut

Relevé dans `kitty/options/definition.py` (0.32.2), comparé à `init.el` :

| Touche           | kitty par défaut           | Emacs                                   |
| ---------------- | -------------------------- | --------------------------------------- |
| C-<tab>          | onglet suivant             | `other-window`                          |
| C-S-<tab>        | onglet précédent           | `org-metaleft` (org)                    |
| C-S-<return>     | nouvelle fenêtre           | `compile-line-and-step`                 |
| C-S-z            | invite précédente          | `undo-fu-only-redo`                     |
| C-S-f            | déplacer la fenêtre        | `query-replace-in-open-buffers`         |
| C-S-o            | sélection vers programme   | `loccur-summary`                        |
| C-S-<backspace>  | taille de police d'origine | `delete-current-line`                   |
| C-S-<left/right> | onglet précédent, suivant  | sélection mot par mot                   |
| C-S-<up/down>    | défilement d'une ligne     | sélection par paragraphe                |
| C-S-<home/end>   | début, fin de l'historique | sélection jusqu'au début, fin du buffer |

- Ctrl+Maj+- de Claude Code (annuler une modification de la saisie) sert
  aussi à kitty pour réduire la police.
- Options utiles : `kitty_mod` (par défaut `ctrl+shift`),
  `clear_all_shortcuts` (par défaut `no`). Pas de raccourci conditionné au
  programme actif dans 0.32.2 ; non vérifié dans les versions récentes.
- Les bindings d'org écrits avec `iso-lefttab` (`init.el`, lignes 1104 et
  1106) portent un nom de touche propre à X11, qui n'arrive jamais en
  terminal.

## 7. `kkp` et C-g

D'après le README de kkp :

- Par défaut, kkp active deux options du protocole clavier kitty (`kkp-active-enhancements`) :
  `disambiguate-escape-codes` et `report-alternate-keys`. La seconde traduit
  correctement les touches qui demandent Maj, ce qui compte sur un clavier
  AZERTY.
- Avec kkp, C-g arrive comme une séquence (`\e[103;5u`) : il n'interrompt
  plus un appel bloquant (`call-process`, `process-file`), mais marche
  toujours dans la boucle de commandes. L'option
  `kkp-restore-legacy-keys-around-subprocesses` rétablit les touches
  classiques pendant ces appels.
- Dans la config, ça toucherait le `pip install` de `create-python-env`
  (`shell-command`), figlet (court) et, plus tard, TRAMP.

## 8. Les sessions de kitty

kitty sait depuis longtemps lancer des fichiers de session (onglets,
panneaux et programmes décrits dans un fichier texte). Depuis 0.43
(28 septembre 2025), il passe d'une session à l'autre d'une touche
(`goto_session`) et enregistre la disposition en cours dans un fichier de
session (`save_as_session`). Absent de 0.32.2 ; présent dans 0.45.0 (Ubuntu
26.04) et dans le binaire officiel. C'est ce qui se rapproche le plus d'une
« session par projet ».

## 9. Claude Code et Emacs

- **Monet** : Claude Code tourne dans son propre terminal (kitty est cité) et
  se connecte à Emacs par `/ide`. Partage la sélection, transmet les
  diagnostics (Flymake, Flycheck), montre les diffs (au choix, dans ediff),
  ouvre les fichiers ; une session par projet. Demande Emacs 30 ou plus.
- **claude-code-ide.el** : Claude tourne dans un terminal à l'intérieur
  d'Emacs (vterm, eat ou ghostel), Emacs 28.1 ou plus. Offre à Claude des
  outils d'Emacs (xref, imenu, treesit, projet). Par défaut, laisse Claude
  exécuter du Lisp dans Emacs (`claude-code-ide-enable-execute-code`). Son
  README signale un scintillement avec vterm et eat.
- **Claude Code seul** : Ctrl+G (ou Ctrl+X Ctrl+E) ouvre le prompt dans
  l'éditeur par défaut, qui peut être `emacsclient -t`. Maj+Entrée et les
  notifications de bureau marchent sans réglage dans kitty, y compris à
  travers SSH. Depuis la v2.1.295, Claude Code signale l'état de chaque
  session (au travail, en attente, fini) aux terminaux qui gèrent le
  protocole OSC 7501 ; non vérifié pour kitty.

## Sources

- Emacs 31 : [annonce](https://www.phoronix.com/news/GNU-Emacs-31.1-Released), [NEWS](https://raw.githubusercontent.com/emacs-mirror/emacs/emacs-31/etc/NEWS), [`term/xterm.el`](https://raw.githubusercontent.com/emacs-mirror/emacs/emacs-31/lisp/term/xterm.el)
- kitty 0.32.2 : [`setup.py`](https://raw.githubusercontent.com/kovidgoyal/kitty/v0.32.2/setup.py), [`definition.py`](https://raw.githubusercontent.com/kovidgoyal/kitty/v0.32.2/kitty/options/definition.py), [`terminfo.py`](https://raw.githubusercontent.com/kovidgoyal/kitty/v0.32.2/kitty/terminfo.py)
- kitty actuel : [`window.py`](https://raw.githubusercontent.com/kovidgoyal/kitty/master/kitty/window.py) (fonction `da1`), [changelog](https://raw.githubusercontent.com/kovidgoyal/kitty/master/docs/changelog.rst), [dernière version](https://github.com/kovidgoyal/kitty/releases/latest)
- [CVE-2026-54057 chez Ubuntu](https://ubuntu.com/security/CVE-2026-54057), [suivi Debian](https://security-tracker.debian.org/tracker/CVE-2026-54057)
- Versions d'Ubuntu 26.04 et du PPA : API de Launchpad (`getPublishedSources`, série `resolute`, archive `~ubuntuhandbook1/emacs`)
- [kkp](https://github.com/benjaminor/kkp), [Monet](https://github.com/stevemolitor/monet), [claude-code-ide.el](https://github.com/manzaltu/claude-code-ide.el)
- Claude Code : [configuration du terminal](https://code.claude.com/docs/en/terminal-config), [mode interactif](https://code.claude.com/docs/en/interactive-mode)
- Sur ce poste : `term/xterm.el` 29.3, `elpa/xclip-1.11.1/xclip.el`, `snap info emacs`, `apt changelog kitty`, `apt-cache policy kitty`, `systemctl --user show-environment`, `~/.config/mimeapps.list`, `glxinfo -B`, `setxkbmap -query`
- Mesures des §4 et §5 : scripts jetables lancés sur `emacs -Q` dans un pseudo-terminal, sur le principe de `dev/tty-check.py`
