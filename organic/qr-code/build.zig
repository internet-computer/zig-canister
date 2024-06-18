const std = @import("std");

pub fn build(b: *std.Build) void {
    const qr = b.addExecutable(.{
        .name = "main",
        .root_source_file = b.path("src/main.zig"),
        .target = b.resolveTargetQuery(.{
            .cpu_arch = .wasm32,
            .os_tag = .freestanding,
        }),
        .optimize = .ReleaseSmall,
        .strip = true,
    });

    qr.entry = .disabled;
    qr.root_module.export_symbol_names = &[_][]const u8{
        "canister_update go",
    };

    qr.addIncludePath(.{ .path = "Qr-Code-generator/c/" });
    qr.addCSourceFile(.{ .file = .{ .path = "Qr-Code-generator/c/qrcodegen.c" }, .flags = &[_][]const u8{} });
    qr.addCSourceFile(.{ .file = .{ .path = "Qr-Code-generator/c/libc.c" }, .flags = &[_][]const u8{} });
    b.installArtifact(qr);
}
