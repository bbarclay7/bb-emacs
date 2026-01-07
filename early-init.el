;;; early-init.el --- Early initialization for Emacs startup optimization -*- lexical-binding: t -*-

;;; Commentary:
;; This file is loaded before package.el and the GUI is initialized.
;; It's used to optimize startup performance by tuning garbage collection
;; and disabling unnecessary features during initialization.

;;; Code:

;; Increase garbage collection threshold during startup
;; This prevents GC from running frequently during initialization
(setq gc-cons-threshold most-positive-fixnum  ; 2^61 bytes (~2GB)
      gc-cons-percentage 0.6)

;; Disable package.el initialization here - we'll do it manually in init
(setq package-enable-at-startup nil)

;; Prevent unwanted runtime compilation for gccemacs users
(setq native-comp-deferred-compilation-deny-list nil)

;; Suppress compiler warnings in echo area during native compilation
(when (and (fboundp 'native-comp-available-p)
           (native-comp-available-p))
  (setq native-comp-async-report-warnings-errors nil
        native-comp-deferred-compilation t))

;; Restore garbage collection settings after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 16777216  ; 16MB
                  gc-cons-percentage 0.1)
            ;; GC automatically after 15 seconds of idle time
            (run-with-idle-timer 15 t #'garbage-collect))
          100)

;; Measure and report startup time
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done))
          101)

(provide 'early-init)
;;; early-init.el ends here
