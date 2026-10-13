# Décisions

Les choix qui ont émergé du travail, avec leur date et leur raison. Ce sont
des repères pour avancer : ils évoluent avec le travail, et git garde
l'historique. Les constats qui les fondent sont dans `dev/audits/`.

## Logiciels et versions

**Kubuntu 24.04 jusqu'au changement de distribution** (14 octobre 2026, Lou).
Pas de mise à niveau vers 26.04 : Plasma 6 ne charge plus les widgets du KDE
Store qui font le panneau de Lou, ni ses raccourcis KHotkeys, et ce remontage
de l'interface se fera une seule fois, au changement de distribution. Celui-ci
a une échéance : KDE n'a plus de correctifs dans Kubuntu 24.04 après
avril 2027. Bilan et inventaire de l'interface :
`dev/plans/2026-10-13_ubuntu-26.04.md`.

**Mesa du PPA kisak-mesa, pour Minecraft** (14 octobre 2026, Lou). Minecraft
(26.3, Fabric, Sodium et Iris) dessine en OpenGL par Mesa (son journal du
20 septembre 2026), et Mojang fait passer Minecraft Java à Vulkan, où les
pilotes récents comptent. Ubuntu 24.04 fournit Mesa 25.2.8, le PPA suit les
dernières versions stables (26.2.4). Les mises à jour passent par
`apt full-upgrade`, pour que Mesa ne reste pas en deux versions mêlées. Repli
possible sur la Mesa d'Ubuntu par `ppa-purge`.

**Pas de snap** (13 octobre 2026, Lou). Pour aucun logiciel du poste. Une
version plus récente passe par apt, une mise à niveau du système, un PPA ou
le binaire officiel du projet, à tester avant d'adopter.

**Emacs reste en 29.3, celui d'apt** (13 octobre 2026). Sans snap, Emacs 31
demanderait un PPA (qui n'a que 30.2) ou une compilation depuis les sources.
Sous 29, le passage au terminal n'a besoin que d'un seul contournement :
`COLORTERM` dans l'environnement du daemon. L'OSC 52 ne sert pas, puisqu'Emacs
reste sur ce poste (voir plus bas), et Monet, qui demande Emacs 30, n'est pas
nécessaire tant que le lien entre Claude Code et Emacs n'est pas choisi.
À revoir au changement de distribution, ou si les essais de ce lien demandent
Emacs 30.

**kitty par apt, en 0.32.2** (13 octobre 2026). Mis à jour avec le système ;
on change si une fonction manque. Une candidate est connue : les sessions
(0.43 et plus), à juger pendant les essais du point d'entrée par projet (plan,
étape 4). Le binaire officiel (0.49.2) serait alors à tester.

## Façon de travailler

**Les serveurs s'éditent depuis l'Emacs du poste** (13 octobre 2026, Lou),
par TRAMP, avec la config habituelle. Pas d'Emacs nu sur un serveur, rien à y
installer.

**Presse-papier : le paquet `xclip`, pas d'OSC 52** (13 octobre 2026). Emacs
restant sur ce poste, `xclip` parle au presse-papier X dans les deux sens, et
Klipper suit. L'OSC 52 ne servirait qu'à un Emacs lancé sur un serveur.

**Raccourcis : la cohérence avant la richesse** (13 octobre 2026, Lou). Un
même geste fait la même chose partout : KDE puis le futur tiler (gestionnaire
de fenêtres en mosaïque), Firefox, kitty, Emacs, Claude Code. Les conventions
courantes (Ctrl+C, Ctrl+V…) servent de base. On garde ce qu'Emacs, kitty et le
tiler apportent, sans chercher à tout couvrir : un raccourci sans usage n'entre
pas. Pour kitty, on vide ses raccourcis par défaut (`clear_all_shortcuts yes`)
et on ne redéfinit que l'utile.

**Les configurations restent à leur place** (13 octobre 2026, Lou). Chaque
logiciel garde sa config là où il l'attend ; pas d'outil de gestion de
dotfiles. Un dossier de config qui mérite d'être partagé devient son propre
dépôt public, comme `.emacs.d` ; un lien symbolique seulement si le logiciel
ne permet pas autrement. Depuis GitHub, un README relie ces dépôts, pour que
tout se retrouve.
