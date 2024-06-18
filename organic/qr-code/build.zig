const std = @import("std");

pub fn build(b: *std.Build) void {
    const qrcodegen = b.addStaticLibrary(.{
        .name = "qrcodegen",
        .target = b.resolveTargetQuery(.{
            .cpu_arch = .wasm32,
            .os_tag = .freestanding,
        }),
        .optimize = .ReleaseSmall,
    });
    qrcodegen.addCSourceFile(.{ .file = .{ .path = "Qr-Code-generator/c/qrcodegen.c" }, .flags = &[_][]const u8{} });
    qrcodegen.addIncludePath(.{ .path = "Qr-Code-generator/c/" });

    const libc = b.addStaticLibrary(.{
        .name = "libc",
        .target = b.resolveTargetQuery(.{
            .cpu_arch = .wasm32,
            .os_tag = .freestanding,
        }),
        .optimize = .ReleaseSmall,
    });
    libc.addCSourceFile(.{ .file = .{ .path = "Qr-Code-generator/c/libc.c" }, .flags = &[_][]const u8{} });
    libc.addIncludePath(.{ .path = "Qr-Code-generator/c/" });

    const qr = b.addExecutable(.{
        .name = "qr",
        .root_source_file = b.path("src/main.zig"),
        .target = b.resolveTargetQuery(.{
            .cpu_arch = .wasm32,
            .os_tag = .freestanding,
        }),
        .optimize = .ReleaseSmall,
        .strip = true,
    });
    qr.addIncludePath(.{ .path = "Qr-Code-generator/c/" });
    qr.entry = .disabled;
    qr.root_module.export_symbol_names = &[_][]const u8{
        "canister_update go",
    };

    b.installArtifact(qr);
    b.installArtifact(qrcodegen);
    b.installArtifact(libc);

    // wasm.addObjectFile(.{ .path = qr.out_lib_filename });
    // wasm.addObjectFile(.{ .path = qrcodegen.out_lib_filename });
    // wasm.addObjectFile(.{ .path = libc.out_lib_filename });

    //  wasm = b.addExecutable(.{
    //     .name = "qr_wasm",
    //     .target = b.resolveTargetQuery(.{
    //         .cpu_arch = .wasm32,
    //         .os_tag = .freestanding,
    //     }),
    //     .optimize = .ReleaseSmall,
    //     .strip = true,
    // });

    // // b.installArtifact(wasm);
}
