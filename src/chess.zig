// SPDX-FileContributor: Zephyr Du <elecleus@outlook.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later

const std = @import("std");
const rl = @import("raylib");

const color: rl.Color = .dark_gray;

pub const Chess = union(enum) {
    square: Square,
    circle: Circle,
    l_triangle: LTriangle,
    r_triangle: RTriangle,
    u_triangle: UTriangle,
    d_triangle: DTriangle,

    pub fn draw(self: *Chess, base: rl.Vector2) void {
        switch (self) {
            .square => |s| s.draw(base),
            _ => {},
        }
    }
};

pub const Square = struct {
    const in: [8]bool = .{ false, true, false, true, true, false, true, false };
    const out = in;

    const p0: rl.Vector2 = .init(-10, -10);
    const p1: rl.Vector2 = .init(-10, 10);
    const p2: rl.Vector2 = .init(10, 10);
    const p3: rl.Vector2 = .init(10, -10);

    pub fn draw(base: rl.Vector2) void {
        rl.drawLineV(base.add(p0), base.add(p1), color);
        rl.drawLineV(base.add(p1), base.add(p2), color);
        rl.drawLineV(base.add(p2), base.add(p3), color);
        rl.drawLineV(base.add(p3), base.add(p0), color);
    }
};

pub const Circle = struct {
    const in: [8]bool = .{};
    const out = in;

    const r: f32 = 12;

    pub fn draw(base: rl.Vector2) void {
        rl.drawCircleLinesV(base, r, color);
    }
};

pub const UTriangle = struct {
    const in: [8]bool = .{ true, false, true, true, true, false, true, false };
    const out: [8]bool = .{ true, false, true, false, false, false, true, false };

    const p0: rl.Vector2 = .init(0, -12);
    const p1: rl.Vector2 = .init(-9, 4);
    const p2: rl.Vector2 = .init(9, 4);

    pub fn draw(base: rl.Vector2) void {
        rl.drawLineV(base.add(p0), base.add(p1), color);
        rl.drawLineV(base.add(p1), base.add(p2), color);
        rl.drawLineV(base.add(p2), base.add(p0), color);
    }
};

pub const DTriangle = struct {
    const in = turnRight(UTriangle.in, 2);
    const out = turnRight(UTriangle.out, 2);

    const p0: rl.Vector2 = .init(0, 12);
    const p1: rl.Vector2 = .init(-9, -4);
    const p2: rl.Vector2 = .init(9, -4);

    pub fn draw(base: rl.Vector2) void {
        rl.drawLineV(base.add(p0), base.add(p1), color);
        rl.drawLineV(base.add(p1), base.add(p2), color);
        rl.drawLineV(base.add(p2), base.add(p0), color);
    }
};

pub const LTriangle = struct {
    const in = turnRight(UTriangle.in, 3);
    const out = turnRight(UTriangle.out, 3);

    const p0: rl.Vector2 = .init(-12, 0);
    const p1: rl.Vector2 = .init(4, -9);
    const p2: rl.Vector2 = .init(4, 9);

    pub fn draw(base: rl.Vector2) void {
        rl.drawLineV(base.add(p0), base.add(p1), color);
        rl.drawLineV(base.add(p1), base.add(p2), color);
        rl.drawLineV(base.add(p2), base.add(p0), color);
    }
};

pub const RTriangle = struct {
    const in = turnRight(UTriangle.in, 1);
    const out = turnRight(UTriangle.out, 1);

    const p0: rl.Vector2 = .init(12, 0);
    const p1: rl.Vector2 = .init(-4, -9);
    const p2: rl.Vector2 = .init(-4, 9);

    pub fn draw(base: rl.Vector2) void {
        rl.drawLineV(base.add(p0), base.add(p1), color);
        rl.drawLineV(base.add(p1), base.add(p2), color);
        rl.drawLineV(base.add(p2), base.add(p0), color);
    }
};

// Tool function

fn turnRight(comptime array: [8]bool, times: comptime_int) [8]bool {
    var result = array;

    var i: i32 = times;
    while (i > 0) : (i -= 1) {
        result = .{
            array[5], array[3], array[0], array[6],
            array[1], array[7], array[4], array[2],
        };
    }

    return result;
}

test "tureRight" {
    const origin: [8]bool = .{ true, false, true, true, true, false, true, false };
    const expected: [8]bool = .{ false, true, true, true, false, false, true, true };

    try std.testing.expectEqual(expected, turnRight(origin, 1));
}
