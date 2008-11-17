(in-package #:hairball)

(defun main-page ()
  (standard-page
      (:title "Hello, world!")
    (:h1 "Welcome!")
    (:p "Would you like to" (:a :href (uri-for-action #'login-page) "log in") "?")))

(defun login-page ()
  (show-login))

(defun to-keyword (symbol)
  (intern (format nil "~A" symbol) :keyword))

(defmacro keyword-alist-bind (fields alist &body body)
  (let ((alist-sym (gensym)))
    `(let ((,alist-sym ,alist))
       (let ,(loop for (k default)
                in (mapcar (lambda (f) (if (listp f) f (list f nil))) fields)
                collect
                  `(,k (or (ignore-errors (cdr (assoc
                                                ,(to-keyword k)
                                                ,alist-sym)))
                           ,default)))
         ,@body))))

(defmacro define-custom-tag (tag-name args &body body)
  `(defmethod convert-tag-to-string-list ((tag (eql ,tag-name)) attr-list body body-fn)
     (keyword-alist-bind (,@args) attr-list
       (list (with-html-output-to-string (s) ,@body)))))

(define-custom-tag :field (name label (type "text"))
  (:label :for name (esc label))
  (:input :type type :id name :name name)
  (:br))

(defun show-login ()
  (standard-page
      (:title "Log in")
    (:h1 "Log in")
    (:p "Please enter your username and password.")
    (:form :name "login" :action "" :method "post"
      (:field :name "username" :label "Username: "))
      (:field :name "password" :label "Password: " :type "password")
      (:input :type "submit" :name "log_in" :value "Log in")))

(add-action "/" #'main-page)
(add-action "/login" #'login-page)
