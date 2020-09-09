;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Paul Johnson
;; 2014-07-14
;; UPDATE: Because Emacs ESS changes made this MUCH easier, my
;; re-work gets shorter :=)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INSTRUCTIONS. Rename this file, call it ~/.emacs, or copy it into the 
;; folder ~/emacs.d, so its name would be ~/emacs.d/init.el
;; or copy it into the Emacs site-start.d folder.

;; R USER PREVIEW.
;; Here are my special features related to ESS with R.

;; 1. Indentation policy follows Programming R Extensions Manual
;; UPDATE 2013-07-10. No longer needed. This is ESS default as of version 13-05

;; 2. Shift+Enter will send the current line to R, and it will start R
;; if it is not running.  ESS 13-05 chose instead CTL+Enter, which I
;; DO NOT want because it conflicts with CUA mode. 

;; 3. R will assume the current working directory is the document directory.

;; 4. R runs in its own "frame" 

;; 5. Emacs help pops up in its own frame. 

;; JUSTIFICATION.  The intention is to make Emacs work more like a
;; "modern" GUI editor. 
;; See my companion lecture 
;; "Emacs Has No Learning Curve"
;; http://pj.freefaculty.org/guides/Rcourse


;; Paul Johnson <pauljohn@ku.edu>
;; 2012-11-24
;;
;; Conflicts between Emacs-ESS and SAS usage forced me to make
;; some changes. And for no benefit, as SAS mode still not great.
;; I had to cut out a lot of framepop stuff.
;;


;; 2013-07-10 TODO: Find out if this is still necessary, or for
;; which versions of windows.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Section I. Windows OS work-arounds
;; 2014-10-09 no longer needed in Emacs 24.3
;; (if (eq system-type 'windows-nt)
;;    (setq use-file-dialog nil)) 
;; There's been a chronic problem with file selection dialogs on Windows
;; Maybe you commment previous out and see if your Windows is fixed.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Section II. Keyboard and mouse customization
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; IIA: make mouse selection work in the usual Mac/Windows way
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 2013-07-10 Comment these out
;; (setq shift-select-mode t) ; is default in Emacs 23+, replaces pc-select
;; (transient-mark-mode t) ; highlight text selection, is default Emacs 23+
(delete-selection-mode t) ; delete seleted text when typing


;; http://ergoemacs.org/emacs/emacs24_features.html
;; after copy Ctrl+c in X11 apps, you can paste by `yank' in emacs
;; (setq x-select-enable-clipboard t)

;; after mouse selection in X11, you can paste by `yank' in emacs
;;(setq x-select-enable-primary t)
;; This seems not reliable to me (2013-07-10)

;; TODO:
;; Figure out Emacs-24 trouble with mouse selections. I need to
;; figure out where the truth lies

;; In Linux, I see weirdness in Emacs 24 with paste and clipboard. Confusing!
;; http://stackoverflow.com/questions/13036155/how-to-to-combine-emacs-primary-clipboard-copy-and-paste-behavior-on-ms-windows
(setq select-active-regions t)
(global-set-key [mouse-2] 'mouse-yank-primary)  ; make mouse middle-click only paste from primary X11 selection, not clipboard and kill ring.

;;(setq mouse-drag-copy-region t)
;; See following http://emacswiki.org/emacs/CopyAndPaste
;; where there is a ton of really confusing advice.

;; highlight does not alter KILL ring
(setq mouse-drag-copy-region nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; IIB: keyboard customization

;; CUA mode is helpful not only for copy and paste, but also C-Enter is rectangle select
(cua-mode t) ; windows style binding C-x, C-v, C-c, C-z
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
;;20130717(setq cua-keep-region-after-copy t) ;; Selection remains after C-c

;; write line numbers on left of window
;; Caution: if you do this, it makes Emacs much slower!
;;(global-linum-mode 1) ; always show line numbers


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Section III. Programming conveniences:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(show-paren-mode t) ; light-up matching parens
(global-font-lock-mode t) ; turn on syntax highlighting
(setq text-mode-hook (quote (turn-on-auto-fill text-mode-hook-identify)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Section IV. ESS Emacs Statistics
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; start R in current working directory, don't let R ask user
(setq ess-ask-for-ess-directory nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ESS 13.05 default C-Ret conflicts with CUA mode rectangular selection.
;; Change shortcut to use Shift-Return
;; Suggested by Vitalie Spinu ESS-help email 2013-05-15
;; Revision suggested 2013-09-30 to co-exist with Windows Emacs
;; and the load order which has ess after user init file.
(eval-after-load "ess-mode"
 '(progn
   (define-key ess-mode-map [(control return)] nil)
   (define-key ess-mode-map [(shift return)] 'ess-eval-region-or-line-and-step))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; create a new frame for each help instance
;; (setq ess-help-own-frame t)
;; If you want all help buffers to go into one frame do:
(setq ess-help-own-frame 'one)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; I want the *R* process in its own frame
;; This was a broken feature in ESS, fixed now. Helps massively!
(setq inferior-ess-own-frame t)
;;(setq inferior-ess-same-window nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; See no beauty in this. Test: move pointer into a function
;; Run C-c C-d C-e to see effect
;;(setq ess-describe-at-point-method 'tooltip)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PJ 2013-07-10 Following commented out
;; PJ 2012-03-21 because ESS 13.05 made it default
;; Indentation per Programming R Extensions
;; (add-hook 'ess-mode-hook
;;    (lambda ()
;;    (ess-set-style 'C++ 'quiet)
;;    (add-hook 'local-write-file-hooks
;;	      (lambda ()
;;		(ess-nuke-trailing-whitespace)))))
;;;;(setq ess-nuke-trailing-whitespace-p 'ask)
;;;; or even
;;(setq ess-nuke-trailing-whitespace-p t)
;;; Perl
;;(add-hook 'perl-mode-hook
;;	  (lambda () (setq perl-indent-level 4)))
;; End ESS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; In Spring 2012, we noticed ESS SAS mode doesn't work well
;; at all on Windows, that lead to removal of lots of stuff
;; I really liked. Even then, we couldn't get much satisfaction.
;;
;; Following was needed for that, otherwise, it is not needed
;; (load "ess-site")
;; (ess-sas-global-unix-keys)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PJ 2013-02-28
;; stops suggestions in R when tabbing. Quiets noise, but ruins feature
;; (setq completion-auto-help nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; ;; Section V. Customize the use of Frames. Try to make new content
;; ;; ;; appear in wholly new frames on screen.
;; ;; ;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; ;; V.A: Discourage Emacs from splitting "frames", encourage it to pop up new
;; ;; ;; frames for new content.
;; ;; ;; see: http://www.gnu.org/software/emacs/elisp/html_node/Choosing-Window.html
;; (setq pop-up-frames t)
;; (setq special-display-popup-frame t)
(setq split-window-preferred-function nil) ;discourage horizontal splits
;; (setq pop-up-windows nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; V.C: Make files opened from the menu bar appear in their own
;; frames. This overrides the default menu bar settings.  Opening an
;; existing file and creating new one in a new frame are the exact
;; same operations.  adapted from Emacs menu-bar.el
(defun menu-find-existing ()
  "Edit the existing file FILENAME."
  (interactive)
  (let* ((mustmatch (not (and (fboundp 'x-uses-old-gtk-dialog)
                              (x-uses-old-gtk-dialog))))
         (filename (car (find-file-read-args "Find file: " mustmatch))))
    (if mustmatch
        (find-file-other-frame filename)
      (find-file filename))))
(define-key menu-bar-file-menu [new-file]
  '(menu-item "Open/Create" find-file-other-frame
	      :enable (menu-bar-non-minibuffer-window-p)
	      :help "Create a new file"))
(define-key menu-bar-file-menu [open-file]
  '(menu-item ,(purecopy "Open File...") menu-find-existing
              :enable (menu-bar-non-minibuffer-window-p)
              :help ,(purecopy "Read an existing file into an Emacs buffer")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; V.D  Open directory list in new frame.
(define-key menu-bar-file-menu [dired]
  '(menu-item "Open Directory..." dired-other-frame
	      :help "Read a directory; operate on its files (Dired)"
	      :enable (not (window-minibuffer-p (frame-selected-window menu-updating-frame)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Section VI: Miscellaneous convenience
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Remove Emacs "splash screen"
;; http://fuhm.livejournal.com/
(defadvice command-line-normalize-file-name
  (before kill-stupid-startup-screen activate)
  (setq inhibit-startup-screen t))
(setq inhibit-splash-screen t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Show file name in title bar
;; http://www.thetechrepo.com/main-articles/549
(setq frame-title-format "%b - Emacs")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; I'm right handed, need scroll bar on right (like other programs)
;;(setq scroll-bar-mode-explicit t)
;;(set-scroll-bar-mode `right) 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Make Emacs scroll smoothly with down arrow key.
;; 2011-10-14
;; faq 5.45 http://www.gnu.org/s/emacs/emacs-faq.html#Modifying-pull_002ddown-menus
(setq scroll-conservatively most-positive-fixnum)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; adjust the size of the frames, uncomment this, adjust values
;;(setq default-frame-alist '((width . 90) (height . 65)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Remember password when connected to remote sites via Tramp
;; http://stackoverflow.com/questions/840279/passwords-in-emacs-tramp-mode-editing
;; Emacs "tramp" service (ssh connection) constantly
;; asks for the log in password without this
(setq password-cache-expiry nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Section : Emacs shells work better
;; http://snarfed.org/why_i_run_shells_inside_emacs
(setq ansi-color-for-comint-mode 'filter)
(setq comint-prompt-read-only t)
(setq comint-scroll-to-bottom-on-input t)
(setq comint-scroll-to-bottom-on-output t)
(setq comint-move-point-for-output t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-auto-tabify-rectangles nil)
 '(tab-stop-list (quote (8 16 24 32 40 48 56 64 72 80 88 96 104 112 120 4))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Former IRB users' add-ons
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Test of Emacs derivates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(if (string-match "XEmacs\\|Lucid" emacs-version)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; XEmacs
  ;;; ------
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (progn
     (if (file-readable-p "~/.xemacs/init.el")
        (load "~/.xemacs/init.el" nil t))
  )
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; GNU-Emacs
  ;;; ---------
  ;;; load ~/.gnu-emacs or, if not exists /etc/skel/.gnu-emacs
  ;;; For a description and the settings see /etc/skel/.gnu-emacs
  ;;;   ... for your private ~/.gnu-emacs your are on your one.
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (if (file-readable-p "~/.gnu-emacs")
      (load "~/.gnu-emacs" nil t)
    (if (file-readable-p "/etc/skel/.gnu-emacs")
	(load "/etc/skel/.gnu-emacs" nil t)))

  ;; Custum Settings
  ;; ===============
  ;; To avoid any trouble with the customization system of GNU emacs
  ;; we set the default file ~/.gnu-emacs-custom
  (setq custom-file "~/.gnu-emacs-custom")
  (load "~/.gnu-emacs-custom" t t)
;;;
)
;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ASSOCIATE FILE EXTENSIONS WITH EMACS MODES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq auto-mode-alist
      '(("\\.txt$" . text-mode)
        ("\\.tex$" . latex-mode)
        ("\\.Rnw$" . latex-mode)
        ("\\.texinfo$" . texinfo-mode)
        ("\\.h$" . c-mode)
        ("\\.c$" . c-mode)
        ("^/tmp/Re" . non-saved-text-mode)
        ("\\.lsp$" . lisp-mode)
        ("\\.S$" . S-mode)
        ("\\.R$" . R-mode)
        ("\\.r$" . R-mode)
        ("/\\..*emacs" . emacs-lisp-mode)
        ("\\.el$" . emacs-lisp-mode)
        ("\\.html$" . html-mode)
        ("\\.htm$" . html-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SPECIFY KEY-BINDINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key "\^[[5D" 'beginning-of-line) ;^[[5D corresponds to C-left
(global-set-key "\^[[5C" 'end-of-line) ;^[[5C corresponds to C-right

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; R MODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(autoload 'R-mode "ess-site" "Emacs Speaks Statistics" t)
(load "/Applications/Emacs.app/Contents/Resources/site-lisp/ess/ess-site.el")

(setq ess-ask-for-ess-directory nil)
(setq ess-local-process-name "R")
(setq ansi-color-for-comint-mode 'filter)
(setq comint-scroll-to-bottom-on-input t)
(setq comint-scroll-to-bottom-on-output t)
(setq comint-move-point-for-output t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EPLANET ADDONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(transient-mark-mode t)
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; do not make backup files
(setq make-backup-files nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Changes all yes/no questions to y/n type
(fset 'yes-or-no-p 'y-or-n-p)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Keep mouse high-lightening 
(setq mouse-sel-retain-highlight t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;set cursor color to red
(set-cursor-color "red")
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;set cursor not to blink
(blink-cursor-mode 0)
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;highlight current line
;(global-hl-line-mode 1)
;(set-face-background 'hl-line "grey60")
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;show position line position
(column-number-mode 1)
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;full screen
;(defun toggle-fullscreen () (interactive) (set-frame-parameter nil 'fullscreen (if (frame-parameter nil 'fullscreen) nil 'fullboth)))
;(global-set-key [(meta return)] 'toggle-fullscreen)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;resize frames
;(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
;(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
;(global-set-key (kbd "C-") 'shrink-window)
;(global-set-key ("\^[[5C") 'enlarge-window)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;share clipboard with OSX
(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))
(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil)) 
      (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
        (process-send-string proc text)
        (process-send-eof proc))))
(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Remove splash screen
(setq inhibit-splash-screen t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;turn off auto save
(setq auto-save-default nil) 
(setq transient-mark-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set default window size
(setq initial-frame-alist
      '((top . 20) (left . 10)
        (width . 150) (height . 55)
;;        (font . "-apple-monaco-medium-r-normal--13-140-72-72-m-140-iso10646-1")))
        (font . "-apple-monaco-medium-r-normal--12-140-72-72-m-140-iso10646-1")))
;;        (font . "-apple-monaco-medium-r-normal--11-140-72-72-m-140-iso10646-1")))
;;        (font . "-apple-courier-medium-r-normal--12-120-72-72-m-120-mac-roman")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;pdf mode in tex 
(setq-default TeX-PDF-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; disable bell
;;(setq visible-bell t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;full screen
(defun toggle-fullscreen () (interactive) (set-frame-parameter nil 'fullscreen (if (frame-parameter nil 'fullscreen) nil 'fullboth)))
(global-set-key [(meta return)] 'toggle-fullscreen)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;column mode
(cua-mode t)
;(setq cua-enable-cua-keys nil)
;(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
;(transient-mark-mode 1)               ;; No region when it is not highlighted
;(setq cua-keep-region-after-copy t) 

;;hide tool bar (menu with buttons)
(custom-set-variables '(tool-bar-mode nil))

;;recenter
;(global-set-key "\C-t" 'recenter)

;;auto indent (in latex mode)
;(add-hook 'LaTeX-mode-hook 'auto-fill-mode)

;;do not auto indent comments when pressing return
(setq ess-fancy-comments nil)

;;move up with C-u (C-p is ised for R)
;(global-set-key "\^u" 'previous-line)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Toni Berenguer adds-on
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; switch to previous buffer
(defun switch-to-previous-buffer ()
      (interactive)
      (switch-to-buffer (other-buffer (current-buffer) 1))
      (recenter)
)
(global-set-key "\C-f" 'switch-to-previous-buffer) 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Numeric keyboard

(global-set-key "\eOp" "0")
(global-set-key "\eOq" "1")
(global-set-key "\eOr" "2")
(global-set-key "\eOs" "3")
(global-set-key "\eOt" "4")
(global-set-key "\eOu" "5")
(global-set-key "\eOv" "6")
(global-set-key "\eOw" "7")
(global-set-key "\eOx" "8")
(global-set-key "\eOy" "9")
(global-set-key "\Ok" "+")
(global-set-key "\Oo" "/")
(global-set-key "\Oj" "*")
(global-set-key "\Om" "-")
(global-set-key "\eOn" ".")
(global-set-key "\OM" "\")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; for make shift-up selection work
(define-key function-key-map "\^[[1;2A" [S-up])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Auto-indent
;; ESS
;; (add-hook 'ess-mode-hook
;;           (lambda ()
;;             (ess-set-style 'C++ 'quiet)
;;             ;; Because
;;             ;;                                 DEF GNU BSD K&R  C++
;;             ;; ess-indent-level                  2   2   8   5  4
;;             ;; ess-continued-statement-offset    2   2   8   5  4
;;             ;; ess-brace-offset                  0   0  -8  -5 -4
;;             ;; ess-arg-function-offset           2   4   0   0  0
;;             ;; ess-expression-offset             4   2   8   5  4
;;             ;; ess-else-offset                   0   0   0   0  0
;;             ;; ess-close-brace-offset            0   0   0   0  0
;;             (add-hook 'local-write-file-hooks
;;                       (lambda ()
;;                         (ess-nuke-trailing-whitespace)))))
;; (setq ess-nuke-trailing-whitespace-p 'ask)
 ;; or even
;; (setq ess-nuke-trailing-whitespace-p t)
 ;;; Perl
;; (add-hook 'perl-mode-hook
;;           (lambda () (setq perl-indent-level 4)))

;;(setq c-default-style "bsd"  c-basic-offset 4)

;(setq ess-fancy-comments nil)
;(add-hook 'ess-mode-hook 
;          (lambda () 
;            (local-set-key (kbd "RET") 'newline-and-indent)))


(global-set-key (kbd "<backtab>") 'indent-region)

(setq tab-width 4)
;(setq indent-tabs-mode nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; start with R
(defun my-ess-start-R ()
  (interactive)
  (if (not (member "*R*" (mapcar (function buffer-name) (buffer-list))))
      (progn
        (delete-other-windows)
        (setq w1 (selected-window))
        (setq w1name (buffer-name))
        (setq w2 (split-window w1 nil t))
        (R)
        (set-window-buffer w2 "*R*")
        (set-window-buffer w1 w1name))))
(local-set-key (kbd "C-c C-r") 'my-ess-start-R)

(global-set-key "\C-\M-r" 'my-ess-start-R)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; send a line to R
(defun my-eval-line ()
  "Evaluate line, scroll down in R and return to script window"
  (interactive)
;  (my-ess-start-R)
  (ess-eval-line-and-go nil)
  (other-window 1)
  (next-line)
  (other-window 1)
  (delete-other-windows)

)

(global-set-key "\C-e" 'my-eval-line) 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; evaluate a paragraph in R
(defun my-eval-paragraf ()
  "Evaluate line, scroll down in R and return to script window"
  (interactive)
  (my-ess-start-R)
  (ess-eval-paragraph-and-go nil);
  (delete-other-windows)
)

(global-set-key "\C-p" 'my-eval-paragraf)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; evaluate a region
(defun my-eval-region (start end vis)
  "Evaluate region, scroll down in R and return to script window"
  (interactive "r\nP")
  (my-ess-start-R)
  (ess-eval-region-and-go start end vis)
  (delete-other-windows)
)

(global-set-key "\C-r" 'my-eval-region)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sent a paragraph or a region
(defun my-eval-region-paragraph (&optional start &optional end &optional vis)
  "Sent region is mark is active, else send paragraph"
  (interactive "r\nP")
  (if mark-active (my-eval-region start end vis) (my-eval-paragraf))
)
(global-set-key "\C-d" 'my-eval-region-paragraph)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;recenter 
(defun recenter-top ()
  (interactive)
  (recenter)
  (scroll-up 12)
)

(defun recenter-down ()
  (interactive)
  (recenter)
  (scroll-down 15)
)
(global-set-key "\C-a" 'recenter-top)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-key inferior-ess-mode-map "\OA" 'comint-previous-input)
(define-key inferior-ess-mode-map "\OB" 'comint-next-input)
(define-key inferior-ess-mode-map "\[1;5A" 'previous-line)
(define-key inferior-ess-mode-map "\[1;5B" 'next-line)

(define-key inferior-ess-mode-map "\OH" 'comint-bol)

;(setq ess-eval-visibly-p nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; scroll one line at a time (less "jumpy" than defaults)

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
;(setq scroll-step 1) ;; keyboard scroll one line at a time
;(setq scroll-conservatively 10000)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; scroll with mouse wheel

(defun what-line-ab ()
       "Print the current line number"
       (interactive)
       (save-restriction
         (widen)
         (save-excursion
           (beginning-of-line)
           (1+ (count-lines 1 (point))))))

(xterm-mouse-mode)

(defun scroll-up-1-lines ()
  "Scroll up 1 line"
  (interactive)
  (setq x (what-line-ab))
  (setq y (+ x -5))
  (if (> x 38) (progn (scroll-down 25) (recenter))
     (progn (if (> x 20) (progn (scroll-down 1) (goto-line y)) (goto-line y)))))
  

(defun scroll-down-1-lines ()
  "Scroll down 1 line"
  (interactive)
  (setq x (what-line-ab))
  (setq y (+ x +5))
  (if (> x 38) (progn (scroll-up 25) (recenter))
     (progn (if (> x 20) (progn (scroll-up 1) (goto-line y)) (goto-line y)))))

   
(global-set-key (kbd "<mouse-4>") 'scroll-up-1-lines) ;
(global-set-key (kbd "<mouse-5>") 'scroll-down-1-lines) ;
(global-set-key (kbd "<mouse-1>") 'mouse-set-point);
(require 'mouse)
(xterm-mouse-mode t)
(defun track-mouse (e)) 
(setq mouse-sel-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; inverse maker navigation

(defun unpop-to-mark-command ()
  "Unpop off mark ring. Does nothing if mark ring is empty."
  (interactive)
      (when mark-ring
        (setq mark-ring (cons (copy-marker (mark-marker)) mark-ring))
        (set-marker (mark-marker) (car (last mark-ring)) (current-buffer))
        (when (null (mark t)) (ding))
        (setq mark-ring (nbutlast mark-ring))
        (goto-char (marker-position (car (last mark-ring))))))
(global-set-key (kbd "C-x <C-down>") 'unpop-to-mark-command) ;
(global-set-key (kbd "C-x <C-up>") 'pop-to-mark-command) ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; AB-customized keyboard
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(global-set-key (kbd "p") 'forward-char);
;(global-set-key (kbd "k") 'backward-char);
;(global-set-key (kbd "") 'forward-word);
;(global-set-key (kbd "") 'backward-word);
;(global-set-key (kbd "C-u") 'beginning-of-line);
;(global-set-key (kbd "C-j") 'end-of-line);
;(global-set-key (kbd "u") 'beginning-of-buffer);
;(global-set-key (kbd "j") 'end-of-buffer);
;(global-set-key (kbd "^L") 'forward-paragraph);
;(global-set-key (kbd "") 'backward-paragraph);
;(global-set-key (kbd "l") 'forward-line);
;(global-set-key (kbd "o") 'previous-line);




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;