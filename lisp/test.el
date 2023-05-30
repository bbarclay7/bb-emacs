;; turn on vertical fido-mode
(setq fido-vertical-mode t)

;; set latitude and logitude for sunrise/sunset

;; sacramento
(setq calendar-latitude 38.5816)
(setq calendar-longitude -121.4944)

;; connellsville
;; (setq calendar-latitude 40.0222)
;; (setq calendar-longitude -79.5897)

;; load epa -- this package is part of emacs
(require 'epa-file)

;; hotkey to encrypt/decrypt selected region
(global-set-key (kbd "C-c e") 'epa-encrypt-region)
(global-set-key (kbd "C-c d") 'epa-decrypt-region)

;; hotkey to encrypt/decrypt file
(global-set-key (kbd "C-c E") 'epa-encrypt-file)
(global-set-key (kbd "C-c D") 'epa-decrypt-file)


