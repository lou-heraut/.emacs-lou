# Ce qui reste à faire

## Python

- **C-S-<return> sur une ligne qui ouvre un bloc** (`for`, `if`, `def`)
  n'envoie que cette ligne, et le shell répond `IndentationError` (mesuré).
  Contrairement à R, le shell Python d'Emacs ne reçoit pas un bloc ligne par
  ligne. Piste : envoyer le bloc entier quand la ligne en ouvre un, et la
  sélection quand il y en a une.
- **Les erreurs du ligne à ligne pointent sur la ligne 1 du fichier**, et
  affichent donc la mauvaise ligne de code (mesuré). `python-shell-send-region`
  complète le code par des lignes vides pour garder les bons numéros ; reste à
  le concilier avec l'envoi de `__file__` en tête du code.
- **Un seul shell `*Python*` pour tout Emacs**, et le venv activé par pyvenv
  vaut pour tout Emacs. Un fichier du projet B s'exécute donc dans le shell, le
  venv et le dossier du projet A tant que ce shell tourne. À regarder avant de
  choisir : `python-shell-dedicated` (par projet ou par buffer), ou rappeler
  `pyvenv-auto-activate` au démarrage du shell.

## Poste de travail : terminal, raccourcis, Claude Code

Passer progressivement au terminal (kitty) sans casser le graphique : des
raccourcis cohérents entre KDE, Firefox, kitty et Emacs, et un point d'entrée
par projet pour les fichiers, l'éditeur, Claude Code et l'exécution. En cours,
voir `dev/plans/2026-10-13_terminal.md`.

- **Changer de distribution**, plus tard : KDE n'a plus de correctifs dans
  Kubuntu 24.04 après avril 2027. Le bilan du poste et l'inventaire de
  l'interface Plasma à remonter sont dans `dev/plans/2026-10-13_ubuntu-26.04.md`.

## Dépôt public

- **Un `README.md`** : à quoi sert cette config, comment l'installer sur un
  nouveau poste, et les liens vers les autres configurations publiées
  (kitty…), pour que tout se retrouve depuis GitHub.
