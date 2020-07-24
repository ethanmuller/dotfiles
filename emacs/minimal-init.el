;; https://github.com/ethanmuller/dotfiles/blob/master/emacs/init.el
;;;** Package system setup
(require 'package)
(add-to-list
 'package-archives
 '("org" . "http://orgmode.org/elpa/"))
(add-to-list
 'package-archives
 '("melpa" . "http://melpa.org/packages/"))
(add-to-list
 'package-archives
 '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq use-package-always-ensure t)

(eval-when-compile
  (require 'use-package))

(use-package general
  :config
  (general-evil-setup)
  (general-create-definer spc-leader-def
    :states '(normal visual insert motion emacs)
    :keymaps 'override
    :prefix "SPC"
    :non-normal-prefix "C-SPC")
  (spc-leader-def
   "d"   'dired

   "x"   'counsel-M-x

   "g"   'magit-status

   "i" '(:ignore t :which-key "insert ⚡")
   "id" 'emu-insert-date
   "im" 'emu-insert-month-name
   "il" 'org-insert-link

   "s" '(:ignore t :which-key "shell stuff 🐌")
   "se" 'eshell
   "sa" 'async-shell-command

   "f" '(:ignore t :which-key "files 🗄")
   "ff" 'counsel-find-file
   "fs" 'save-buffer
   "fw" 'write-file
   "fr" 'counsel-recentf
   "fc" 'emu-region-to-file

   "j" '(:ignore t :which-key "jump 🕴")
   "ja" '((lambda () (interactive) (find-file (concat emu-dropbox-path "documents/org/home.org"))) :which-key "home org")
   "js" '((lambda () (interactive) (find-file (concat emu-dropbox-path "documents/org/work.org"))) :which-key "work org")
   "jd" 'emu-open-config-file
   ;;
   "jo" 'counsel-org-goto
   "jh" 'outline-up-heading
   "jj" 'outline-next-heading
   "jk" 'outline-previous-heading
   ;;
   "jc" '(lambda () (interactive) (switch-to-buffer "*compilation*"))
   "jb" 'counsel-bookmark

   "e" '(:ignore t :which-key "edit ✏")
   "ec"   'emu-copy-file-name-to-clipboard
   "ed"   'delete-blank-lines

   "y" '(:ignore t :which-key "clipboard")
   "yf"   'emu-copy-file-name-to-clipboard

   "b" '(:ignore t :which-key "buffers 🖹")
   "bs" 'ivy-switch-buffer
   "SPC" 'evil-buffer
   "bk" 'kill-buffer
   "bN" 'emu-new-buffer
   "bn" 'next-buffer
   "bp" 'previous-buffer
   "bb" 'evil-buffer
   "be" 'emu-open-config-file
   ;; "bb" 'counsel-bookmark

   "oa" 'org-agenda
   "oc" 'org-capture
   "os" 'org-schedule
   "o#" 'counsel-org-tag
   "oe" 'counsel-org-tag
   "ow" 'org-save-all-org-buffers
   "ot" '(lambda ()
           (interactive)
           (setq current-prefix-arg '(4)) ; C-u
           (call-interactively 'org-todo))
   "op"   'explorg-publish-region

   "v" '(:ignore t :which-key "view 👁")
   "vt" 'toggle-truncate-lines
   "vl" 'emu-toggle-line-numbers-type
   "vj" 'recenter
   "vc" 'centered-cursor-mode
   "vz" '((lambda () (interactive) (text-scale-adjust 0.5)) :which-key "adjust font size")

   "h" 'help-command

   "c" 'org-capture

   ))

(use-package evil
  ;; Evil mode is what makes emacs worth using. <3
  ;; It emulates vim inside of emacs.
  :config
  (evil-mode 1))


(use-package ivy
  ;; Ivy is a completion framework. That means it helps you choose from
  ;; long lists of stuff in a lot of different contexts (like when you
  ;; hit M-x, or you're listing all your buffers). It's like a
  ;; lightweight version of Helm, if you've heard of that. I like it
  ;; more than Helm because it does less, and is less overwhelming.
  ;;
  ;; https://sam217pa.github.io/2016/09/13/from-helm-to-ivy/
  :diminish ""
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)

  ;; This removes default behavior to only match the beginning of strings
  (setq ivy-initial-inputs-alist nil)

  (setq ivy-height 20)

  ;; Nice-looking numbers
  (setq ivy-count-format "(%d/%d) "))

(use-package counsel
  ;; Counsel provides ivy-ified versions of common emacs commands
  :config
  (counsel-mode 1))

(use-package projectile
  :diminish ""
  :general (spc-leader-def
            "p" '(:ignore t :which-key "projects ✨")
            "pp" 'projectile-switch-project
            "pf" 'counsel-projectile-find-file
            "pa" 'projectile-run-async-shell-command-in-root
            "ps" 'counsel-projectile-ag
            "pc" 'projectile-compile-project
            "pd" 'projectile-dired
            "pk" 'projectile-add-known-project)

  :config
  (projectile-global-mode)

  (setq projectile-indexing-method 'alien)

  ;; Enable caching to reduce delay when opening projectile
  (setq projectile-enable-caching nil)

  ;; Expire cache after 30 minutes
  (setq projectile-files-cache-expire (* 60 30))

  ;; When switching projects, open a dired in root
  (setq counsel-projectile-switch-project-action 'dired))

(use-package counsel-projectile
  :config
  (counsel-projectile-mode))

(use-package smex
  ;; This automatically orders counsel's M-x list by frequency. Because
  ;; it's useful to have your most recently used stuff at the top!
  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(smex counsel-projectile projectile general evil use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
