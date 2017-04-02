(when (require 'package nil t)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
  (package-initialize))

(setq inhibit-startup-message t)

(setq make-backup-files nil)
(setq delete-auto-save-files t)

(menu-bar-mode -1)

(setq-default tab-width 4 indent-tabs-mode nil)

(setq x-select-enable-clipboard t)

(global-set-key "\C-o" ctl-x-map)

(setq eol-mnemonic-dos "(CRLF)")
(setq eol-mnemonic-mac "(CR)")
(setq eol-mnemonic-unix "(LF)")

(column-number-mode t)

(global-linum-mode t)

(global-hl-line-mode t)

(show-paren-mode 1)

;;(global-whitespace-mode 1)

(load-theme 'tsdh-dark t)

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

(autoload 'mew "mew" nil t)
(autoload 'mew-send "mew" nil t)


