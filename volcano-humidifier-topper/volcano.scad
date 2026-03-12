include <../BOSL2/std.scad>
include <shared.scad>

base_cut = 4.8;

$fn = $preview ? 18 : 180;

down(base_cut) {
  difference() {
    union() {
      scale(0.7) {
        // translate([-117.5, -123, 0]) {
        translate([-124, -123, 0]) {
          import("./volcano-raw.stl");
        }
      }

      // make the inside mostly solid
      cyl(d1=100, d2=0, h=45, anchor=BOTTOM);
    }

    union() {
      // temp cutaway
      cuboid([200, 200, 200], anchor=BOTTOM + BACK);

      // remove the flat base
      cuboid([200, 200, base_cut], anchor=BOTTOM) {
        attach(TOP, BOTTOM, overlap=0.01) {
          // base interlock
          base_negative();

          // downwards "funnel"
          cyl(d1=50, d2=73, h=12, anchor=BOTTOM) {
            attach(TOP, BOTTOM) {
              // upwards "funnel"
              cyl(d1=73, d2=20, h=40, anchor=BOTTOM) {
                attach(TOP, BOTTOM) {
                  // top chimney
                  skew(sxz=-0.28) cyl(d1=20, d2=8, h=20, anchor=BOTTOM);
                }
              }
            }
          }
        }
      }
    }
  }
}
