(setq-default
 ; don't show startup screen
 inhibit-startup-screen t
 ; disable backup
 backup-inhibited t
 ; disable auto save
 auto-save-default nil

 make-backup-files nil

 ; don't do all this renaming/copying jiggery-pokery when saving a file.
 file-precious-flag nil
 ; don't break hard links when editing
 backup-by-copying-when-linked nil

 indent-tabs-mode nil
 standard-indent 2
 c-basic-offset 2
 python-indent 4

 show-trailing-whitespace t
 require-final-newline t  ; will this break stuff?

 ; middle-click should paste at the point, not where I clicked.
 mouse-yank-at-point t

 ; death to fsync (really to ext3 with mode=ordered)
 write-region-inhibit-fsync t
)

; no menu bar on console mode
(menu-bar-mode -1)

; reduce big gray margins on window
(fringe-mode '(1 . 0))

(add-to-list 'load-path "~/.emacs.d")

; start emacs server
(server-start)

; interactive buffer switch and file load
(require 'ido)
(ido-mode t)

; Don't require me to type out "yes".
(fset 'yes-or-no-p 'y-or-n-p)

; Git support.
(autoload 'magit-status "magit" nil t)
(require 'git-grep)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(org-agenda-files (quote ("~/everything.org")))
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style (quote forward))
 '(haskell-program-name "ghci"))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(whitespace-line ((t (:underline t)))))

; Haskell ghci support.
(require 'inf-haskell)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
(setq completion-ignored-extensions
      (cons ".hi" completion-ignored-extensions))
(add-to-list 'auto-mode-alist '("\\.cpphs$" . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.chs$" . haskell-mode))

;; this means hitting the compile button always saves the buffer
;; having to separately hit C-x C-s is a waste of time
(setq mode-compile-always-save-buffer-p t)
;; make the compile window stick at 12 lines tall
(setq compilation-window-height 12)
;; always scroll
(setq compilation-scroll-output t)
;; If the compilation has a zero exit code, the windows disappears
;; after two seconds.
(setq compilation-finish-functions
      (lambda (buf str)
        (unless (string-match "exited abnormally" str)
          ;; No errors, make the compilation window go away in a few seconds.
          (run-at-time
           "2 sec" nil 'delete-windows-on
           (get-buffer-create "*compilation*"))
          (message "No Compilation Errors!"))))

; Timestamp function.
(defun timestamp ()
  "Insert a time stamp into the buffer."
  (interactive)
  (insert (format-time-string "%Y/%m/%d %H:%M" (current-time))))

(defun new-post ()
  "Set up a post for lazyblog."
  (interactive)
  (insert "Timestamp: ") (timestamp) (insert "\n")
  (insert "Subject: "))

; Chromium!
(require 'chromium)

; Markdown
(autoload 'markdown-mode "markdown-mode.el"
   "Major mode for editing Markdown files" t)
(setq auto-mode-alist
   (cons '("\\.text" . markdown-mode) auto-mode-alist))

; Javascript
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))

; SCons
(add-to-list 'auto-mode-alist '("\\.scons$" . python-mode))
; vi-like keybindings

(defvar newline-and-indent nil
  "Modify the behavior of the open-*-line functions to cause them
to autoindent.")

(defun open-previous-line (arg)
  "Open a new line before the current one.

See also `newline-and-indent'."
  (interactive "p")
  (beginning-of-line)
  (open-line arg)
  (when newline-and-indent
    (indent-according-to-mode)))

(defun open-next-line (arg)
  "Move to the next line and then opens a line.

See also `newline-and-indent'."
  (interactive "p")
  (end-of-line)
  (open-line arg)
  (forward-line 1)
  (when newline-and-indent
    (indent-according-to-mode)))

(global-set-key (kbd "C-o") 'open-next-line)
(global-set-key (kbd "M-o") 'open-previous-line)

(global-set-key [f7] 'recompile)
(global-set-key (kbd "M-`") 'next-error)

(defun autocompile nil
  "compile itself if ~/.emacs/init.el"
  (interactive)
  (require 'bytecomp)
  (print (buffer-file-name))
  (if (or (string= (buffer-file-name) (expand-file-name "~/.emacs.d/init.el"))
          (string= (buffer-file-name) (expand-file-name "~/projects/config/emacs.d/init.el")))
      (byte-compile-file (buffer-file-name))))
(add-hook 'after-save-hook 'autocompile)

; Only use whitespace mode for overlong lines; its end-of-line whitespace
; detection is annoying.
(require 'whitespace)
(setq whitespace-style '(lines-tail))
(global-whitespace-mode)

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome")
