;; Vehicle Transfer Contract

;; Constants
(define-constant err-unauthorized (err u200))
(define-constant err-invalid-price (err u201))

;; Data structures
(define-map transfer-requests
  { vin: (string-ascii 17) }
  {
    seller: principal,
    buyer: principal,
    price: uint,
    status: (string-ascii 20)
  }
)

;; Public functions
(define-public (initiate-transfer 
  (vin (string-ascii 17))
  (buyer principal)
  (price uint))
  (let ((vehicle-owner (contract-call? .vehicle-registry get-vehicle-owner vin)))
    (asserts! (is-eq tx-sender (unwrap! vehicle-owner err-unauthorized)) err-unauthorized)
    (ok (map-set transfer-requests
      { vin: vin }
      {
        seller: tx-sender,
        buyer: buyer,
        price: price,
        status: "pending"
      }
    ))
  )
)

(define-public (accept-transfer (vin (string-ascii 17)))
  (let (
    (transfer (unwrap! (map-get? transfer-requests { vin: vin }) err-unauthorized))
    (price (get price transfer))
  )
    (asserts! (is-eq tx-sender (get buyer transfer)) err-unauthorized)
    ;; Transfer ownership and handle payment logic here
    (ok true)
  )
)
