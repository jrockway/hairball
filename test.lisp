(in-package :cl-user)
(asdf:operate 'asdf:load-op :hairball)

(in-package :hairball)
(asdf:operate 'asdf:load-op :fiveam)
(asdf:operate 'asdf:load-op :cl-fad)


(defun init-test-database nil
  (let ((+database-directory+ #P"/tmp/db-test/"))
    (format t "database dir is ~A ~%" +database-directory+)
    (cl-fad:delete-directory-and-files +database-directory+ :if-does-not-exist :ignore)
    (ensure-directories-exist +database-directory+ :verbose t)
    (connect-to-database)))

(defun runtests nil
  (init-test-database)
  (5am:run!))

(5am:def-suite data-model :description "basic data model functionality tests")
(5am:in-suite data-model)

(5am:test user-basics
  "maipulate user objects"
  (5am:signals (error) (get-user "foo"))
  (let (user)
    (5am:finishes
      (setf user (make-instance 'user :username "foo" :password "test")))
    (5am:is (eq (class-name (class-of user)) 'user) "created a user ok")
    (5am:is (eq (get-user "foo") user) "get-user returns our user")
    (5am:is (equal (password user) "test") "got password")
    (5am:is (endp (pset-list (emails user))) "no emails yet")
    (5am:finishes (add-email user "foo@example.com") "add an email")
    (5am:is (equal (car (pset-list (emails user))) "foo@example.com") "lookup email")))

(5am:test upload-basics
  "upload files"
  (let (user upload)
    (5am:finishes
      (setf user (make-instance 'user :username "upload-test")))
    (5am:finishes
      (setf upload (start-upload user #P"/tmp/foo" )))
    (5am:is (class-name (class-of user)) 'partial-upload)
    (5am:is (eq (car (pset-list (uploads user))) upload) "user has upload")
    (5am:finishes (finish-upload upload))
    (5am:is (eq (class-name (class-of upload)) 'upload) "upload class changed"))
  (5am:is (eq
           (class-name
            (class-of
             (car
              (pset-list
               (uploads (get-user "upload-test"))))))
           'upload) "class change stored to database ok"))

(runtests)

(in-package :cl-user)
(quit)
