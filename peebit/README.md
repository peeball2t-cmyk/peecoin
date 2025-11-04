# Peebit (PEEBIT)

SIP-010 fungible token implemented in Clarity using Clarinet.

## Project layout
- `Clarinet.toml` — Clarinet project manifest
- `contracts/peebit.clar` — main token contract
- `contracts/sip010-ft-trait.clar` — SIP-010 trait implemented by the token

## Requirements
- Clarinet CLI

## Install Clarinet
If you don't have Clarinet installed:
- Option A (npm): `npm install -g @hirosystems/clarinet`
- Option B (installer): `curl -LsSf https://hiro.so/clarinet/install.sh | sh -s -- -b ~/.local/bin`

Make sure `~/.local/bin` is on your `PATH`.

## Commands
- Check compilation:
  ```sh
  clarinet check
  ```
- Open REPL:
  ```sh
  clarinet console
  ```

## Example usage in REPL
- Mint 1,000,000 units to your address:
  ```clarity
  (contract-call? .peebit mint u1000000 tx-sender)
  ```
- Transfer 10 units to a recipient:
  ```clarity
  (contract-call? .peebit transfer u10 tx-sender 'ST3NBRSFKX28FQ2ZJ1MAKX58HKHSDGNV5N7R21XCP none)
  ```
- Read balance:
  ```clarity
  (contract-call? .peebit get-balance 'ST3NBRSFKX28FQ2ZJ1MAKX58HKHSDGNV5N7R21XCP)
  ```

## Notes
- Token decimals: 6
- Only the deployer (owner) can mint and may burn from any account; any user can burn their own balance.
