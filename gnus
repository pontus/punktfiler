(require 'pgg)




(setq gnus-nttp-server nil)

(add-to-list 'gnus-secondary-select-methods '(nnmaildir "Privat"
							(directory "~/.mingmail")
							(archivefolder "nnmaildir+Privat:[Gmail]/Alla mail")))



(add-to-list 'gnus-secondary-select-methods '(nnmaildir "Jobb"
							(directory "~/.minjobb")
							(archivefolder
							 (concat "nnmaildir+Jobb:INBOX.Arkiv."
								 (format-time-string "%Y" date)))))



(setq gnus-use-bbdb t)

(setq gnus-default-charset 'utf-8)

(setq message-send-mail-function 'message-smtpmail-send-it)
(setq smtpmail-smtp-server "smtp.uu.se")
(setq mm-inline-large-images t)


(setq message-from-style 'angles)

(bbdb-initialize 'gnus 'message)
(bbdb-insinuate-message)
(add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)

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
(setq gnus-newsgroup-variables '(pgg-default-user-id))



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
