(in-package #:hairball)

(defvar +upload-directory+ #P"/home/jon/tmp/hairball-uploads/")
(defvar +database-directory+ #P"/home/jon/tmp/hairball-db/")

(defun connect-to-database ()
  (ensure-directories-exist +database-directory+ :verbose t)
  (ensure-directories-exist +upload-directory+ :verbose t)
  (open-store (list :BDB +database-directory+)))
