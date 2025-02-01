;; Vehicle Registry Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u100))
(define-constant err-already-registered (err u101))
(define-constant err-not-found (err u102))

;; Data structures
(define-map vehicles
  { vin: (string-ascii 17) }
  {
    owner: principal,
    make: (string-ascii 50),
    model: (string-ascii 50),
    year: uint,
    registered: uint
  }
)

;; Public functions
(define-public (register-vehicle 
  (vin (string-ascii 17))
  (make (string-ascii 50))
  (model (string-ascii 50))
  (year uint))
  (let ((existing-vehicle (get-vehicle-details vin)))
    (asserts! (is-none existing-vehicle) err-already-registered)
    (ok (map-set vehicles
      { vin: vin }
      {
        owner: tx-sender,
        make: make,
        model: model,
        year: year,
        registered: block-height
      }
    ))
  )
)

;; Read only functions
(define-read-only (get-vehicle-details (vin (string-ascii 17)))
  (map-get? vehicles { vin: vin })
)

(define-read-only (get-vehicle-owner (vin (string-ascii 17)))
  (let ((vehicle (get-vehicle-details vin)))
    (ok (get owner (unwrap! vehicle err-not-found)))
  )
)
