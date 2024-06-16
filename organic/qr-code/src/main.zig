const c = @cImport({
    @cInclude("qrcodegen.h");
});

extern "ic0" fn msg_reply_data_append(ptr: [*]const u8, len: usize) void;
extern "ic0" fn msg_reply() void;
extern "ic0" fn msg_arg_data_size() i32;
extern "ic0" fn msg_arg_data_copy(dst: i32, offset: i32, size: i32) void;

pub fn main() void {}
