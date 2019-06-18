(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(current-language-environment "UTF-8")
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(global-linum-mode 1)
 '(line-number-mode 1)
 '(org-agenda-files
   (quote
    ("~/Dropbox/org/self_build.org" "~/Dropbox/org/articles.org" "~/Dropbox/org/notes.org")))
 '(package-selected-packages
   (quote
    (irony platformio-mode direx doom-themes smart-mode-line-powerline-theme smart-mode-line git-gutter jsx-mode websocket markdown-mode yaml-mode projectile flycheck flymake-cursor solarized-theme fill-column-indicator ag smartparens jedi epc pyvenv slime)))
 '(show-paren-mode t)
 '(word-wrap nil))

(add-to-list 'exec-path "/usr/local/bin/")
(tool-bar-mode -1)
(scroll-bar-mode -1)
(fset 'yeas-or-no-p 'y-or-n-p)
(ido-mode 1)

;; Package manager:
;; Initialise package and add Melpa repository
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(defvar required-packages '(slime
                            pyvenv
                            smartparens
                            ag
                            fill-column-indicator
                            solarized-theme
                            flycheck
                            projectile
                            company
                            company-anaconda))

; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package required-packages)
  (unless (package-installed-p package)
    (package-install package)))

(setq default-tab-width 4)
(setq sgml-basic-offset 4)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default py-indent-offset 4)

(setq whitespace-action
      '(auto-cleanup)) ;; automatically clean up bad whitespace
(setq whitespace-style
      '(trailing space-before-tab indentation empty space-after-tab)) ;; only show bad whitespace
(global-whitespace-mode 1)

(add-hook 'after-init-hook 'global-company-mode)
(projectile-global-mode 1)

;; --- hightlight 80 ---
(setq-default fill-column 80)
(require 'fill-column-indicator)
(setq fci-rule-width 1)
(setq fci-rule-color "DodgerBlue4")
(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
;; fix company popup
(defun on-off-fci-before-company(command)
  (when (string= "show" command)
    (turn-off-fci-mode))
  (when (string= "hide" command)
    (turn-on-fci-mode)))
(advice-add 'company-call-frontends :before #'on-off-fci-before-company)
(global-fci-mode 1)

;; --- hightlight 120 ---
(add-to-list 'load-path "~/.emacs.d/column-enforce-mode/")
(setq column-enforce-column 120)
(require 'column-enforce-mode)
(add-hook 'prog-mode-hook 'column-enforce-mode)


;; --- flycheck ---
(add-hook 'after-init-hook #'global-flycheck-mode)

;; --- keys ---
(global-set-key (kbd "C-c a") 'org-agenda-list)
(if (eq system-type 'gnu/linux)
    (progn
      (global-set-key (kbd "M-l") 'goto-line)))

;; --- lisp ---
(require 'cl)
(if (eq system-type 'darwin)
    (setq inferior-lisp-program "/usr/local/bin/ccl"))
(if (eq system-type 'gnu/linux)
    (setq inferior-lisp-program "/usr/bin/sbcl"))

;; --- python ---
(add-hook 'python-mode-hook '(lambda ()
    (define-key python-mode-map (kbd "RET") 'newline-and-indent)))
;; (add-hook 'python-mode-hook '(lambda ()
;;     (pretty-lambda-mode 1)))

(eval-after-load "company"
  '(add-to-list 'company-backends '(company-anaconda :with company-capf)))
(add-hook 'python-mode-hook 'anaconda-mode)


;; --- c/c++ ---
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)
(add-to-list 'auto-mode-alist '("\\.ino\\'" . c++-mode))

;; theme
(set-face-font 'default "Inconsolata-11")
;; (set-face-font 'default "-unknown-Inconsolata-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")
;; (set-fontset-font "fontset-default"
;;                   (cons (decode-char 'ucs #x0400)
;;                         (decode-char 'ucs #x052F))
;;                   (if (eq system-type 'darwin)
;;                       (font-spec :size 12 :name "Monaco")
;;                     (font-spec :size 12 :name "Droid Sans Mono")))
                  ; (font-spec :size 12 :name "Droid Sans Mono"))
                  ; "-unknown-Droid Sans Mono-normal-normal-normal-*-9-*-*-*-m-0-iso10646-1")
(load-theme 'solarized-dark t)

(defun my-pretty-lambda ()
  "make some word or string show as pretty Unicode symbols"
  (setq prettify-symbols-alist
        '(
          ("lambda" . 955) ; λ
          )))

(add-hook 'lisp-mode-hook 'my-pretty-lambda)
(add-hook 'python-mode-hook 'my-pretty-lambda)
(global-prettify-symbols-mode 1)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
