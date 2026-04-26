// SPDX-FileContributor: Zephyr Du <elecleus@outlook.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later

const rl = @import("raylib");
const chess = @import("chess.zig");

const Board = @This();

const Chess = chess.Chess;

chesses: [8][5]?Chess = .{
    .{ .circle, .circle, .circle, .circle, .circle }, // Fake Home
    .{ null, null, null, null, null },
    .{ null, null, null, null, null },
    .{ null, null, null, null, null },
    .{ null, null, null, null, null },
    .{ null, null, null, null, null },
    .{ null, null, null, null, null },
    .{ .circle, .circle, .circle, .circle, .circle }, // Fake Home
},

center: rl.Vector2,

pub fn init(center: rl.Vector2) Board {
    return Board{ .center = center };
}

pub fn get_cell_center(self: *const Board, x: u8, y: u8) rl.Vector2 {
    return self.get_draw_base()
        .add(rl.Vector2.init(cell_width / 2, cell_height / 2))
        .add(rl.Vector2.init(cell_width * @as(f32, @floatFromInt(x)), cell_height * @as(f32, @floatFromInt(y))));
}

pub fn draw(self: *const Board) void {
    self.draw_board();
    self.draw_base();
}

const cell_width: f32 = 24.0;
const cell_height: f32 = cell_width;

fn get_draw_base(self: *const Board) rl.Vector2 {
    return self.center
        .add(rl.Vector2.init(cell_width / 2, 0))
        .add(rl.Vector2.init(cell_width, cell_height).scale(-3));
}

fn draw_board(self: *const Board) void {
    const base = self.get_draw_base();

    const x_axis = blk: {
        var x_axis: [6]rl.Vector2 = undefined;

        x_axis[0] = base;

        comptime var i: i32 = 1;
        inline while (i < 6) : (i += 1) {
            x_axis[i] = x_axis[0].add(rl.Vector2.init(cell_width, 0).scale(i));
        }

        break :blk x_axis;
    };

    const y_axis = blk: {
        var y_axis: [7]rl.Vector2 = undefined;

        y_axis[0] = base;

        comptime var j: i32 = 1;
        inline while (j < 7) : (j += 1) {
            y_axis[j] = y_axis[0].add(rl.Vector2.init(0, cell_height).scale(j));
        }

        break :blk y_axis;
    };

    const y_extend = rl.Vector2.init(0, cell_height).scale(6);
    for (x_axis) |start| {
        rl.drawLineV(start, start.add(y_extend), color);
    }

    const x_extend = rl.Vector2.init(cell_width, 0).scale(5);
    for (y_axis, 0..) |start, i| {
        switch (i) {
            3 => rl.drawLineDashed(start, start.add(x_extend), 7, 4, color),
            else => rl.drawLineV(start, start.add(x_extend), color),
        }
    }
}

fn draw_base(self: *const Board) void {
    const bar_width = cell_width * 5;
    const bar_height = 12;
    const bar_gap = 4;

    rl.drawRectangleV(
        self.get_draw_base()
            .add(rl.Vector2.init(0, -bar_gap - bar_height)),
        rl.Vector2.init(bar_width, bar_height),
        color,
    );

    rl.drawRectangleV(
        self.get_draw_base()
            .add(rl.Vector2.init(0, cell_height * 6 + bar_gap)),
        rl.Vector2.init(bar_width, bar_height),
        color,
    );
}

const color: rl.Color = .pink;
