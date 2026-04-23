// SPDX-FileContributor: Zephyr Du <elecleus@outlook.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later

const rl = @import("raylib");

const chess = @import("chess.zig");
const Board = @import("Board.zig");

pub fn main() !void {
    rl.initWindow(200, 200, "Ray Cross");
    defer rl.closeWindow();

    const base = rl.Vector2.init(100, 100);
    const board = Board.init(base);

    rl.setTargetFPS(60);

    var count: u16 = 0;
    while (!rl.windowShouldClose()) : (count += 1) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.sky_blue);

        board.draw();

        const draw_at = board.get_cell_center(
            @intCast(@divTrunc(count, 60)),
            @intCast(@divTrunc(count, 60)),
        );
        switch (count) {
            0...59 => chess.Square.draw(draw_at),
            60...119 => chess.Circle.draw(draw_at),
            120...179 => chess.UTriangle.draw(draw_at),
            180...239 => chess.RTriangle.draw(draw_at),
            240...299 => chess.DTriangle.draw(draw_at),
            300...359 => chess.LTriangle.draw(draw_at),
            360 => count = 0,
            else => unreachable,
        }
    }
}
