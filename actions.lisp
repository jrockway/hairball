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
  "Bind each element of FIELDS to the CDR of the corresponding element in ALIST, then run BODY with those bindings.

Given:
   (keyword-alist-bind (a b (c 42)) '((:a . 1)(:b . 2)) (list a b c))

The return value is (1 2 42)."
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
  (:tr
   (:td (:label :for name (esc label)))
   (:td (:input :type type :id name :name name))))

(define-custom-tag :form (name action (method "post") fields)
  (call-next-method))

(defun show-login ()
  (standard-page
      (:title "Log in")
    (:h1 "Log in")
    (:p "Please enter your username and password.")
    (:form :name "login" :action (uri-for-action #'login-page)
      (:field :name "username" :label "Username: "))
      (:field :name "password" :label "Password: " :type "password")
      (:input :type "submit" :name "log_in" :value "Log in")))

(clear-action-table)
(add-action "/" #'main-page)
(add-action "/login" #'login-page)
