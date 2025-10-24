# PeeCoin (Clarity + Clarinet)

A simple fungible token (FT) smart contract for PeeCoin on Stacks, built with Clarity and managed with Clarinet.

- Contract: `contracts/peecoin.clar`
- Manifest: `Clarinet.toml`

## Prerequisites
- Install Clarinet: https://docs.hiro.so/clarinet/get-started

## Quick start
```pwsh path=null start=null
# Validate the project
clarinet check

# Open the interactive console
clarinet console
```

From the console, example calls:
```clarity path=null start=null
;; Mint 100_000 PEE (6 decimals) to a recipient (owner-only)
(contract-call? .peecoin mint u100000 '<recipient-principal>)

;; Transfer 50_000 PEE from tx-sender to someone
(contract-call? .peecoin transfer u50000 '<recipient-principal>)

;; Read balance
(contract-call? .peecoin get-balance-of '<principal>)

;; Total supply
(contract-call? .peecoin get-total-supply)
```

Notes
- `mint` is restricted to the contract owner (the deployer by default).
- Decimals: 6 (so 1.000000 PEE = u1_000_000).

## Functions
- `mint(amount uint, recipient principal) -> (response bool uint)`
- `transfer(amount uint, recipient principal) -> (response bool uint)`
- `burn(amount uint) -> (response bool uint)`
- `set-owner(new-owner principal) -> (response bool uint)`
- `get-balance-of(who principal) -> uint`
- `get-total-supply() -> uint`
- `get-name() -> (string-ascii 32)`
- `get-symbol() -> (string-ascii 10)`
- `get-decimals() -> uint`
