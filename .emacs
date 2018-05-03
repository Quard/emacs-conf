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
    (direx doom-themes smart-mode-line-powerline-theme smart-mode-line git-gutter jsx-mode websocket markdown-mode yaml-mode projectile flycheck flymake-cursor solarized-theme fill-column-indicator ag smartparens jedi epc pyvenv slime)))
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
                            epc
                            jedi
                            smartparens
                            auto-complete
                            ag
                            fill-column-indicator
                            solarized-theme
                            flymake-cursor
                            flycheck
                            projectile))

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

(projectile-global-mode 1)

;; hightlight 80
(setq-default fill-column 80)
(require 'fill-column-indicator)
(setq fci-rule-width 1)
(setq fci-rule-color "DodgerBlue4")
(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)

;; hightlight 120
(add-to-list 'load-path "~/.emacs.d/column-enforce-mode/")
(setq column-enforce-column 120)
(require 'column-enforce-mode)
(add-hook 'prog-mode-hook 'column-enforce-mode)

;; flymake
(require 'tramp-cmds)
(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
     ; Make sure it's not a remote buffer or flymake would not work
     (when (not (subsetp (list (current-buffer)) (tramp-list-remote-buffers)))
      (let* ((temp-file (flymake-init-create-temp-buffer-copy
             'flymake-create-temp-inplace))
         (local-file (file-relative-name
              temp-file
              (file-name-directory buffer-file-name))))
    (list "pyflakes" (list local-file)))))
  (add-to-list 'flymake-allowed-file-name-masks
           '("\\.py\\'" flymake-pyflakes-init)))
(delete '("\\.html?\\'" flymake-xml-init) flymake-allowed-file-name-masks)
(add-hook 'find-file-hook 'flymake-find-file-hook)
(require 'flymake)
(require 'flymake-cursor)

;; flycheck
;; (require 'flycheck)
;; (add-hook 'after-init-hook #'global-flycheck-mode)
;; (flycheck-add-mode 'javascript-eslint 'javascript-mode)
;; (when (memq window-system '(mac ns))
;;   (exec-path-from-shell-initialize))

;; keys
(global-set-key (kbd "C-c a") 'org-agenda-list)
(if (eq system-type 'gnu/linux)
    (progn
      (global-set-key (kbd "M-l") 'goto-line)))

;; lisp
(require 'cl)
(if (eq system-type 'darwin)
    (setq inferior-lisp-program "/usr/local/bin/ccl"))
(if (eq system-type 'gnu/linux)
    (setq inferior-lisp-program "/usr/bin/sbcl"))

;; python
(add-hook 'python-mode-hook '(lambda ()
    (define-key python-mode-map (kbd "RET") 'newline-and-indent)))
;; (add-hook 'python-mode-hook '(lambda ()
;;     (pretty-lambda-mode 1)))

(setq jedi:setup-keys t)
(setq jedi:complete-on-dot t)
(add-hook 'python-mode-hook 'jedi:setup)
(require 'jedi-direx)
(add-hook 'jedi-mode-hook 'jedi-direx:setup)

;; theme
(set-face-font 'default "Inconsolata-14")
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
