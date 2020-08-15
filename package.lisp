(reader:enable-reader-syntax 'lambda 'get-val)
(defpackage :movie-review-sentiment
  (:use :cl :py4cl2 :alexandria :iterate :hash-set :langutils :uniform-utilities)
  (:shadow :set))

(in-package :movie-review-sentiment)

(defmacro defun-single-valued (name lambda-list &body body)
  "Creates a DEFUN with BODY surrounded by (nth-value 0 ...) form.
This can help to decrease \"declaim conflicts\"."
  `(defun ,name ,lambda-list
     (nth-value 0 (progn ,@body))))

(deftype set () 'hash-set)

(defun tokenize (string &optional (treat-as-pathname nil))
  (str:split " " (nth-value 2 (tokenize-string (if treat-as-pathname
                                                   (read-file-into-string string)
                                                   string)))))

(defpyfun "Tokenizer" "keras.preprocessing.text")
(defpyfun "pad_sequences" "keras.preprocessing.sequence")
(defpyfun "Sequential" "keras.models")
(defpymodule "keras.layers" nil :lisp-package "KL")
(defpymodule "keras.layers.convolutional" nil :lisp-package "KLC")
(defpymodule "keras.datasets.imdb" nil :lisp-package "IMDB")

(declaim (ftype (function (string set) string) clean-doc))
(defun-single-valued CLEAN-DOC (document vocab)
  "Cleans up DOCUMENT using VOCAB and turns it into TOKENS and then rejoins them using \" \"."
  (str:join " "
            (remove-if-not λ(hs-memberp vocab -)
                           (tokenize
                            (str:remove-punctuation document)))))

(declaim (ftype (function (string set &key (:train boolean)) list) process-docs))
(defun-single-valued PROCESS-DOCS (directory vocab &key (train nil train-provided-p))
  "Returns a list of CLEAN-DOCed documents in DIRECTORY."
  (assert train-provided-p)
  (iter (for file in (uiop:directory-files directory))
    (for filename = (file-namestring file))
    (unless (or (and train (str:starts-with-p "cv9" filename))
                (and (not train)
                     (not (str:starts-with-p "cv9" filename))))
      (collect (clean-doc (read-file-into-string file)
                          vocab)))))

(defun download-data ()
  ;; TODO
  )

