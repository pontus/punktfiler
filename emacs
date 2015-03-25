;  -*- mode: LISP; coding: utf-8; -*-



(if (and (boundp 'running-xemacs)
	 running-xemacs)
    (progn
      (setq load-home-init-file t)
      (require 'un-define)
  ))

;(if (fboundp 'server-start)
;    (server-start))

(setq load-path
      (cons (concat (getenv "HOME")
		    "/Utveckling/emacs")
	    load-path))



(setq mm-universal-file-coding-system 'utf-8)

(if (fboundp 'set-specifier)
    (set-specifier top-toolbar-visible-p nil))

(if (fboundp 'set-coding-priority-list)
    (set-coding-priority-list '(utf-8 iso-8-1)))

(if (fboundp 'set-coding-category-system)
    (set-coding-category-system 'utf-8 'utf-8))

(setq default-file-name-coding-system 'utf-8)
(setq file-name-coding-system 'utf-8)

(if (not window-system) 
    (progn
      (set-terminal-coding-system 'utf-8)
      (set-keyboard-coding-system 'utf-8)))


(condition-case foo
    (load-library (concat (getenv "HOME") 
			  "/Utveckling/lyskom-elisp-client/src/lyskom.elc")) 
  (file-error (message "Not loading local lyskom.elc - not found")))

(require 'calendar)
;(load-library "/home/pont/progs/emacs/sv-kalender.el")


;; Dagarnas namn
(setq calendar-day-name-array
      ["Söndag" "Måndag" "Tisdag" "Onsdag" "Torsdag" "Fredag" "Lördag"])

;; Månadernas namn
(setq calendar-month-name-array
      ["Januari" "Februari" "Mars" "April" "Maj" "Juni"
       "Juli" "Augusti" "September" "Oktober" "November" "December"])

(add-hook 'initial-calendar-window-hook (lambda ()
					 (if (not (member 
						   '(day " *" monthname " *" year "[^0-9]") diary-date-forms))
					     (setq diary-date-forms
						   (append (list '(day " *" monthname " *" year "[^0-9]"))
							   diary-date-forms)))))

(setq tmp-cim (current-input-mode))
(set-input-mode (car tmp-cim) (nth 1 tmp-cim) 'not-nil-or-t (nth 3 tmp-cim))


(setq display-time-show-icons-maybe nil)

(autoload 'flyspell-mode-on "flyspell" "Temporary docstring" t)
(autoload 'wwtime "wwtime" "Docstring not available until loaded" t)



;(require 'mailcrypt) ; Just a bunch of autoloads anyway

; Fix diary/calendar

(setq european-calendar-style t)
(setq calendar-latitude [63 49 north])
(setq calendar-longitude [20 19 east])
(setq calendar-week-start-day 1)
(setq calendar-location-name "Umeå")

(setq message-log-max 8192)






(add-hook 'kom-login-hook 'kom-keep-alive)
(setq kom-unread-mode-line-type t)
(setq lyskom-language 'sv)
(setq kom-default-language 'sv)
(setq kom-preferred-charsets '(utf-8))


; Fix up python

(unless (assoc "\\.py\\'" auto-mode-alist)
  (setq auto-mode-alist
	(cons '("\\.py$" . python-mode) auto-mode-alist))

  (setq interpreter-mode-alist
	(cons '("python" . python-mode)
	      interpreter-mode-alist))


  (autoload 'python-mode "python-mode" "Python editing mode." t))

; Fix display

(setq display-time-24hr-format t)

(display-time)
(setq require-final-newline t)
; (standard-display-european t)

(line-number-mode 1)
(column-number-mode 1)


; IRC


;(load "~/.zenirc-personal.el")

(setq process-coding-system-alist (cons '(".*zenirc.*" . utf-8) process-coding-system-alist))




; Setup w3

(setq w3-default-homepage "http://www.google.com")

(autoload 'w3m "w3m" "Load and start w3m" t)
(setq w3m-home-page "http://www.google.com")


(setq ldap-host-parameters-alist '(("ldap.user.uu.se" 
				    base "cn=People,dc=uu,dc=se"
				    auth simple)))

(setq ldap-default-host "ldap.user.uu.se")
(setq ldap-default-base "cn=People,dc=uu,dc=se")


(eudc-set-server "ldap.user.uu.se" 'ldap t)
(setq eudc-server-hotlist '(("ldap.user.uu.se" . ldap)))
(setq eudc-inline-expansion-servers 'hotlist)


(setq eudc-default-return-attributes nil
      eudc-strict-return-matches nil)

(setq ldap-ldapsearch-args (quote ("-tt" "-LLL" "-x")))
(setq eudc-inline-query-format '(
				 (firstname)
				 (firstname name)
				 (name)
                                 (email)
                                 ))


(setq ph-strict-return-matches nil)


(setq mc-default-scheme 'mc-scheme-gpg)


;;; LysKOM Settings
;;; =====================
;;; ============================
;;; End of LysKOM Settings






(defun switch-to-same-mode-buffer ()
  "Switch to a buffer that uses the same major mode as the current buffer.

This selects the bottom-most buffer of the same major mode as the
current buffer.  Do nothing if no other buffer with the same major
mode exists."
  (interactive)
  (let ((buffers (nreverse (buffer-list)))
        (wanted major-mode))                                                  
    (while (and buffers
                (not (eq wanted
                         (progn
                           (set-buffer (car buffers))
                           major-mode))))
      (setq buffers (cdr buffers)))
    (switch-to-buffer (if buffers (car buffers) (car (buffer-list))))))



(defun use-input-method () "Use default-input-method"
  (activate-input-method default-input-method)) 

(add-hook 'lyskom-edit-mode-hook 'use-input-method)
(add-hook 'lyskom-edit-mode-hook 'flyspell-mode)
(add-hook 'message-mode-hook 'use-input-method)
(add-hook 'zenirc-mode-hook 'use-input-method)



(defun 
  pont-swedish 
  ()
  "Set swedish local dictionary and kill ispell" 
  (interactive "")
  (setq ispell-dictionary "svenska")
  (setq ispell-local-dictionary "svenska")
  (setq ispell-local-dictionary-alist ispell-dictionary-alist)
  (ispell-kill-ispell t)
  )


(defun 
  pont-english
  ()
  "Set english local dictionary and kill ispell" 
  (interactive "")
  (setq ispell-dictionary "american")
  (setq ispell-local-dictionary "american")
  (setq ispell-local-dictionary-alist ispell-dictionary-alist)  
  (ispell-kill-ispell t)
  )

;(add-hook 'lyskom-edit-mode-hook
;          (function (lambda ()
;		      (pont-swedish)
;                      (flyspell-mode))))


(add-hook 'lyskom-edit-mode-hook
          (function (lambda ()
		      (defun  lyskom-mime-string-charset (data) 'utf-8))))

(add-hook 'lyskom-edit-mode-hook
          '(lambda ()
             (setq buffer-auto-save-file-name
		   (make-temp-name
		    (expand-file-name
		     (format "~/.lyskom-saves/%s" (buffer-name)))))))


(setq ispell-dictionary "svenska")

(defun
  pont-hallonsaft
  ()
  "Set the hallonsaft profile"
  (interactive "")
  (save-excursion
    (pont-unsetup-message)
    (pont-remove-signature)
    (set-message-profile 'hallonsaft)
    (pont-setup-message)
    (message-insert-signature)))

(defun add-filetype (regex mode)
  (setq auto-mode-alist (cons (cons regex mode) auto-mode-alist)))


(add-filetype "/README[^/]*$" 'text-mode)

;
(setq sentence-end "[.?!][]\"')]*\\($\\|\t\\| \\)[ \t\n]*")
(setq sentence-end-double-space nil)

;
;

(global-set-key [f4] 'next-error)
(global-set-key "\C-hg" 'find-function)

(global-set-key "\C-cx" (function (lambda () (interactive)
 (shell-command-on-region (mark) (point) "xclip -display unix:0 -quiet -in"))))


(defun quick-compile ()
  "Rerun the last compilation command"
  (interactive)
  (let ((buf (get-buffer "*compilation*")))
    (if buf
        (if (equal buf (current-buffer))
            nil
          (switch-to-buffer-other-window buf))
      (error "No previous compilation"))
    (compile compile-command)))

(global-set-key [f3] 'quick-compile)

(if (and (fboundp 'menu-bar-mode) 
	 (not window-system))
    (menu-bar-mode -1))


;(load-library "xml-rpc")

(setq user-full-name "Pontus Freyhult")
(setq user-mail-address "pontus@soua.net")


(load-library "uniquify")

(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
; Protect any buffer with a buffer name starting with an asterisk 
(setq uniquify-ignore-buffers-re "^\*.*")

(if  (fboundp 'partial-completion-mode)
    (partial-completion-mode))

(if (locate-library "completer")
    (load-library "completer"))

(setq completer-any-delimiter ?\ )

;; (load-library "iso-acc")

; (setq iso-languages 
;       (append iso-languages 
; 	      '(("swedish" (?\" 
; 			  (?A . ?\304 ) 
; 			  (?a . ?\344 )  
; 			  (?O . ?\326 ) 
; 			  (?o . ?\366 ) 
; 			  )
; 			 
; 			 (?/
; 			  (?A . ?\305 )
; 			  (?a . ?\345 )
; 			  )
; 			 ))
; 	      )
;       )
;   

;; (iso-accents-customize "swedish")

(setq TeX-file-extensions '("tex" "sty" "cls" "ltx" "texi" "texinfo" "latex"))


(add-hook 'c-mode-hook
  (function (lambda () (local-set-key "\C-cc" 'recompile)))
)

(setq auto-save-list-file-prefix nil)

(defun next-to-read 
  ()
  (interactive)
  
  (cond ((and 
	  (functionp 'erc-track-switch-buffer)
	  erc-modified-channels-alist)
	 (erc-track-switch-buffer 1))
	 ((functionp 'kom-next-unread-kom)
	  (kom-next-unread-kom))))

(defvar next-to-write-re "\\*mail*.*\\|\\*wide reply to.*\\|\\*reply to.*\\|\\.*-edit.*\\|\\*followup.*" 
  "Regexp used to find buffers we may want to go to.")
 
(defun write-current-buf ()
  (interactive)
  "Add this buffer to the ones"
  (setq next-to-write-re (concat next-to-write-re "\\|" (buffer-name))))


(defun next-to-write
  ()
  "Go to next buffer we want to write."
  (interactive)
  (let ((buflist (remove (current-buffer) (buffer-list))))
    (while buflist
      (if (string-match next-to-write-re (buffer-name (car buflist))) 
	  (progn
	    (bury-buffer)
	    (switch-to-buffer (car buflist) t)
	    (setq buflist nil))
	(setq buflist (cdr buflist))))))

(global-set-key "\C-cl" 'next-to-read)
(global-set-key "\C-cw" 'next-to-write)
 
(require 'quail)

(quail-define-package
 "swedish-prefix" "Latin-1" "SE>" t
 "Swedish character input method with prefix modifiers

 \"a -> ?� \"o -> ?� /a -> ?�" nil t nil nil nil nil nil nil nil nil t)

(quail-define-rules 
 ("\"A" "Ä")
 ("\"O" "Ö")
 ("\"a" "ä")
 ("\"o" "ö")
 ("/A" "Å")
 ("/a" "å")
)

(setq default-input-method "swedish-prefix")

;(lyskom "kom.lysator.liu.se" "Pontus Sköld")
;(lyskom "sno.pp.se" "Pontus Sköld")
;(lyskom "kom.stacken.kth.se" "Pontus Sköld")
;(lyskom "kom.csd.uu.se" "Pont IÅM")
;(lyskom "kom.csd.uu.se" "Pont Sköld igen")




(defun visa-tv-guiden (conf-no past)
  "Review the pastth last text by anyone to the conference referenced by
conf-no."
  (interactive "P")
  (let ((text-no nil))                  ; the last text written there
      (cache-del-conf-stat conf-no)
      (setq text-no (car (lyskom-get-texts-to conf-no (+ past 1))))
      (if text-no
	  (lyskom-view-text text-no)
	  ;;(tv-guiden-view-text text-no)
	(lyskom-insert 'confusion-what-to-view))))

(defun tv-guiden (past)
  "Review the last text by anyone to the conference tv-guiden.  With
prefix argument, review the pastth last text."
  (interactive "P")
  (cond ((string-equal (downcase lyskom-server-name)
		       "kom.lysator.liu.se")
	 (if (and past (> past 0))
	     (lyskom-insert (format "Visa en gammal TV-guide (%d)" past))
	   (progn (lyskom-insert "Visa TV-guiden")
		  (setf past 0)))
	 (lyskom-start-of-command 'tv-guiden)
	 (lyskom-tell-internat 'kom-tell-review)
	 (visa-tv-guiden 8703           ; conf. no for tv-guiden
			 past)
	 (lyskom-end-of-command))
	(t
	 (lyskom-start-of-command 'tv-guiden)
	 (lyskom-tell-internat 'kom-tell-review)
	 (lyskom-insert "Visa TV-guiden
Jag vet inte vilket m?�esnummer TV-guiden har i detta kom.
")
	 (lyskom-end-of-command))))

(defun tv+guiden (past)
  "Review the last text by anyone to the conference tv++.  With prefix
argument, review the pastth last text."
  (interactive "P")
  (cond ((string-equal (downcase lyskom-server-name)
		       "kom.lysator.liu.se")
	 (if (and past (> past 0))
	     (lyskom-insert (format "Visa en gammal lång TV-guide (%d)" past))
	   (progn (lyskom-insert "Visa långa TV-guiden")
		  (setf past 0)))
	 (lyskom-start-of-command 'tv+guiden)
	 (lyskom-tell-internat 'kom-tell-review)
	 (visa-tv-guiden 9709           ; conf. no for tv-guiden
			 past)
	 (lyskom-end-of-command))
	(t
	 (lyskom-start-of-command 'tv+guiden)
	 (lyskom-tell-internat 'kom-tell-review)
	 (lyskom-insert "Visa l?�ga TV-guiden
Jag vet inte vilket mötesnummer TV++ har i detta kom.
")
	 (lyskom-end-of-command))))

(add-hook
 'lyskom-mode-hook
 (function (lambda ()
	     (if (string-match "XEmacs" emacs-version) 
		 (progn
		   (define-key lyskom-sv-mode-map 'Å 'lyskom-sv-review-prefix) 
		   (define-key lyskom-sv-mode-map 'å 'lyskom-sv-review-prefix) 
		   (define-key lyskom-sv-mode-map 'Ä 'lyskom-sv-change-prefix) 
		   (define-key lyskom-sv-mode-map 'ä 'lyskom-sv-change-prefix))))))


(setq type-break-good-rest-interval 180)
(setq type-break-interval 2700)
(setq type-break-file-name nil)


(defvar open-all-ignore-res 
  '( "\.o$"  "\.orig$"  "\.rej$" "\.so$" "\.a$" )
  "List of res for open-all-in-buffer to ignore." 
  )

(defun open-all-in-buffer
  ()
  "Open any file mentioned in the current buffer, 
ignoring any file matching one of the regexps 
in open-all-ignore-res as well as files that are
not readable."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "\\([^ \t\n]+\\)[ \t\n]+" (point-max) t)
      (let ((filename (match-string 1)))
        (if (and
             (not (remove nil
                   (mapcar (lambda (s) (string-match s filename ))
                           open-all-ignore-res)))
             (file-readable-p filename))
            (save-excursion (find-file filename))
          )))))

(global-set-key "\C-ca" 'open-all-in-buffer)


(setq appt-message-warning-time 120)
(add-hook 'diary-hook 'appt-make-list)
(add-hook 'diary-display-hook 'fancy-diary-display)

(if (fboundp 'appt-initialize)
      (appt-initialize))


(setq ldap-default-host "ldap.uu.se")
(setq diary-file "~/.dagbok")

(if (locate-library "type-break")
    (load-library "type-break"))

(if (fboundp 'type-break-mode)
    (type-break-mode))

(defun start-koms () (interactive)
  (let ((mypass (read-string "Lösen: ")))

    (lyskom "kom.lysator.liu.se" "Pontus Freyhult" mypass)
    (lyskom "kom.stacken.kth.se" "Pontus Freyhult" mypass)
    (lyskom "myskom.kfib.org" "Pontus Freyhult" mypass)
    (lyskom "kom.ludd.luth.se" "Pontus Freyhult" mypass)
    (lyskom "kom.update.uu.se" "Pontus Freyhult" mypass)
    (lyskom "kom.update.uu.se" "Pont IÅM" mypass)))

(defun reload-koms () (interactive)
  (save-excursion
    (lyskom-traverse buf lyskom-sessions-with-unread
      (set-buffer buf)
      (kom-recover t))))

;(make-coding-system 'utf-8-emacs (coding-system-type 'utf-8)
;		    (coding-system-mnemonic 'utf-8)
;		    (coding-system-doc-string 'utf-8)
;		    (coding-system-flags 'utf-8))


(if (boundp 'ispell-dictionary-alist)
    (let* ((svenska (assoc "svenska" ispell-dictionary-alist)) 
	   (casechars (cadr svenska)) 
	   (not-casechars (cadr (cdr svenska))))
      (setq ispell-dictionary-alist 
	    (mapcar 
	     (lambda (lang) 
	       (append (list (car lang) casechars not-casechars) (cdr (cdr (cdr lang)))))
	     ispell-dictionary-alist))))


(setq browse-url-browser-function 'browse-url-generic)
(setq browse-url-generic-program "sensible-browser")




(defun my-this-url () 
  "Get the URL at point"
  (interactive)
  (let ((prop (text-properties-at (point))))
    (if prop
	(let ((pos (position 'w3m-cursor-anchor prop)))
	  (nth (+ 1 pos) prop)))))

(defun my-browse-url ()
  "Browse URL at widget."
  (interactive)
  (if	(my-this-url) 
      (browse-url (my-this-url))
    (error "No link found")))


(defun my-show-url ()
  "Show URL at widget."
  (interactive)
  (if  (my-this-url)
      (message (my-this-url))
    (error "No link found")))

;(defvar tramp-methods '() "")

;(let ((le (assoc "lshg-rcp" tramp-methods)))
;  (if le (setq tramp-methods (remove le tramp-methods))))


;(setq tramp-methods
;      (append tramp-methods
;	      '(("lshg"
;		 (tramp-connection-function tramp-open-connection-rsh)
;		 (tramp-rsh-program "lshg")
;		 (tramp-rcp-program "rcp")
;		 (tramp-remote-sh "/bin/sh")
;		 (tramp-rsh-args
;		  ("--no-cvs-workaround" "--no-detach"))
;		 (tramp-rcp-args nil)
;		 (tramp-rcp-keep-date-arg "-p")
;		 (tramp-su-program nil)
;		 (tramp-su-args nil)
;		 (tramp-encoding-command nil)
;		 (tramp-decoding-command nil)
;		 (tramp-encoding-function nil)
;		 (tramp-decoding-function nil)
;		 (tramp-telnet-program nil)
;		 (tramp-telnet-args nil)))))

;(setq tramp-default-method "lshg")

(setq gnuserv-program "gnuserv")
(if (fboundp 'gnuserv-start)
    (gnuserv-start))

;(if (fboundp 'server-start)
;    (server-start))

(if (fboundp 'auto-compression-mode)
    (auto-compression-mode 1))

(defun lyskom-mime-string-charset (data) 'utf-8) 

(require 'tramp)

; (setq tramp-default-method "lshg")



; För att inte få Emacs smiley-region från smiley-emc
(load-library "smiley.elc")


;; (setq w3m-coding-system 'utf-8)
(setq w3m-display-inline-images t)
;; (setq w3m-use-mule-ucs t)
;; (setq w3m-default-coding-system 'utf-8)
;; (setq w3m-terminal-coding-system 'utf-8)
;; (setq w3m-file-coding-system 'utf-8)
;; (setq w3m-input-coding-system 'utf-8)
;; (setq w3m-output-coding-system 'utf-8)
(setq mm-inline-text-html-with-w3m-keymap nil)

;(setq x-select-enable-clipboard nil)



(setq remember-use-bbdb t)
(setq remember-handler-functions 'append-to-planner)



(if (boundp 'tool-bar-mode)
    (tool-bar-mode nil))


; (if (fboundp 'clipboard-kill-ring-save) 
;    (defalias 'kill-ring-save 'clipboard-kill-ring-save))

; (if (fboundp 'clipboard-kill-region) 
;    (defalias 'kill-region 'clipboard-kill-region))

(setq tramp-remote-process-environment '("LC_ALL=C" "TERM=dumb" "EMACS=t" "INSIDE_EMACS='24.3.1,tramp:2.2.6-24.3'" "MAIL=" "MAILCHECK=" "MAILPATH=" "PAGER=\"\"" "autocorrect=" "correct="))

(setq gnus-use-cache t)
(setq gnus-cache-directory "~/.cache/Mail")
(setq gnus-cache-enter-articles '(ticked dormant read unread))
(setq gnus-cache-remove-articles nil)
(setq gnus-cacheable-groups "^nnimap")

(setq send-mail-function 'smtpmail-send-it)
(setq smtpmail-smtp-server "smtp.uu.se")
(setq smtpmail-smtp-service 587)


(setq gnus-posting-styles '((".*mail.uu.se.*" (address "Pontus.Freyhult@it.uu.se"))
			    (".*Privat.*" (address "pontus@freyhult.net"))))

(setq gnus-summary-line-format "%U%R%z%I%(%[%d: %4L: %-23,23f%]%) %s
")

(setq gnus-agent nil)

(setq gnus-nov-is-evil t)
