const std = @import("std");

pub fn build(b: *std.Build) void {
    // if it's a run we build and run in debug mode for native architecture

    // if it's a build, we build the wasm
    var target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .wasm32,
            .os_tag = .freestanding,
        },
    });
    var optimize: std.builtin.OptimizeMode = .ReleaseSmall;
    var strip = true;

    // TODO hacky could not figure out how to get if we do `zig build` or `zig build run`, rather if we have `zig build run -- aoeu` this works
    if (b.args) |_| {
        target = b.host;
        optimize = .Debug;
        strip = false;
    }

    const qr = b.addExecutable(.{
        .name = "main",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .strip = strip,
    });

    qr.entry = .disabled;
    qr.root_module.export_symbol_names = &[_][]const u8{
        "canister_update go",
    };

    qr.addIncludePath(.{ .path = "Qr-Code-generator/c/" });
    qr.addCSourceFile(.{ .file = .{ .path = "Qr-Code-generator/c/qrcodegen.c" }, .flags = &[_][]const u8{} });
    qr.addCSourceFile(.{ .file = .{ .path = "Qr-Code-generator/c/libc.c" }, .flags = &[_][]const u8{} });
    b.installArtifact(qr);

    const run_cmd = b.addRunArtifact(qr);
    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run_cmd.step);
}
