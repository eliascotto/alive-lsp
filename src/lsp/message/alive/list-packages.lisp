(defpackage :alive/lsp/message/alive/list-packages
    (:use :cl)
    (:export :create-params
             :create-request
             :create-response
             :from-wire
             :get-path
             :request)
    (:local-nicknames (:message :alive/lsp/message/abstract)
                      (:types :alive/types)))

(in-package :alive/lsp/message/alive/list-packages)


(defclass request (message:request)
    ((message::method :initform "$/alive/listPackages")))


(defmethod print-object ((obj request) out)
    (format out "{id: ~A; method: ~A; params: ~A}"
            (message:id obj)
            (message:method-name obj)
            (message:params obj)))


(defmethod types:deep-equal-p ((a request) b)
    (and (equal (type-of a) (type-of b))
         (equalp (message:id a) (message:id b))
         (types:deep-equal-p (message:params a) (message:params b))))


(defclass response (message:result-response)
    ())


(defmethod print-object ((obj response) out)
    (format out "{id: ~A; result: ~A}"
            (message:id obj)
            (message:result obj)))


(defclass response-body ()
    ((packages :accessor packages
              :initform nil
              :initarg :packages)))


(defmethod print-object ((obj response-body) out)
    (format out "{packages: ~A}" (packages obj)))


(defun create-response (id packages)
    (make-instance 'response
                   :id id
                   :result (make-instance 'response-body :packages packages)))


(defun create-request (&key jsonrpc id params)
    (make-instance 'request
                   :jsonrpc jsonrpc
                   :id id
                   :params params))


(defun from-wire (&key jsonrpc id params)
    (declare (ignore params))

    (create-request :jsonrpc jsonrpc
                    :id id))
