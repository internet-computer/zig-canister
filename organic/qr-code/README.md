
- a QR code canister from Ben Lynn - [link](https://fxa77-fiaaa-aaaae-aaana-cai.raw.ic0.app/organic/qr.html)


-   add the qr-code library header

-   let's compile some C code to webassembly with zig

```bash
zig cc -target=wasm32-wasi -O ReleaseSmall qrcodegen.c -o qrcodegen.wasm
```


compile qrcodegen and link against libc
```
zig  cc -r -target wasm32-freestanding -fPIC -lc Qr-Code-generator/c/qrcodegen.c -Wl,--no-en
try -o qrcodegen.o
```
