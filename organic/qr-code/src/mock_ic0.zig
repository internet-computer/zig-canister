const std = @import("std");

// Education - https://internetcomputer.org/docs/current/references/ic-interface-spec

var reply_buffer: [2 * 1024 * 1024]u8 = undefined;
var msg_reply_call_count: u32 = 0;
var reply_len: usize = 0;
var arg_buffer: [1024]u8 = undefined;
var arg_len: usize = 0;

// replies to the sender with data assembled by `msg_reply_data_append`
// can only be called once
pub fn msg_reply() void {
    if (msg_reply_call_count > 0) {
        @panic("Only allowed to call `msg_reply` once");
    }

    std.debug.print("Replying with {} bytes: \n{s}\n", .{ reply_len, reply_buffer[0..reply_len] });

    // reset
    reply_len = 0;
    msg_reply_call_count += 1;
    @memset(reply_buffer[0..], 0);
}

pub fn msg_arg_data_size() i32 {
    return @intCast(arg_len);
}

// Appends data it to the (initially empty) data reply
pub fn msg_reply_data_append(ptr: [*]const u8, len: usize) void {
    if (reply_len + len > reply_buffer.len) {
        @panic("Reply buffer overflow");
    }

    // TODO check the total length of the message does not exceed the maxmimum response size

    // maybe copy forwards
    @memcpy(reply_buffer[reply_len..][0..len], ptr[0..len]);
    reply_len += len;
}

pub fn msg_arg_data_copy(dst: i32, offset: i32, size: i32) void {
    if (offset + size > arg_len) {
        @panic("Argument buffer overflow");
    }
    const dest_ptr: [*]u8 = @ptrFromInt(@as(usize, @intCast(dst)));
    @memcpy(dest_ptr[0..@intCast(size)], arg_buffer[@intCast(offset)..][0..@intCast(size)]);
}
