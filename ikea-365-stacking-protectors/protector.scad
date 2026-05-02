include <../BOSL2/std.scad>

$fn = $preview ? 18 : 360;
fuzz = 0.01;

glass_thickness = 9;
protector_drop = 25;
protector_width = 15;
hook_d = 5.5;

thickness = 1.2;

cuboid([protector_width, protector_drop + thickness, thickness]) {
  attach(TOP, BOTTOM, align=BACK) {
    cuboid([protector_width, thickness, glass_thickness - hook_d * 0.4]) {
      translate([0, -hook_d / 2 - thickness / 2, -hook_d / 2 - thickness]) {
        zrot(90) {
          attach(TOP, LEFT) {
            diff() {
              tube(id=hook_d, od=hook_d + thickness * 2, h=protector_width) {
                tag("remove") {
                  attach(LEFT, LEFT, inside=true) {
                    cuboid([(hook_d + thickness * 2) / 2, hook_d + thickness * 2, protector_width]);
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
