include <../BOSL2/std.scad>

// general settings
$fn = $preview ? 6 : 180;
fuzz = 0.01;
wall_thickness = 1.2;

// overall box dimensions
box_x = 185.75;
box_y = 65;
box_z = 14.5;
box_rounding = 5;

// positioning pegs on either end of the box
peg_x = 3;
peg_y = 2;
peg_z = box_z / 2;
peg_y_gap = 3;

// perforations in the x-axis sides of the boxes
box_hole_x = $preview ? 15 : 5;
box_hole_z = $preview ? 3 : 1;
box_hole_x_margin = 6;
box_hole_z_margin = 2;
box_hole_x_gap = 1;
box_hole_z_gap = 1;

// perforations in the lid
lid_hole_x = $preview ? 10 : 1;
lid_hole_x_gap = 1;
lid_hole_count = floor((box_x - wall_thickness * 4) / (lid_hole_x + lid_hole_x_gap));

// magnet sizes
magnet_d = 6.2;
magnet_z = 3;
magnet_inset = 4;

module box() {
  diff("r2", "k2") {
    diff("r1", "k1 r2") {
      // main shell
      cuboid([box_x, box_y, box_z], rounding=box_rounding, edges=["Z"], anchor=BOTTOM) {

        // fitting pegs
        for (x = [LEFT, RIGHT]) {
          for (y = [1, -1]) {
            fwd((peg_y_gap + peg_y) / 2 * y) {
              attach(x, x * -1, align=BOTTOM) {
                cuboid([peg_x, peg_y, peg_z], rounding=peg_y / 4, edges=[x + FRONT, x + BACK]);
              }
            }
          }
        }

        // main cavity
        tag("r1") {
          attach(TOP, TOP, inside=true, overlap=fuzz) {
            cuboid(
              [
                box_x - wall_thickness * 2,
                box_y - wall_thickness * 2,
                box_z - wall_thickness,
              ],
              rounding=box_rounding - wall_thickness,
              edges=["Z"],
            );
          }
        }

        // wall perforations
        tag("r1") {
          box_box_hole_cluster();
          left(box_x / 3) box_box_hole_cluster();
          right(box_x / 3) box_box_hole_cluster();
        }

        // magnet posts
        tag("k1") {
          for (x = [LEFT, RIGHT]) {
            attach(x, x * -1, align=BOTTOM, inside=true, overlap=-wall_thickness, inset=wall_thickness) {
              cuboid(
                [magnet_d + wall_thickness * 2, magnet_d + wall_thickness * 2, box_z - magnet_inset - wall_thickness],
                rounding=wall_thickness,
                edges=[x + FRONT, x + BACK],
              ) {
                tag("r2") {
                  attach(TOP, TOP, inside=true, overlap=fuzz) {
                    cyl(d=magnet_d, h=magnet_z);
                  }
                }
              }
            }

            for (y = [BACK, FRONT]) {
              left(box_x / 6 * (x == LEFT ? 1 : -1)) {
                attach(y, y * -1, align=BOTTOM, inside=true, overlap=-wall_thickness, inset=wall_thickness) {
                  cuboid(
                    [magnet_d + wall_thickness * 2, magnet_d + wall_thickness * 2, box_z - magnet_inset - wall_thickness],
                    rounding=wall_thickness,
                    edges=[y + LEFT, y + RIGHT],
                  ) {
                    tag("r2") {
                      attach(TOP, TOP, inside=true, overlap=fuzz) {
                        cyl(d=magnet_d, h=magnet_z);
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
  }
}

module lid() {
  diff("r2", "k2") {
    diff("r1", "k1 r2") {
      // main shell
      cuboid([box_x, box_y, wall_thickness], rounding=box_rounding, edges=["Z"], anchor=BOTTOM) {

        // magnet posts
        for (x = [LEFT, RIGHT]) {
          attach(x, x * -1, align=BOTTOM, inside=true, overlap=-wall_thickness - 0.2, inset=wall_thickness) {
            cuboid(
              [magnet_d + wall_thickness * 2, magnet_d + wall_thickness * 2, magnet_inset],
              rounding=wall_thickness,
              edges=[x + FRONT, x + BACK],
            ) {
              tag("r2") {
                attach(TOP, TOP, inside=true, overlap=fuzz) {
                  cyl(d=magnet_d, h=magnet_z);
                }
              }
            }
          }

          for (y = [BACK, FRONT]) {
            left(box_x / 6 * (x == LEFT ? 1 : -1)) {
              attach(y, y * -1, align=BOTTOM, inside=true, overlap=-wall_thickness - 0.2, inset=wall_thickness) {
                cuboid(
                  [magnet_d + wall_thickness * 2, magnet_d + wall_thickness * 2, magnet_inset],
                  rounding=wall_thickness,
                  edges=[y + LEFT, y + RIGHT],
                ) {
                  tag("r2") {
                    attach(TOP, TOP, inside=true, overlap=fuzz) {
                      cyl(d=magnet_d, h=magnet_z);
                    }
                  }
                }
              }
            }
          }
        }

        // holes
        tag("r1") {
          left(( (lid_hole_x + lid_hole_x_gap) * (lid_hole_count - 1)) / 2) {
            for (x = [0:lid_hole_count - 1]) {
              right((lid_hole_x + lid_hole_x_gap) * x) {
                cuboid([lid_hole_x, box_y - wall_thickness * 6, wall_thickness + fuzz * 2], rounding=lid_hole_x / 2, edges=["Z"]);
              }
            }
          }
        }

        // supports for the holes
        tag("k1") {
          // centre strip
          cuboid([box_x, wall_thickness * 2, wall_thickness]);

          // magnet post "feet"
          for (x = [LEFT, RIGHT]) {
            attach(x, x * -1, inside=true, overlap=-wall_thickness) {
              cuboid(
                [magnet_d + wall_thickness * 4.5, magnet_d + wall_thickness * 6, wall_thickness],
                rounding=wall_thickness,
                edges=[x + FRONT, x + BACK],
              );
            }

            for (y = [BACK, FRONT]) {
              left(box_x / 6 * (x == LEFT ? 1 : -1)) {
                attach(y, y * -1, inside=true, overlap=-wall_thickness) {
                  cuboid(
                    [magnet_d + wall_thickness * 6, magnet_d + wall_thickness * 4, wall_thickness],
                    rounding=wall_thickness,
                    edges=[y + LEFT, y + RIGHT],
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

module box_box_hole_cluster() {
  magnet_post_x = magnet_d + wall_thickness * 2;
  box_hole_z_count = floor((box_z - box_hole_z_margin * 2) / (box_hole_z + box_hole_z_gap));
  box_hole_x_count = floor(( (box_x - magnet_post_x * 2 - box_hole_x_margin * 6) / 3) / (box_hole_x + box_hole_x_gap));

  up(( (box_hole_z + box_hole_z_gap) * box_hole_z_count) / 2) {
    left(( (box_hole_x + box_hole_x_gap) * box_hole_x_count) / 2) {
      for (z = [0:box_hole_z_count]) {
        down((box_hole_z + box_hole_z_gap) * z) {
          for (x = [0:box_hole_x_count]) {
            right((box_hole_x + box_hole_x_gap) * x) {
              cuboid([box_hole_x, box_y + fuzz * 2, box_hole_z], rounding=box_hole_z / 2, edges=["Y"]);
            }
          }
        }
      }
    }
  }
}

back(box_y * 0.6) box();
fwd(box_y * 0.6) lid();
