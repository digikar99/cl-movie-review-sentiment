;; (ql:quickload '(:py4cl2 :alexandria :str :reader :iterate :hash-set))

(in-package :movie-review-sentiment)

;; TASK UTILS ==================================================================

;; (defdpar ((+xtrain+ +ytrain+) (+xtest+ +ytest+)) )

(defconstant +max-length+ 500)
(defconstant +num-words+ 20000)

(write-line "Loading data...")
(destructuring-bind ((xtrain ytrain) (xtest ytest))
    (imdb:load-data :num-words +num-words+ :skip-top 10)
  (defparameter +xtrain+
    (pad-sequences :maxlen +max-length+
                   :padding "post"
                   :sequences xtrain))
  (defparameter +ytrain+ ytrain)
  (defparameter +xtest+
    (pad-sequences :maxlen +max-length+
                   :padding "post"
                   :sequences xtest))
  (defparameter +ytest+ ytest))


(write-line "Defining model...")
(defparameter +model+
  (let ((model (sequential)))
    (flet ((add (&rest args)
             (apply #'pymethod model 'add args)))
      (add (kl:embedding/class :input-dim +num-words+
                               :output-dim 150
                               :input-length +max-length+))
      ;; (add (klc:conv-1d/class :filters 32 :kernel-size 8
      ;;                         :activation "relu"))
      (add (kl:max-pooling-1d/class :pool-size 32 :strides 16))
      (add (kl:flatten/class))
      ;; (add (kl:dense/class :units 10 :activation "relu"))
      (add (kl:dense/class :units 1 :activation "sigmoid")))
    (pymethod model 'compile :loss "binary_crossentropy"
                             :optimizer "adam"
                             :metrics #("accuracy"))
    model))

(defun train-and-test (epochs)
  (iter (for i below epochs)
    (format t "Training ~D/~D...~%" (1+ i) epochs)
    (with-python-output (pymethod +model+ 'fit +xtrain+ +ytrain+ :epochs 1 :verbose 2
                                                                 :batch-size 1024))
    (format t "Test Accuracy: ~D~%"
            (aref (pymethod +model+ 'evaluate +xtest+ +ytest+ :verbose 2)
                  1))))

