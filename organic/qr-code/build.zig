const std = @import("std");

pub fn build(b: *std.Build) void {
    var wasm = b.addExecutable(.{
        .name = "main",
        .root_source_file = b.path("src/main.zig"),
        .target = b.resolveTargetQuery(.{
            .cpu_arch = .wasm32,
            .os_tag = .freestanding,
        }),
        .optimize = .ReleaseSmall,
        .strip = true,
    });
    wasm.addIncludePath(.{ .path = "Qr-Code-generator/c" });

    wasm.entry = .disabled;
    wasm.root_module.export_symbol_names = &[_][]const u8{
        "canister_update go",
    };

    // wasm.addObjectFile(source: LazyPath)

    b.installArtifact(wasm);
}
