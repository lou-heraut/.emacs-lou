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

## Ensemble

- Voir ce qui rapprocherait cette config d'un VS Code libre et simple.
