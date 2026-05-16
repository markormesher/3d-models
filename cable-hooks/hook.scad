include <../BOSL2/std.scad>

$fn = $preview ? 18 : 180;
fuzz = 0.01;

hook(
  // edit these parameters
  d=30,
  thickness=10,
  wall=2,
  screw_d=2.5,
  screwdriver_d=6,
);

module hook(d, thickness, wall, screw_d, screwdriver_d) {
  hook_outer_d = d + wall * 2;
  diff("r") {
    cyl(d=hook_outer_d, h=thickness, anchor=BOTTOM) {
      // corner brace
      right(hook_outer_d / 4) {
        attach(BACK, BACK, inside=true) {
          cuboid([hook_outer_d / 2, hook_outer_d / 2, thickness]);
        }
      }

      // top bar
      attach(BACK, BACK, inside=true) {
        cuboid([hook_outer_d, wall, thickness]);
      }

      // hollow
      tag("r") {
        cyl(d=d, h=thickness + fuzz * 2);
      }

      // opening
      tag("r") {
        left(hook_outer_d / 4) {
          attach(BACK, BACK, inside=true, overlap=-wall) {
            cuboid([hook_outer_d / 2, d / 4, thickness + fuzz * 2]);
          }
        }
      }

      // screw hole
      tag("r") {
        attach(BACK, BACK, inside=true, overlap=wall) {
          teardrop(d=screw_d, h=wall * 3, cap_h=screw_d / 2);
        }
        attach(FRONT, FRONT, inside=true, overlap=wall) {
          teardrop(d=screwdriver_d, h=wall * 3, cap_h=screwdriver_d / 2);
        }
      }
    }
  }
}

// demo
// for (x = [0:2]) {
//   for (y = [0:2])
//     translate([100 + 50 * x, 100 + 60 * y, 0]) {
//       hook(d=20 + x * 10, thickness=8 + y * 6, screw_d=2.5 + x * 2);
//     }
// }
