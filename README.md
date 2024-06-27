# Organic Zig

Attempts and contempt at re-creating iconic c canister in zig

## Organic IC
-   [X] hello-ic
-   [ ] qr-code

## Zig

### Snippets
```zig
    inline for (std.meta.fields(@TypeOf(b.*))) |f| {
        std.log.debug(f.name ++ " {any}", .{@as(f.type, @field(b, f.name))});
    }
```

### Issues
Interesting issues we stumbled on:
-   https://github.com/ziglang/zig/issues/12726
-   https://github.com/ziglang/zig/issues/17039

### Learning

-   [documentation](https://ziglang.org/documentation/master)
-   [zig build system](https://ziglang.org/learn/build-system/)
-   [std doc](https://ziglang.org/documentation/master/std/)
-   [learn x in y](https://learnxinyminutes.com/docs/zig/)

-   [interesting build.zig](https://github.com/hardliner66/abps/blob/main/build.zig)

The library sometime does not have the answer

-   [dude the builder](https://www.youtube.com/@dudethebuilder)
-   [zig.guide](https://zig.guide/)
-   [openmind learning zig](https://www.openmymind.net/learning_zig/)



-   [ic0 interface](https://internetcomputer.org/docs/current/references/ic-interface-spec#system-api)
