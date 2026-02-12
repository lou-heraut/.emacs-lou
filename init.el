;; Add MELPA repository for package installations
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Install `use-package` if not already installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Load `use-package`
(require 'use-package)


;    _          _        
;   /_\   _  _ | |_  ___ 
;  / _ \ | || ||  _|/ _ \
; /_/ \_\ \_,_| \__|\___/

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(yaml-mode auctex good-scroll ess web-mode elpy company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; Add the themes directory to the load path
(add-to-list 'load-path "~/.emacs.d/themes/")

(require 'apropospriate)
;; Load the apropospriate theme (you can choose dark, light, or the general one)
(load-theme 'apropospriate-dark t)  ;; or 'apropospriate-dark, 'apropospriate-light


;  ____         _                    _              
; | __ )   ___ | |__    __ _ __   __(_)  ___   _ __ 
; |  _ \  / _ \| '_ \  / _` |\ \ / /| | / _ \ | '__|
; | |_) ||  __/| | | || (_| | \ V / | || (_) || |   
; |____/  \___||_| |_| \__,_|  \_/  |_| \___/ |_|   

;; dired
(defun dired-open-all-files ()
  (interactive)
  (dired-unmark-all-marks)
  (dired-toggle-marks)
  (dolist (f (dired-get-marked-files)) 
    (find-file f)))

(add-hook 'dired-load-hook
          (function (lambda () (load "dired-x") (define-key dired-mode-map (kbd "F") 'dired-open-all-files))))

(define-key global-map (kbd "C-x C-d") 'dired)
(define-key global-map (kbd "C-x C-r") 'find-name-dired)

(ido-mode -1)


;  ___                      
; / __| _ __  __ _  __  ___ 
; \__ \| '_ \/ _` |/ _|/ -_)
; |___/| .__/\__,_|\__|\___|
;      |_|      

;; new tab and ret
;; (define-key global-map (kbd "RET") 'electric-newline-and-maybe-indent)
(define-key global-map (kbd "RET") 'newline-and-indent)
(define-key global-map (kbd "TAB") 'indent-for-tab-command)

;  ___        _       _        
; |   \  ___ | | ___ | |_  ___ 
; | |) |/ -_)| |/ -_)|  _|/ -_)
; |___/ \___||_|\___| \__|\___|

;; selection delete when typing
(delete-selection-mode)


;  ___                _  _  _             
; / __| __  _ _  ___ | || |(_) _ _   __ _ 
; \__ \/ _|| '_|/ _ \| || || || ' \ / _` |
; |___/\__||_|  \___/|_||_||_||_||_|\__, |
;                                   |___/ 


;; ;; Basic scrolling tweaks
;; (setq mouse-wheel-scroll-amount '(1 ((shift) . 5))) ;; Scroll 1 line normally, 5 with Shift
;; (setq mouse-wheel-progressive-speed nil) ;; Disable acceleration
;; (setq mouse-wheel-follow-mouse t) ;; Scroll the window under the mouse
;; (setq scroll-step 1) ;; Keyboard scroll one line at a time
;; (setq scroll-conservatively 10000) ;; Prevent recentering during scrolling
;; (setq scroll-margin 0) ;; No margin while scrolling
;; (setq scroll-preserve-screen-position 'always) ;; Preserve screen position while scrolling

;; ;; Performance improvements for smoother scrolling
;; (setq auto-window-vscroll nil) ;; Disable automatic horizontal scrolling
;; (setq fast-but-imprecise-scrolling t) ;; Improve redisplay speed
;; (setq jit-lock-defer-time 0) ;; Disable delayed font locking
;; (setq redisplay-dont-pause t) ;; Prevent redisplay pauses

(when (require 'use-package nil 'noerror)
  (use-package good-scroll
    :ensure t
    :config
    (setq good-scroll-amount 100) ;; Adjust scrolling speed (pixels per frame)
    (good-scroll-mode 1)))

;; Scroll bar configuration
(set-scroll-bar-mode 'right) ;; Place scroll bar on the right
(scroll-bar-mode -1) ;; Disable the scroll bar

;; Enable pixel-precision scrolling (Emacs 27+)
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode t))




;   ___  _  _        _                        _ 
;  / __|| |(_) _ __ | |__  ___  __ _  _ _  __| |
; | (__ | || || '_ \| '_ \/ _ \/ _` || '_|/ _` |
;  \___||_||_|| .__/|_.__/\___/\__,_||_|  \__,_|
;             |_|                               

;; xclip
(use-package xclip
  :ensure t
  :config
  (xclip-mode 1))

;; enable clipboard in emacs
(setq x-select-enable-clipboard t)

(setq ns-pop-up-frames nil)


;; in order to use shortcut in therminal Emacs
;;(require 'term-keys)
;;(term-keys-mode t)
;;(require 'term-keys-konsole)
;;(with-temp-buffer
;;  (insert (term-keys/konsole-keytab))
;;  (append-to-file (point-min) (point-max) "~/.local/share/konsole/Emacs.keytab"))



;                           --------------------
;  _____      _  _  _    _                
; | ____|  __| |(_)| |_ (_) _ __    __ _  
; |  _|   / _` || || __|| || '_ \  / _` | 
; | |___ | (_| || || |_ | || | | || (_| | 
; |_____| \__,_||_| \__||_||_| |_| \__, | 
;                                  |___/ 


;; encoding
(prefer-coding-system 'utf-8-unix)

;; saving all buffers
(define-key global-map (kbd "C-x C-a") 'save-all)

(defun save-all ()
  (interactive)
  (let ((current-prefix-arg 4)) ;; emulate C-u
    (call-interactively 'save-some-buffers)
    )
  )



;; (defun my-syntax-class (char)
;;   "Return ?s, ?w or ?p depending or whether CHAR is a white-space, word or punctuation character."
;;   (pcase (char-syntax char)
;;     (`?\s ?s)
;;     (`?w ?w)
;;     ;; (`?_ ?w)
;;     ;; (_ ?p)
;;     ))

;; (defun my-forward-word (&optional arg)
;;   "Move point forward a word (simulate behavior of Far Manager's editor).
;; With prefix argument ARG, do it ARG times if positive, or move backwards ARG times if negative."
;;   (interactive "^p")
;;   (or arg (setq arg 1))
;;   (let* ((backward (< arg 0))
;;          (count (abs arg))
;;          (char-next
;;           (if backward 'char-before 'char-after))
;;          (skip-syntax
;;           (if backward 'skip-syntax-backward 'skip-syntax-forward))
;;          (skip-char
;;           (if backward 'backward-char 'forward-char))
;;          prev-char next-char)
;;     (while (> count 0)
;;       (setq next-char (funcall char-next))
;;       (cl-loop
;;        (if (or                          ; skip one char at a time for whitespace,
;;             (eql next-char ?\n)         ; in order to stop on newlines
;;             ;; (eql (char-syntax next-char) ?\s)
;; 	    )
;;            (funcall skip-char)
;;          (funcall skip-syntax (char-to-string (char-syntax next-char))))
;;        (setq prev-char next-char)
;;        (setq next-char (funcall char-next))
;;        ;; (message (format "Prev: %c %c %c Next: %c %c %c"
;;        ;;                   prev-char (char-syntax prev-char) (my-syntax-class prev-char)
;;        ;;                   next-char (char-syntax next-char) (my-syntax-class next-char)))
;;        (when
;;            (or
;;             (eql prev-char ?\n)         ; stop on newlines
;;             (eql next-char ?\n)
;;             (and                        ; stop on word -> punctuation
;;              (eql (my-syntax-class prev-char) ?w))
;;              ;; (eql (my-syntax-class next-char) ?p)) /////
;;             (and                        ; stop on word -> whitespace
;;              this-command-keys-shift-translated ; when selecting
;;              (eql (my-syntax-class prev-char) ?w)
;;              (eql (my-syntax-class next-char) ?s)
;; 	     )
;;             (and                        ; stop on whitespace -> non-whitespace
;;              (not backward)             ; when going forward
;;              (not this-command-keys-shift-translated) ; and not selecting
;;              (eql (my-syntax-class prev-char) ?s)
;;              (not (eql (my-syntax-class next-char) ?s))
;; 	     )
;;             (and                        ; stop on non-whitespace -> whitespace
;;              backward                   ; when going backward
;;              (not this-command-keys-shift-translated) ; and not selecting
;;              (not (eql (my-syntax-class prev-char) ?s))
;;              (eql (my-syntax-class next-char) ?s)
;; 	     )
;;             )
;;          (cl-return))
;;        )
;;       (setq count (1- count)))))


;; (defun my-delete-word (&optional arg)
;;   "Delete characters forward until encountering the end of a word.
;; With argument ARG, do this that many times."
;;   (interactive "p")
;;   (delete-region (point) (progn (my-forward-word arg) (point))))

;; (defun delete-word (&optional arg)
;;   "Delete characters forward until encountering the end of a word.
;; With argument ARG, do this that many times."
;;   (interactive "p")
;;   (delete-region (point) (progn (forward-word arg) (point))))

;; (defun my-backward-delete-word (arg)
;;   "Delete characters backward until encountering the beginning of a word.
;; With argument ARG, do this that many times."
;;   (interactive "p")
;;   (my-delete-word (- arg)))

;; (defun my-backward-word (&optional arg)
;;   (interactive "^p")
;;   (or arg (setq arg 1))
;;   (my-forward-word (- arg)))

(defun delete-current-line ()
  "Delete (not kill) the current line."
  (interactive)
  (save-excursion
    (delete-region
     (progn (forward-visible-line 0) (point))
     (progn (forward-visible-line 1) (point)))))

(global-set-key (kbd "C-S-<backspace>") 'delete-current-line)



;; (defun reluctant-forward (&optional arg)
;;   "Move point to the end of the next word or string of
;; non-word-constituent characters.
;; Do it ARG times if ARG is positive, or -ARG times in the opposite
;; direction if ARG is negative. ARG defaults to 1."
;;   (interactive "^p")
;;   (if (> arg 0)
;;       (dotimes (_ arg)
;;         ;; First, skip whitespace ahead of point
;;         (when (looking-at-p "[ \t\n]")
;;           (skip-chars-forward " \t\n"))
;;         (unless (= (point) (point-max))
;;           ;; Now, if we're at the beginning of a word, skip it…
;;           (if (looking-at-p "\\sw")
;;               (skip-syntax-forward "w")
;;             ;; …otherwise it means we're at the beginning of a string of
;;             ;; symbols. Then move forward to another whitespace char,
;;             ;; word-constituent char, or to the end of the buffer.
;;             (if (re-search-forward "\n\\|\\s-\\|\\sw" nil t)
;;                 (backward-char)
;;               (goto-char (point-max))))))
;;     (dotimes (_ (- arg))
;;       (when (looking-back "[ \t\n]")
;;         (skip-chars-backward " \t\n"))
;;       (unless (= (point) (point-min))
;;         (if (looking-back "\\sw")
;;             (skip-syntax-backward "w")
;;           (if (re-search-backward "\n\\|\\s-\\|\\sw" nil t)
;;               (forward-char)
;;             (goto-char (point-min))))))))

;; (defun reluctant-backward (&optional arg)
;;   "Move point to the beginning of the previous word or string of
;; non-word-constituent characters.
;; Do it ARG times if ARG is positive, or -ARG times in the opposite
;; direction if ARG is negative. ARG defaults to 1."
;;   (interactive "^p")
;;   (reluctant-forward (- arg)))








(defun reluctant-forward (&optional arg)
  "Move point to the end of the next word or string of
non-word-constituent characters.
Do it ARG times if ARG is positive, or -ARG times in the opposite
direction if ARG is negative. ARG defaults to 1."
  (interactive "^p")
  (if (> arg 0)
      (dotimes (_ arg)
        (cond
         ;; Stop after newline
         ((looking-at-p "\n")
          (forward-char))
         ;; Skip spaces/tabs
         ((looking-at-p "[ \t]")
          (skip-chars-forward " \t"))
         ;; Skip word
         ((looking-at-p "\\sw")
          (skip-syntax-forward "w"))
         ;; Skip symbol (non-word non-whitespace)
         (t
          (if (re-search-forward "\\s-\\|\\sw\\|\n" nil t)
              (backward-char)
            (goto-char (point-max))))))
    (dotimes (_ (- arg))
      (cond
       ;; Stop before newline
       ((and (not (bobp)) (eq (char-before) ?\n))
        (backward-char))
       ;; Skip spaces/tabs
       ((looking-back "[ \t]" 1)
        (skip-chars-backward " \t"))
       ;; Skip word
       ((looking-back "\\sw" 1)
        (skip-syntax-backward "w"))
       ;; Skip symbol
       (t
        (if (re-search-backward "\\s-\\|\\sw\\|\n" nil t)
            (forward-char)
          (goto-char (point-min))))))))



(defun reluctant-backward (&optional arg)
  "Move point to the beginning of the previous word or string of
non-word-constituent characters.
Do it ARG times if ARG is positive, or -ARG times in the opposite
direction if ARG is negative. ARG defaults to 1."
  (interactive "^p")
  (reluctant-forward (- arg)))


(global-set-key (kbd "C-<right>") #'reluctant-forward)
(global-set-key (kbd "C-<left>") #'reluctant-backward)






(defun my-delete-word (&optional arg)
  "Delete characters forward until encountering the end of a word or
string of non-word-constituent characters.
Do it ARG times if ARG is positive. ARG defaults to 1."
  (interactive "^p")
  (let ((start (point)))
    (reluctant-forward (or arg 1))
    (delete-region start (point))))

(defun my-backward-delete-word (&optional arg)
  "Delete characters backward until encountering the beginning of a word or
string of non-word-constituent characters.
Do it ARG times if ARG is positive. ARG defaults to 1."
  (interactive "^p")
  (let ((start (point)))
    (reluctant-backward (or arg 1))
    (delete-region (point) start)))

;; Set up the keybindings as you wanted
(global-set-key (kbd "C-<delete>") #'my-delete-word)
(global-set-key (kbd "C-<backspace>") #'my-backward-delete-word)








(define-key global-map (kbd "<C-up>") 'backward-paragraph)
(define-key global-map (kbd "<C-down>") 'forward-paragraph)

;; move line
;; (define-key global-map (kbd "<M-up>") 'backward-sentence)
;; (define-key global-map (kbd "<M-down>") 'forward-sentence)

(define-key global-map (kbd "M-<left>") 'beginning-of-visual-line)
(define-key global-map (kbd "M-<right>") 'end-of-visual-line)



;; For pixel-based scrolling, use scroll-up and scroll-down
;; Unbind the pixel-scroll specific keybindings for <prior> and <next>
(define-key pixel-scroll-precision-mode-map (kbd "<prior>") nil)
(define-key pixel-scroll-precision-mode-map (kbd "<next>") nil)




(defun my-smooth-scroll-up ()
  "Smooth scroll up by half the page height."
  (interactive)
  (dotimes (_ 2)  ; Scroll 5 steps at once
    (good-scroll-up)))

(defun my-smooth-scroll-down ()
  "Smooth scroll down by half the page height."
  (interactive)
  (dotimes (_ 2)  ; Scroll 5 steps at once
    (good-scroll-down)))


(defun my-smooth-scroll-up-fast ()
  "Smooth scroll up by half the page height."
  (interactive)
  (dotimes (_ 7)  ; Scroll 5 steps at once
    (good-scroll-up)))

(defun my-smooth-scroll-down-fast ()
  "Smooth scroll down by half the page height."
  (interactive)
  (dotimes (_ 7)  ; Scroll 5 steps at once
    (good-scroll-down)))



(define-key global-map (kbd "<next>") 'my-smooth-scroll-up)
(define-key global-map (kbd "<prior>") 'my-smooth-scroll-down)
;; (define-key global-map (kbd "<S-prior>") 'cua-scroll-down)
;; (define-key global-map (kbd "<S-next>") 'cua-scroll-up)

(define-key global-map (kbd "<S-next>") 'my-smooth-scroll-up-fast)
(define-key global-map (kbd "<S-prior>") 'my-smooth-scroll-down-fast)
;; (define-key global-map (kbd "<prior>") (lambda () (interactive) (scroll-down 4)))
;; (define-key global-map (kbd "<next>") (lambda () (interactive) (scroll-up 4)))

;; (define-key global-map (kbd "<M-prior>") 'scroll-down-line)
;; (define-key global-map (kbd "<M-next>") 'scroll-up-line)



;; window movement
(global-set-key (kbd "<C-x-left>")  'windmove-left)
(global-set-key (kbd "<C-x-right>") 'windmove-right)
(global-set-key (kbd "<C-x-up>")    'windmove-up)
(global-set-key (kbd "<C-x-down>")  'windmove-down)

(global-set-key (kbd "C-x <left>")  'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <up>")    'windmove-up)
(global-set-key (kbd "C-x <down>")  'windmove-down)

(global-set-key (kbd "C-x <C-left>")  'windmove-left)
(global-set-key (kbd "C-x <C-right>") 'windmove-right)
(global-set-key (kbd "C-x <C-up>")    'windmove-up)
(global-set-key (kbd "C-x <C-down>")  'windmove-down)




;  ___       _           _    _            
; / __| ___ | | ___  __ | |_ (_) ___  _ _  
; \__ \/ -_)| |/ -_)/ _||  _|| |/ _ \| ' \ 
; |___/\___||_|\___|\__| \__||_|\___/|_||_|

;; all selection
(define-key global-map (kbd "C-a") 'mark-whole-buffer)

;  _  _  _      _              _     
; | || |(_) ___| |_  ___  _ _ (_) __ 
; | __ || |(_-<|  _|/ _ \| '_|| |/ _|
; |_||_||_|/__/ \__|\___/|_|  |_|\__|

(use-package undo-fu
  :ensure t
  :bind
  (("C-z" . undo-fu-only-undo)
   ("C-S-z" . undo-fu-only-redo)))


;  _  __ _  _  _  _             
; | |/ /(_)| || |(_) _ _   __ _ 
; | ' < | || || || || ' \ / _` |
; |_|\_\|_||_||_||_||_||_|\__, |
;                         |___/ 

;; CUA
(cua-mode t)

;; kill line
(defun backward-kill-line (arg)
  "Kill ARG lines backward."
  (interactive "p")
  (kill-line (- 1 arg)))

(define-key global-map (kbd "C-d") (lambda () (interactive) (kill-line 1) (yank)))
(define-key global-map (kbd "M-d") (lambda () (interactive) (backward-kill-line 1) (yank)))

;; kill sentence
(define-key global-map (kbd "C-;") (lambda () (interactive) (kill-sentence) (yank)))
(define-key global-map (kbd "M-;") (lambda () (interactive) (backward-kill-sentence) (yank)))

;; kill word
(define-key global-map (kbd "C-,") (lambda () (interactive) (kill-word 1) (yank)))
(define-key global-map (kbd "M-,") (lambda () (interactive) (backward-kill-word 1) (yank)))

;                           --------------------

;  ____   _              _               
; |  _ \ (_) ___  _ __  | |  __ _  _   _ 
; | | | || |/ __|| '_ \ | | / _` || | | |
; | |_| || |\__ \| |_) || || (_| || |_| |
; |____/ |_||___/| .__/ |_| \__,_| \__, |
;                |_|               |___/ 
;  ___             _                      _     _     _            
; | __| ___  _ _  | |_     __ _  _ _   __| |   | |   (_) _ _   ___ 
; | _| / _ \| ' \ |  _|   / _` || ' \ / _` |   | |__ | || ' \ / -_)
; |_|  \___/|_||_| \__|   \__,_||_||_|\__,_|   |____||_||_||_|\___|

;; colum and line numer
(setq column-number-mode t)

;; font
(set-frame-font "hack 15" nil t)

;; line wrap
(visual-line-mode t)
(global-visual-line-mode t)
;; (global-visual-line-mode 1)

;; line number
(require 'display-line-numbers)

(defcustom display-line-numbers-exempt-modes
  '(doc-view-mode)
  "Major modes on which to disable line numbers."
  :group 'display-line-numbers
  :type 'list
  :version "green")

(defun display-line-numbers--turn-on ()
  "Turn on line numbers except for certain major modes.
Exempt major modes are defined in `display-line-numbers-exempt-modes'."
  (unless (or (minibufferp)
              (member major-mode display-line-numbers-exempt-modes))
    (display-line-numbers-mode)))

(global-display-line-numbers-mode)

;; parenthesis
(show-paren-mode 1)
(setq show-paren-delay 0)


;  _  _  _        _     _  _        _     _   
; | || |(_) __ _ | |_  | |(_) __ _ | |_  | |_ 
; | __ || |/ _` || ' \ | || |/ _` || ' \ |  _|
; |_||_||_|\__, ||_||_||_||_|\__, ||_||_| \__|
;          |___/             |___/            

;; highlight line
(global-hl-line-mode 1)
(set-face-attribute 'region nil :background "#777")

; __      __ _           _              
; \ \    / /(_) _ _   __| | ___ __ __ __
;  \ \/\/ / | || ' \ / _` |/ _ \\ V  V /
;   \_/\_/  |_||_||_|\__,_|\___/ \_/\_/ 

;; tool bar
(tool-bar-mode -1)

;; menu bar
 (menu-bar-mode -1)

;; dialog box
(setq use-dialog-box nil)

;; startup screen
(setq inhibit-startup-screen t)

;; solaire mode
(use-package solaire-mode
  :ensure t
  :config
  ;; Enable solaire mode globally
  (solaire-global-mode +1))

;; Remove info in modeline
;;(require 'diminish)
;;(diminish 'undo-tree-mode)


(global-set-key (kbd "M-SPC") 'enlarge-window-horizontally)
(global-set-key (kbd "<C-tab>") 'other-window)

;; Disable zooming with Ctrl + Mouse Scroll
(global-unset-key (kbd "<C-mouse-4>"))
(global-unset-key (kbd "<C-mouse-5>"))
(global-set-key (kbd "<C-wheel-up>") nil)
(global-set-key (kbd "<C-wheel-down>") nil)
(global-set-key (kbd "<C-double-wheel-up>") nil)
(global-set-key (kbd "<C-double-wheel-down>") nil)
(global-set-key (kbd "<C-triple-wheel-up>") nil)
(global-set-key (kbd "<C-triple-wheel-down>") nil)
;; Optional: Disable other related zoom shortcuts if needed
;; (global-unset-key (kbd "C-+"))
;; (global-unset-key (kbd "C--"))
;; (global-unset-key (kbd "C-0"))


;   ___                          
;  / __| _  _  _ _  ___ ___  _ _ 
; | (__ | || || '_|(_-</ _ \| '_|
;  \___| \_,_||_|  /__/\___/|_|  

;; cursor
(xterm-mouse-mode 1)
(setq-default cursor-type 'bar)

(add-hook 'window-setup-hook '(lambda () (set-cursor-color "palegoldenrod")))
(add-hook 'after-make-frame-functions '(lambda (f) (with-selected-frame f (set-cursor-color "palegoldenrod"))))


;; TAB
(use-package centaur-tabs
  :ensure t
  :config
  ;; Enable centaur-tabs mode
  (centaur-tabs-mode t)
  
  ;; Set keybindings for switching between tabs
  (global-set-key (kbd "C-<prior>") 'centaur-tabs-backward)
  (global-set-key (kbd "C-<next>") 'centaur-tabs-forward)
  
  ;; Enable matching of the headline with the tab
  (centaur-tabs-headline-match))

;; (setq centaur-tabs-set-modified-marker t)
;; (setq centaur-tabs-modified-marker ".")





;                           --------------------

;  ____         _                    _              
; | __ )   ___ | |__    __ _ __   __(_)  ___   _ __ 
; |  _ \  / _ \| '_ \  / _` |\ \ / /| | / _ \ | '__|
; | |_) ||  __/| | | || (_| | \ V / | || (_) || |   
; |____/  \___||_| |_| \__,_|  \_/  |_| \___/ |_|   

;; dired
(defun dired-open-all-files ()
  (interactive)
  (dired-unmark-all-marks)
  (dired-toggle-marks)
  (dolist (f (dired-get-marked-files)) 
    (find-file f)))

(add-hook 'dired-load-hook
          (function (lambda () (load "dired-x") (define-key dired-mode-map (kbd "F") 'dired-open-all-files))))

(define-key global-map (kbd "C-x C-d") 'dired)
(define-key global-map (kbd "C-x C-r") 'find-name-dired)

;  ___                      
; / __| _ __  __ _  __  ___ 
; \__ \| '_ \/ _` |/ _|/ -_)
; |___/| .__/\__,_|\__|\___|
;      |_|      

;; new tab and ret
;; (define-key global-map (kbd "RET") 'electric-newline-and-maybe-indent)
(define-key global-map (kbd "RET") 'newline-and-indent)
(define-key global-map (kbd "TAB") 'indent-for-tab-command)

;  ___        _       _        
; |   \  ___ | | ___ | |_  ___ 
; | |) |/ -_)| |/ -_)|  _|/ -_)
; |___/ \___||_|\___| \__|\___|

;; selection delete when typing
(delete-selection-mode)


;  ___                _  _  _             
; / __| __  _ _  ___ | || |(_) _ _   __ _ 
; \__ \/ _|| '_|/ _ \| || || || ' \ / _` |
; |___/\__||_|  \___/|_||_||_||_||_|\__, |
;                                   |___/ 

;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(2 ((shift) . 2))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq scroll-preserve-screen-position 'always)

;; scroll bar
(set-scroll-bar-mode 'right)
(scroll-bar-mode -1)

;   ___  _  _        _                        _ 
;  / __|| |(_) _ __ | |__  ___  __ _  _ _  __| |
; | (__ | || || '_ \| '_ \/ _ \/ _` || '_|/ _` |
;  \___||_||_|| .__/|_.__/\___/\__,_||_|  \__,_|
;             |_|                               

;; xclip
(require 'xclip)
(xclip-mode 1)

;; enable clipboard in emacs
(setq x-select-enable-clipboard t)

(setq ns-pop-up-frames nil)


;                           --------------------

;  _____                _      
; |_   _|  ___    ___  | | ___ 
;   | |   / _ \  / _ \ | |/ __|
;   | |  | (_) || (_) || |\__ \
;   |_|   \___/  \___/ |_||___/

;; renaming buffer 
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

(define-key global-map (kbd "C-x C-n") 'rename-file-and-buffer)

;   ___                                _   
;  / __| ___  _ __   _ __   ___  _ _  | |_ 
; | (__ / _ \| '  \ | '  \ / -_)| ' \ |  _|
;  \___|\___/|_|_|_||_|_|_|\___||_||_| \__|

;; comment
(define-key global-map (kbd "C-r") 'comment-line)
(setq comment-start "#")
;; (add-hook 'r-mode-hook (lambda () (setq comment-start "#")))


(add-hook 'ess-r-mode-hook
    (lambda () (progn (setq comment-start "# ")
                      (setq comment-add 0))))

;; # or ## or ### in the same place
(setq ess-fancy-comments nil)

;  _  _  _        _     _  _        _     _    _             
; | || |(_) __ _ | |_  | |(_) __ _ | |_  | |_ (_) _ _   __ _ 
; | __ || |/ _` || ' \ | || |/ _` || ' \ |  _|| || ' \ / _` |
; |_||_||_|\__, ||_||_||_||_|\__, ||_||_| \__||_||_||_|\__, |
;          |___/             |___/                     |___/ 


(use-package loccur
  :ensure t
  :config
  ;; Configure loccur commands and keybindings
  (define-key global-map (kbd "C-o") 'loccur-current)
  (define-key global-map (kbd "C-S-o") 'loccur-summary)
  (define-key global-map (kbd "M-o") 'loccur-empty))

(defun loccur-empty ()
  (interactive)
  ;; (run-with-timer .2 nil 'insert 'delete-current-line)
  (let ((current-prefix-arg 4)) ;; emulate C-u
    (call-interactively 'loccur))) ;; invoke align-regexp interactively

(defun loccur-summary ()
  (interactive)
  (run-with-timer .1 nil 'insert "##")
  (run-with-timer .2 nil 'execute-kbd-macro (kbd "RET"))
  (let ((current-prefix-arg 4)) ;; emulate C-u
    (call-interactively 'loccur))) ;; invoke align-regexp interactively


(use-package hi-lock
  :ensure nil  ;; no need to install, it's a built-in package
  :config
  ;; Function to highlight the current selection
  (defun autohighlight-selection ()
    "Highlight the current region or selection interactively."
    (interactive)
    (cua-set-mark)
    (cua-set-mark)
    (if (boundp 'hi-lock-interactive-patterns)
        (unhighlight-regexp t))
    (if (use-region-p)
        (highlight-regexp (buffer-substring-no-properties (region-beginning) (region-end)))))

  ;; Bind the function to a key
  (define-key global-map (kbd "C-w") 'autohighlight-selection))


;   ___                    _  _  _             
;  / __| ___  _ __   _ __ (_)| |(_) _ _   __ _ 
; | (__ / _ \| '  \ | '_ \| || || || ' \ / _` |
;  \___|\___/|_|_|_|| .__/|_||_||_||_||_|\__, |
;                   |_|                  |___/ 


;; (setq browse-url-browser-function 'browse-url-firefox
      ;; browse-url-new-window-flag  t
      ;; browse-url-firefox-new-window-is-tab t)

(setq browse-url-generic-program (executable-find "firefox")
      browse-url-browser-function 'browse-url-generic)


;; (defun python-eval-logical-line-and-step ()
;;   "Evaluate current logical line in Python and step to next logical line."
;;   (interactive)
;;   (let ((beg (save-excursion (python-nav-beginning-of-statement) (point)))
;;         (end (save-excursion (python-nav-end-of-statement) (point))))
;;     (python-shell-send-string (buffer-substring beg end))
;;     (goto-char end)
;;     (python-nav-forward-statement)))


(defun my-python-ensure-shell ()
  "Ensure Python shell is running and ready."
  (unless (python-shell-get-process)
    (my-python-start-shell))
  ;; Wait until the process is alive
  (let ((proc (python-shell-get-process)))
    (while (and proc (not (process-live-p proc)))
      (accept-process-output proc 0.1))))

(defun python-eval-logical-line-and-step ()
  "Evaluate current logical line in Python and step to next logical line."
  (interactive)
  (my-python-ensure-shell)
  (let ((beg (save-excursion (python-nav-beginning-of-statement) (point)))
        (end (save-excursion (python-nav-end-of-statement) (point))))
    (python-shell-send-string (buffer-substring beg end))
    (goto-char end)
    (python-nav-forward-statement)))


(defun compile-line-and-step (&optional arg)
  "Compile or execute the current line and move to the next based on the major mode."
  (interactive)
  (cond
   ((eq major-mode 'ess-r-mode)
    (ess-eval-line-and-step))        ;; For R scripts
   ((eq major-mode 'sql-mode)
    (sql-send-paragraph))            ;; For SQL scripts
   ((eq major-mode 'python-mode)
    (python-eval-logical-line-and-step))
   (t
    (message "No compile-line-and-step action defined for %s" major-mode))))


;; Compile the whole document or buffer based on major mode
(defun compile-all (&optional arg)
  "Compile or execute the entire buffer based on the major mode."
  (interactive)
  (cond
   ((eq major-mode 'ess-r-mode)
    (ess-eval-buffer))              ;; For R scripts
   ((eq major-mode 'sql-mode)
    (sql-send-buffer))              ;; For SQL scripts
   ((eq major-mode 'python-mode)
    (my-python-ensure-shell)
    (python-shell-send-buffer))     ;; For Python
   ((eq major-mode 'LaTeX-mode)
    (TeX-command-run-all arg))      ;; For LaTeX documents
   (t
    (message "No compile-all action defined for %s" major-mode))))


;; Keep your existing keybindings
(define-key cua-global-keymap (kbd "C-S-<return>") #'compile-line-and-step)
(define-key cua-global-keymap (kbd "C-<return>") #'compile-all)

;; Bind the functions to convenient keys globally
(define-key cua-global-keymap (kbd "C-S-<return>") #'compile-line-and-step)
(define-key cua-global-keymap (kbd "C-<return>") #'compile-all)



;  ___                      _    
; / __| ___  __ _  _ _  __ | |_  
; \__ \/ -_)/ _` || '_|/ _|| ' \ 
; |___/\___|\__,_||_|  \__||_||_|
                               
;; search and replace
(defun query-replace-region-or-from-top ()
  "If marked, query-replace for the region, else for the whole buffer (start from the top)"
  (interactive)
  (progn
    (let ((orig-point (point)))
      (if (use-region-p)
          (call-interactively 'query-replace)
        (save-excursion
          (goto-char (point-min))
	  (setq case-fold-search nil) ; Make it case-sensitive
          (call-interactively 'query-replace)))
      (message "Back to old point.")
      (goto-char orig-point))))

(define-key global-map (kbd "C-f") 'query-replace-region-or-from-top)


(defun query-replace-in-open-buffers (arg1 arg2)
  "query-replace in open files"
  (interactive "sQuery Replace in open Buffers: \nsquery with: ")
  (mapcar
   (lambda (x)
     (find-file x)
     (save-excursion
       (beginning-of-buffer)
       (setq case-fold-search nil) ; Make it case-sensitive
       (query-replace arg1 arg2)))
   (delq
    nil
    (mapcar
     (lambda (x)
       (buffer-file-name x))
     (buffer-list)))))

(define-key global-map (kbd "C-S-f") 'query-replace-in-open-buffers)
                   

(defun ascii-art-convert ()
  "Convert the current line of text to ascii art"
  (interactive)
  (let* ((line (buffer-substring (line-beginning-position) (line-end-position)))
         (string-line (concat line))
         (output-buf (generate-new-buffer "*figlet-output*"))
         (figlet-args (list "-f" "/home/louis/.emacs.d/fonts/small.flf" "-w" "80" string-line)))
    (apply 'call-process "figlet" nil output-buf nil figlet-args)
    (delete-region (line-beginning-position) (line-end-position))
    (insert-buffer-substring output-buf)
    (indent-according-to-mode)))

(global-set-key (kbd "C-c a") 'ascii-art-convert)



;                           --------------------

;   ___                                      _       
;  / _ \  _ __   __ _  _ __ ___    ___    __| |  ___ 
; | | | || '__| / _` || '_ ` _ \  / _ \  / _` | / _ \
; | |_| || |   | (_| || | | | | || (_) || (_| ||  __/
;  \___/ |_|    \__, ||_| |_| |_| \___/  \__,_| \___|
;               |___/
(defun my-org-mode-hook ()
  (local-set-key (kbd "<M-S-iso-lefttab>") 'org-shiftleft)
  (local-set-key (kbd "<M-tab>") 'org-shiftright)
  (local-set-key (kbd "<C-S-iso-lefttab>") 'org-metaleft)
  (local-set-key (kbd "<C-tab>") 'org-metaright)
  (local-set-key (kbd "<tab>") 'org-cycle))

(add-hook 'org-mode-hook 'my-org-mode-hook)


(setq org-hide-emphasis-markers t)

(setq org-emphasis-alist
      '(("+" bold)
        ("/" italic)
        ("_" underline)
        ("=" org-verbatim verbatim)
        ("~" org-code verbatim)
        ("-" (:strike-through t))))


;  ___              _                   
; / __| _  _  _ _  | |_  __ _ __ __ ___ 
; \__ \| || || ' \ |  _|/ _` |\ \ // -_)
; |___/ \_, ||_||_| \__|\__,_|/_\_\\___|
;       |__/                            
                 
(fset 'org\#
      "#+")
(add-hook 'org-mode-hook (lambda () (global-set-key (kbd "M-#")  'org\#)))

;  _           _             
; | |    __ _ | |_  ___ __ __
; | |__ / _` ||  _|/ -_)\ \ /
; |____|\__,_| \__|\___|/_\_\

(add-hook 'org-mode-hook (lambda () (global-set-key (kbd "M-p") 'org-latex-export-to-pdf)))

(require 'org)
(setq org-highlight-latex-and-related '(latex script entities))

(with-eval-after-load 'ox-latex
   (add-to-list 'org-latex-classes
                '("basic"
                  "\\documentclass{cup-pan}
		  \\usepackage[utf8]{inputenc}
		  \\usepackage{blindtext}
		  \\usepackage{minted}
		  \\usepackage{float}
		  \\usepackage{upgreek}
		  \\usepackage{indentfirst}
		  \\usepackage[table]{xcolor}
		  \\usepackage{hyperref}
		  \\usepackage{wrapfig}
		  \\usepackage{gensymb}
		  \\usepackage{wasysym}
		  \\definecolor{mygray}{RGB}{251,251,251}
		  \\usepackage[position=bottom]{subfig}
		  \\usepackage{mathtools}
		  \\usepackage[superscript]{cite}
		  \\bibliographystyle{ieeetran}"
                  ("\\section{%s}" . "\\section*{%s}")
                  ("\\subsection{%s}" . "\\subsection*{%s}")
                  ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))

;                           --------------------

;  _             _               
; | |      __ _ | |_   ___ __  __
; | |     / _` || __| / _ \\ \/ /
; | |___ | (_| || |_ |  __/ >  < 
; |_____| \__,_| \__| \___|/_/\_\

;; Ensure PATH and TeX binaries are correctly accessed on macOS/Linux
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize)
  (add-to-list 'exec-path "/Library/TeX/texbin"))

;; Configure AUCTeX for LaTeX
(use-package auctex
  :ensure t
  :defer t
  :hook ((LaTeX-mode . TeX-PDF-mode)      ;; Enable PDF mode by default
         (LaTeX-mode . reftex-mode)      ;; Enable RefTeX for citations
         (LaTeX-mode . flyspell-mode))   ;; Enable Flyspell for spelling checks
  :config
  (setq TeX-engine 'xetex                 ;; Use XeTeX engine
        TeX-auto-save t
        TeX-parse-self t
        TeX-source-correlate-mode t      ;; Enable source correlation
        TeX-source-correlate-start-server t
        TeX-master nil)                  ;; Prompt for master file when opening .tex files

  ;; Set Okular as the default PDF viewer
  (setq TeX-view-program-selection '((output-pdf "Okular"))))
  ;; (setq TeX-view-program-list '(("Okular" "okular --unique %o#src:%n%b"))))


;; Flyspell configuration for spell-checking
(use-package flyspell
  :ensure t
  :hook (LaTeX-mode . flyspell-mode)
  :config
  (setq ispell-dictionary "french")
  (add-hook 'flyspell-mode-hook
            (lambda () (ispell-change-dictionary "french"))))

;; RefTeX for bibliography and cross-references
(use-package reftex
  :ensure t
  :hook (LaTeX-mode . reftex-mode)
  :config
  (setq reftex-plug-into-AUCTeX t
        reftex-default-bibliography '("~/Documents/References/references.bib")))



;                           --------------------

(setq confirm-kill-processes nil)

;; Company Mode Configuration
(use-package company
  :ensure t
  :config
  (global-company-mode 1)
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 2)
  
  (add-to-list 'company-backends 'company-files)  ;; Add company-files for path completion
  
  ;; Optionally, enable ido-mode for interactive path completion
  ;; (ido-mode 1)
  ;; (setq ido-enable-flex-matching t)
  ;; (setq ido-everywhere t)
)

;; R _________________________________________________________________
(use-package ess
  :ensure t
  :config
  ;; Disable Flymake in ESS
  (setq ess-use-flymake nil)
  (add-hook 'ess-r-mode-hook (lambda () (flymake-mode -1)))
  (add-hook 'inferior-ess-r-mode-hook (lambda () (flymake-mode -1)))

  ;; Enable company-mode for code completion in R
  (add-hook 'inferior-ess-r-mode-hook 'company-mode)
  (add-hook 'inferior-ess-r-mode-hook
            (lambda ()
              (setq-local company-backends '((company-files company-dabbrev-code)))))
)

;; Custom function to split window when starting inferior R
(defun init-R ()
  "Initialize the R process with a split window."
  (interactive)
  (split-window-right))

;; Hook for starting inferior-ess-r-mode with custom window split
(add-hook 'inferior-ess-r-mode-hook 'init-R)


;; PYTHON ____________________________________________________________
;; (use-package pyvenv
;;   :ensure t
;;   :config
;;   ;; Activate the Python virtual environment: project-specific or global
;;   (let ((project-env (expand-file-name ".python_env"))
;;         (global-env (expand-file-name "~/.python_env")))
;;     (pyvenv-activate (if (file-directory-p project-env)
;;                          project-env
;;                        global-env))))

;; (use-package elpy
;;   :ensure t
;;   :config
;;   ;; Set the Python interpreter for elpy to use the active virtual environment
;;   (setq elpy-rpc-python-command
;;         (expand-file-name "bin/python" pyvenv-virtual-env))

;;   ;; Use IPython as the Python shell interpreter
;;   (setq python-shell-interpreter "ipython"
;;         python-shell-interpreter-args "--simple-prompt -i")

;;   ;; Enable elpy
;;   (elpy-enable))



;; ;; Allow company mode for python shell
;; (add-hook 'python-shell-completion-setup-hook
;;           (lambda ()
;;             (setq-local company-backends '((company-files company-dabbrev-code)))))

;; (defun restart-python-shell ()
;;   "Kill the current Python shell and restart it."
;;   (interactive)
;;   (let ((python-shell-buffer-name "*Python*"))
;;     (when (get-buffer python-shell-buffer-name)
;;       (kill-buffer python-shell-buffer-name)))
;;   (run-python))

;; (global-set-key (kbd "C-c r") 'restart-python-shell)




;; PYTHON ____________________________________________________________
(use-package python
  :ensure t
  :config
  (setq python-shell-interpreter "ipython"
        python-shell-interpreter-args "--simple-prompt -i"
        python-shell-completion-native-enable nil
	python-indent-guess-indent-offset-verbose nil
	python-indent-offset 4))


;; (use-package pyvenv
;;   :ensure t
;;   :hook (python-mode . pyvenv-auto-activate)
;;   :config
;;   (defun pyvenv-auto-activate ()
;;     "Auto-activate .python_env if found."
;;     (let ((venv-dir (locate-dominating-file default-directory ".python_env")))
;;       (when venv-dir
;;         (pyvenv-activate (expand-file-name ".python_env" venv-dir))))))

(use-package pyvenv
  :ensure t
  :hook (python-mode . pyvenv-auto-activate)
  :config
  (defun pyvenv-auto-activate ()
    "Auto-activate a Python virtual environment.

1. Prefer `.python_env` in current directory/project.
2. Fallback to `~/.python_env` if none found."
    (let* ((project-venv (locate-dominating-file default-directory ".python_env"))
           (default-venv (expand-file-name "~/.python_env"))
           (venv-to-activate (or project-venv
                                 (and (file-directory-p default-venv) default-venv))))
      (when venv-to-activate
        (pyvenv-activate (expand-file-name ".python_env" venv-to-activate))))))



(defun my-python-start-shell ()
  "Open Python shell on the right, keep current Python buffer on the left."
  (when (and (derived-mode-p 'python-mode)
             (not (python-shell-get-process)))
    (let* ((source-buffer (current-buffer))
           (source-window (selected-window))
           (python-window (split-window-right)))
      ;; Start Python (may clobber windows)
      (run-python (python-shell-calculate-command) nil nil)
      ;; Restore source buffer explicitly
      (set-window-buffer source-window source-buffer)
      ;; Put Python in the right window
      (set-window-buffer
       python-window
       (process-buffer (python-shell-get-process)))
      ;; Keep focus on source
      (select-window source-window))))


(add-hook 'hack-local-variables-hook #'my-python-start-shell)


(add-hook 'python-shell-completion-setup-hook
          (lambda ()
            (setq-local company-backends '((company-files 
                                            company-dabbrev-code
                                            company-keywords
                                            company-yasnippet)))))


(defun create-python-env ()
  "Create or recreate a .python_env virtualenv in the current project.
Installs IPython and any packages listed in requirements.txt if present."
  (interactive)
  (let* ((venv-path (expand-file-name ".python_env" default-directory))
         (python "python3")  ;; Change if you want a specific Python
         (requirements (expand-file-name "requirements.txt" default-directory)))
    ;; Remove existing venv if it exists
    (when (file-directory-p venv-path)
      (delete-directory venv-path t))
    ;; Create new virtualenv
    (shell-command (format "%s -m venv %s" python venv-path))
    ;; Activate the venv in Emacs
    (pyvenv-activate venv-path)
    ;; Upgrade pip and install ipython
    (shell-command (format "%s -m pip install --upgrade pip ipython" 
                           (expand-file-name "bin/python" venv-path)))
    ;; Install requirements if the file exists
    (when (file-exists-p requirements)
      (shell-command (format "%s -m pip install -r %s"
                             (expand-file-name "bin/python" venv-path)
                             requirements)))
    (message "Python virtualenv created at %s" venv-path)))




;; HTML PHP __________________________________________________________
(use-package web-mode
  :ensure t
  :mode (("\\.html\\'" . web-mode)
         ("\\.php\\'" . web-mode))
  :config
  (setq web-mode-enable-css-colorization t))

;; SQL _______________________________________________________________
(setq sql-connection-alist
      '((explore2 (sql-product 'postgres)
                  (sql-database "postgresql://dora@localhost/explore2"))
        (server2 (sql-product 'postgres)
                 (sql-port 5432)
                 (sql-server "localhost")
                 (sql-user "user")
                 (sql-password "password")
                 (sql-database "db2"))))

(defun my-sql-connect (product connection)
  "Connect to a SQL database with the given product and connection."
  (setq sql-product product)
  (sql-connect connection))

(defun sql-explore2 ()
  "Connect to the explore2 database."
  (interactive)
  (my-sql-connect 'postgres 'explore2))

;; Automatically split window for SQL interactive mode
(use-package sql
  :ensure t
  :hook (sql-interactive-mode . init-sql)
  :config
  (defun init-sql ()
    "Initialize SQL interactive mode with a split window."
    (split-window-right)
    (run-at-time 0.1 nil
                 (lambda () (toggle-truncate-lines t)))))
(put 'scroll-left 'disabled nil)


;; YAML ______________________________________________________________
(use-package yaml-mode
  :ensure t
  :mode ("\\.ya?ml\\'" . yaml-mode)
  :hook ((yaml-mode . (lambda ()
                        (setq tab-width 2)
                        (setq yaml-indent-offset 2)
                        (setq indent-tabs-mode nil)))))
