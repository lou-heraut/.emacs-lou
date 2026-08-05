;;; early-init.el --- Charge avant la creation du premier cadre -*- lexical-binding: t; -*-

;; Emacs 27+ lit ce fichier AVANT d'initialiser l'interface graphique et AVANT
;; init.el. C'est le seul endroit ou l'on peut agir sur ce qui se passe avant
;; que la premiere fenetre soit dessinee.
;;
;; Deux objectifs ici :
;;   1. supprimer le flash blanc au demarrage
;;   2. reduire le travail inutile fait pendant le chargement


;;   ___  _              _      _     _
;;  | __|| | __ _  ___ | |_   | |__ | | __ _  _ _   __
;;  | _| | |/ _` |(_-< | ' \  | '_ \| |/ _` || ' \ / _|
;;  |_|  |_|\__,_|/__/ |_||_| |_.__/|_|\__,_||_||_|\__|

;; Le flash blanc vient de ce qu'Emacs dessine son premier cadre avec ses
;; couleurs par defaut (fond blanc) puis charge init.el, qui applique enfin le
;; theme. En declarant les couleurs ici, le cadre nait deja sombre et il n'y a
;; plus de transition visible.
;;
;; Ces valeurs doivent rester alignees sur apropospriate-dark :
;;   fond        base00  = #1c1c1c
;;   avant-plan  base03  = #E0E0E0
;; Si tu changes de theme, mets ces deux lignes a jour, sinon le flash revient
;; (dans l'autre sens).
(push '(background-color . "#1c1c1c") default-frame-alist)
(push '(foreground-color . "#E0E0E0") default-frame-alist)

;; Meme raison pour les elements d'interface : init.el les desactive plus tard
;; avec (tool-bar-mode -1) et compagnie, mais ils sont alors deja dessines, ce
;; qui provoque un second sursaut visuel et du travail pour rien. En les
;; declarant absents des la creation du cadre, ils ne sont jamais dessines.
(push '(tool-bar-lines . 0)   default-frame-alist)
(push '(menu-bar-lines . 0)   default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Pas d'ecran d'accueil ni de message dans le minibuffer.
(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message user-login-name
      initial-scratch-message nil)


;;   ___  _  _  _                                       _
;;  |   \| || |(_) ___  ___  _ __   __ _  _ _  _ _   ___| |_
;;  | |) | __ || |/ -_)/ _ \| '  \ / _` || ' \| ' \ / -_)  _|
;;  |___/|_||_||_|\___|\___/|_|_|_|\__,_||_||_||_||_|\___|\__|

;; Emacs 27+ active deja tous les paquets automatiquement avant init.el.
;; Comme init.el appelle ensuite (package-initialize) explicitement, le travail
;; etait fait DEUX FOIS. On desactive l'activation automatique : c'est l'appel
;; de init.el qui fait foi.
;; ATTENTION : si tu retires (package-initialize) de init.el, il faut remettre
;; cette variable a t, sinon plus aucun paquet ne sera charge.
(setq package-enable-at-startup nil)

;; Pendant le chargement, on desactive quasiment le ramasse-miettes : il n'y a
;; aucun interet a nettoyer la memoire alors qu'on ne fait qu'allouer. La valeur
;; raisonnable est retablie une fois le demarrage fini.
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Meme idee pour la table des gestionnaires de noms de fichiers : elle est
;; consultee a chaque `load' et chaque `require', et pendant le demarrage on ne
;; charge que des fichiers locaux ordinaires. On la vide puis on la restaure.
(defvar my/file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 32 1024 1024)
                  gc-cons-percentage 0.1
                  file-name-handler-alist my/file-name-handler-alist-original)))

;;; early-init.el ends here
