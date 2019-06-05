;;;* My Emacs Config (hit TAB to expand)
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

(setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH")))
(setq exec-path (append exec-path '("/usr/local/bin")))

(defvar emu-dropbox-path "~"
  "Variable containing the file path to my personal dropbox folder.")

(if (file-exists-p "~/Dropbox (Personal)/")
    (setq emu-dropbox-path "~/Dropbox (Personal)/"))

(defun emu-org-scratch ()
  "Make a new 'org-mode' buffer."
  (interactive)
  (switch-to-buffer (get-buffer-create "new.org"))
  (org-mode))

;;;** Package initialization & config
;;;*** Org
(use-package ox-gfm)

(use-package ox-jira
             :config (add-to-list 'org-export-backends 'jira))

(require 'ox-odt)

(use-package org
  :config
  (define-key global-map "\C-cl" 'org-store-link)
  (define-key global-map (kbd "C-M-RET") 'org-insert-subheading)

  (add-hook 'org-capture-mode-hook 'evil-insert-state)
  ;; (add-hook 'org-capture-after-finalize-hook 'org-agenda-redo-all)
  (add-hook 'org-mode-hook 'visual-line-mode)
  (add-hook 'org-mode-hook 'org-indent-mode)

  (setq org-export-with-section-numbers nil)
  (setq org-export-with-toc nil)
  (setq org-html-validation-link nil)
  (setq org-export-html-postamble nil)

  (setq org-src-fontify-natively t)

  (setq org-export-headline-levels 6)

  ;; This sets a custom character to indicate a heading
  ;; has collapsed content associated with it
  ;; (setq org-ellipsis nil)
  ;; (setq org-ellipsis " ⋯")
  ;; (setq org-ellipsis " ⤵")

  ;; This logs the date/time TODO items are marked DONE
  (setq org-log-done t)

  (setq org-todo-keywords
        '((sequence "TODO" "IN-PROGRESS" "WAITING" "|" "DONE" "CANCELED")))

  ;; This tells org-mode where my org files live
  (setq org-agenda-files (list (concat emu-dropbox-path "org")))

  ;; This lets me refile across all my agenda files
  (setq org-refile-targets
      '((nil :maxlevel . 3)
        (org-agenda-files :maxlevel . 3)))

  ;; Do some automatic saving
  ;; https://emacs.stackexchange.com/questions/477/how-do-i-automatically-save-org-mode-buffers
  (add-hook 'org-agenda-mode-hook
          (lambda ()
            (message "AGENDA MODE ENGAGED")
            (add-hook 'auto-save-hook 'org-save-all-org-buffers nil t)
            (auto-save-mode)))

  ;; Save after refile
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  ;; (setq org-archive-location "~/data/org/archive/%s::")
  (setq org-archive-location (concat emu-dropbox-path "org/archive/%s::"))

  (setq org-capture-templates
        `(("h" "Home task" entry (file+headline ,(concat emu-dropbox-path "org/home.org") "Unorganized Tasks") "** TODO %?\n  %i\n")
          ("c" "Work task" entry (file+headline ,(concat emu-dropbox-path "org/work.org") "Tasks") "* TODO %? %^g")
          ("p" "Project Idea" entry (file ,(concat emu-dropbox-path "org/projects.org")) "* %?")
          ("j" "Jira Annoyance" item (file+headline ,(concat emu-dropbox-path "org/work.org") "Why I Hate Jira") "%?")
          ("b" "Blog idea" entry (file  ,(concat emu-dropbox-path "org/posts.org")) "* %?"))))


(use-package evil-org
  :after (org evil)
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (evil-org-set-key-theme '(textobjects insert navigation additional shift todo agenda))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

;;;*** Functions
(defun emu-dired-open-file-at-point ()
  "Open the file at point in the OS's default application"
  (interactive)
  (shell-command (concat "open " (dired-file-name-at-point))))

(defun emu-projectile-run-eshell-dwim ()
  "Open up an eshell, and if in a project, open it in that project's root"
  (interactive)
  (if (projectile-project-p)
      (projectile-run-eshell)
    (eshell)))

(defun emu-open-dired-here ()
  "Open a dired in the current directory"
  (interactive)
  (dired default-directory))

(defun emu-new-buffer ()
  "Open a new buffer."
  (interactive)
  (switch-to-buffer (generate-new-buffer "*scratch*")))

(defun emu-insert-date ()
  "Insert current date into buffer."
  (interactive)
  (insert (shell-command-to-string "echo -n $(date +%m-%d-%y)")))

(defun emu-insert-month-name ()
  "Insert current month into buffer.
Stolen from here: https://www.emacswiki.org/emacs/InsertingTodaysDate"
  (interactive)
  (insert (shell-command-to-string "echo -n $(date +%B)")))

(defun emu-open-config-file ()
  "Open the emacs config file."
  (interactive)
  (find-file user-init-file))
;;;*** General
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

   "j" '(:ignore t :which-key "jump 🕴")
   "je" 'emu-open-config-file
   "jb" 'counsel-bookmark
   "jh" '((lambda () (interactive) (find-file (concat emu-dropbox-path "org/home.org"))) :which-key "home org")
   "jw" '((lambda () (interactive) (find-file (concat emu-dropbox-path "org/work.org"))) :which-key "work org")
   "jo" 'counsel-org-goto
    ;; (concat emu-dropbox-path "org/home.org")

   "e" '(:ignore t :which-key "edit ✏")
   "ec"   'emu-copy-file-name-to-clipboard

   "b" '(:ignore t :which-key "buffers 🖹")
   "bs" 'ivy-switch-buffer
   "SPC" 'evil-buffer
   "bk" 'kill-buffer
   "bn" 'emu-new-buffer
   "bb" 'evil-buffer
   "be" 'emu-open-config-file
   ;; "bb" 'counsel-bookmark
   "bh" '((lambda () (interactive) (find-file (concat emu-dropbox-path "org/home.org"))) :which-key "home org")
   "bw" '((lambda () (interactive) (find-file (concat emu-dropbox-path "org/work.org"))) :which-key "work org")

   "v" '(:ignore t :which-key "view 👁")
   "vt" 'toggle-truncate-lines
   "vl" 'emu-toggle-line-numbers-type
   "vj" 'recenter
   "vz" '((lambda () (interactive) (text-scale-adjust 0.5)) :which-key "adjust font size")

   "h" 'help-command

   "c" 'org-capture

   ))
;;;*** Evil
(use-package evil
  ;; Evil mode is what makes emacs worth using. <3
  ;; It emulates vim inside of emacs.
  :config
  (evil-mode 1)
  (spc-leader-def
    "w" '(:ignore t :which-key "windows 📖")
    ;; ugh, I gotta figure out how to use SPC w to simulate "C-w"
    ;; "w" '((lambda () (interactive) (general-simulate-key "C-w")) :which-key "windows 📖")
    ;; "w" (general-simulate-key "C-w")
    ;; "w" '(lambda () (interactive) (general-key "C-w") :which-key "windows 📖")
    ;; "w" '(lambda () (interactive) (general-key "C-w") :which-key "windows 📖")
    "wh" 'evil-window-left
    "wj" 'evil-window-down
    "wk" 'evil-window-up
    "wl" 'evil-window-right
    "wc" 'evil-window-delete
    "wo" 'delete-other-windows
    ;; "ws" '((lambda () (interactive) (split-window-vertically) (other-window 1) (buffer-menu)) :which-key "split 🁣")
    ;; "wv" '((lambda () (interactive) (split-window-horizontally) (other-window 1) (buffer-menu)) :which-key "split 🀱")
    "ws" 'evil-window-split
    "wv" 'evil-window-vsplit
    "C-w" nil
    ;; "C-w s" '((lambda () (interactive) (split-window-vertically) (other-window 1) (buffer-menu)) :which-key "split 🁣")
    ;; "C-w v" '((lambda () (interactive) (split-window-horizontally) (other-window 1) (buffer-menu)) :which-key "split 🀱")
    ;; "ws" '((lambda () (interactive) (split-window-vertically) (other-window 1) (buffer-menu)) :which-key "split 🁣")
    ;; "wv" '((lambda () (interactive) (split-window-horizontally) (other-window 1) (buffer-menu)) :which-key "split 🀱")
    ;; "w=" 'balance-windows
    )

  (general-define-key
   :states '(motion)
   "j" 'evil-next-visual-line
   "k" 'evil-previous-visual-line)

  (general-def 'motion 'override
   ;; Use ctrl + arrow keys for window movement
   "C-<left>" 'evil-window-left
   "C-<down>" 'evil-window-down
   "C-<up>" 'evil-window-up
   "C-<right>" 'evil-window-right

   ;; Use shift + arrow keys to throw window
   "S-<right>" 'evil-window-right
   "S-<left>" 'evil-window-move-far-left
   "S-<down>" 'evil-window-move-very-bottom
   "S-<up>" 'evil-window-move-very-top
   "S-<right>" 'evil-window-move-far-right

   "-" 'emu-open-dired-here
   "gx" 'browse-url-at-point
   ))

(use-package evil-surround
  ;; evil-surround emulates tpope's surround.vim plugin, for evil, in emacs.
  :config
  ;; This lets surround play nicely with evil-paredit
  (add-to-list 'evil-surround-operator-alist
               '(evil-paredit-change . change))
  (add-to-list 'evil-surround-operator-alist
               '(evil-paredit-delete . delete))

  (global-evil-surround-mode t))

(use-package evil-commentary
  ;; evil-commentary emulates tpope's vim-commentary plugin, for evil, in emacs.
  :diminish ""
  :config
  (evil-commentary-mode))

(use-package evil-matchit
  :pin melpa-stable
  :config

  (eval-after-load 'evil-matchit-ruby
    '(progn
       (add-to-list 'evilmi-ruby-extract-keyword-howtos '("^[ \t]*\\([a-z]+\\)\\( .*\\| *\\)$" 1))
       (add-to-list 'evilmi-ruby-match-tags '(("unless" "if") ("elsif" "else") "end"))
       ))

  (global-evil-matchit-mode 1))

(use-package evil-paredit
  :config
  (add-hook 'emacs-lisp-mode-hook 'evil-paredit-mode))

;;;*** Magit
(use-package magit
  :pin melpa-stable
  :config
  (magit-auto-revert-mode)
  (magit-save-repository-buffers)

  (vc-mode vc-mode)

  ;; Speed things up a little
  ;; https://williambert.online/2015/11/How-I-made-Magit-fast-again/
  (setq magit-commit-show-diff nil)

  ;; https://endlessparentheses.com/easily-create-github-prs-from-magit.html
  (defun endless/visit-pull-request-url ()
    "Visit the current branch's PR on Github."
    (interactive)
    (browse-url
     (format "https://github.com/%s/pull/new/%s"
             (replace-regexp-in-string
              "\\`.+github\\.com:\\(.+\\)\\.git\\'" "\\1"
              (magit-get "remote"
                         (magit-get-current-remote)
                         "url"))
             (magit-get-current-branch))))

  (eval-after-load 'magit
    '(define-key magit-mode-map "V"
       #'endless/visit-pull-request-url))


  ;; Prevent magit from making new splits, but only sometimes
  ;; https://github.com/magit/magit/issues/2541
  (setq magit-display-buffer-function
      (lambda (buffer)
        (display-buffer
         buffer (if (and (derived-mode-p 'magit-mode)
                         (memq (with-current-buffer buffer major-mode)
                               '(magit-process-mode
                                 magit-revision-mode
                                 magit-diff-mode
                                 magit-stash-mode
                                 magit-status-mode)))
                    nil
                  '(display-buffer-same-window))))))

(use-package evil-magit
  :pin melpa-stable
  :after evil)

;;;*** Ivy/Counsel/Projectile
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
  :diminish ""
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
            "pk" 'projectile-add-known-project)

  :config
  (projectile-global-mode)

  ;; Enable caching to reduce delay when opening projectile
  (setq projectile-enable-caching t)

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

;;;*** Filetypes
(use-package json-mode
  ;; This is used mostly for syntax highlighting on JSON files. It also
  ;; provides functions for working with JSON, but I'll probably never
  ;; use them.
  ;; https://github.com/joshwnj/json-mode
 )

(use-package haml-mode
  :pin melpa-stable)

(use-package js2-mode
  :pin melpa-stable)

(defun emu-run-src-in-love ()
  "Invoke `async-shell-command' in the project's root."
  (interactive)
  (projectile-with-default-dir (projectile-project-root)
    (shell-command "/Applications/love.app/Contents/MacOS/love src")))

(use-package lua-mode
  :mode "\\.p8\\'"
  :bind ("C-SPC" . 'emu-run-src-in-love))

(use-package twig-mode)

(use-package markdown-mode)

(use-package csharp-mode)

(use-package handlebars-sgml-mode)

(use-package scss-mode
  :mode "\\.scss.erb\\'")

(use-package web-mode
  :pin melpa-stable
  :mode "\\.cshtml\\'"
  :config
  (setq web-mode-markup-indent-offset 2))

;;;*** Other
;; (use-package sound-wav
;;   :config
;;   (setq ring-bell-function (lambda ()
;;                              ;; (play-sound '(sound :file "~/.emacs.d/sound/bell.wav"))
;;                              ;; (sound-wav-play  "~/.emacs.d/sound/bell.wav")
;;                              )))

;; (use-package dsvn)
;; (use-package masvn)

(use-package npm-mode
  :config
  (npm-global-mode)
  (spc-leader-def
    "n" (general-simulate-key "C-c n")))

(use-package nvm
  :config
  (nvm-use "10.13.0"))

(use-package flycheck
  :config
  ;; Show errors in minibuffer instantly
  (global-flycheck-mode)

  (general-define-key
   :states '(motion)
   "]e" 'flycheck-next-error
   "[e" 'flycheck-previous-error)
  )

(use-package ag)

(use-package rvm)

(use-package rspec-mode
  :mode
  ("*spec.rb" . rspec-mode))

(use-package diminish
  :config
  (diminish 'undo-tree-mode))

(use-package visual-fill-column
    :pin melpa-stable)

(use-package writeroom-mode
    :pin melpa-stable)

(use-package emmet-mode
  ;; This enables usage of emmet, which is a tool that lets you expand
  ;; CSS selector-like snippets into HTML. It also has some CSS
  ;; expansions.
  :hook (sgml-mode css-mode)
  :bind ("C-SPC" . emmet-expand-line))

(use-package which-key
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1)
  (setq which-key-idle-secondary-delay 0.01)
  (setq which-key-separator "  ")
  (setq which-key-show-prefix 'echo)
  (setq which-key-max-description-length 50)
  (setq which-key-prefix-prefix "")
  (setq which-key-add-column-padding 3)
  (setq which-key-sort-order 'which-key-prefix-then-key-order))

(use-package paredit
  :config
  (add-hook 'emacs-lisp-mode-hook 'paredit-mode))

(use-package hl-line
 :config
  (global-hl-line-mode))

(use-package default-text-scale

  ;; this lets us change text sizes in all of emacs. emacs' built-in
  ;; text-scale-* functions only operate on the current buffer.
  :config
  (define-key global-map (kbd "s-=") 'default-text-scale-increase)
  (define-key global-map (kbd "s--") 'default-text-scale-decrease))

(use-package rainbow-delimiters
  :config
  (add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode))

(defun get-flatui-color (c)
  "Get a color from the values set by the flatui-theme package.
These colors can be also be referenced at this URL:
http://flatuicolors.com/palette/defo
"
  (cdr (assoc c flatui-colors-alist)))

(defun emu-set-faces (bg-color)
  (interactive)
  (set-face-attribute 'show-paren-match nil
                      :background (get-flatui-color "sun-flower")
                      :foreground (get-flatui-color "wet-asphalt")
                      :weight 'bold)
  (set-face-attribute 'default nil
                      :background bg-color)
  (set-face-attribute 'fringe nil
                      :background bg-color)
  (set-face-attribute 'hl-line nil
                      :background "#f3f8f8")
  (set-face-attribute 'line-number nil
                      :height 0.7
                      :box `(:line-width 4 :color ,(get-flatui-color "clouds") :style nil)
                      :foreground (get-flatui-color "concrete"))
  (set-face-attribute 'line-number-current-line nil
                      :weight 'bold
                      :background (get-flatui-color "sun-flower")
                      :box `(:line-width 4 :color ,(get-flatui-color "sun-flower") :style nil)
                      :foreground (get-flatui-color "midnight-blue"))
  (set-face-attribute 'org-ellipsis nil
                      :weight 'normal
                      :height 0.75
                      :foreground (get-flatui-color "wet-asphalt")
                      :underline nil)
  (set-face-attribute 'header-line nil
                      :background (get-flatui-color "clouds")
                      :foreground (get-flatui-color "wet-asphalt")
                      :box `(:line-width 20 :color ,(get-flatui-color "clouds") :style nil))
  (set-face-attribute 'org-agenda-date-today nil
                      :background (get-flatui-color "clouds")
                      :foreground (get-flatui-color "midnight-blue"))
  (set-face-attribute 'mode-line nil
                      :background (get-flatui-color "sun-flower")
                      :foreground (get-flatui-color "midnight-blue")
                      :box `(:line-width 10 :color ,(get-flatui-color "sun-flower") :style nil))
  (set-face-attribute 'mode-line-inactive nil
                      :background (get-flatui-color "silver")
                      :foreground (get-flatui-color "asbestos")
                      :box `(:line-width 10 :color ,(get-flatui-color "silver") :style nil))
  (set-face-attribute 'minibuffer-prompt nil
                      :background (get-flatui-color "clouds")
                      :foreground (get-flatui-color "wisteria")))

(use-package flatui-theme
  ;; Nice colors!
  :config
  ;; Better font
  (add-to-list 'default-frame-alist '(font . "Ubuntu Mono:pixelsize=16:weight=normal:slant=normal:width=normal:spacing=100:scalable=true"))

  ;; Change fringe size
  (set-fringe-mode '(10 . 10))

  (setq-default line-spacing 0)

  (setq frame-background-mode 'light)

  (emu-set-faces (get-flatui-color "clouds")))



;;;** Emacs settings
;;;*** Nice defaults
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
(setq-default evil-shift-width 2)
(setq-default css-indent-offset 2)
(setq js-indent-level 2)
(setq js-basic-offset 2)

(setq-default fill-column 80)

(setq show-paren-delay 0)
(setq show-paren-style 'parenthesis)
(show-paren-mode)

;; this automatically reads files from disk when they've changed
(global-auto-revert-mode)

;; Persistent history for eshell & other minibuffer history rings
(savehist-mode)

(setq)

(when (string= system-type "darwin")
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . 'nil))
  (add-to-list 'default-frame-alist '(height . 103))
  (add-to-list 'default-frame-alist '(width . 87)))

;; (add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))

;; this disables the splash screen
(setq inhibit-splash-screen t)

(setq dired-dwim-target t
      dired-recursive-deletes t
      delete-by-moving-to-trash t)

;; Disable GUI toolbar
(tool-bar-mode -1)

;; Disable GUI scrollbar
(toggle-scroll-bar -1)


;; (pixel-scroll-mode)

;; this replaces "yes or no" prompts with "y or n" prompts that only require a
;; single keystroke
(fset 'yes-or-no-p 'y-or-n-p)

;; http://emacsredux.com/blog/2013/03/27/copy-filename-to-the-clipboard/
(defun emu-copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard.
If in a project, copy the file path relative to the project root."
  (interactive)
  (let* ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name)))
        (relative-filename (if (projectile-project-p)
                               (file-relative-name filename (projectile-project-root))
                             filename)))
    (when relative-filename
      (kill-new relative-filename)
      (message "Copied buffer file name '%s' to the clipboard." relative-filename))))

;; Offer to create parent directories if they do not exist
;; http://iqbalansari.github.io/blog/2014/12/07/automatically-create-parent-directories-on-visiting-a-new-file-in-emacs/
(defun emu-create-non-existent-directory ()
  (let ((parent-directory (file-name-directory buffer-file-name)))
    (when (and (not (file-exists-p parent-directory))
               (y-or-n-p (format "Directory `%s' does not exist! Create it?" parent-directory)))
      (make-directory parent-directory t))))

(add-to-list 'find-file-not-found-functions #'emu-create-non-existent-directory)


(setq sentence-end-double-space nil
      echo-keystrokes 0.01)

;; disable backups. without this, emacs poops out #backup_files# everywhere.
;; gross. just use git, ya silly dingus. for your health.
(setq make-backup-files nil)
(setq auto-save-default nil)

;; by default, emacs rings the system bell a lot. when it makes sound,
;; it gets really annoying really fast. this provides a custom
;; function to "ring the bell." this quickly flashes the mode line as
;; an inverted color.
(setq ring-bell-function (lambda ()
			   (invert-face 'mode-line)
			   (run-with-timer 0.05 nil 'invert-face 'mode-line)))
;; (setq ring-bell-function (lambda ()
;; 			  (play-sound-file "~/.emacs.d/sound/bell.wav")))
;; (setq ring-bell-function nil)
;; (async-shell-command "say yo" nil)
;; (async-shell-command "osascript -e beep")
;; (ding)

;; a little encouragement while starting up emacs
(setq dope-unicorn "
;;               \\
;;                \\
;;                 \\\\
;;                  \\\\
;;                   >\\/7
;;               _.-(6'  \\
;;              (=___._/` \\
;;                   )  \\ |
;;                  /   / |
;;                 /    > /
;;                j    < _\\
;;            _.-' :      ``.
;;            \\ r=._\\        `.
;;           <`\\\\_  \\         .`-.
;;            \\ r-7  `-. ._  ' .  `\\
;;             \\`,      `-.`7  7)   )
;;              \\/         \\|  \\'  / `-._
;;                         ||    .'
;;                          \\\\  (
;;                           >\\  >
;;                       ,.-' >.'
;;                      <.'_.''
;;                        <'")
(setq initial-scratch-message dope-unicorn)

;;;*** Hooks

;;; Normally this type of stuff is set up within my use-package configs, but
;;; there aren't use-package configs for built-in stuff like dired. So those
;;; kind of hooks for vanilla emacs stuff lives here.
;;;
;;; This feels pretty messy. I'd like a way to oranize this stuff better.

(add-hook 'shell-mode-hook 'evil-normal-state)

(defun emu-open-finder-here ()
  (interactive)
  (shell-command "open ."))

(defun emu-dired-mode-hook-func ()
  (evil-define-key 'normal dired-mode-map
    "n" 'evil-search-next
    "N" 'evil-search-previous
    "gg" 'evil-goto-first-line
    "G" 'evil-goto-line
    "-" 'dired-up-directory
    (kbd "s-r") 'revert-buffer
    "F" 'emu-open-finder-here
    "O" 'emu-dired-open-file-at-point)
  (dired-hide-details-mode 1))
(add-hook 'dired-mode-hook 'emu-dired-mode-hook-func)

(defun emu-eshell-mode-hook-func ()
  ;; https://emacs.stackexchange.com/questions/27849/how-can-i-setup-eshell-to-use-ivy-for-tab-completion
  (define-key eshell-mode-map (kbd "<tab>") 'completion-at-point)

  ;; This makes eshell aware of the homebrew directory
  (setq eshell-path-env (concat "/usr/local/bin:" eshell-path-env)))
(add-hook 'eshell-mode-hook 'emu-eshell-mode-hook-func)

(defun emu-emacs-lisp-mode-hook-func ()
  (outline-minor-mode 1)
  (setq outline-regexp ";;;\\*+\\|\\`")
  (define-key evil-normal-state-map (kbd "TAB") 'outline-toggle-children)
  (define-key evil-normal-state-map (kbd "gh") 'outline-up-heading)
  (define-key evil-normal-state-map (kbd "gk") 'outline-previous-heading)
  (define-key evil-normal-state-map (kbd "gj") 'outline-next-heading)
  (define-key evil-normal-state-map (kbd "M-k") 'outline-move-subtree-up)
  (define-key evil-normal-state-map (kbd "M-j") 'outline-move-subtree-down)
  (outline-hide-body))
(add-hook 'emacs-lisp-mode-hook 'emu-emacs-lisp-mode-hook-func)

(defun emu-display-line-numbers-mode-hook ()
  (setq display-line-numbers 'visual))

(defun emu-toggle-line-numbers-type ()
  "toggle between absolute and visual line numbers."
  (interactive)
  (if (eq display-line-numbers 'visual)
      (setq display-line-numbers t)
    (setq display-line-numbers 'visual)))
(add-hook 'display-line-numbers-mode-hook 'emu-display-line-numbers-mode-hook)
(global-display-line-numbers-mode)

;; prevent "ls does not support --dired" message
(when (string= system-type "darwin")
  (setq dired-use-ls-dired nil))

;; ;; by default, async-shell-command pops up an annoying window showing
;; ;; the output of the async command. this prevents that.
;; (add-to-list 'display-buffer-alist
             ;; (cons "\\*async shell command\\*.*" (cons #'display-buffer-no-window nil)))

;; https://github.com/bbatsov/projectile/issues/520
(setq projectile-svn-command "find . -type f -not -iwholename '*.svn/*' -print0")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (ox-jira npm-mode nvm ox-odt javascript-eslint csharp-mode masvn dsvn psvn sound-wav wav-sound play-sound writeroom-mode which-key web-mode use-package twig-mode smex scss-mode rvm rspec-mode rainbow-delimiters ox-gfm markdown-mode lua-mode json-mode js2-mode handlebars-sgml-mode haml-mode general flycheck flatui-theme evil-surround evil-paredit evil-org evil-matchit evil-magit evil-leader evil-commentary emmet-mode diminish default-text-scale counsel-projectile ag))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:foreground "#2c3e50" :background "#ecf0f1")))))
