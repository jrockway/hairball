(in-package #:hairball)

(defvar *hunchentoot-server* nil)

(defun start ()
  (connect-to-database)
  (setf *dispatch-table* (list #'default-dispatcher))
  (loop for h in (reverse (get-action-handlers)) do (push h *dispatch-table*))
  (setf *hunchentoot-server* (start-server :port 3000)))

(defun stop ()
  (stop-server *hunchentoot-server*))

(defun -restart ()
  (stop)
  (start))
