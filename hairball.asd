;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-

(defpackage #:hairball-asd
  (:use :cl :asdf))

(in-package #:hairball-asd)

(defsystem hairball
  :name "hairball"
  :depends-on (elephant cl-who parenscript hunchentoot fiveam)
  :components ((:file "package")
               (:file "config" :depends-on ("package"))
               (:file "model" :depends-on ("config"))
               (:file "templates" :depends-on ("model"))
               (:file "action-manager" :depends-on ("package"))
               (:file "actions" :depends-on ("action-manager" "model" "templates"))
               (:file "app" :depends-on ("actions"))
               (:file "test" :depends-on ("app"))))
