# QR Code
a QR code canister from Ben Lynn - [link](https://fxa77-fiaaa-aaaae-aaana-cai.raw.ic0.app/organic/qr.html)

run
```fish
zig build run
```

**canister**
```fish
dfx deploy
dfx canister call qr go --type raw  $(echo "Hello, QR Code!" | xxd -p) --output raw | xxd -r -p
```
