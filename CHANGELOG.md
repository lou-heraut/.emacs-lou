# Changelog

Ce qui a été fait, version par version. Format
[Keep a Changelog](https://keepachangelog.com/fr/1.1.0/), versions
[SemVer](https://semver.org/lang/fr/). Ce qui reste à faire est dans
`ROADMAP.md`.

## Non publié

### Ajouté

- `early-init.el` : le premier cadre naît aux couleurs du thème (plus de flash
  blanc), sans barres d'outils ni de menu ; démarrage en mode daemon passé de
  1,141 s à 0,488 s (médiane sur 3).
- `CLAUDE.md` : conventions de travail, pièges vérifiés, mesures de référence,
  dépendances externes et fichiers hors dépôt.
- Polices FIGlet versionnées dans `fonts/`, et ressources de l'export Markdown
  vers PDF (modèles, CSS, logos).
- `dev/tty-check.py` : vérifie qu'Emacs en terminal reçoit les touches de la
  config.
- `dev/` : état des lieux et plan du passage au terminal, bilan du poste pour
  Ubuntu 26.04 (mise à niveau reportée), journal des choix (`decisions.md`).

### Modifié

- `custom-file` pointe vers `custom.el`, jamais chargé : toute la config reste
  dans `init.el`.
- `package-selected-packages` déclarée à la main, 15 paquets au lieu de 8.
- Shell Python : IPython seulement s'il est installé dans le venv actif, sinon
  le `python3` du venv ; `__file__` défini à chaque envoi sans attendre que le
  shell soit libre ; C-<return> exécute aussi le bloc
  `if __name__ == "__main__"` ; `pyvenv-auto-activate` retrouve
  `~/.python_env` hors du dossier personnel.
- `exec-path-from-shell` limité au mode graphique ; `select-enable-clipboard`
  remplace un alias obsolète ; `save-interprogram-paste-before-kill` activé.
- Sauvegardes (`fichier~`), auto-sauvegardes (`#fichier#`) et verrous
  (`.#fichier`) rangés dans `backups/` au lieu des dossiers de travail.

### Corrigé

- C-z annule de nouveau avec `undo-fu` : `cua-mode` le confisquait au profit
  du `undo` natif, qui boucle.
- `ascii-art-convert` : chemin vers un ancien dossier personnel, et ligne
  effacée même quand figlet échouait.

### Supprimé

- Le mot de passe PostgreSQL de `init.el`, passé dans `~/.pgpass`.
- Un bloc d'environ 70 lignes répété à l'identique, un binding C-<return> en
  double et des bindings morts.
