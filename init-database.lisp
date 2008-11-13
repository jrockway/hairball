(in-package :cl-user)
(asdf:operate 'asdf:load-op :hairball)

(in-package :hairball)

(defun init-database ()
  (ensure-directories-exist +database-directory+)
  (ensure-directories-exist +upload-directory+)
  (connect-to-database))


(init-database)
(format t "Successfully created the database... ~%")



(in-package :cl-user)
(quit)
