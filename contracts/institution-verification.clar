;; Institution Verification Contract
;; Validates and stores information about financial entities

(define-data-var admin principal tx-sender)

;; Map to store verified institutions
(define-map verified-institutions
  principal
  {
    name: (string-utf8 100),
    license-id: (string-utf8 50),
    verified: bool,
    verification-date: uint
  }
)

;; Register a new institution (only admin can do this)
(define-public (register-institution (institution principal) (name (string-utf8 100)) (license-id (string-utf8 50)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u1))
    (ok (map-set verified-institutions
      institution
      {
        name: name,
        license-id: license-id,
        verified: true,
        verification-date: block-height
      }
    ))
  )
)

;; Check if an institution is verified
(define-read-only (is-verified (institution principal))
  (default-to false (get verified bool (map-get? verified-institutions institution)))
)

;; Get institution details
(define-read-only (get-institution-details (institution principal))
  (map-get? verified-institutions institution)
)

;; Transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u2))
    (ok (var-set admin new-admin))
  )
)
