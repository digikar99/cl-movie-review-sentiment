
# Movie Review Sentiment Prediction

> This is an adoptation of https://machinelearningmastery.com/predict-sentiment-movie-reviews-using-deep-learning/ to Common Lisp.

# Prerequisites

Python: `numpy, keras`

Common Lisp:
- not in quicklisp yet: [py4cl2](#https://github.com/digikar99/py4cl2)
- in quicklisp: alexandria, iterate, str, hash-set, langutils, reader, uniform-utilities

# What's new here?

Nothing. The model lives in [movie-review-sentiment.lisp](./movie-review-sentiment.lisp). I played with it a bit to obtain a 88.5% accuracy; the above linked tutorial gets a ~87.2%. SOTA is well at 99% (see that link for the links)!

# How do I play with this?

Download this to somewhere quicklisp can find; consult `ql:*local-project-directories*`.

Then

```lisp
(ql:quickload "movie-review-sentiment")
(in-package "movie-review-sentiment")
```

and play around. Most of the juicy code lies in [movie-review-sentiment.lisp](./movie-review-sentiment.lisp). I am aware I haven't followed the naming conventions. I found the semantics a bit dubious. Anyways, enjoy!

Oh, right, the model that got us the very slight 1% improvement:

```
Model: "sequential_2"
_________________________________________________________________
Layer (type)                 Output Shape              Param #   
=================================================================
embedding_5 (Embedding)      (None, 500, 150)          3000000   
_________________________________________________________________
max_pooling1d_5 (MaxPooling1 (None, 30, 150)           0         
_________________________________________________________________
flatten_5 (Flatten)          (None, 4500)              0         
_________________________________________________________________
dense_5 (Dense)              (None, 1)                 4501      
=================================================================
Total params: 3,004,501
Trainable params: 3,004,501
Non-trainable params: 0
_________________________________________________________________

```

The crucial concern happens to be to prevent overfitting on the training data. It's incredibly easy to get a 100% accuracy on training.
