// SPDX-FileContributor: Zephyr Du <elecleus@outlook.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later

const rl = @import("raylib");

const Board = @import("Board.zig");
const chess = @import("chess.zig");
const Chess = chess.Chess;

const Game = @This();

board: Board,
/// Current player: true for upper, false for lower.
player: Player = .lower,
cursor: Cursor = .{ .x = 0, .y = 0 },

pub fn init(center: rl.Vector2) Game {
    return Game{ .board = .init(center) };
}

pub fn handle_input(self: *Game) void {
    if (rl.isKeyDown(.right)) {
        self.cursor.move_r();
    }
    if (rl.isKeyDown(.left)) {
        self.cursor.move_l();
    }
    if (rl.isKeyDown(.up)) {
        self.cursor.move_u();
    }
    if (rl.isKeyDown(.down)) {
        self.cursor.move_d();
    }
}

pub fn put_chess_at(self: *Game, chess_type: Chess, c_index: u8, r_index: u8) !void {
    switch (self.player) {
        .upper => {
            if (r_index > 2) {
                return error.NotTheTurn;
            } else try self.board.put_at(chess_type, c_index, r_index);
        },
        .lower => {
            if (r_index > 6) {
                return error.OutOfRange;
            } else if (r_index < 3) {
                return error.NotTheTurn;
            } else try self.board.put_at(chess_type, c_index, r_index);
        },
    }
}

pub fn draw(self: *const Game) void {
    self.board.draw();
    self.draw_chesses();
    self.draw_cursor();
}

pub fn draw_cursor(self: *const Game) void {
    const outset = 3;

    const center = self.board.get_cell_center(self.cursor.x, self.cursor.y);

    const rect = rl.Rectangle.init(
        center.x - Board.cell_width / 2 - outset,
        center.y - Board.cell_height / 2 - outset,
        Board.cell_width + outset * 2 - 1,
        Board.cell_height + outset * 2 - 1,
    );
    rl.drawRectangleLinesEx(rect, 2, .blue);
}

pub fn draw_chesses(self: *const Game) void {
    for (0..5) |i| {
        for (0..6) |j| {
            if (self.board.get_at(
                @intCast(i),
                @intCast(j),
            )) |chess_| {
                chess_.draw(self.board.get_cell_center(
                    @intCast(i),
                    @intCast(j),
                ));
            }
        }
    }
}

const Player = enum {
    upper,
    lower,
};

const Cursor = struct {
    const boundry = .{
        .x = 4,
        .y = 5,
    };

    x: u8,
    y: u8,

    pub fn move_u(self: *Cursor) void {
        if (self.y != 0) {
            self.y -= 1;
        }
    }

    pub fn move_d(self: *Cursor) void {
        if (self.y != boundry.y) {
            self.y += 1;
        }
    }

    pub fn move_l(self: *Cursor) void {
        if (self.x != 0) {
            self.x -= 1;
        }
    }

    pub fn move_r(self: *Cursor) void {
        if (self.x != boundry.x) {
            self.x += 1;
        }
    }
};
