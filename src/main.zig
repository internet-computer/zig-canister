extern "ic0" fn msg_reply_data_append(ptr: [*]const u8, len: usize) void;
extern "ic0" fn msg_reply() void;

comptime {
    @export(go, .{ .name = "canister_query hi", .linkage = .strong });
}

fn go() callconv(.C) void {
    const msg = "Hello, World!\n";
    msg_reply_data_append(msg, msg.len);
    msg_reply();
}
