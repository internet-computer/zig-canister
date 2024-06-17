const c = @cImport({
    @cInclude("qrcodegen.h");
});

extern "ic0" fn msg_reply_data_append(ptr: [*]const u8, len: usize) void;
extern "ic0" fn msg_reply() void;
extern "ic0" fn msg_arg_data_size() i32;
extern "ic0" fn msg_arg_data_copy(dst: i32, offset: i32, size: i32) void;

const max = 2048;

pub fn printQr(qrcode: [*]u8) void {
    const size: c_int = c.qrcodegen_getSize(qrcode);
    const border: c_int = 4;
    var y: c_int = undefined;
    var x: c_int = undefined;

    while (y < size + border) {
        while (x < size + border) {
            const resp = if (c.qrcodegen_getModule(qrcode, x, y)) "##" else "  ";
            msg_reply_data_append(resp, resp.len);

            x += 1;
        }
        msg_reply_data_append("\n", 1);
        y += 1;
    }
    msg_reply_data_append("\n", 1);
}

pub fn basic(text: [*]u8) void {
    const errCorLvl: c.qrcodegen_Ecc = c.qrcodegen_Ecc_LOW;
    const qrcode: [c.qrcodegen_BUFFER_LEN_MAX]u8 = undefined;
    const tempBuffer: [c.qrcodegen_BUFFER_LEN_MAX]u8 = undefined;

    const ok = c.qrcodegen_encodeText(text, @constCast(&tempBuffer), @constCast(&qrcode), errCorLvl, c.qrcodegen_VERSION_MIN, c.qrcodegen_VERSION_MAX, c.qrcodegen_Mask_AUTO, true);

    if (ok) printQr(text);
}

export fn @"canister_update go"() callconv(.C) void {
    var n: i32 = msg_arg_data_size();
    n = if (n > max) max else n;

    var buf: [max + 1]u8 = undefined;
    msg_arg_data_copy(@intCast(@intFromPtr(&buf)), 0, n);
    buf[@intCast(n)] = 0;

    basic(&buf);
    msg_reply();
}
