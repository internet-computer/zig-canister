const std = @import("std");

pub fn build(b: *std.Build) void {
    // if it's a run we build and run in debug mode for linux x86-64
    // if it's a build, we build the wasm

    var target: std.Build.ResolvedTarget = undefined;
    var optimize: std.builtin.OptimizeMode = undefined;
    var strip: bool = undefined;
    var debug: bool = undefined;

    if (b.args) |_| {
        std.debug.print("debug mode\n", .{});
        debug = true;
    } else {
        std.debug.print("wasm mode\n", .{});
        debug = false;
    }

    // TODO hacky could not figure out how to get if we do `zig build` or `zig build run` , rather if we have `zig build run -- aoeu` this works
    if (debug) {
        // TODO compiling for aarch64 leads to an error I cannot troubleshoot
        target = b.standardTargetOptions(
            .{
                .default_target = .{
                    // .cpu_arch = .aarch64,
                    .cpu_arch = .x86_64,
                    .os_tag = .linux,
                },
            },
        );
        optimize = .Debug;
        strip = false;
    } else {
        target = b.standardTargetOptions(.{
            .default_target = .{
                .cpu_arch = .wasm32,
                .os_tag = .freestanding,
            },
        });
        optimize = .ReleaseSmall;
        strip = true;
    }

    const qr = b.addExecutable(.{
        .name = "main",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .strip = strip,
        .pic = true,
    });

    // TODO hacky
    if (!debug) {
        qr.entry = .disabled;
        qr.root_module.export_symbol_names = &[_][]const u8{
            "canister_update go",
        };
    }

    qr.addIncludePath(.{ .path = "Qr-Code-generator/c/" });
    qr.addCSourceFile(.{ .file = .{ .path = "Qr-Code-generator/c/qrcodegen.c" }, .flags = &[_][]const u8{} });
    qr.addCSourceFile(.{ .file = .{ .path = "Qr-Code-generator/c/libc.c" }, .flags = &[_][]const u8{} });
    b.installArtifact(qr);
}
