(in-package #:hairball)

(defvar *path-dispatch-table* nil
  "Alist of path => handler pairs")

(defun clear-action-table ()
  (setf *path-dispatch-table* nil))

(defun add-action (prefix action)
  (when (not (eq (aref prefix 0) #\/))
    (setf prefix (format nil "/~A" prefix)))
  (push (cons prefix action) *path-dispatch-table*))

(defun compare-actions (a b)
  ;; ensure that longest path matches first
  (> (length (car a)) (length (car b))))

(defun get-action-handlers-1 ()
  (sort *path-dispatch-table* #'compare-actions))

(defun get-action-handlers ()
  (loop for (path . action) in (get-action-handlers-1)
     collect (create-prefix-dispatcher path action)))

(defun uri-for-action (action)
  (let ((path (rassoc action *path-dispatch-table*)))
    (if (not path)
        (error (format nil "~A is not in the path dispatch table!" action))
        (setf path (car path)))
    (if (not (boundp '*request*))
        (format nil "http://test~A" path) ; for tests
      (let ((scheme (if (ssl-p) "https" "http")))
        (format nil "~A://~A~A" scheme (host) path)))))
