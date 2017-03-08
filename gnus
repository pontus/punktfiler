(require 'epg)



(setq gnus-group-default-list-level 1)

(setq gnus-nttp-server nil)
(setq gnus-select-method '(nndoc "gnus-help"))
(setq gnus-show-thread nil)

(add-to-list 'gnus-secondary-select-methods '(nnmaildir "Privat"
							(directory "~/.mbsync/Privat")
							(archivefolder "nnmaildir+Privat:[Gmail]/Alla mail")))




(add-to-list 'gnus-secondary-select-methods '(nnmaildir "Jobb"
							(directory "~/.mbsync/Jobb")
							(archivefolder
							 (concat "nnmaildir+Jobb:INBOX.Arkiv."
								 (format-time-string "%Y" date)))))



(defun run-gnus-update () 
  (interactive)
  (if (buffer-live-p (get-buffer gnus-group-buffer))
      (let ((cit (current-idle-time)))
	(if cit
	    (if (> (car (cdr cit)) 60)
		(save-excursion
		  (message "Getting new mail.")
		  (set-buffer gnus-group-buffer)
		  (gnus-group-get-new-news)))))))


;(run-with-timer 60 60 'run-gnus-update)

(setq gnus-use-bbdb t)
(setq gnus-use-cache nil)

(setq gnus-default-charset 'utf-8)

(setq message-send-mail-function 'message-smtpmail-send-it)
(setq smtpmail-smtp-server "smtp.uu.se")
(setq mm-inline-large-images t)


(setq message-from-style 'angles)

(bbdb-initialize 'gnus 'message)
(bbdb-insinuate-message)
(add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)

(add-hook 'gnus-group-mode-hook (lambda nil (define-key
				     gnus-group-mode-map "Z"
				     'gnus-group-get-new-news-this-group)))

(setq bbdb-complete-name-full-completion t)
(setq bbdb-completion-type 'primary-or-name)
(setq bbdb-complete-name-allow-cycling t)

;(add-hook 'message-setup-hook 'nil)

(defun enz-eudc-expand-inline()
  (interactive)
  (move-end-of-line 1)
  (insert "*")
  (unless (condition-case nil
              (eudc-expand-inline)
            (error nil))
    (backward-delete-char-untabify 1))
  )

;; Adds some hooks

(eval-after-load "message"
  '(define-key message-mode-map (kbd "TAB") 'enz-eudc-expand-inline))
(eval-after-load "sendmail"
  '(define-key mail-mode-map (kbd "TAB") 'enz-eudc-expand-inline))
(eval-after-load "post"
  '(define-key post-mode-map (kbd "TAB") 'enz-eudc-expand-inline))

(setq gnus-ignored-newsgroups "intedå")



(setq archivefolder nil)
;; Automatically sign when sending mails
(add-hook 'message-setup-hook 'mml-secure-message-sign-pgpmime)
;(setq gnus-newsgroup-variables '(pgg-default-user-id))



(setq nnmail-expiry-target
      (lambda (group)
	(let ((sm nil))

	  (save-excursion
	    (set-buffer gnus-summary-buffer)
	    (setq sm gnus-current-select-method))

	  
	  (let ((af (assoc 'archivefolder (cdr (cdr sm))))
		(date (date-to-time (message-fetch-field "date"))))

	    
	    (if af
		(progn 
		  (message "hej")
		  (eval (car (cdr af)))))))))


(setq nnmail-expiry-wait 'immediate)

(setq gnus-large-newsgroup 150000)

(defface gnus-group-mail-3 '((t . (":foreground" "#404020"))) "Gnus face")
(defface gnus-cite-1 '((t . (":foreground" "#202090"))) "Quoted text")
(defface message-header-cc '((t . (":foreground" "#202090"))) "CC line")
(defface message-header-to '((t . (":foreground" "#202090"))) "To line")
;(defface gnus-cite-1 '((t . (":foreground" "#202090"))) "Gnus face")
;(defface gnus-cite-1 '((t . (":foreground" "#202090"))) "Gnus face")

(add-hook 'gnus-group-prepare-hook (lambda ()
  (set-face-foreground 'gnus-group-mail-3 "#404020")
  (set-face-foreground 'message-header-to "#202090")
  (set-face-foreground 'message-header-cc "#202090")
  (set-face-foreground 'gnus-header-from "#202030")
  (set-face-foreground 'gnus-cite-1 "#202090")))


(setq smime-keys '(("Pontus.Freyhult@it.uu.se" . (  (concat (getenv "HOME") "/Dropbox/Identiteter/PontusFreyhult.pem")))))
