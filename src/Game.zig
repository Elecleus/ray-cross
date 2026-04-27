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

pub fn init(center: rl.Vector2) Game {
    return Game{ .board = .init(center) };
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
