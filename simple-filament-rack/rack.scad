include <../BOSL2/std.scad>
include <../BOSL2/walls.scad>

$fn = $preview ? 18 : 360;
fuzz = 0.01;

dowel_d = 18.1;

screw_d = 3;
screw_head_d = 8;

magnet_d = 3.1;
magnet_len = 8.5;

wall_thickness = 1.6;
cap_thickness = 1.5;

block_end_thickness = 15;
block_mid_thickness = 10;

spool_d = 200;
spool_ground_clearance = 15;
dowel_spool_angle = 55; // degree from vertical

dowel_centre_x = polar_to_xy((spool_d + dowel_d) / 2, 90 - dowel_spool_angle)[0];
dowel_centre_z = (spool_d / 2) - polar_to_xy((spool_d + dowel_d) / 2, 90 - dowel_spool_angle)[1] + spool_ground_clearance;

block_x = dowel_centre_x * 2 + dowel_d + wall_thickness * 2;
block_y = spool_d / 2 + spool_ground_clearance;
block_rounding = block_y - dowel_centre_z;

fwd(block_y * 0.6) {
  rack_part(true);
}

back(block_y * 0.6) {
  rack_part(false);
}

module rack_part(end = false) {
  block_z = end ? block_end_thickness : block_mid_thickness;
  spacing = block_x / 6;
  diff() {
    hex_panel(
      shape=rect([block_x, block_y], rounding=[block_rounding, block_rounding, 0, 0]),
      h=block_z,
      strut=wall_thickness,
      spacing=spacing,
      shift=[spacing / 2, 0],
      frame=wall_thickness,
      anchor=BOTTOM,
    ) {

      // dowel insert
      for (x = [1, -1]) {
        left(x * dowel_centre_x) {
          attach(FRONT, FRONT, overlap=-dowel_centre_z + dowel_d - wall_thickness, inside=true) {
            tag("") {
              cyl(d=dowel_d + wall_thickness * 2, h=block_z) {
                tag("remove") {
                  if (end) {
                    // capped socket
                    attach(TOP, TOP, inside=true, overlap=fuzz) {
                      cyl(d=dowel_d, h=block_z - cap_thickness + fuzz);
                    }

                    // screw hole
                    attach(BOTTOM, BOTTOM, inside=true, overlap=fuzz) {
                      cyl(d1=screw_head_d, d2=screw_d, h=cap_thickness + fuzz);
                    }
                  } else {
                    // through-hole
                    cyl(d=dowel_d + 0.75, h=block_z + fuzz * 2);
                  }
                }
              }
            }
          }
        }
      }

      // magnet blocks
      for (x = [1, -1]) {
        attach(FRONT, FRONT, inside=true, align=LEFT * x) {
          tag("") {
            cuboid(
              [magnet_d + wall_thickness * 2, magnet_len + wall_thickness, block_z],
              chamfer=wall_thickness,
              edges=[BACK + RIGHT * x]
            );
          }
        }
      }

      // magnet holes
      magnet_z_opts = end ? [-1, 0, 1] : [0];
      for (x = [1, -1]) {
        for (z = magnet_z_opts) {
          up(z * block_z / 4) {
            attach(FRONT, BOTTOM, inside=true, overlap=fuzz, align=LEFT * x, inset=wall_thickness) {
              tag("remove") {
                cyl(d=magnet_d, h=magnet_len + fuzz);
              }
            }
          }
        }
      }
    }
  }
}
