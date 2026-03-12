$fn = $preview ? 18 : 180;

fuzz = 0.1;

pot_diameter = 62;
pot_height = 70;

wall_thickness = 1.5;

ear_count = 3;
ear_overhang = 9;
ear_inner_height = 10;
ear_locator_height = wall_thickness;
ear_locator_tolerance = 0.2;

drain_hole_diameter = 4;
drain_ring_radius_1 = pot_diameter / 2 * 0.33;
drain_ring_count_1 = floor(drain_ring_radius_1 * 2 * PI / (drain_hole_diameter * 3));
drain_ring_radius_2 = pot_diameter / 2 * 0.66;
drain_ring_count_2 = floor(drain_ring_radius_2 * 2 * PI / (drain_hole_diameter * 3));

module main_pot() {
  difference() {
    // outer shell
    cylinder(h=pot_height, r=pot_diameter / 2);

    // main void
    translate([0, 0, wall_thickness]) {
      cylinder(h=pot_height, r=pot_diameter / 2 - wall_thickness);
    }

    // first ring of drain holes
    for (i = [0:drain_ring_count_1]) {
      translate(
        [
          drain_ring_radius_1 * cos(360 / drain_ring_count_1 * i),
          drain_ring_radius_1 * sin(360 / drain_ring_count_1 * i),
          -fuzz,
        ]
      ) {
        cylinder(h=wall_thickness + fuzz * 2, r=drain_hole_diameter / 2);
      }
    }

    // second ring of drain holes
    for (i = [0:drain_ring_count_2]) {
      translate(
        [
          drain_ring_radius_2 * cos(360 / drain_ring_count_2 * i),
          drain_ring_radius_2 * sin(360 / drain_ring_count_2 * i),
          -fuzz,
        ]
      ) {
        cylinder(h=wall_thickness + fuzz * 2, r=drain_hole_diameter / 2);
      }
    }

    // cut-outs for ear locators
    for (i = [0:ear_count - 1]) {
      rotate([0, 0, 360 / ear_count * i]) {
        translate(
          [
            -pot_diameter / 2 - fuzz,
            -(wall_thickness + ear_locator_tolerance) / 2,
            pot_height - ear_locator_height - ear_locator_tolerance,
          ]
        ) {
          cube(
            [
              pot_diameter / 2 + fuzz,
              wall_thickness + ear_locator_tolerance,
              ear_locator_height + ear_locator_tolerance + fuzz,
            ]
          );
        }
      }
    }
  }
}

module ear() {
  // top ear surface
  difference() {
    cylinder(h=wall_thickness, r=ear_overhang + wall_thickness);

    translate([-pot_diameter / 2, 0, -fuzz]) {
      cylinder(h=wall_thickness + fuzz * 2, r=pot_diameter / 2 - wall_thickness);
    }
  }

  intersection() {
    translate([-pot_diameter / 2 + wall_thickness, 0, 0])
      // thin ring
      difference() {
        cylinder(h=ear_inner_height + wall_thickness, r=pot_diameter / 2 - wall_thickness);
        translate([0, 0, -fuzz]) {
          cylinder(h=ear_inner_height + wall_thickness + fuzz * 2, r=pot_diameter / 2 - wall_thickness * 2);
        }
      }

    translate([0, 0, -fuzz]) {
      cylinder(h=ear_inner_height + wall_thickness + fuzz * 2, r=ear_overhang + wall_thickness);
    }
  }

  // locator
  translate([-wall_thickness / 2, -wall_thickness / 2, wall_thickness]) {
    cube([wall_thickness * 1.5, wall_thickness, ear_locator_height]);
  }
}

main_pot();
for (i = [0:ear_count - 1]) {
  // overkill to space them nicely and centred, but who cares
  translate([pot_diameter, ear_overhang * 3 * i - (ear_overhang * 3 * (ear_count - 1) / 2), 0]) ear();
}
