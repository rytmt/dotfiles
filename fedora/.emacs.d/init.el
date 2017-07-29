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


;; --------------------------------------------------
;; General
;; --------------------------------------------------
(when (require 'gruvbox-theme nil t) (load-theme 'gruvbox-dark-soft t))
(load custom-file)

(setq inhibit-startup-message t)

(setq-default tab-width 4 indent-tabs-mode nil)

(setq x-select-enable-clipboard t)

(setq eol-mnemonic-dos "(CRLF)")
(setq eol-mnemonic-mac "(CR)")
(setq eol-mnemonic-unix "(LF)")

(setq c-tab-always-indent t)

(setq scroll-conservatively 35)
(setq scroll-margin 0)
(setq scroll-step 1)

(setq scroll-preserve-screen-position t)

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
(setq make-backup-files t)
(setq delete-auto-save-files t)
(add-to-list 'backup-directory-alist
             (cons "." backup-dir))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name backup-dir) t)))


;; --------------------------------------------------
;; Visual
;; --------------------------------------------------
(set-face-attribute 'default nil :family "Migu 1M" :height 100)

(menu-bar-mode -1)
;;(tool-bar-mode -1)
;;(scroll-bar-mode 0)

(column-number-mode t)

(global-linum-mode t)
(setq linum-format "%4d ")

(global-hl-line-mode t)

(show-paren-mode 1)

(size-indication-mode t)

(setq split-width-threshold nil)

(progn
  (require 'whitespace)
  (setq whitespace-style
        '(
          face
          trailing
          ;tabs
          spaces
          space-mark
          tab-mark
          ))
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
(global-set-key "\C-o" ctl-x-map)

(define-key global-map (kbd "C-j") 'next-line)
(define-key global-map (kbd "C-k") 'previos-line)
(define-key global-map (kbd "C-h") 'backward-char)
(define-key global-map (kbd "C-l") 'forward-char)

(define-key global-map (kbd "M-j") (kbd "C-u 10 <down>"))
(define-key global-map (kbd "M-k") (kbd "C-u 10 <up>"))
(define-key global-map (kbd "M-h") (kbd "C-u 10 <left>"))
(define-key global-map (kbd "M-l") (kbd "C-u 10 <right>"))

(define-key global-map (kbd "C-y") 'kill-ring-save)
(define-key global-map (kbd "C-p") 'yank)
(define-key global-map (kbd "C-d") 'kill-region)

(define-key global-map (kbd "C-o <up>") 'beginning-of-buffer)
(define-key global-map (kbd "C-o <down>") 'end-of-buffer)

(define-key global-map (kbd "C-o C-q") 'save-buffers-kill-terminal)
(define-key global-map (kbd "C-o k") 'kill-this-buffer)

;;(define-key global-map (kbd "C-o C-u") 'undo)

(define-key global-map (kbd "C-w") 'backward-delete-word)

(define-key global-map (kbd "C-f") 'scroll-up)
(define-key global-map (kbd "C-b") 'scroll-down)

(define-key global-map (kbd "C-o C-o") 'other-window)

(define-key global-map (kbd "C-o C-y") (kbd "C-a C-SPC C-e M-w C-a"))
(define-key global-map (kbd "C-o C-d") (kbd "C-a C-SPC C-e C-d <DEL> <right>"))
(define-key global-map (kbd "C-v") 'cua-set-rectangle-mark)

(define-key global-map (kbd "C-o r") 'replace-string)
(define-key global-map (kbd "C-o C-r") 'replace-regexp)

;;(define-key global-map (kbd "C-<return>")
;;   (lambda () (interactive) (move-end-of-line nil) (newline)))


;; --------------------------------------------------
;; Input
;; --------------------------------------------------
(setq fill-column 64)
(setq mail-mode-hook 'turn-on-auto-fill)
(setq text-mode-hook 'turn-off-auto-fill)
;;(setq use-hard-newlines t)
;;(setq truncate-lines nil)
;;(setq word-wrap t)


;; --------------------------------------------------
;; Org-mode
;; --------------------------------------------------
(when (require 'org nil t)
  ;; key bind
  (define-key org-mode-map (kbd "TAB") 'org-shiftright)
  (define-key org-mode-map (kbd "<backtab>") 'org-shiftleft)
  (define-key org-mode-map (kbd "C-o TAB") 'org-cycle)
  (define-key org-mode-map (kbd "C-o t") (kbd "#+TITLE: SPC"))
  (define-key org-mode-map (kbd "M-j") (kbd "C-u 10 <down>"))
  (define-key org-mode-map (kbd "M-k") (kbd "C-u 10 <up>"))
  (define-key org-mode-map (kbd "M-h") (kbd "C-u 10 <left>"))
  (define-key org-mode-map (kbd "M-l") (kbd "C-u 10 <right>"))
  (define-key org-mode-map (kbd "C-y") 'kill-ring-save)
  (define-key org-mode-map (kbd "C-p") 'yank)
  (define-key org-mode-map (kbd "C-d") 'kill-region)
  (define-key org-mode-map (kbd "M-n") 'org-shiftdown)
  (define-key org-mode-map (kbd "M-p") 'org-shiftup)
  ;; config
  (setq org-todo-keywords '((sequence "TODO(t)" "|" "DONE(d)")))
  (setq org-log-done 'time)
  (setq org-startup-folded 'all)
)


;; --------------------------------------------------
;; Others
;; --------------------------------------------------

;; for mutt
(setq auto-mode-alist (append '(("/tmp/mutt.*" . mail-mode)) auto-mode-alist))
(defun list-mail-domain ()
  (interactive)
  (shell-command-on-region
   1 (1+ (buffer-size))
   "grep -e ^To -e ^Cc -e ^Bcc -A 10 | grep -E -o '@[a-zA-Z0-9.-]+' | sort | uniq -c | sort -nr"))
(define-key global-map (kbd "C-o C-c") 'list-mail-domain)


;; clipboard
(load clipboard)


;; --------------------------------------------------
;; Plugin
;; --------------------------------------------------

;; anything
(when (and (require 'anything nil t) (require 'anything-startup nil t) (require 'anything-config nil t))
  (define-key global-map (kbd "C-o C-b") 'anything-buffers-list)
  (define-key global-map (kbd "C-o C-f") 'anything-recentf))

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

;; undo-tree
(when (require 'undo-tree nil t)
  (global-undo-tree-mode)
  (define-key global-map (kbd "C-o C-u") 'undo-tree-visualize))

(when (require 'undohist nil t)
  (undohist-initialize))

;; mew
;;(autoload 'mew "mew" nil t)
;;(autoload 'mew-send "mew" nil t)
;;(setq load-path (append '("/usr/local/share/emacs/site-lisp/mew") load-path))

;;(define-key mew-summary-mode-map "j" (kbd "<down>"))
;;(define-key mew-summary-mode-map "k" (kbd "<up>"))


