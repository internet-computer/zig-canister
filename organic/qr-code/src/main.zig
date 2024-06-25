const std = @import("std");
const builtin = @import("builtin");
const c = @cImport({
    @cInclude("qrcodegen.h");
});

const debug = if (builtin.mode == .Debug) true else false;

const ic0 = if (debug)
{
    @import("mock_ic0");
} else {
    @import("ic0");
};

const max = 2048;

pub fn printQr(qrcode: [*]u8) void {
    const size: c_int = c.qrcodegen_getSize(qrcode);
    const border: c_int = 4;
    const newline = "\n";

    var y: c_int = -border;
    while (y < size + border) : (y += 1) {
        var x: c_int = -border;
        while (x < size + border) : (x += 1) {
            const resp = if (c.qrcodegen_getModule(qrcode, x, y)) "##" else "  ";

            ic0.msg_reply_data_append(resp, resp.len);
        }

        ic0.msg_reply_data_append(newline, newline.len);
    }

    ic0.msg_reply_data_append(newline, newline.len);
}

pub fn basic(text: [*]u8) void {
    const errCorLvl: c.qrcodegen_Ecc = c.qrcodegen_Ecc_LOW;
    const qrcode: [c.qrcodegen_BUFFER_LEN_MAX]u8 = undefined;
    const tempBuffer: [c.qrcodegen_BUFFER_LEN_MAX]u8 = undefined;

    const ok = c.qrcodegen_encodeText(@constCast(text), @constCast(&tempBuffer), @constCast(&qrcode), errCorLvl, c.qrcodegen_VERSION_MIN, c.qrcodegen_VERSION_MAX, c.qrcodegen_Mask_AUTO, true);

    if (ok) printQr(@constCast(&qrcode));
}

export fn @"canister_update go"() callconv(.C) void {
    var n: i32 = ic0.msg_arg_data_size();
    n = if (n > max) max else n;

    var buf = std.mem.zeroes([max + 1]u8);

    ic0.msg_arg_data_copy(@intCast(@intFromPtr(&buf)), 0, n);

    // n is i32 and buf is usize!
    buf[@intCast(n)] = 0;

    basic(&buf);

    ic0.msg_reply();
}

pub fn main() void {
    var args = std.process.args();
    var i: u8 = 0;

    while (args.next()) |arg| : (i += 1) std.debug.print("arg #{}: {s}\n", .{ i, arg });

    // set up msg_arg

    @"canister_update go"();
}
