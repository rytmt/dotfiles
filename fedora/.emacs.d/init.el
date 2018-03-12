;; --------------------------------------------------
;; Initialization
;; --------------------------------------------------
(when (require 'package nil t)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
  (package-initialize))


;; --------------------------------------------------
;; Variable
;; --------------------------------------------------
(setq custom-file "~/.emacs.d/custom.el")
(setq backup-dir "~/.emacs.d/backup/")
(setq clipboard "~/.emacs.d/clipboard.el")
(setq bookmark-dir "~/.emacs.d/bookmark/")


;; --------------------------------------------------
;; General
;; --------------------------------------------------
(when (require 'gruvbox-theme nil t) (load-theme 'gruvbox-dark-soft t))
(when (file-readable-p custom-file) (load custom-file))

(setq-default tab-width 4 indent-tabs-mode nil)
(setq inhibit-startup-message t)
(setq x-select-enable-clipboard t)
(setq eol-mnemonic-dos "(CRLF)")
(setq eol-mnemonic-mac "(CR)")
(setq eol-mnemonic-unix "(LF)")
(setq c-tab-always-indent t)
(setq scroll-conservatively 35)
(setq scroll-margin 0)
(setq scroll-step 1)
(setq require-final-newline nil)
(setq scroll-preserve-screen-position t)
(setq recentf-max-saved-items 3000)
(setq recentf-auto-cleanup 'never)
(setq recentf-exclude '("/tmp/mutt.*"))
(setq fill-column 56)
(setq truncate-lines nil)

(cua-mode t)
(setq cua-enable-cua-keys nil)


;; --------------------------------------------------
;; Language
;; --------------------------------------------------
(set-locale-environment nil)
(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)


;; --------------------------------------------------
;; Backup
;; --------------------------------------------------
(when (file-directory-p backup-dir)
  (setq make-backup-files t)
  (setq delete-auto-save-files t)
  (add-to-list 'backup-directory-alist
               (cons "." backup-dir))
  (setq auto-save-file-name-transforms
        `((".*" ,(expand-file-name backup-dir) t))))


;; --------------------------------------------------
;; Visual
;; --------------------------------------------------
(set-face-attribute 'default nil :family "Migu 1M" :height 100)
(menu-bar-mode -1)
(column-number-mode t)
(global-linum-mode t)
(setq linum-format "%4d ")
(global-hl-line-mode t)
(show-paren-mode 1)
(size-indication-mode t)

(progn
  (require 'whitespace)
  (setq whitespace-style
        '(face trailing spaces space-mark tab-mark))
  (setq whitespace-display-mappings
        '(
          (space-mark ?\x3000 [?\＿])
          (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])
          ))
  (setq whitespace-trailing-regexp  "\\([ \u00A0]+\\)$")
  (setq whitespace-space-regexp "\\(\u3000+\\)")
  (set-face-attribute 'whitespace-trailing nil
                      :foreground "white"
                      :background "white"
                      :underline nil)
  (set-face-attribute 'whitespace-space nil
                      :foreground "gray40"
                      :background "gray20"
                      :underline nil)
  (global-whitespace-mode t)
)


;;--------------------------------------------------
;; Keybind
;; --------------------------------------------------
(defun delete-word (arg) (interactive "p") (delete-region (point) (progn (forward-word arg) (point))))
(defun backward-delete-word (arg) (interactive "p") (delete-word (- arg)))
(defadvice clone-buffer (around clone-buffer-split-horizontal activate)
  (let ((split-height-threshold 0)
        (split-width-threshold nil))
        ad-do-it))
(defun next-line-10 () (interactive) (next-line 10))
(defun previous-line-10 () (interactive) (previous-line 10))
(defun backward-char-10 () (interactive) (backward-char 10))
(defun forward-char-10 () (interactive) (forward-char 10))
(defun cua-decr-rectangle (decriment)
  "Decrement each line of CUA rectangle by prefix amount."
  (interactive "p")
  (cua-incr-rectangle (- decriment)))

(define-key global-map "\C-o" ctl-x-map)

(define-key global-map (kbd "C-j") 'next-line)
(define-key global-map (kbd "C-k") 'previos-line)
(define-key global-map (kbd "C-h") 'backward-char)
(define-key global-map (kbd "C-l") 'forward-char)
(define-key global-map (kbd "M-j") 'next-line-10)
(define-key global-map (kbd "M-k") 'previous-line-10)
(define-key global-map (kbd "M-h") 'backward-char-10)
(define-key global-map (kbd "M-l") 'forward-char-10)
(define-key global-map (kbd "C-y") 'kill-ring-save)
(define-key global-map (kbd "C-p") 'yank)
(define-key global-map (kbd "C-d") 'kill-region)
(define-key global-map (kbd "C-o <up>") 'beginning-of-buffer)
(define-key global-map (kbd "C-o <down>") 'end-of-buffer)
(define-key global-map (kbd "C-o C-q") 'save-buffers-kill-terminal)
(define-key global-map (kbd "C-o k") 'kill-this-buffer)
(define-key global-map (kbd "C-o M-k") 'kill-buffer-and-window)
(define-key global-map (kbd "C-w") 'backward-delete-word)
(define-key global-map (kbd "C-f") 'scroll-up)
(define-key global-map (kbd "C-b") 'scroll-down)
(define-key global-map (kbd "C-o C-y") (kbd "C-a C-SPC C-e M-w C-a"))
(define-key global-map (kbd "C-o C-d") (kbd "C-a C-SPC C-e C-d <DEL> <right>"))
(define-key global-map (kbd "C-v") 'cua-set-rectangle-mark)
(define-key global-map (kbd "C-o r") 'replace-string)
(define-key global-map (kbd "C-o C-r") 'replace-regexp)
(define-key global-map (kbd "C-M-h") 'windmove-left)
(define-key global-map (kbd "C-M-j") 'windmove-down)
(define-key global-map (kbd "C-M-k") 'windmove-up)
(define-key global-map (kbd "C-M-l") 'windmove-right)
(define-key global-map (kbd "M-;") 'enlarge-window-horizontally)
(define-key global-map (kbd "M--") 'shrink-window-horizontally)
(define-key global-map (kbd "C-o <right>") 'emacs-lock-mode)
(define-key global-map (kbd "C-o s") 'clone-buffer)
(define-key global-map (kbd "C-x C-x") 'eval-print-last-sexp)
;(define-key global-map (kbd "C-o C-b") 'switch-to-buffer)

(define-key occur-mode-map "\C-o" ctl-x-map)
(define-key occur-mode-map (kbd "C-o k") 'kill-this-buffer)

(define-key cua--rectangle-keymap (kbd "M-d") 'cua-decr-rectangle)

;; --------------------------------------------------
;; Org-mode
;; --------------------------------------------------
(when (require 'org nil t)

  ;; function
  (defun org-insert-todo-with-ts ()
    (interactive)
    (org-insert-todo-heading "TODO")
    (org-insert-time-stamp (current-time))
    )
  (defun org-mode-keybind ()
    (define-key org-mode-map (kbd "C-^") 'org-shiftright)
;    (define-key org-mode-map (kbd "<backtab>") 'org-shiftleft)
    (define-key org-mode-map (kbd "C-o TAB") 'org-cycle)
    (define-key org-mode-map (kbd "C-o t") (kbd "#+TITLE: SPC"))
    (define-key org-mode-map (kbd "M-j") 'next-line-10)
    (define-key org-mode-map (kbd "M-k") 'previous-line-10)
    (define-key org-mode-map (kbd "M-h") 'backward-char-10)
    (define-key org-mode-map (kbd "M-l") 'forward-char-10)
    (define-key org-mode-map (kbd "C-y") 'kill-ring-save)
    (define-key org-mode-map (kbd "C-p") 'yank)
    (define-key org-mode-map (kbd "C-d") 'kill-region)
    (define-key org-mode-map (kbd "M-n") 'org-shiftdown)
    (define-key org-mode-map (kbd "M-p") 'org-shiftup)
    (define-key org-mode-map (kbd "C-o a") 'org-agenda)
    (define-key org-mode-map (kbd "C-c .") 'org-insert-todo-with-ts)
    )

  ;; variable
  (setq org-todo-keywords '((sequence "TODO(t)" "WAIT(w)" "MEMO(m)" "|" "DONE(d)")))
  (setq org-log-done 'time)
  (setq org-startup-folded 'all)
  (setq org-agenda-files '("~/todo.org"))
  (setq-default org-display-custom-times t)
  (setq org-time-stamp-custom-formats '("<%Y/%m/%d>" . "<%Y/%m/%d %H:%M>"))
  (setq org-todo-keyword-faces
        '(
          ("WAIT" . (:foreground "magenta" :weight bold))
          ("MEMO" . (:foreground "magenta" :weight bold))
          ))

  ;; hook
  (add-hook 'org-mode-hook 'org-mode-keybind)
  )


;; --------------------------------------------------
;; dired
;; --------------------------------------------------
(when (require 'dired nil t)

  ;; function
  (defun dired-mode-keybind ()
    (define-key dired-mode-map "\C-o" ctl-x-map)
    (define-key dired-mode-map (kbd "h") (lambda () (interactive) (find-alternate-file "..")))
    (define-key dired-mode-map (kbd "j") 'dired-next-line)
    (define-key dired-mode-map (kbd "k") 'dired-previous-line)
    (define-key dired-mode-map (kbd "l") 'dired-find-alternate-file)
    (define-key dired-mode-map (kbd "RET") 'dired-find-file-other-window)
    (define-key dired-mode-map (kbd "r") 'wdired-change-to-wdired-mode)
    (define-key dired-mode-map (kbd "q") 'kill-this-buffer)
    (define-key dired-mode-map (kbd "n") 'dired-create-file)
    (define-key dired-mode-map (kbd "N") 'dired-create-directory)
    (define-key dired-mode-map (kbd "y") (kbd "C-u 0-w"))
    (define-key dired-mode-map (kbd "v") 'dired-view-file-other-window)
    (define-key dired-mode-map (kbd "g") (lambda () (interactive) (beginning-of-buffer) (dired-next-line 2)))
    (define-key dired-mode-map (kbd "G") (lambda () (interactive) (end-of-buffer) (dired-previous-line 1)))
    (define-key dired-mode-map (kbd "C-g") 'revert-buffer)
    (define-key dired-mode-map (kbd "TAB") 'other-window)
    (when (file-directory-p bookmark-dir)
      (define-key dired-mode-map (kbd "C-o b")
        (lambda () (interactive) (find-alternate-file bookmark-dir))
        ))
    )
  (defun dired-view-file-other-window ()
    (interactive)
    (let ((file (dired-get-file-for-visit)))
      (if (file-directory-p file)
          (or (and (cdr dired-subdir-alist) (dired-goto-subdir file)) (dired file))
        (view-file-other-window file)
        )))
  (defun dired-create-file ()
    (interactive)
    (shell-command (concat "touch " (read-shell-command "Create file: ")))
    (revert-buffer)
    )

  ;; variable
  (put 'dired-find-alternate-file 'disabled nil)
  (setq dired-recursive-copies 'always)
  (setq dired-dwim-target t)
  (setq dired-listing-switches (purecopy "-lah"))

  ;; hook
  (add-hook 'dired-mode-hook 'dired-mode-keybind)
  )


;; --------------------------------------------------
;; Mail
;; --------------------------------------------------
(add-hook 'mail-mode-hook 'turn-on-auto-fill)
(setq auto-mode-alist (append '(("/tmp/mutt.*" . mail-mode)) auto-mode-alist))
(defun list-mail-domain ()
  (interactive)
  (shell-command-on-region
   1 (1+ (buffer-size))
   "grep -e ^To -e ^Cc -e ^Bcc -A 10 | grep -E -o '@[a-zA-Z0-9.-]+' | sort | uniq -c | sort -nr"))
(define-key global-map (kbd "C-o C-c") 'list-mail-domain)
(define-key global-map (kbd "C-o C-s") (lambda () (interactive) (save-buffer) (list-mail-domain)))


;; --------------------------------------------------
;; Others
;; --------------------------------------------------

;; clipboard
(when (file-readable-p clipboard) (load clipboard))

;; tramp
;; sample: C-x C-f /ssh:USERNAME@HOSTNAME:
(when (require 'tramp nil t))

;; for EasyPG
;; require gnupg and pinentry-emacs rpm packages (in fedora)
;; hint: gpg --cipher-algo AES256 -c -v __FILENAME__
(setq epa-pinentry-mode 'loopback)
(setq epa-file-cache-passphrase-for-symmetric-encryption t)


;; --------------------------------------------------
;; Package
;; --------------------------------------------------

;; migemo
(when (require 'migemo nil t)
  (setq migemo-command "cmigemo")
  (setq migemo-options '("-q" "--emacs"))
  (setq migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict")
  (setq migemo-user-dictionary nil)
  (setq migemo-regex-dictionary nil)
  (setq migemo-coding-system 'utf-8-unix)
  (load-library "migemo")
  (migemo-init))

;; helm
(when (and (require 'helm nil t) (require 'helm-config nil t))
  ;; keybind
  (define-key global-map (kbd "C-o h") 'helm-command-prefix)
  (global-unset-key (kbd "C-x c"))
;  (define-key global-map (kbd "C-o C-o") 'helm-mini)
  (define-key global-map (kbd "C-o C-g") 'helm-occur)
  (define-key global-map (kbd "C-o C-b") 'helm-buffers-list)
;  (define-key global-map (kbd "C-o C-f") 'helm-find-files)
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
  (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
  (define-key helm-map (kbd "C-z")  'helm-select-action)
  (define-key helm-map (kbd "C-d") 'helm-buffer-run-kill-persistent)
  (define-key helm-map (kbd "C-w") 'backward-delete-word)

  ;; config
;  (setq helm-autoresize-max-height 0)
;  (setq helm-autoresize-min-height 20)
  (helm-migemo-mode 1)
  (setq helm-buffers-fuzzy-matching t
        helm-recentf-fuzzy-match    t)
  (setq helm-split-window-in-side-p t)
;  (helm-autoresize-mode 1)
  (helm-mode 1)

  ;; helm-swoop
  (when (require 'helm-swoop nil t)
    (define-key global-map (kbd "C-s") 'helm-swoop)
    (setq helm-swoop-pre-input-function (lambda () ""))
    (setq helm-swoop-split-direction 'split-window-vertically)
    (setq helm-swoop-split-with-multiple-windows t)
    )

  ;; helm-elscreen
  (when (require 'helm-elscreen nil t)
  (define-key global-map (kbd "C-o C-o") 'helm-elscreen)
    )

  ;; helm-gtags
  (when (require 'helm-gtags nil t)
    (define-key global-map (kbd "M-g t") 'helm-gtags-find-tag)
    (define-key global-map (kbd "M-g r") 'helm-gtags-find-rtag)
    (define-key global-map (kbd "M-g s") 'helm-gtags-find-symbol)
    (define-key global-map (kbd "M-g h") 'helm-gtags-select)
    (define-key global-map (kbd "M-g ^") 'helm-gtags-pop-stack)
    (define-key global-map (kbd "M-g M-g") 'helm-gtags-dwim)
    )
  )

;; undo-tree
(when (require 'undo-tree nil t)
  (global-undo-tree-mode)
  (define-key global-map (kbd "C-o C-u") 'undo-tree-visualize)
  (define-key global-map (kbd "C-u") 'undo-tree-undo)
  (define-key global-map (kbd "C-r") 'undo-tree-redo)
  (defadvice undo-tree-visualize (around undo-tree-split-horizontal activate)
    (let ((split-height-threshold 0)
          (split-width-threshold nil))
      ad-do-it))
  )

;; undohist
(when (require 'undohist nil t) (undohist-initialize))

;; recentf-ext
(when (require 'recentf-ext nil t)
  (define-key global-map (kbd "C-o C-r") 'recentf-open-files)
  )

;; elscreen
(when (require 'elscreen nil t)
  (global-unset-key (kbd "C-q"))
  (elscreen-set-prefix-key (kbd "C-q"))
  (elscreen-start)
  (setq elscreen-tab-display-kill-screen nil)
  (setq elscreen-tab-display-control nil)
  (define-key global-map (kbd "C-z") 'suspend-frame)
  (define-key global-map (kbd "C-q C-q") 'elscreen-toggle)
  (defadvice dired-find-file-other-window (around elscreen-dired-find-file-other-window activate)
    (let ((window-configuration (current-window-configuration))
          (buffer nil))
      ad-do-it
      (unless (eq major-mode 'dired-mode)
        (setq buffer (current-buffer))
        (set-window-configuration window-configuration)
        (elscreen-find-and-goto-by-buffer buffer t))))
  )

;; highlight-indentation
(when (require 'highlight-indentation nil t)
  (set-face-background 'highlight-indentation-face "#4e4e4e")
  (set-face-background 'highlight-indentation-current-column-face "#4e4e4e")
  (defun hii () (interactive) (highlight-indentation-current-column-mode))
  )

;; pwgen
(defun pwgen ()
  (interactive)
  (insert (shell-command-to-string "echo -n $(pwgen -sync1 16)"))
  (kill-line 0)
  )

;; mew
(autoload 'mew "mew" nil t)
(autoload 'mew-send "mew" nil t)
(setq read-mail-command 'mew)
;(setq load-path (append '("/usr/local/share/emacs/site-lisp/mew") load-path))

;;(define-key mew-summary-mode-map "j" (kbd "<down>"))
;;(define-key mew-summary-mode-map "k" (kbd "<up>"))

