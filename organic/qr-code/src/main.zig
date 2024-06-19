const std = @import("std");
const builtin = @import("builtin");
const c = @cImport({
    @cInclude("qrcodegen.h");
});

const debug = if (builtin.mode == .Debug) true else false;

extern "ic0" fn msg_reply_data_append(ptr: [*]const u8, len: usize) void;
extern "ic0" fn msg_reply() void;
extern "ic0" fn msg_arg_data_size() i32;
extern "ic0" fn msg_arg_data_copy(dst: i32, offset: i32, size: i32) void;

const max = 2048;

pub fn printQr(qrcode: [*]u8) void {
    const size: c_int = c.qrcodegen_getSize(qrcode);
    const border: c_int = 4;
    const newline = "\n";

    var y: c_int = -border;
    while (y < size + border) {
        var x: c_int = -border;
        while (x < size + border) {
            const resp = if (c.qrcodegen_getModule(qrcode, x, y)) "##" else "  ";

            if (!debug) {
                msg_reply_data_append(resp, resp.len);
            }

            x += 1;
        }

        if (!debug) {
            msg_reply_data_append(newline, newline.len);
        }
        y += 1;
    }

    if (!debug) {
        msg_reply_data_append(newline, newline.len);
    }
}

pub fn basic(text: [*]u8) void {
    const errCorLvl: c.qrcodegen_Ecc = c.qrcodegen_Ecc_LOW;
    const qrcode: [c.qrcodegen_BUFFER_LEN_MAX]u8 = undefined;
    const tempBuffer: [c.qrcodegen_BUFFER_LEN_MAX]u8 = undefined;

    const ok = c.qrcodegen_encodeText(@constCast(text), @constCast(&tempBuffer), @constCast(&qrcode), errCorLvl, c.qrcodegen_VERSION_MIN, c.qrcodegen_VERSION_MAX, c.qrcodegen_Mask_AUTO, true);

    if (ok) printQr(@constCast(&qrcode));
}

export fn @"canister_update go"() callconv(.C) void {
    var n: i32 = if (!debug) msg_arg_data_size() else 0;
    n = if (n > max) max else n;

    var buf = std.mem.zeroes([max + 1]u8);

    if (!debug) {
        msg_arg_data_copy(@intCast(@intFromPtr(&buf)), 0, n);
    }

    buf[@intCast(n)] = 0;

    basic(&buf);

    if (!debug) {
        msg_reply();
    }
}

pub fn main() void {
    @"canister_update go"();
}
