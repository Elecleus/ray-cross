// SPDX-FileContributor: Zephyr Du <elecleus@outlook.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later

const rl = @import("raylib");

const chess = @import("chess.zig");

pub fn main() !void {
    rl.initWindow(200, 200, "Ray Cross");
    defer rl.closeWindow();

    const base = rl.Vector2.init(100, 100);

    rl.setTargetFPS(60);

    var count: u16 = 0;
    while (!rl.windowShouldClose()) : (count += 1) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.sky_blue);

        switch (count) {
            0...59 => chess.Square.draw(base),
            60...119 => chess.Circle.draw(base),
            120...179 => chess.UTriangle.draw(base),
            180...239 => chess.RTriangle.draw(base),
            240...299 => chess.DTriangle.draw(base),
            300...359 => chess.LTriangle.draw(base),
            360 => count = 0,
            else => unreachable,
        }
    }
}
