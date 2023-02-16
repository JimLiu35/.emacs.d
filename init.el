(load-theme 'tango-dark)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("e3daa8f18440301f3e54f2093fe15f4fe951986a8628e98dcd781efbec7a46f2" default))
 '(package-selected-packages
   '(org-bullets visual-fill-column neotree key-chord evil-collection evil general ivy doom-themes helpful ivy-rich which-key rainbow-delimiters counsel use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(set-face-attribute 'default nil :height 200)

(custom-set-faces
  '(org-level-1 ((t (:height 1.5 :weight bold))))
  '(org-level-2 ((t (:height 1.2 :weight bold))))
  '(org-level-3 ((t (:height 1.1 :weight bold))))
  '(org-level-4 ((t (:height 1.0 :weight bold)))))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;; buffer switching
(global-set-key (kbd "C-M-J") 'counsel-switch-buffer)

(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))
 
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind(("M-x" . counsel-M-x)
	("C-x b" . counsel-ibuffer)
	("C-x C-f" . counsel-find-file)
	:map minibuffer-local-map
	("C-r" . counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with ^

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . helpful-function)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-command] . helpful-command)
  ([remap describe-key] . helpful-key))

(use-package doom-themes
  :init (load-theme 'doom-gruvbox ))

(use-package general
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (rune/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))


(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-normal-state-map (kbd "S") 'save-buffer)
  (define-key evil-normal-state-map (kbd "Q") 'evil-quit)
  (define-key evil-normal-state-map (kbd "SPC sv") 'evil-window-vsplit)
  (define-key evil-normal-state-map (kbd "SPC sh") 'evil-window-split)
  (define-key evil-normal-state-map (kbd "J")
    (lambda nil (interactive) (evil-next-visual-line 5)))
  (define-key evil-normal-state-map (kbd "K")
  (lambda nil (interactive) (evil-previous-visual-line 5)))
  (define-key evil-normal-state-map (kbd "SPC h") 'evil-window-left)
  (define-key evil-normal-state-map (kbd "SPC l") 'evil-window-right)
  (define-key evil-normal-state-map (kbd "SPC j") 'evil-window-down)
  (define-key evil-normal-state-map (kbd "SPC k") 'evil-window-up)
  ;; (define-key evil-motion-state-map (kbd "RET") nil)
  ;; (define-key evil-motion-state-map (kbd "TAB") nil)

  ;; Use visual line motions even outside of visual-line-mode buffers
  
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package key-chord)
(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
(key-chord-mode 1)

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package neotree
  :ensure t
  :config
    (evil-set-initial-state 'neotree-mode 'normal)
    (evil-define-key 'normal neotree-mode-map
      (kbd "o")   'neotree-enter
      (kbd "c")   'neotree-create-node
      (kbd "r")   'neotree-rename-node
      (kbd "d")   'neotree-delete-node
      ;; (kbd "j")   'neotree-next-node
      ;; (kbd "k")   'neotree-previous-node
      (kbd "g")   'neotree-refresh
      (kbd "C")   'neotree-change-root
      (kbd "I")   'neotree-hidden-file-toggle
      (kbd "H")   'neotree-hidden-file-toggle
      (kbd "q")   'neotree-hide
      (kbd "l")   'neotree-enter
      (kbd "s")   'neotree-enter-vertical-split
      (kbd "i")   'neotree-enter-horizontal-split
      )
  )

(define-key evil-normal-state-map (kbd "tt") 'neotree-toggle)

;; (with-eval-after-load 'evil-maps
  ;; (define-key evil-motion-state-map (kbd "SPC") nil)
  ; (define-key evil-motion-state-map (kbd "RET") nil)
  ; (define-key evil-motion-state-map (kbd "TAB") nil))

;; Org Mode Configuration ------------------------------------------------------
(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (setq org-want-todo-bindings t)
  (setq org-adapt-indentation t)
  (evil-define-key 'normal org-mode-map (kbd "C-RET") 'org-return)
  )

(add-hook 'org-mode-hook (lambda () (electric-indent-local-mode -1)))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))
