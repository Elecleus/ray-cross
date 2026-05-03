// SPDX-FileContributor: Zephyr Du <elecleus@outlook.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later

const rl = @import("raylib");

const chess = @import("chess.zig");
const Board = @import("Board.zig");
const Game = @import("Game.zig");

const window_width = 300;
const window_height = 400;

pub fn main() !void {
    rl.initWindow(window_width, window_height, "Ray Cross");
    defer rl.closeWindow();

    const base = rl.Vector2.init(window_width / 2, window_height / 2);
    var game = Game.init(base);

    rl.setTargetFPS(60);

    try game.put_chess_at(.{ .circle = .{} }, 4, 5);

    while (!rl.windowShouldClose()) {
        game.handle_input();

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.sky_blue);

        game.draw();
    }
}
