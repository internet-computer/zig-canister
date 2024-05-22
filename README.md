# A Zig Canister

Ben Lynn has a blog post series about "Organic Apps", he creates canisters with
`clang`, and `lld` only.

[Quint](https://github.com/q-uint) and [Enzo](https://github.com/EnzoPlayer0ne), over beers, thought it would be fun to create a canister in zig, so
we looked at
Ben's [Hello, Internet Computer](https://fxa77-fiaaa-aaaae-aaana-cai.raw.ic0.app/organic/hello.html)
blog post and decided to port it to Zig the following day.

Anyways, here is the C code from Ben:
```c
#define IMPORT(m,n) __attribute__((import_module(m))) __attribute__((import_name(n)));
#define EXPORT(n) asm(n) __attribute__((visibility("default")))

void reply_append(void*, unsigned) IMPORT("ic0", "msg_reply_data_append");
void reply       (void)            IMPORT("ic0", "msg_reply");

void go() EXPORT("canister_query hi");

void go() {
  char msg[] = "Hello, World!\n";
  reply_append(msg, sizeof(msg) - 1);
  reply();
}

```

And here is our zig code:
```zig
extern "ic0" fn msg_reply_data_append(ptr: [*]const u8, len: usize) void;
extern "ic0" fn msg_reply() void;

comptime {
    @export(go, .{ .name = "canister_query hi", .linkage = .strong });
}

fn go() callconv(.C) void {
    const msg = "Hello, World!\n";
    msg_reply_data_append(msg, msg.len);
    msg_reply();
}
```

Let's compile the C code:
```sh
# we compile the object file
clang --target=wasm32 -c -O3 src/main.c -o main_c.o
# we link the object file
wasm-ld --no-entry --export-dynamic --allow-undefined main_c.o -o main_c.wasm
# translate to wat
wasm2wat main_c.wasm > main_c.wat
# we strip the wasm binary
wasm-strip main_c.wasm
```

Let's compile the Zig code:
```sh
# we compile zig
zig build-exe src/main.zig -target wasm32-freestanding -fno-entry -fstrip --export="canister_query hi"
# translate to wat
wasm2wat main.wasm > main.wat
```

Now let's compare the two WASMs:
```sh
enzo@merlaux:~/code/zig-cdk$ ll *.wasm
-rwxrwxr-x 1 enzo enzo 181 May 22 18:03 main.wasm*
-rwxrwxr-x 1 enzo enzo 308 May 22 18:04 main_c.wasm*
```

We have created a 181 bytes canister in Zig. Let us see if it works. First we need to create a minimal `dfx.json`:
```json
{
  "canisters": {
    "hello_zig": {
      "type": "custom",
      "build": "",
      "candid": "not.did",
      "wasm": "main.wasm"
    }
  }
}
```

Then let's create a minimal candid file `not.did`:
```
service: {}
```

We check if it actually works, start-up `dfx`:
```sh
dfx start
dfx deploy
```

Now, let's call the canister:
```sh
enzo@merlaux:~/code/zig-cdk$ dfx canister call hello hi --output raw  | xxd -r -p
WARN: Cannot fetch Candid interface for hi, sending arguments with inferred types.
Hello, World!
```

IT WORKS!

## Dev

To replicate the code, install `nix` and `direnv`:

- Install nix with [Determinate Systems Nix Installer](https://github.com/DeterminateSystems/nix-installer)

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

- Install direnv - [installation page](https://direnv.net/docs/installation.html)

- [hook direnv into your shell](https://direnv.net/docs/hook.html)

Run `direnv allow`. You should be all set-up!
