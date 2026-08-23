include <../BOSL2/std.scad>

$fn = $preview ? 18 : 180;
fuzz = 0.01;

total_x = 110;
total_y = 80;
total_z = 15;
wall_thickness = 4;

rim_depth = 3;
rim_z = 3;
rim_slop = 0.3;

leg_z = 5;
leg_xy = 5;

rounding = 10;

angled_cutout_z = total_z * 0.7;
hole_cutout_z = total_z * 0.3;
hole_cutout_x = wall_thickness;

up(total_z / 2) {
  diff() {
    cuboid([total_x, total_y, total_z - rim_z], rounding=rounding, edges=["Z"]) {
      // bottom rim section
      attach(BOTTOM, TOP) {
        cuboid([total_x - rim_depth * 2, total_y - rim_depth * 2, rim_z], rounding=rounding - rim_depth, edges=["Z"]);
      }

      // inner features
      tag("remove") {
        // angled cut-out section
        attach(TOP, TOP, inside=true, overlap=fuzz) {
          prismoid(
            size1=[total_x - wall_thickness * 4, total_y - wall_thickness * 4],
            size2=[total_x - wall_thickness * 2, total_y - wall_thickness * 2],
            h=angled_cutout_z + fuzz,
            rounding=rounding - wall_thickness,
          );
        }

        // hole cut-out sections
        floor_area_x = total_x - wall_thickness * 4;
        hole_qty = floor(floor_area_x / (hole_cutout_x * 2));
        hole_spacing = (floor_area_x - (hole_qty * hole_cutout_x)) / (hole_qty + 1);
        hole_cutout_y = total_y - wall_thickness * 4 - hole_spacing * 1.5;
        attach(TOP, TOP, inside=true, overlap=-angled_cutout_z + fuzz) {
          for (x = [0:hole_qty - 1]) {
            right(floor_area_x * -0.5 + (hole_cutout_x * x) + (hole_spacing * (x + 1)) + hole_cutout_x / 2) {
              cuboid(
                [hole_cutout_x, hole_cutout_y, hole_cutout_z + fuzz * 2],
                rounding=hole_cutout_x / 2,
                edges=["Z"]
              ) {
                attach(TOP, TOP, inside=true) {
                  prismoid(
                    size1=[hole_cutout_x, hole_cutout_y],
                    size2=[hole_cutout_x + hole_spacing * 0.6, hole_cutout_y + hole_spacing * 0.6],
                    h=hole_cutout_z / 2,
                    rounding=hole_cutout_x / 2,
                  );
                }
              }
            }
          }
        }
      }
    }
  }
}

down(total_z / 2) {
  diff() {
    cuboid([total_x, total_y, rim_z + leg_z], rounding=rounding, edges=["Z"]) {
      tag("remove") {
        // inner gap
        attach(TOP, TOP, inside=true, overlap=fuzz) {
          cuboid(
            [total_x - rim_depth * 2 + rim_slop, total_y - rim_depth * 2 + rim_slop, rim_z + leg_z + fuzz * 2],
            rounding=rounding - rim_depth,
            edges=["Z"]
          );
        }

        // leg cut-outs
        attach(TOP, TOP, inside=true, overlap=-rim_z) {
          cuboid([total_x * 1.5, total_y - leg_xy * 2, leg_z * 2], rounding=leg_z, edges=["X"]);
          cuboid([total_x - leg_xy * 2, total_y * 1.5, leg_z * 2], rounding=leg_z, edges=["Y"]);
        }
      }
    }
  }
}
