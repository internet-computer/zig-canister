extern "ic0" fn msg_reply_data_append(ptr: [*]const u8, len: usize) void;
extern "ic0" fn msg_reply() void;

export fn @"canister_query hi"() callconv(.C) void {
    const msg = "Hello, World!\n";
    msg_reply_data_append(msg, msg.len);
    msg_reply();
}
