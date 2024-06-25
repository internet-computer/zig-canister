// src/mock_ic0.zig
const std = @import("std");

var msg: [2 * 1024 * 1024]u8 = "This is a mock message data for testing purposes.";

pub fn msg_reply_data_append(ptr: [*]const u8, len: usize) void {
    // Mock behavior: Print the data to the console
    const data = @ptrCast([*]const u8, ptr)[0..len];
    std.debug.print("Mock msg_reply_data_append: {s}\n", .{data});
}

// This function can be called at most once (a second call will trap), and must
// be called exactly once to indicate success.
pub fn msg_reply() void {
    std.debug.print("msg_reply() -> \n", .{});
}

pub fn msg_arg_data_size() i32 {
    // Mock behavior: Return the size of the mock message
    return msg.len;
}

pub fn msg_arg_data_copy(dst: i32, offset: i32, size: i32) void {
    // Mock behavior: Copy data from the mock message to the destination
    const buffer = @intToPtr([*]u8, dst);
    for (var i: i32 = 0; i < size; i += 1) {
        buffer[i] = msg[offset + i];
    }
}
