;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; File name: ` ~/.emacs '
;;; ---------------------
;;;
;;; If you need your own personal ~/.emacs
;;; please make a copy of this file
;;; an placein your changes and/or extension.
;;;
;;; Copyright (c) 1997-2002 SuSE Gmbh Nuernberg, Germany.
;;;
;;; Author: Werner Fink, <feedback@suse.de> 1997,98,99,2002
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Test of Emacs derivates
;;; -----------------------
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


;;; FROM HERE ON WE CAN FIND CODE ADDED BY EPL

;;----------------------------------------------------------
;; ASSOCIATE FILE EXTENSIONS WITH EMACS MODES
;;----------------------------------------------------------

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

;;----------------------------------------------------------
;; SPECIFY KEY-BINDINGS
;;----------------------------------------------------------

(global-set-key "\^[[5D" 'beginning-of-line) ;^[[5D corresponds to C-left
(global-set-key "\^[[5C" 'end-of-line) ;^[[5C corresponds to C-right

;(setq mac-option-modifier 'meta)
;(global-set-key "C-tab" 'other-window) ;switch to other window in a divided frame
;(global-set-key [M-tab] 'other-frame)  ;switch to frame in a different window

;epl: removed cause its used to del a line
;(global-set-key "\C-k" 'kill-buffer)

;epl: removed cause it uses apple key
;;Apple-N will open a new buffer in a new window
;(defun my-new-frame-with-new-scratch ()
;  (interactive)
;  (let ((one-buffer-one-frame t))
;    (new-frame-with-new-scratch)))
;
;(define-key osx-key-mode-map (kbd "A-n") 'my-new-frame-with-new-scratch)

;epl: removed cause it uses apple key
;;Apple-W will close only the current window
;(one-buffer-one-frame-mode 0)
;(defun my-close-current-window-asktosave ()
;  (interactive)
;  (let ((one-buffer-one-frame t))
;    (close-current-window-asktosave)))
;(define-key osx-key-mode-map (kbd "A-w") 'my-close-current-window-asktosave)

;;----------------------------------------------------------
;; R MODE
;;----------------------------------------------------------

(autoload 'R-mode "ess-site" "Emacs Speaks Statistics" t)
(load "/software/ess-13.09/lisp/ess-site.el")

;; (defun my-start-R ()
;;   "Split window in 2, start R and load R-mode"
;;   (interactive)
;;   (R)
;;   (setq win1 (selected-window))
;;   (setq win2 (split-window-horizontally))
;; ;;  (setq win1 (split-window-vertically))
;; ;;  (select-window win2)
;;   (select-window win1)
;; )

(setq ess-ask-for-ess-directory nil)
(setq ess-local-process-name "R")
(setq ansi-color-for-comint-mode 'filter)
(setq comint-scroll-to-bottom-on-input t)
(setq comint-scroll-to-bottom-on-output t)
(setq comint-move-point-for-output t)
;(defun my-ess-start-R ()
;  (interactive)
;  (if (not (member "*R*" (mapcar (function buffer-name) (buffer-list))))
;      (progn
;        (delete-other-windows)
;        (setq w1 (selected-window))
;        (setq w1name (buffer-name))
;        (setq w2 (split-window w1 nil t))
;        (R)
;        (set-window-buffer w2 "*R*")
;        (set-window-buffer w1 w1name))))
;(local-set-key (kbd "C-c C-r") 'my-ess-start-R)

;; (defun my-ess-eval ()
;;   (interactive)
;;   (my-ess-start-R)
;;   (if (and transient-mark-mode mark-active)
;;       (call-interactively 'ess-eval-region)
;;     (call-interactively 'ess-eval-line-and-step)))

;; (add-hook 'ess-mode-hook
;;           '(lambda()
;;              (local-set-key [(shift return)] 'my-ess-eval)))
;; (add-hook 'inferior-ess-mode-hook
;;           '(lambda()
;;              (local-set-key [C-up] 'comint-previous-input)
;;              (local-set-key [C-down] 'comint-next-input)))
;; (add-hook 'Rnw-mode-hook
;;           '(lambda()
;;              (local-set-key [(shift return)] 'my-ess-eval)))
;; (require 'ess-site)

;(defun my-eval-line ()
;  "Evaluate line, scroll down in R and return to script window"
;  (interactive)
;  (my-ess-start-R)
;  (ess-eval-line-and-go nil)
;  (other-window 1)
;)

;(defun my-eval-paragraf ()
;  "Evaluate line, scroll down in R and return to script window"
;  (interactive)
;  (my-ess-start-R)
;  (ess-eval-paragraph-and-go nil);
;  (other-window 1)
;)

;(defun my-eval-region (start end vis)
;  "Evaluate region, scroll down in R and return to script window"
;  (interactive "r\nP")
;  (my-ess-start-R)
;  (ess-eval-region-and-go start end vis)
;  (other-window 1)
;)

;(global-set-key "\C-l" 'my-eval-line) 
;(global-set-key "\C-p" 'my-eval-paragraf)
;(global-set-key "\C-r" 'my-eval-region)
;(global-set-key "\C-\M-r" 'my-ess-start-R)

;;----------------------------------------------------------
;; Run gdb on R
;;----------------------------------------------------------
;; Rgdb starts gdb with R. New buffer is not of mode ess, so usual ess-eval functions don't work
;; send-line, send-paragraph and send-region are a simpler version of ess-evals that do work

(defun Rgdb ()
  "Start R with gdb"
  (interactive)
  (R-mode)              ;put original window in R-mode
  (let ((name "R -d gdb"))(gdb name))
)

(defun send-line () 
  (interactive)
  (save-excursion
    (beginning-of-line)
    (if (not (= (point) (point-max)))
      (let ((linestr (buffer-substring (progn (end-of-line) (point)) (progn (beginning-of-line) (point)))))
      (other-window 1)
      (end-of-buffer)
      (insert linestr)
      (call-interactively (key-binding "\r"))
      (other-window -1)
      )
    )
  )
)

(defun send-paragraph (&optional arg)
  (interactive "P")
  (let ((beg (progn (backward-paragraph 1) (point)))
  (end (progn (forward-paragraph arg) (point))))
  (copy-region-as-kill beg end))
  (other-window 1)
  (end-of-buffer)
  (yank)
  (call-interactively (key-binding "\r"))
  (other-window -1)
)

(defun send-region (beg end &optional args)   ;beg and end indicate beginning and end of selection
  (interactive "r\nP")                        ;r\nP is needed so that beg, end are properly set up
  (copy-region-as-kill beg end)
  (other-window 1)
  (end-of-buffer)
  (yank)
  (call-interactively (key-binding "\r"))
  (other-window -1)
)

(global-set-key (kbd "C-c l") 'send-line) 
(global-set-key (kbd "C-c p") 'send-paragraph) 
(global-set-key (kbd "C-c r") 'send-region)

;;;----------------------------------------------------------
;;; TEX MODE auc-tex
;;;----------------------------------------------------------
;
;(autoload 'LaTeX-mode "tex-site"  "Math mode for TeX." t)
;(add-hook 'LaTeX-mode-hook 'flyspell-mode)
;(add-hook 'LaTeX-mode-hook 'reftex-mode)

;(setq-default abbrev-mode t)
;(load "/home/eplanet/.emacsinputs/latexinit.el")
;(read-abbrev-file "/home/eplanet/.emacsinputs/abbrevs.el")

;(load "/home/eplanet/.emacsinputs/flyspell-1.7m.el")
;(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)
;(autoload 'flyspell-delay-command "flyspell" "Delay on command." t) 
;(autoload 'tex-mode-flyspell-verify "flyspell" "" t)
;(global-set-key "\C-i" 'flyspell-buffer) ;mark spelling errors across buffer


;;----------------------------------------------------------
;; UTILITIES
;;----------------------------------------------------------

;(defun newlatex()
;  (interactive)
;  (insert-file "/home/eplanet/.emacsinputs/paper.tex"))

;(defun newletter()
;  (interactive)
;  (insert-file "/home/eplanet/.emacsinputs/letter.tex"))

;(defun newfax()
;  (interactive)
;  (insert-file "/home/eplanet/.emacsinputs/fax.tex"))

;(defun newpres()
;  (interactive)
;  (insert-file "/home/eplanet/.emacsinputs/pres.tex"))

;(defun newrprog()
;  (interactive)
;  (insert-file "/home/eplanet/.emacsinputs/rprogram.r"))

;(defun bioclib()
;  (interactive)
;  (insert-file "/home/eplanet/.emacsinputs/biocliblist.txt"))

;(defun newrweave()
;  (interactive)
;  (insert-file "/home/eplanet/.emacsinputs/rweavedoc.Rnw"))

;set properties of new frames
;(smart-frame-positioning-mode nil)


;;----------------------------------------------------------
;; EPLANET ADDONS
;;----------------------------------------------------------

(transient-mark-mode t)
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

;;turn auto indent to off
;(add-hook 'TeX-mode-hook 
;  '(lambda () (auto-fill-mode -1))) 

;; do not make backup files
(setq make-backup-files nil)

;; Changes all yes/no questions to y/n type
(fset 'yes-or-no-p 'y-or-n-p)

;;Keep mouse high-lightening 
(setq mouse-sel-retain-highlight t)

;;set cursor color to red
(set-cursor-color "red")
 
;;set cursor not to blink
(blink-cursor-mode 0)
 
;;highlight current line
;(global-hl-line-mode 1)
;(set-face-background 'hl-line "grey60")
 
;;show position line position
(column-number-mode 1)
 
;;full screen
;(defun toggle-fullscreen () (interactive) (set-frame-parameter nil 'fullscreen (if (frame-parameter nil 'fullscreen) nil 'fullboth)))
;(global-set-key [(meta return)] 'toggle-fullscreen)

;resize frames
;(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
;(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
;(global-set-key (kbd "C-") 'shrink-window)
;(global-set-key ("\^[[5C") 'enlarge-window)

;share clipboard with OSX
;(defun copy-from-osx ()
;  (shell-command-to-string "pbpaste"))
;(defun paste-to-osx (text &optional push)
;  (let ((process-connection-type nil)) 
;      (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
;        (process-send-string proc text)
;        (process-send-eof proc))))
;(setq interprogram-cut-function 'paste-to-osx)
;(setq interprogram-paste-function 'copy-from-osx)

;; Remove splash screen
(setq inhibit-splash-screen t)

;;turn off auto save
(setq auto-save-default nil) 
(setq transient-mark-mode t)

;; Set default window size
(setq initial-frame-alist
      '((top . 20) (left . 10)
        (width . 150) (height . 55)
;;        (font . "-apple-monaco-medium-r-normal--13-140-72-72-m-140-iso10646-1")))
        (font . "-apple-monaco-medium-r-normal--12-140-72-72-m-140-iso10646-1")))
;;        (font . "-apple-monaco-medium-r-normal--11-140-72-72-m-140-iso10646-1")))
;;        (font . "-apple-courier-medium-r-normal--12-120-72-72-m-120-mac-roman")))

;;pdf mode in tex 
(setq-default TeX-PDF-mode t)

;; disable bell
;;(setq visible-bell t)

;;full screen
(defun toggle-fullscreen () (interactive) (set-frame-parameter nil 'fullscreen (if (frame-parameter nil 'fullscreen) nil 'fullboth)))
(global-set-key [(meta return)] 'toggle-fullscreen)

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

::::::::::::::::::::::::::::::::::::::::::
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Toni Berenguer adds-on

(defun switch-to-previous-buffer ()
      (interactive)
      (switch-to-buffer (other-buffer (current-buffer) 1))
      (recenter)
)
(global-set-key "\C-f" 'switch-to-previous-buffer) 


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


;(defun switch-R-code ()

;  (interactive)
;  (switch-to-buffer nil)
;  (recenter)
;)

;(defun shift-backward-selection ()
;            (interactive)
;	    (if mark-active  (previous-line) 
;	      (end-of-line)
;	      (call-interactively (key-binding "\ "))
;	      (previous-line)
;	    )
;)

;(defun shift-backward-selection ()
;            (interactive "P")
;            (call-interactively (key-binding "\[1;2H"))
;            (call-interactively (key-binding "\[1;2D"))
;)
;(global-set-key "\[1;5A" 'shift-backward-selection)

; for make shift-up selection work
(define-key function-key-map "\^[[1;2A" [S-up])


; Auto-indent
;; ESS
 (add-hook 'ess-mode-hook
           (lambda ()
             (ess-set-style 'C++ 'quiet)
             ;; Because
             ;;                                 DEF GNU BSD K&R  C++
             ;; ess-indent-level                  2   2   8   5  4
             ;; ess-continued-statement-offset    2   2   8   5  4
             ;; ess-brace-offset                  0   0  -8  -5 -4
             ;; ess-arg-function-offset           2   4   0   0  0
             ;; ess-expression-offset             4   2   8   5  4
             ;; ess-else-offset                   0   0   0   0  0
             ;; ess-close-brace-offset            0   0   0   0  0
             (add-hook 'local-write-file-hooks
                       (lambda ()
                         (ess-nuke-trailing-whitespace)))))
 (setq ess-nuke-trailing-whitespace-p 'ask)
 ;; or even
;; (setq ess-nuke-trailing-whitespace-p t)
 ;;; Perl
 (add-hook 'perl-mode-hook
           (lambda () (setq perl-indent-level 4)))

(setq c-default-style "bsd"  c-basic-offset 4)

;(setq ess-fancy-comments nil)
;(add-hook 'ess-mode-hook 
;          (lambda () 
;            (local-set-key (kbd "RET") 'newline-and-indent)))




(global-set-key (kbd "<backtab>") 'indent-region)

;(setq tab-width 4)
;(setq indent-tabs-mode nil)


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

(defun my-eval-paragraf ()
  "Evaluate line, scroll down in R and return to script window"
  (interactive)
  (my-ess-start-R)
  (ess-eval-paragraph-and-go nil);
  (delete-other-windows)
)

;(defun my-eval-paragraf (&optional arg)
;  (interactive "P")
;  (let ((beg (progn (backward-paragraph 1) (point)))
;  (end (progn (forward-paragraph arg) (point))))
;  (copy-region-as-kill beg end))
;  (my-ess-start-R)
;  (switch-R-code)
;  (delete-other-windows)  
;  (switch-R-code)
;  (end-of-buffer)
;  (yank)
;  (call-interactively (key-binding "\r"))
;)


(defun my-eval-region (start end vis)
  "Evaluate region, scroll down in R and return to script window"
  (interactive "r\nP")
  (my-ess-start-R)
  (ess-eval-region-and-go start end vis)
  (delete-other-windows)
)


;(defun my-eval-region (beg end &optional args)
;  "Evaluate region, scroll down in R and return to script window"
;  (interactive "r\nP")
;  (copy-region-as-kill beg end)
;  (my-ess-start-R)
;  (switch-R-code)
;  (delete-other-windows)  
;  (switch-R-code)
;  (end-of-buffer)
;  (yank)
;  (call-interactively (key-binding "\r"))
;)


(defun send-region (beg end &optional args)   ;beg and end indicate beginning and end of selection
  (interactive "r\nP")                        ;r\nP is needed so that beg, end are properly set up
  (copy-region-as-kill beg end)
  (other-window 1)
  (end-of-buffer)
  (yank)
  (call-interactively (key-binding "\r"))
;  (other-window -1)
)


(global-set-key "\C-e" 'my-eval-line) 
(global-set-key "\C-p" 'send-paragraph)
(global-set-key "\C-r" 'my-eval-region)
(global-set-key "\C-\M-r" 'my-ess-start-R)

(defun my-eval-region-paragraph (&optional start &optional end &optional vis)
  "Sent region is mark is active, else send paragraph"
  (interactive "r\nP")
  (if mark-active (my-eval-region start end vis) (my-eval-paragraf))
)
(global-set-key "\C-d" 'my-eval-region-paragraph)


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

;;scroll and center

;(defun scroll-up-and-center ()
;            (interactive)
;	    (scroll-up)
;	    (recenter)
;)
;(defun scroll-down-and-center ()
;            (interactive)
;	    (scroll-down)
;	    (recenter)
;)

;(global-set-key "\[1;5A" 'scroll-down)
;(global-set-key "\[1;5B" 'scroll-up)
;(global-set-key "\[5~" 'scroll-down-and-center)
;(global-set-key "\[6~" 'scroll-up-and-center)


(define-key inferior-ess-mode-map "\OA" 'comint-previous-input)
(define-key inferior-ess-mode-map "\OB" 'comint-next-input)
(define-key inferior-ess-mode-map "\[1;5A" 'previous-line)
(define-key inferior-ess-mode-map "\[1;5B" 'next-line)

(define-key inferior-ess-mode-map "\OH" 'comint-bol)

;(setq ess-eval-visibly-p nil)


;; scroll one line at a time (less "jumpy" than defaults)

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
;(setq scroll-step 1) ;; keyboard scroll one line at a time
;(setq scroll-conservatively 10000)


;; scroll with mouse wheel

(xterm-mouse-mode)
(defun scroll-up-5-lines ()
  "Scroll up 5 lines"
  (interactive)
  (scroll-up 5))

(defun scroll-down-5-lines ()
  "Scroll down 5 lines"
  (interactive)
  (scroll-down 5))

(global-set-key (kbd "<mouse-4>") 'scroll-down-5-lines) ;
(global-set-key (kbd "<mouse-5>") 'scroll-up-5-lines) ;
(global-set-key (kbd "<mouse-1>") 'mouse-set-point);
(require 'mouse)
(xterm-mouse-mode t)
(defun track-mouse (e)) 
(setq mouse-sel-mode t)


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



