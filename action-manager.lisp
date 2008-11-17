(in-package #:hairball)

(defvar *path-dispatch-table* nil
  "Alist of path => handler pairs")

(defun add-action (prefix action)
  (when (not (eq (aref prefix 0) #\/))
    (setf prefix (format nil "/~A" prefix)))
  (push (cons prefix action) *path-dispatch-table*))

;;; ensure that longest path matches first
(defun compare-actions (a b)
  (> (length (car a)) (length (car b))))

(defun get-action-handlers-1 ()
  (sort *path-dispatch-table* #'compare-actions))

(defun get-action-handlers ()
  (loop for (path . action) in (get-action-handlers-1)
     do (create-prefix-dispatcher path action)))

(defun uri-for-action (action)
  (let ((path (rassoc action *path-dispatch-table*)))
    (if (not path)
        (error (format nil "~A is not in the path dispatch table!" action))
        (setf path (car path)))
    (format nil "http://~A~A"
            (if (boundp '*request*) (server-addr) "test")
            path)))