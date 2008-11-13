(in-package #:hairball)

(defvar +upload-directory+ #P"/home/jon/tmp/hairball-uploads/")
(defvar +database-directory+ #P"/home/jon/tmp/hairball-db/")

(defun connect-to-database ()
  (open-store (list :BDB +database-directory+)))
