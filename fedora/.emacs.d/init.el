;; --------------------------------------------------
;; Initialization
;; --------------------------------------------------
(when (require 'package nil t)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
  (package-initialize))
                

;; --------------------------------------------------
;; General
;; --------------------------------------------------
(load-theme 'madhat2r t)
(set-face-foreground 'default "#93a1a1")

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
             (cons "." "~/.emacs.d/backup/"))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.emacs.d/backup/") t)))


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
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hl-line ((t (:background "color-236")))))

(show-paren-mode 1)

(size-indication-mode t)

(setq split-width-threshold nil)

;;(global-whitespace-mode 1)


;; --------------------------------------------------
;; Keybind
;; --------------------------------------------------
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

(define-key global-map (kbd "C-o C-u") 'undo)

(define-key global-map (kbd "C-w") 'backward-kill-word)

(define-key global-map (kbd "C-f") 'scroll-up)
(define-key global-map (kbd "C-b") 'scroll-down)

(define-key global-map (kbd "C-o C-o") 'other-window)

(define-key global-map (kbd "C-o C-y") (kbd "C-a C-SPC C-e M-w C-a"))
(define-key global-map (kbd "C-o C-d") (kbd "C-a C-SPC C-e C-d <DEL> <right>"))
(define-key global-map (kbd "C-v") 'cua-set-rectangle-mark)

(define-key global-map (kbd "C-o C-r") 'replace-regexp)

;;(define-key global-map (kbd "C-<return>")
;;   (lambda () (interactive) (move-end-of-line nil) (newline)))


;; --------------------------------------------------
;; Input
;; --------------------------------------------------
(setq fill-column 70)
(setq mail-mode-hook 'turn-on-auto-fill)
(setq text-mode-hook 'turn-off-auto-fill)
;;(setq use-hard-newlines t)
;;(setq truncate-lines nil)
;;(setq word-wrap t)


;; --------------------------------------------------
;; Plugin
;; --------------------------------------------------

;; anything
(require 'anything)
(require 'anything-startup)
(require 'anything-config)
(define-key global-map (kbd "C-o C-b") 'anything-buffers-list)

;; mew
;;(autoload 'mew "mew" nil t)
;;(autoload 'mew-send "mew" nil t)
;;(setq load-path (append '("/usr/local/share/emacs/site-lisp/mew") load-path))

;;(define-key mew-summary-mode-map "j" (kbd "<down>"))
;;(define-key mew-summary-mode-map "k" (kbd "<up>"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (madhat2r-theme anything))))


(setq auto-mode-alist (append '(("/tmp/mutt.*" . mail-mode)) auto-mode-alist))


(setq load-path (append '("~/.emacs.d/conf") load-path))
(load "clipboard")
