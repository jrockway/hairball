(in-package :hairball)

(defun init-test-database nil
  (let ((+database-directory+ #P"/tmp/db-test/"))
    (format t "database dir is ~A ~%" +database-directory+)
    (cl-fad:delete-directory-and-files +database-directory+ :if-does-not-exist :ignore)
    (ensure-directories-exist +database-directory+ :verbose t)
    (connect-to-database)))

(defun runtests (&optional &rest args)
  (init-test-database)
  (apply #'run! args))

(def-suite data-model :description "basic data model functionality tests")
(in-suite data-model)

(test user-basics
  "maipulate user objects"
  (signals (error) (get-user "foo"))
  (let (user)
    (finishes
      (setf user (make-instance 'user :username "foo" :password "test")))
    (is (eq (class-name (class-of user)) 'user) "created a user ok")
    (is (eq (get-user "foo") user) "get-user returns our user")
    (is (equal (password user) "test") "got password")
    (is (endp (pset-list (emails user))) "no emails yet")
    (finishes (add-email user "foo@example.com") "add an email")
    (is (equal (car (pset-list (emails user))) "foo@example.com") "lookup email")))

(test upload-basics
  "upload files"
  (let (user upload)
    (finishes
      (setf user (make-instance 'user :username "upload-test")))
    (finishes
      (setf upload (start-upload user #P"/tmp/foo" )) "created upload ok")
    (is (eq (class-name (class-of upload)) 'partial-upload) "upload is partial")
    (is (eq (car (pset-list (uploads user))) upload) "user has upload")
    (finishes (finish-upload upload) "finish-upload lives")
    (is (eq (class-name (class-of upload)) 'upload) "upload class changed"))
  (is (eq
       (class-name (class-of
                    (car (pset-list (uploads (get-user "upload-test"))))))
       'upload)
      "class change stored to database ok"))
