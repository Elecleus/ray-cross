// SPDX-FileContributor: Zephyr Du <elecleus@outlook.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later

const rl = @import("raylib");

const chess = @import("chess.zig");
const Board = @import("Board.zig");
const Game = @import("Game.zig");

pub fn main() !void {
    rl.initWindow(200, 200, "Ray Cross");
    defer rl.closeWindow();

    const base = rl.Vector2.init(100, 100);
    var game = Game.init(base);

    rl.setTargetFPS(60);

    try game.put_chess_at(.{ .circle = .{} }, 4, 5);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.sky_blue);

        game.draw();
    }
}
