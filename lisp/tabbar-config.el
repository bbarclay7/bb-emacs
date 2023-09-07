(setq tabbar-use-images nil)
(setq tabbar-cycle-scope 'tabs)
(setq tabbar-buffer-groups-function 'bb-tabbar-buffer-groups)

(defun bb-tabbar-buffer-groups ()
  (interactive)
  ;; disable this - bb
  ;; ;; put all tabs together
  ;; (setq tabbar-buffer-groups-function
  ;;       (lambda ()
  ;;         (list "All"))) ;; code by Peter Barabas
;
  ;(lambda ()
    (let ((dir (expand-file-name default-directory)))
      (list
       (cond ((member (buffer-name) '("*Completions*"
                                      "*scratch*"
                                      "*Warnings*"
                                      "*Messages*"
                                      "*Buffer List*"
                                      "*Ediff Registry*"))
              "#misc")

             ((string-match-p "*Flycheck error messages*" (buffer-name))
	      "#flycheck")
	     
             ((or
               (string-match "/bb-emacs/" dir)
               (string-match "\\.emacs" (buffer-name) ))
               "#site-emacs")
             
             ((string-match (getenv "HOME") dir)
              "$HOME")

            

            ((string-match-p "isoenv-core" dir)
             "#isoenv-core")
       
            
            (t "##"))  ;; end first ent in tabbargroup list

       ;; ;; Return `mode-name' if not blank, `major-mode' otherwise.
       ;; (if (and (stringp mode-name)
       ;;          ;; Take care of preserving the match-data because this
       ;;          ;; function is called when updating the header line.
       ;;          (save-match-data (string-match "[^ ]" mode-name)))
       ;;     mode-name
       ;;   (symbol-name major-mode))

       
       )))

