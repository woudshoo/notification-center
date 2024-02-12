(uiop:define-package :notification-center/api
    (:use #:cl)
  (:export
   #:notification-center
   #:full-notify
   #:full-register
   #:full-unregister
   #:receivers))


(in-package :notification-center/api)

(defclass notification-center ()
  ((receivers :initform (list))))

(defparameter *default-center* (make-instance 'notification-center))

(defgeneric full-notify (what who data center)
  (:documentation "Tell the CENTER to notify all interested paty
that WHO send the message WHAT with extra data DATA.

The CENTER will determine who to sent the message to.")
  (:method (what who data (center (eql nil)))
    (full-notify what who data *default-center*)))

(defgeneric full-register (receiver what who center)
  (:documentation "Register RECEIVER with CENTER to receive
messages matching WHAT and WHO.

- RECEIVER is a function taking 3 arguments: what who data.

- WHAT is a filter on the WHAT argument to full-notify.
  it can be
   - nil match everything
   - an atom matching with eql
  Need experimenting if we also want a predicate function

- WHO is a filter on the WHO argument:
  - nil, matches everything
  - an atom, matches with eql
  Need experimenting if we also want a predicate function

- CENTER, the center to register to
  - an instance of the XXX class
  - nil to use the default center")
  (:method (receiver what who (center (eql nil)))
    (full-register receiver what who *default-center*)))


(defgeneric full-unregister (receiver what who center)
  (:documentation "Removes the receiver from CENTER")
  (:method (receiver what who (center (eql nil)))
    (full-unregister receiver what who *default-center*)))
