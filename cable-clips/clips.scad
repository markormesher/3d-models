ring_radius = 3;
ring_thickness = 1;
ring_angle = 260;

label_thickness = 1.5;
label_width = 8;
text_size = 4;
text_depth = 0.5;

height = 8;

numbers = [1, 2, 3, 4, 5];
rows = ceil(sqrt(len(numbers)));

for (i = [0:len(numbers) - 1]) {
  x_offset = (i % rows) * ring_radius * 4;
  y_offset = floor(i / rows) * ring_radius * 4;

  translate([x_offset, y_offset, 0]) {
    difference() {
      union() {
        // C-shaped clip
        rotate([0, 0, (360 - ring_angle) / 2]) {
          rotate_extrude(angle=ring_angle, $fn=64) {
            translate([ring_radius, 0, 0]) {
              square(size=[ring_thickness, height]);
            }
          }
        }

        // label block
        translate(
          [
            (ring_radius + label_thickness) * -1,
            label_width * -0.5,
            0,
          ]
        ) {
          cube(size=[label_thickness, label_width, height]);
        }
      }

      // numbers
      translate(
        [
          (ring_radius + label_thickness - text_depth) * -1 - 0.01,
          0,
          height * 0.5,
        ]
      ) {
        // flip orientation to match label block
        rotate([90, 0, -90]) {
          linear_extrude(height=text_depth) {
            text(str(numbers[i]), size=text_size, font="Helvetica", halign="center", valign="center");
          }
        }
      }

      // underline
      translate([(ring_radius + label_thickness) * -1 - 0.01, -0.5, 1]) {
        cube([text_depth, 1, 0.5]);
      }
    }
  }
}
