(asdf:defsystem "movie-review-sentiment"
  :depends-on ("alexandria"
               "iterate"
               "py4cl2" ; not in quicklisp
               "str"
               "hash-set"
               "langutils"
               "reader"
               "uniform-utilities")
  :components ((:file "package")
               (:file "movie-review-sentiment")))
