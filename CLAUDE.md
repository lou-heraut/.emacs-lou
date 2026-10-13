# Configuration Emacs de Lou Héraut

Dépôt : `git@github.com:lou-heraut/.emacs-lou.git` (public, branche `main`).
Emacs 29.3 sous Ubuntu 24.04, KDE Plasma 5.27 sur X11.
Utilisé en mode graphique **et** en terminal (`emacs -nw`).

## Structure

| Fichier | Rôle |
|---|---|
| `early-init.el` | Lu avant la création du premier cadre. Couleurs, désactivation de l'activation auto des paquets, réglages de démarrage. |
| `init.el` | Toute la configuration, à plat, en sections avec bannières ASCII. |
| `custom.el` | Poubelle de `M-x customize`. **Jamais chargé**, ignoré par git. |
| `themes/` | Thème `apropospriate`, modifié localement. |
| `fonts/` | Polices FIGlet `.flf` versionnées, utilisées par `C-c a`. |
| `dev/` | Audits et plans datés, et `tty-check.py` : test des touches en terminal, à relancer après tout changement qui touche au terminal. |

## Conventions de travail attendues

Ces règles viennent de Lou, elles priment sur les habitudes générales.

**Ne jamais être destructif.** Avant de supprimer quoi que ce soit, vérifier que
c'est strictement redondant. En cas de doute, garder.

**Les blocs commentés sont des essais à conserver.** Ils représentent des pistes
qui ont plu à un moment et peuvent resservir. On ne les supprime que s'ils sont
identiques au caractère près à leur version active.

**L'ordre d'évaluation compte.** On peut ranger et déplacer des blocs, mais
jamais d'une façon qui change l'ordre dans lequel les choses sont évaluées.
Quand un déplacement introduit le moindre doute, le dire plutôt que de parier.

**Mesurer, ne pas supposer.** Sur cette config, plusieurs intuitions
raisonnables se sont révélées fausses à la mesure (voir « Pièges » plus bas).
Chronométrer, interroger le système, tester le chemin d'échec.

**Format des échanges.** Pas de widget de questions à choix multiples. Les
arbitrages se présentent en texte, avec une recommandation claire. Tableaux et
schémas ASCII appréciés. Pas de tirets quadratins dans la prose.

## Pièges vérifiés, à ne pas réintroduire

**`cua-mode` confisque `C-z`.** Son keymap `cua--cua-keys-keymap` vit dans
`emulation-mode-map-alists`, prioritaire sur `global-map`. Les bindings
`use-package :bind` d'`undo-fu` ne l'atteignaient jamais, et `C-z` retombait sur
le `undo` natif, qui boucle. Le rattrapage se fait par `define-key` sur
`cua--cua-keys-keymap` **après** `(cua-mode t)`. Testé : `:bind*` ne suffit pas.
Vérification : `C-h k` puis `C-z` doit afficher `undo-fu-only-undo`.

**Les couleurs d'`early-init.el` doivent suivre le thème.** `#1c1c1c` et
`#E0E0E0` y sont codées en dur pour éviter le flash blanc au démarrage. Un
changement de thème sans mise à jour de ces deux lignes fait réapparaître le
flash, dans l'autre sens.

**`package-selected-packages` se tient à la main.** `use-package :ensure t` ne
l'alimente pas. Une liste incomplète expose à un `M-x package-autoremove` qui
supprime des paquets réellement utilisés, et à une réinstallation incomplète sur
une nouvelle machine. Ajouter chaque nouveau paquet à la liste en haut d'`init.el`.

**Aucun secret dans le dépôt.** Il est public. Les identifiants PostgreSQL
vivent dans `~/.pgpass` (mécanisme standard de libpq, donc valable hors Emacs).
`sql-connection-alist` ne contient jamais de `sql-password`.

**Les chemins absolus cassent au changement de machine.** C'est ce qui est
arrivé à `ascii-art-convert`, qui pointait vers `/home/louis/`. Utiliser
`user-emacs-directory`, et versionner les ressources dont dépend la config.

**Une fonction qui modifie le buffer doit vérifier le code de retour** de tout
processus externe qu'elle appelle. `ascii-art-convert` effaçait la ligne avant de
constater l'échec de figlet.

**Le code part vers le shell Python sans attendre.** Tout envoi passe par
`python-shell-send-string`. `python-shell-send-string-no-output` attend que le
shell soit libre : pendant un calcul long, Emacs se bloque, la sortie du calcul
disparaît, et un `C-g` interrompt le processus Python (mesuré, et lu dans
`python.el`). Seule attente légitime : la première invite d'un shell neuf, avant
laquelle `__PYTHON_EL_eval` n'existe pas encore (`my-python-ensure-shell`).

## Mesures de référence

Démarrage complet, mode daemon, médiane sur 3 :

```
avant early-init.el   1,141 s
après                 0,488 s
```

Décomposition du restant : `package-initialize` 46 ms, thème 7 ms, `require`
des paquets non différés environ 130 ms, activation des modes globaux environ
300 ms, cœur d'Emacs et fichiers site-start environ 10 ms.

Testé et **écarté** : `package-quickstart`, aucun gain, parce qu'il n'agit que
sur l'activation automatique des paquets, que `early-init.el` désactive déjà.

Testé : différer `ess` et `python` fait gagner environ 30 ms. Reste non fait,
rapport bénéfice sur risque jugé insuffisant. Pistes restantes si besoin :
`centaur-tabs` (le plus lourd) et `(set-frame-font "hack 15")`, à profiler avec
`M-x profiler-start` ou `esup`.

## Dépendances externes

| Outil | Sert à | Absence |
|---|---|---|
| `figlet` | bannières `C-c a` | message clair, ligne intacte |
| `pandoc` + `weasyprint` | export Markdown vers PDF (`my/markdown-to-pdf`) | échec signalé dans `*pandoc-output*` |
| `ipython`, dans le venv actif | shell Python | repli sur le `python3` du venv |
| `okular` | visionneuse PDF d'AUCTeX | |
| `klipper` | presse-papier qui survit à la fermeture d'Emacs | contenu copié perdu |

`my/python-interpreter` ne prend IPython que s'il est installé dans le venv
actif (`create-python-env` l'y installe). Le `ipython3` d'apt, présent sur ce
poste, est écarté exprès : il tourne sur le Python du système et mélange ses
paquets avec ceux du venv (constaté : erreurs NumPy 1.x contre 2.x). Le nom
reste **relatif** pour que `exec-path` suive le venv actif.

## Hors dépôt mais nécessaire au poste

Ces fichiers ne sont pas versionnés et sont à recréer sur une nouvelle machine :

- `~/.pgpass`, permissions `600`, format `hôte:port:base:utilisateur:motdepasse`
- `~/.config/klipperrc` contenant `[General]` puis `AutoStart=true`. Sans ce
  fichier Klipper ne démarre jamais, sa condition d'autodémarrage vaut `false`
  par défaut.
