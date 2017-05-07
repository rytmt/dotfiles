;; --------------------------------------------------
;; Initialization
;; --------------------------------------------------
(when (require 'package nil t)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
  (package-initialize))


;; --------------------------------------------------
;; General
;; --------------------------------------------------
;;(load-theme 'misterioso t)
(load-theme 'solarized-dark t)
(setq inhibit-startup-message t)

(setq make-backup-files nil)
(setq delete-auto-save-files t)

(setq-default tab-width 4 indent-tabs-mode nil)

(setq x-select-enable-clipboard t)

(setq eol-mnemonic-dos "(CRLF)")
(setq eol-mnemonic-mac "(CR)")
(setq eol-mnemonic-unix "(LF)")

(set-face-attribute 'default nil :family "Migu 1M" :height 100)


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
;; Layout
;; --------------------------------------------------
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode 0)

(column-number-mode t)

(global-linum-mode t)

(global-hl-line-mode t)

(show-paren-mode 1)

(global-whitespace-mode 1)


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


;; --------------------------------------------------
;; Japanese Input
;; --------------------------------------------------
(require 'mozc)
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")

(global-set-key [zenkaku-hankaku] 'toggle-input-method)

;;(set-language-environment "Japanese")
;;(setq default-input-method "japanese-mozc")
;;(global-set-key (kbd "<zenkaku-hankaku>") 'toggle-input-method)
;;(add-hook 'mozc-mode-hook
;;  (lambda()
;;    (define-key mozc-mode-map (kbd "<zenkaku-hankaku>") 'toggle-input-method))
;;)


;; --------------------------------------------------
;; Plugin
;; --------------------------------------------------
(autoload 'mew "mew" nil t)
(autoload 'mew-send "mew" nil t)





(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (markdown-mode solarized-theme jbeans-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
