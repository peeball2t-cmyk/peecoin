;; Peebit (PEEBIT) - SIP-010 fungible token implementation
;; Owner can mint; anyone can burn their own tokens; owner can burn from any account.


;; Errors
(define-constant err-unauthorized (err u100))
(define-constant err-insufficient-balance (err u101))
(define-constant err-amount-zero (err u102))

;; Metadata
(define-constant TOKEN-NAME "Peebit")
(define-constant TOKEN-SYMBOL "PEEBIT")
(define-constant TOKEN-DECIMALS u6)

;; Storage
(define-data-var contract-owner principal tx-sender)
(define-data-var total-supply uint u0)
(define-map balances {address: principal} {balance: uint})

;; Helpers
(define-private (get-balance-internal (who principal))
  (default-to u0 (get balance (map-get? balances {address: who}))))

(define-private (credit (who principal) (amount uint))
  (let ((current (get-balance-internal who)))
    (map-set balances {address: who} {balance: (+ current amount)})
    true))

(define-private (debit (who principal) (amount uint))
  (let ((current (get-balance-internal who)))
    (asserts! (>= current amount) err-insufficient-balance)
    (map-set balances {address: who} {balance: (- current amount)})
    (ok true)))

;; SIP-010 - Read-onlys
(define-read-only (get-name)
  (ok TOKEN-NAME))

(define-read-only (get-symbol)
  (ok TOKEN-SYMBOL))

(define-read-only (get-decimals)
  (ok TOKEN-DECIMALS))

(define-read-only (get-balance (who principal))
  (ok (get-balance-internal who)))

(define-read-only (get-total-supply)
  (ok (var-get total-supply)))

;; SIP-010 - Publics
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (asserts! (> amount u0) err-amount-zero)
    (asserts! (is-eq tx-sender sender) err-unauthorized)
    (try! (debit sender amount))
    (credit recipient amount)
    (ok true)))

(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) err-unauthorized)
    (asserts! (> amount u0) err-amount-zero)
    (var-set total-supply (+ (var-get total-supply) amount))
    (credit recipient amount)
    (ok true)))

(define-public (burn (amount uint) (sender principal))
  (begin
    (asserts! (> amount u0) err-amount-zero)
    (asserts! (or (is-eq tx-sender sender) (is-eq tx-sender (var-get contract-owner))) err-unauthorized)
    (try! (debit sender amount))
    (var-set total-supply (- (var-get total-supply) amount))
    (ok true)))
