;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'package)
(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)
(load "~/q-mode/q-mode.el")
(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'load-path "~/.emacs.d/shell-switcher")
(add-to-list 'auto-mode-alist '("\\.[kq]\\'" . q-mode))
;; shell-switcher
(require 'shell-switcher)
(setq shell-switcher-mode t)
(defun make-bash ()
  "Create new bash term" (ansi-term "/bin/bash" (generate-new-buffer-name "ansi-term")))
(setq-default shell-switcher-new-shell-function 'make-bash)
(define-key shell-switcher-mode-map (kbd "M-'")
  'shell-switcher-switch-buffer)
;; custom functions
(defun launch-ansi-term (name command)
  "Create or visit a terminal buffer."
  ;;(interactive "MBuffer Name: \nbCommand: ")
  (sleep-for 0 500)
  (progn
    ;;(split-window-sensibly (selected-window))
    ;;(other-window 1)
    (ansi-term (getenv "SHELL"))
    (rename-buffer name)
    (end-of-buffer)
    (insert command)
    (term-send-input)))
  ;;(switch-to-buffer-other-window name))

(defun voi-layout ()
  (interactive)
  (delete-other-windows)
  (setq hbm (car (window-list)))
  (switch-to-buffer "heartbeat-monitor")
  (select-window (split-window nil 100 'right))
  (switch-to-buffer "voi")
  (select-window (split-window nil nil nil))
  (switch-to-buffer "ctrader")
  (select-window hbm)
  (select-window (split-window nil 15 'below))
  (switch-to-buffer "order-book")
  (select-window (split-window nil nil 'below))
  (switch-to-buffer "tickerplant")
  (select-window hbm))

(defun voi-workflow ()
  (interactive)
  (launch-ansi-term "order-book" "cd ~/pyq-gdax && q ob.q")
  (launch-ansi-term "tickerplant" "cd ~/pyq-gdax && q tp.q")
  (launch-ansi-term "heartbeat-monitor" "cd ~/pyq-gdax && q hb.q")
  (launch-ansi-term "voi" "cd ~/pyq-gdax && q voi.q")
  (launch-ansi-term "qtrader" "cd ~/pyq-gdax && q voiTrader.q")
  (launch-ansi-term "hdb" "cd ~/pyq-gdax && q hdb.q")
  (launch-ansi-term "ctrader" "cd ~/pyq-gdax && ./subscriber")
  (voi-layout))

;; Don't clutter up directories with files~
(setq backup-directory-alist `(("." . ,(expand-file-name
					(concat "~/.backups")))))
;; Don't clutter with #files either
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name (concat "~/.backups")))))
(setq inferior-lisp-program "/usr/bin/sbcl")
(menu-bar-mode -1)
(desktop-save-mode 1)
