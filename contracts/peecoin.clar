;; PeeCoin fungible token on Stacks (Clarity v2)

(define-fungible-token peecoin)

(define-data-var contract-owner principal tx-sender)

(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-MINT-FAILED u101)
(define-constant ERR-TRANSFER-FAILED u102)
(define-constant ERR-BURN-FAILED u103)
(define-constant ERR-BAD-AMOUNT u400)

;; Metadata
(define-read-only (get-name) "Pee Coin")
(define-read-only (get-symbol) "PEE")
(define-read-only (get-decimals) u6)

;; Getters
(define-read-only (get-balance-of (who principal))
  (ft-get-balance peecoin who)
)

(define-read-only (get-total-supply)
  (ft-get-supply peecoin)
)

;; Transfers tokens from tx-sender to recipient
(define-public (transfer (amount uint) (recipient principal))
  (if (> amount u0)
      (begin
        (try! (ft-transfer? peecoin amount tx-sender recipient))
        (ok true))
      (err ERR-BAD-AMOUNT))
)

;; Mints tokens to a recipient (owner-only)
(define-public (mint (amount uint) (recipient principal))
  (if (is-eq tx-sender (var-get contract-owner))
      (if (> amount u0)
          (begin
            (try! (ft-mint? peecoin amount recipient))
            (ok true))
          (err ERR-BAD-AMOUNT))
      (err ERR-NOT-AUTHORIZED))
)

;; Burns tokens from tx-sender balance
(define-public (burn (amount uint))
  (if (> amount u0)
      (begin
        (try! (ft-burn? peecoin amount tx-sender))
        (ok true))
      (err ERR-BAD-AMOUNT))
)

;; Transfers contract ownership (owner-only)
(define-public (set-owner (new-owner principal))
  (if (is-eq tx-sender (var-get contract-owner))
      (begin
        (var-set contract-owner new-owner)
        (ok true))
      (err ERR-NOT-AUTHORIZED))
)
