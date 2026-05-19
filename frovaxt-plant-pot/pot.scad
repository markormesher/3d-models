include <../BOSL2/std.scad>
include <../BOSL2/threading.scad>

$fn = $preview ? 18 : 180;

fuzz = 0.01;

wall_thickness = 1.5;

pot_id = 61;
pot_od = 72;
pot_h = 100;

thread_pitch = 2;
thread_slop = 0.2;
thread = [
  pot_id - wall_thickness * 2 - thread_slop * 4 - 2,
  pot_id - wall_thickness * 2 - thread_slop * 4 - 1,
  pot_id - wall_thickness * 2 - thread_slop * 4,
];
screw_h = 5;

left(pot_od * 0.6) {
  diff() {
    cyl(d=pot_id, h=screw_h, anchor=BOTTOM) {
      tag("remove") {
        threaded_rod(d=thread, pitch=thread_pitch, h=screw_h + fuzz * 2, internal=true, $slop=thread_slop + 0.05);
      }

      attach(TOP, BOTTOM) {
        tube(od=pot_id, id=pot_id - wall_thickness * 2, h=pot_h - screw_h) {
          attach(TOP, BOTTOM) {
            tube(od=pot_od, id=pot_id - wall_thickness * 2, h=wall_thickness);
          }
        }
      }
    }
  }
}

right(pot_od * 0.6) {
  diff() {
    cyl(d=pot_id, wall_thickness, anchor=BOTTOM) {
      attach(TOP, BOTTOM) {
        threaded_rod(d=thread, pitch=thread_pitch, h=screw_h);
      }

      tag("remove") {
        attach(TOP, BOTTOM, overlap=fuzz) {
          cyl(d=thread[0] - wall_thickness * 2, h=screw_h + fuzz * 2);
        }
      }

      tag("remove") {
        cyl(d=2, h=wall_thickness + fuzz * 2);
        arc_copies(n=8, r=pot_id / 6) {
          cyl(d=2, h=wall_thickness + fuzz * 2);
        }
        arc_copies(n=16, r=pot_id / 3) {
          cyl(d=2, h=wall_thickness + fuzz * 2);
        }
      }
    }
  }
}
