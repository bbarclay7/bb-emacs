;;; package --- Summary
;;; bblib.el

;;; Commentary:
;;This file is comprised of utility functions and constants
;;used to configure Emacs by Brandon Barclay.

;;; Code:


;;This method, when bound to C-x C-c, allows you to close an emacs frame the
;;same way, whether it's the sole window you have open, or whether it's
;;a "child" frame of a "parent" frame.  If you're like me, and use emacs in
;;a windowing environment, you probably have lots of frames open at any given
;;time.  Well, it's a pain to remember to do Ctrl-x 5 0 to dispose of a child
;;frame, and to remember to do C-x C-x to close the main frame (and if you're
;;not careful, doing so will take all the child frames away with it).  This
;;is my solution to that: an intelligent close-frame operation that works in
;;all cases (even in an emacs -nw session).

(defun intelligent-close ()
"Quit a frame the same way no matter what kind of frame you are on."
  (interactive)
  (if (eq (car (visible-frame-list)) (selected-frame))
      ;;for parent/master frame...
      (if (> (length (visible-frame-list)) 1)
          ;;close a parent with children present
          (delete-frame (selected-frame))
        ;;close a parent with no children present
        (save-buffers-kill-emacs))
    ;;close a child frame
    (delete-frame (selected-frame))))

;; Eshell itself can open a specific new buffer when invoked as (eshell
;; 'N) where N is a positive integer.  When invoked as (eshell 'Z) where Z
;;is not a positive integer, it will open the next sequential free shell
;;number.  If you would like to provide a function to perform this, you may
;; use something similar to the following:
(defun eshell-new()
  "Open a new instance of eshell."
    (interactive)
      (eshell 'N))


(defvar my-latest-killed-buffer)

(defun my-kill-buffer()
"Kill current buffer without confirmation.
To undo latest kill call 'my-unkill-buffer'"
  (interactive)
  (setq my-latest-killed-buffer (buffer-file-name) )
  (kill-buffer (buffer-name)))


(defun my-unkill-buffer()
"Undo the latest buffer kill."
  (interactive)
  (find-file my-latest-killed-buffer ))




;;a no-op function to bind to if you want to set a keystroke to null
(defun void ()
"This is a no-op."
  (interactive))

(defun split-window-fork ()
"Spawns a new frame so that a 2-way split window in one frame becomes 2 'top-level' frames."
  (interactive)
  (progn
    (let ((current_window (selected-window))
          (other_window (next-window (selected-window)))
          (current_buffer (window-buffer (selected-window)))
          (other_buffer (window-buffer (next-window (selected-window)))))
      (make-frame)
      (select-window other_window)
      (delete-other-windows))))


(defun byte-compile-el-file-lazy (el-file)
"This enables automatic compilation of EL-FILE."
  (let ((byte-compile-warnings '(unresolved))
	(cache-file (concat el-file ".elc"))
	)
    ;; in case compilation fails, don't leave the old .elc around:
    (when (or
	   (not (file-exists-p cache-file))
	   (file-newer-than-file-p))
      
      (when (file-exists-p cache-file)
        (delete-file (concat user-init-file ".elc")))
      
      (byte-compile-file el-file))
    
    (message "%s compiled" el-file)
    ))

(provide 'bblib)
;;; bblib.el ends here

