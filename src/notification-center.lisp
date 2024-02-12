(uiop:define-package :notification-center/notification-center
    (:use #:cl #:notification-center/api))


(in-package :notification-center/notification-center)


(defun match-p (what who r-what r-who)
  (flet ((match-single (w r)
	   (or (not r)
	       (eql w r))))
    (and (match-single what r-what)
	 (match-single who r-who))))

(defmethod full-notify (what who data (center notification-center))
  (with-slots (receivers) center
    (loop :for (r-what r-who r-receiver) :in receivers
	  :when (match-p what who r-what r-who)
	    :do (funcall r-receiver what who data))))


(defmethod full-register (receiver what who (center notification-center))
  (with-slots (receivers) center
    (push (list what who receiver) receivers)))

(defmethod full-unregister (receiver what who (center notification-center))
  (with-slots (receivers) center
    (setf receivers (remove (list what who receiver) receivers :test #'equalp))))

