(in-package :cl-user)
(asdf:operate 'asdf:load-op :hairball)
(format t "Starting the server on port 3000 ~%")
(hairball:start)

