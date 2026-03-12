include <../BOSL2/std.scad>
include <../BOSL2/threading.scad>

$fn = $preview ? 18 : 180;

peg_d = 46;
peg_z = 65;

flare_d = 50;
flare_z = 6;

bolt_d = 10;
bolt_centres = 100;

washer_d = 31;
washer_z = 1;

plate_x = 60;
plate_y = bolt_centres + washer_d + (plate_x - washer_d);
plate_z = 8;

flare_chamfer = (flare_d - peg_d) / 2;

screw_d = peg_d / 3;
screw_pitch = 3;
screw_depth = peg_d / 4 * 3;

module weight_peg() {
  diff() {
    // back plate
    cuboid([plate_x, plate_y, plate_z], rounding=plate_z / 4) {

      // peg
      attach(TOP, BOTTOM) {
        cyl(d=peg_d, h=peg_z, chamfer1=-flare_chamfer) {

          // flared bases!
          attach(TOP, BOTTOM) {
            cyl(d=flare_d, h=flare_z, chamfer1=flare_chamfer, rounding2=flare_z / 3);
          }

          tag("remove") {
            for (i = [1, -1]) {
              up(peg_d / 3 * i) {
                back(screw_depth) {
                  attach(FRONT, TOP) {
                    threaded_rod(d=[screw_d - 1, screw_d, screw_d + 1], pitch=screw_pitch, l=50, internal=true, $slop=0.1);
                  }
                }
              }
            }
          }
        }
      }

      tag("remove") {
        // bolt holes
        for (i = [1, -1]) {
          fwd(bolt_centres / 2 * i) {
            cyl(d=bolt_d, h=plate_z * 2);
          }
        }

        // washer indents
        for (i = [1, -1]) {
          attach(TOP, BOTTOM, overlap=washer_z) {
            fwd(bolt_centres / 2 * i) {
              cyl(d=washer_d, h=washer_z * 2, rounding=washer_z / 2);
            }
          }
        }

        // material markers
        for (i = [1, -1]) {
          attach(TOP, overlap=washer_z) {
            fwd(bolt_centres / 2 * i + bolt_d) {
              text3d(text="ASA", h=1, size=5, center=true);
            }
          }
        }
      }
    }
  }
}

module screw() {
  diff() {
    threaded_rod(
      d=[screw_d - 1, screw_d, screw_d + 1],
      pitch=screw_pitch,
      l=screw_depth * 0.9,
      bevel=1
    ) {
      tag("remove") {
        attach(BOTTOM, BOTTOM, inside=true, overlap=0.01) {
          cuboid([1.5, screw_d * 0.66, 5]);
        }
      }

      attach(TOP) {
        text3d(text="2", h=1, size=8, center=true);
      }
    }
  }
}

fwd(10) front_half(s=999) weight_peg();
back(10) back_half(s=999) weight_peg();

left(plate_x / 3 * 2) screw();
right(plate_x / 3 * 2) screw();
