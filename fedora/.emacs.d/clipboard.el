;; send killed text to remote host
;; remote host execute 'while true ; do nc -l 33333 >/dev/clipboard; done'
(defun send-text-to-host (text)
  (let ((proc (open-network-stream "send-text-to-host" nil "REMOTE_IPADDRESS" 33333)))
    (process-send-string proc text)
      (delete-process proc)))
(setq interprogram-cut-function 'send-text-to-host)
