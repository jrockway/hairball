(in-package #:hairball)

(defpclass user ()
  ((realname :initarg :realname :accessor realname :type string)
   (email :accessor emails :initform (make-pset))
   (username :initarg :username :accessor username :type string :index t)
   (password :initarg :password :accessor password :type string)
   (uploads :accessor uploads :initform (make-pset)))
  (:index t))

(defpclass partial-upload ()
  ((creator :initarg :creator :accessor creator :type user)
   (location :initarg location :accessor location :type pathname)
   (upload-started :initarg :upload-started :accessor upload-started :type integer
                   :initform (get-universal-time)))
  (:index t))

(defpclass upload (partial-upload)
  ((upload-completed :initarg :upload-completed :accessor upload-completed :type integer
                     :initform (get-universal-time))
   (downloads :accessor downloads :initform (make-pset)))
  (:index t))

(defpclass download ()
  ((downloader :initarg :downloader :accessor downloader :type user)
   (download-time :initarg :download-time :accessor download-time :type integer
                  :initform (gqet-universal-time))
   (of :initarg :of :accessor download-of :type upload))
  (:index t))

(defun get-user (username)
  (let ((users (get-instances-by-value 'user 'username username)))
    (cond ((> (length users) 1)
           (error (format t "Too many users named ~A!" username)))
          ((= (length users) 0)
           (error (format t "No users named ~A!" username))))
    (car users)))

(defgeneric add-email (user email))
(defmethod add-email ((user user) (email string))
  (insert-item email (emails user)))

(defgeneric start-upload (user location))
(defmethod start-upload ((user user) (location pathname))
  (format t "~A is uploading a file ~%" (username user))
  (with-transaction ()
    (let ((upload (make-instance 'partial-upload
                                 :creator user :location location)))
      (insert-item upload (uploads user))
      upload)))

(defgeneric move-to-final-location (upload))
(defmethod move-to-final-location ((upload partial-upload)) nil) ; TODO: do this

(defgeneric finish-upload (upload))
(defmethod finish-upload ((upload partial-upload))
  (change-class upload 'upload)
  (move-to-final-location upload)
  upload)
