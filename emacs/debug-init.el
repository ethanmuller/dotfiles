;;;* My Emacs Config
;;;** OS-specific config
(when (eq system-type 'windows-nt)
  (message "you're in Windows, nerd")
  )

(defconst emu/wsl (not (null (string-match "Linux.*Microsoft" (shell-command-to-string "uname -a")))))

(if emu/wsl
    (progn
      (setq browse-url-browser-function 'browse-url-generic browse-url-generic-program "wslview")))

(when (equal system-type 'darwin)
  (message "you're in macOS, hipster")
  (setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH")))
  (setq exec-path (append exec-path '("/usr/local/bin")))
  )

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

(setq byte-compile-warnings '(cl-functions))

(eval-when-compile
  (require 'use-package))

(setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH")))
(setq exec-path (append exec-path '("/usr/local/bin")))

(defvar emu-dropbox-path "~"
  "Variable containing the file path to my personal dropbox folder.")

(if (file-exists-p "~/Dropbox (Personal)/")
    (setq emu-dropbox-path "~/Dropbox (Personal)/"))

(if (file-exists-p "~/Dropbox/")
    (setq emu-dropbox-path (file-truename "~/Dropbox/")))

(if emu/wsl
    (setq emu-dropbox-path "/mnt/c/Users/ethan/Dropbox/"))

(defvar emu-org-path (concat emu-dropbox-path "Documents/org/")
  "Variable containing the file path to my org files.")

(defvar emu-roam-path (concat emu-org-path "roam")
  "Variable containing the file path to my org-roam files.")

(defun emu-region-to-file (begin end)
  "Move region to a file"
  (interactive "r")
  (call-interactively 'write-region)
  (call-interactively 'kill-region))

(defun emu-org-scratch ()
  "Make a new 'org-mode' buffer."
  (interactive)
  (switch-to-buffer (get-buffer-create "new.org"))
  (org-mode))

;;;** Packages & package config
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
   "ss" 'shell-command

   "f" '(:ignore t :which-key "files 🗄")
   "ff" 'counsel-find-file
   "fs" 'emu-save-buffer
   "fw" 'write-file
   "fr" 'counsel-recentf
   "fc" 'emu-region-to-file
   "fd" 'emu-delete-file-and-buffer

   "j" '(:ignore t :which-key "jump 🕴")
   "jf" 'emu-open-config-file
   ;; "jn" 'org-next-link
   ;; "jp" 'org-previous-link
   ;;
   "jo" 'counsel-org-goto
   ;; "jh" 'outline-up-heading
   ;; "jj" 'outline-next-heading
   ;; "jk" 'outline-previous-heading
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
   "oo" 'org-open-at-point
   "oq" 'counsel-org-tag
   "ow" 'org-save-all-org-buffers
   "o$" 'org-archive-subtree
   "ot" (general-simulate-key "C-c C-t")
   "op"   'explorg-publish-region
   "ol"  'org-store-link
   "o*" 'org-list-make-subtree

   "v" '(:ignore t :which-key "view 👁")
   "vt" 'toggle-truncate-lines
   "vl" 'emu-toggle-line-numbers-type
   "vL" 'emu-no-line-numbers
   "vj" 'recenter
   "vc" 'centered-cursor-mode
   "vz" '((lambda () (interactive) (text-scale-adjust 0.5)) :which-key "adjust font size")
   "vf" 'make-frame
   "vn" 'other-frame
   "vx" 'delete-frame

   "h" 'help-command

   "c" 'org-capture

   ))

;;;*** Org
(use-package org
  :config
  (add-hook 'org-capture-mode-hook 'evil-insert-state)
  (add-hook 'org-mode-hook 'visual-line-mode)
  (setq org-log-done t)
  (setq org-archive-location "%s_archive.org::")

  (setq org-todo-keywords
        '((sequence "TODO" "IN-PROGRESS" "|" "DONE" "CANCELLED")))

  (setq org-default-notes-file (concat emu-roam-path "/20210129221621-life.org"))
  (defun open-org-default-notes-file ()
    (interactive)
    (find-file org-default-notes-file))
  (setq org-capture-templates '(
                                ("j" "fleeting note" plain (file+headline org-default-notes-file "fleeting notes")  "** %i%?" :append t)
                                ))

(use-package evil-org
  :after (org evil)
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (evil-org-set-key-theme '(textobjects insert navigation additional shift todo agenda))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package emacsql-sqlite3
  :custom (emacsql-sqlite-executable-path "c:/Users/ethan/bin/sqlite3.exe"))
(use-package org-roam
  :hook
  (after-init . org-roam-mode)
  :config
  (setq org-roam-db-update-method 'immediate)
  (spc-leader-def
    "rr" 'org-roam
    "rf" 'org-roam-find-file
    "rc" 'org-roam-capture
    "ir" 'org-roam-insert
    "iR" 'org-roam-insert-immediate)
  (setq org-roam-directory emu-roam-path))

;;;*** Functions

(defun emu-save-buffer (&optional arg)
  "Wrapper function for buffer saving"
  (interactive)
  (save-buffer arg))

(defun emu-org-scratch ()
  "Make a new 'org-mode' buffer."
  (interactive)
  (switch-to-buffer (get-buffer-create "new.org"))
  (org-mode))

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
  (switch-to-buffer (generate-new-buffer "new buffer")))
 (defun emu-insert-date (arg)
   "Insert current date into buffer."
   (interactive "P")
   (insert (if arg
               (format-time-string "%d.%m.%Y")
             (format-time-string "%Y-%m-%d"))))

(defun emu-delete-file-and-buffer ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if filename
        (if (y-or-n-p (concat "Do you really want to delete file " filename " ?"))
            (progn
              (delete-file filename)
              (message "Deleted file %s." filename)
              (kill-buffer)))
      (message "Not a file visiting buffer!"))))

(defun emu-open-config-file ()
  "Open the emacs config file."
  (interactive)
  (find-file user-init-file))
;;;*** Evil
(use-package undo-tree
  :config
  (global-undo-tree-mode))
(use-package evil
  ;; Evil mode is what makes emacs worth using. <3
  ;; It emulates vim inside of emacs.
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-tree)
  (evil-set-initial-state 'wdired-mode 'normal)

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

(use-package evil-numbers
  :general (spc-leader-def
             "ia" 'evil-numbers/inc-at-pt
             "iz" 'evil-numbers/dec-at-pt))

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

  (defun parse-url (url)
    "convert a git remote location as a HTTP URL"
    (if (string-match "^http" url)
        url
      (replace-regexp-in-string "\\(.*\\)@\\(.*\\):\\(.*\\)\\(\\.git?\\)"
                                "https://\\2/\\3"
                                url)))
  (defun magit-open-repo ()
    "open remote repo URL"
    (interactive)
    (let ((url (magit-get "remote" "origin" "url")))
      (progn
        (browse-url (parse-url url))
        (message "opening repo %s" url))))

  ;; https://endlessparentheses.com/easily-create-github-prs-from-magit.html
  (defun emu/visit-pull-request-url ()
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

  (setq ivy-height 20)

  ;; Nice-looking numbers
  (setq ivy-count-format "(%d/%d) "))

(use-package counsel
  ;; Counsel provides ivy-ified versions of common emacs commands
  :diminish ""
  :config

  ;; This removes default behavior to only match the beginning of strings
  (setq ivy-initial-inputs-alist nil)

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
            "pk" 'projectile-add-known-project
            "a" 'recompile)

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

;;;*** YASnippet
;; (use-package yasnippet
;;   :init
;;   (yas-global-mode 1))
;; (use-package yasnippet-snippets)
;; (use-package ivy-yasnippet
;;   :config
;;   (spc-leader-def
;;     "is" 'ivy-yasnippet))

;;;*** Filetypes
(use-package python-mode)
(use-package swift-mode)

(use-package company
  :config
  (company-mode))

;; (use-package typescript-mode)

;; (use-package tide
;;   :after (typescript-mode company flycheck)
;;   :hook ((typescript-mode . tide-setup)
;;          (typescript-mode . tide-hl-identifier-mode)
;;          (before-save . tide-format-before-save)))

(use-package vue-mode
  :config
  (setq mmm-submode-decoration-level 0)
  (add-hook 'mmm-mode-hook
            (lambda ()
              (set-face-background 'mmm-default-submode-face "#ffffff"))))

(use-package prettier-js
  :config
  (add-hook 'js2-mode-hook 'prettier-js-mode)
  (add-hook 'web-mode-hook 'prettier-js-mode)
  (add-hook 'vue-mode-hook 'prettier-js-mode))

(use-package lua-mode
  :config
  (setq lua-indent-level 2))

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

(use-package rjsx-mode
  :pin melpa-stable
  :mode ("\\.js\\'"))

(defun emu-run-file-in-pico8 ()
  (interactive)
  (save-some-buffers)
  (async-shell-command (concat "/Applications/PICO-8.app/Contents/MacOS/pico8 " (file-name-nondirectory (buffer-file-name)))))

(defun emu-run-src-in-love ()
  (interactive)
  (projectile-with-default-dir (projectile-project-root)
    (save-some-buffers)
    (shell-command "love src")))

(spc-leader-def
  "ll" 'emu-run-src-in-love)

(defun emu-run-dir-in-love ()
  (interactive)
  (projectile-with-default-dir (projectile-project-root)
    (save-some-buffers)
    (shell-command "/Applications/love.app/Contents/MacOS/love .")))


(setq async-shell-command-buffer 'new-buffer)

(defun emu-say-line ()
  "Say the current line in a low voice. Only on macOS."
  (interactive)
  (let* ((line (thing-at-point 'line t))
         (command (concat "say -v Bruce -r 200 '[[pbas 25]]" line "'" )))
    (async-shell-command command)))

(defun emu-whisper-line ()
  "Say the current line in a whisper voice. Only on macOS."
  (interactive)
  (let* ((line (thing-at-point 'line t))
         (command (concat "say -v Whisper -r 100 '" line "'" )))
    (async-shell-command command)))

(defun emu-whisper-line-slowly ()
  "Say the current line in a whisper voice, slowly. Only on macOS."
  (interactive)
  (let* ((line (thing-at-point 'line t))
         (command (concat "say -v Whisper -r 30 '" line "'" )))
    (async-shell-command command)))

(use-package twig-mode)

(use-package markdown-mode)

(use-package grip-mode
  :pin melpa-stable
  :general (spc-leader-def
             "pr" 'grip-mode))

(use-package csharp-mode)

(use-package handlebars-sgml-mode)

(use-package scss-mode
  :mode "\\.scss.erb\\'")

(use-package web-mode
  :pin melpa-stable
  :mode ("\\.cshtml\\'" "\\.hbs\\'" "\\.svelte\\'")
  :config
  (setq web-mode-markup-indent-offset 2))

;;;*** SFX
;; (use-package sound-wav
;;   :config
;;   (when nil
;;     (setq emu-sfx-list
;;           '("prompt"
;;             "checkmark"
;;             "ending"
;;             "fyi"
;;             "result"
;;             "triumph"
;;             "uh-oh"
;;             "flup"
;;             "flown"
;;             "fluown"))

;;     (defun emu-play-sfx (name)
;;       "Plays the sound effect NAME"
;;       ;; (message (concat "playing sfx: " name))
;;       (interactive (list (completing-read "Play which SFX? " emu-sfx-list)))
;;       (sound-wav-play (concat "~/.emacs.d/sfx/" name ".wav")))

;;     (defun emu-random-choice (items)
;;       (let* ((size (length items))
;;              (index (random size)))
;;         (nth index items)))

;;     (defun emu-play-random-sfx ()
;;       "Play a random sound effect"
;;       (let ((choice (random-choice emu-sfx-list)))
;;         (emu-play-sfx choice)
;;         choice))

;;      ;; (emu-play-random-sfx)

;;     (advice-add 'emu-save-buffer :after (lambda (&optional arg) (emu-play-sfx "checkmark")))
;;     (advice-add 'org-todo :after (lambda (&optional arg) (emu-play-sfx "flup")))
;;     (advice-add 'y-or-n-p :before (lambda (&rest arg) (emu-play-sfx "prompt")))

;;     (add-hook 'git-commit-post-finish-hook (lambda (&optional arg) (emu-play-sfx "ending")))
;;     (add-hook 'compilation-finish-functions (lambda (buffer result)
;;                                               (if (string= (s-trim result) "finished")
;;                                                   (emu-play-sfx "result")
;;                                                 (emu-play-sfx "uh-oh"))))

    (setq ring-bell-function (lambda ()))

;;     ;; (advice-add 'save-some-buffers :before (lambda (&rest arg) (emu-play-sfx "prompt")))

;;     (emu-play-sfx "triumph")))

;;;*** Other

;; (use-package mu4e)

(use-package ox-jira)

(use-package org-tree-slide
  :pin melpa-stable
  :config
  (define-key org-tree-slide-mode-map (kbd "C-S-<left>") 'org-tree-slide-move-previous-tree)
  (define-key org-tree-slide-mode-map (kbd "C-S-<right>") 'org-tree-slide-move-next-tree)
  ;;;; this profile lets you focus on todos. interesting!
  ;;(org-tree-slide-narrowing-control-profile)
  (org-tree-slide-simple-profile)
  (setq org-tree-slide-header "forklore.emu.media")
  )
;; (use-package exec-path-from-shell
;;   :config
;;   (exec-path-from-shell-initialize))
(use-package command-log-mode)
(use-package npm-mode)
(use-package wgrep)
(use-package centered-cursor-mode)

;; (use-package auto-complete
;;   :config
;;   (ac-config-default)
;;   (global-auto-complete-mode t))

(use-package npm-mode
  :config
  (npm-global-mode)
  (spc-leader-def
    "n" (general-simulate-key "C-c n")))

;; (use-package nvm
;;   :config
;;   (nvm-use "14.6.0"))

;; (use-package flycheck
;;   :config
;;   ;; Show errors in minibuffer instantly
;;   (global-flycheck-mode)

;;   (general-define-key
;;    :states '(motion)
;;    "]e" 'flycheck-next-error
;;    "[e" 'flycheck-previous-error)
;;   )

(use-package ag)

(use-package rvm)

(use-package engine-mode
  :config
  (defengine duckduckgo
    "https://duckduckgo.com/?q=%s")
  (defengine mdn
    "https://developer.mozilla.org/en-US/search?q=%s")
  (defengine jira
    "https://sparkbox.atlassian.net/browse/%s")
  (defengine caniuse
    "https://caniuse.com/#search=%s")

  (spc-leader-def
    "/d" 'engine/search-duckduckgo
    "/j" 'engine/search-jira
    "/c" 'engine/search-caniuse
    "/m" 'engine/search-mdn)

  (engine-mode t))

(use-package rspec-mode
  :mode
  ("*spec.rb" . rspec-mode))

(use-package diminish
  :config
  (diminish 'undo-tree-mode))

(use-package visual-fill-column
    :pin melpa-stable)

(use-package writeroom-mode
  :pin melpa-stable
  :config
  (setq writeroom-fullscreen-effect "maximized")
  (spc-leader-def
    "vw" 'writeroom-mode))

(use-package emmet-mode
  ;; This enables usage of emmet, which is a tool that lets you expand
  ;; CSS selector-like snippets into HTML. It also has some CSS
  ;; expansions.
  :general (spc-leader-def
             "<tab>" 'emmet-expand-line))

(use-package lua-mode)

(use-package shader-mode)

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

;; (use-package hl-line
;;  :config
;;   (global-hl-line-mode))

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

(defun set-bigger-spacing ()
  (interactive)
  (setq-local default-text-properties '(line-spacing 0.25 line-height 1.25)))
(add-hook 'text-mode-hook 'set-bigger-spacing)
(add-hook 'prog-mode-hook 'set-bigger-spacing)
(add-hook 'magit-status-mode-hook 'set-bigger-spacing)

;;;*** Faces
(menu-bar-mode 0)
;; (use-package lab-themes
;;   :config
;;   (lab-themes-load-style 'dark)
;;   (add-to-list 'default-frame-alist '(font . "Ubuntu Mono-14"))
;;   (set-face-attribute 'default t :font  "Ubuntu Mono-14")

;;   ;; Change fringe size
;;   (set-fringe-mode '(10 . 10))

;;   (setq-default line-spacing 0))

;; (use-package purp-theme
;;   :config
;;   ;; Better font
      ;; (add-to-list 'default-frame-alist '(font . "IBM Plex Mono:pixelsize=16:weight=normal:slant=normal:width=normal:spacing=100:scalable=true"))
;;   (setq my-font "Ubuntu Mono-14")

;;   (add-to-list 'default-frame-alist '(font . "Ubuntu Mono-14"))
;;   (set-face-attribute 'default t :font  "Ubuntu Mono-14")

;;   ;; Change fringe size
;;   (set-fringe-mode '(10 . 10))

;;   (setq-default line-spacing 0)
;;   (load-theme 'purp t))

(defun emu-set-faces (bg-color)
  (interactive)
  (set-face-attribute 'show-paren-match nil
                      :background (get-flatui-color "sun-flower")
                      :foreground (get-flatui-color "wet-asphalt")
                      :weight 'bold)
  (set-face-attribute 'default nil
                      ;; :height 0.7
                      :background bg-color)
  (set-face-attribute 'fringe nil
                      :background bg-color)
  ;; (set-face-attribute 'hl-line nil
  ;;                     :background "#f3f8f8")
  (set-face-attribute 'line-number nil
                      ;; :height 0.7
                      :box `(:line-width 4 :color ,(get-flatui-color "clouds") :style nil)
                      :foreground (get-flatui-color "concrete"))
  ;; (set-face-attribute 'line-number-current-line nil
  ;;                     :weight 'bold
  ;;                     :background (get-flatui-color "sun-flower")
  ;;                     :box `(:line-width 4 :color ,(get-flatui-color "sun-flower") :style nil)
  ;;                     :foreground (get-flatui-color "midnight-blue"))
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
  ;; (add-to-list 'default-frame-alist '(font . "IBM Plex Mono:pixelsize=16:weight=SemiBold:scalable=true"))

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

(fset 'yes-or-no-p 'y-or-n-p)

(setq show-paren-delay 0)
(setq show-paren-style 'parenthesis)
(show-paren-mode)

;; this automatically reads files from disk when they've changed
(global-auto-revert-mode)

;; Persistent history for eshell & other minibuffer history rings
(savehist-mode)

(setq compilation-scroll-output t)

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
;; (fset 'yes-or-no-p 'y-or-n-p) 

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

;; If you don’t want to clutter up your file tree with Emacs’ backup files, you
;; can save them to the system’s “temp” directory:
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; emacs likes to make .#blahblah.txt files, which are symbolic links
;; to some PID. This was causing issues with Gatsby, so I'm turning the feature off
(setq create-lockfiles nil)

;; a little encouragement while starting up emacs
;; (setq dope-unicorn "
;; ;;
;; ;;               \\
;; ;;                \\
;; ;;                 \\
;; ;;                  \\\\
;; ;;                   \\\\
;; ;; LET'S BOOGIE       >\\/7
;; ;;           \\   _.-(6'  \\
;; ;;              (=___._/` \\
;; ;;                   )  \\ |
;; ;;                  /   / |
;; ;;                 /    > /
;; ;;                j    < _\\
;; ;;            _.-' :      ``.
;; ;;            \\ r=._\\        `.
;; ;;           <`\\\\_  \\         .`-.
;; ;;            \\ r-7  `-. ._  ' .  `\\
;; ;;             \\`,      `-.`7  7)   )
;; ;;              \\/         \\|  \\'  / `-._
;; ;;                         ||    .'
;; ;;                          \\\\  (
;; ;;                           >\\  >
;; ;;                       ,.-' >.'
;; ;;                      <.'_.''
;; ;;                        <'")
;; (setq initial-scratch-message 
;;       (concat ";; Booted up in " (emacs-init-time) dope-unicorn))

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
  (spc-leader-def
    "br" 'dired-toggle-read-only)
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

(defun emu-wdired-mode-hook-func ()
  (spc-leader-def
    "br" 'wdired-exit)
  )
(add-hook 'wdired-mode-hook 'emu-wdired-mode-hook-func)

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
  (define-key evil-normal-state-map (kbd "M-j") 'outline-move-subtree-down))
(add-hook 'emacs-lisp-mode-hook 'emu-emacs-lisp-mode-hook-func)

(defun emu-display-line-numbers-mode-hook ()
  (setq display-line-numbers 'visual))

(defun emu-no-line-numbers ()
  "toggle between absolute and visual line numbers."
  (interactive)
  (setq display-line-numbers nil))

(defun emu-toggle-line-numbers-type ()
  "toggle between absolute and visual line numbers."
  (interactive)
  (if (eq display-line-numbers 'visual)
      (setq display-line-numbers t)
    (setq display-line-numbers 'visual)))
;; (add-hook 'display-line-numbers-mode-hook 'emu-display-line-numbers-mode-hook)
(add-hook 'text-mode-hook 'emu-display-line-numbers-mode-hook)
(add-hook 'prog-mode-hook 'emu-display-line-numbers-mode-hook)

;; ;; by default, async-shell-command pops up an annoying window showing
;; ;; the output of the async command. this prevents that.
(add-to-list 'display-buffer-alist
             (cons "\\*async shell command\\*.*" (cons #'display-buffer-no-window nil)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (tide company company-mode typescript-mode prettier-js vue-mode mu4e yasnippet-snippets ivy-yasnippet yasnippet deft org-roam counsel-projectile counsel ivy org-tree-slide docker swift-mode grip-mode command-log-mode wgrep csharp-mode ox-jira lab-themes exec-path-from-shell evil-numbers centered-cursor-mode auto-complete org-jira org-jira-mode engine-mode ddg-mode ddg-search ddg ox-jira npm-mode nvm ox-odt javascript-eslint csharp-mode masvn dsvn psvn sound-wav wav-sound play-sound writeroom-mode which-key web-mode use-package twig-mode smex scss-mode rvm rspec-mode rainbow-delimiters ox-gfm markdown-mode lua-mode json-mode js2-mode handlebars-sgml-mode haml-mode general flycheck flatui-theme evil-surround evil-paredit evil-org evil-matchit evil-magit evil-leader evil-commentary emmet-mode diminish default-text-scale ag))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:foreground "#2c3e50" :background "#ecf0f1")))))

