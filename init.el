;; Pantalla completa en GNOME
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; UI básica
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 10)
(global-display-line-numbers-mode 1)
(column-number-mode)
(delete-selection-mode 1)

;; Historial
(recentf-mode 1)
(global-set-key (kbd "C-c r") 'recentf-open-files)
(setq history-length 25)
(savehist-mode 1)

;; Desactivar números de línea en ciertos modos
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Sistema de paquetes
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org"   . "https://orgmode.org/elpa/")
                         ("elpa"  . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t) ;; instala automáticamente si no está

;; Modos de lenguajes
(use-package markdown-mode)
(use-package nix-mode) ;; opcional, podés comentar si no usás Nix

;; Tema
(use-package catppuccin-theme
  :config
  (setq catppuccin-flavor 'mocha)
  (setq catppuccin-highlight-line-numbers t
        catppuccin-italic-comments t
        catppuccin-italic-keywords t)
  (load-theme 'catppuccin t))

;; Completion / navegación
(use-package ivy
  :config
  (ivy-mode)
  (setq ivy-use-virtual-buffers t
        enable-recursive-minibuffers t))

(use-package ivy-rich
  :after ivy
  :config
  (ivy-rich-mode 1))

(use-package counsel
  :after ivy
  :bind (("M-x"     . counsel-M-x)
         ("C-x b"   . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . counsel-minibuffer-history)))

(use-package helpful
  :after counsel
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command]  . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key]      . helpful-key))

;; UI
;; NOTA: la primera vez corré M-x all-the-icons-install-fonts
(use-package all-the-icons)

(use-package doom-modeline
  :after all-the-icons
  :init (doom-modeline-mode 1)
  :custom (doom-modeline-height 15))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config (setq which-key-idle-delay 0.5))

;; Proyectos
(use-package projectile
  :diminish projectile-mode
  :config
  (projectile-mode)
  (setq projectile-save-known-projects t)
  (projectile-discover-projects-in-search-path)
  :custom
  (projectile-completion-system 'ivy)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/projects")
    (setq projectile-project-search-path '(("~/projects/" . 2))))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :after projectile
  :config (counsel-projectile-mode 1))

;; Git
(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

