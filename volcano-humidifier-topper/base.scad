include <../BOSL2/std.scad>
include <shared.scad>

difference() {
  tube(id=insert_id, od=insert_od, h=insert_height, anchor=BOTTOM) {
    up(lip_1_lift) {
      attach(BOTTOM, BOTTOM, inside=true) {
        tube(
          id=insert_od - lip_1_size,
          od=insert_od + lip_1_size,
          h=lip_1_size * 2,
          chamfer=lip_1_size / 2,
        );
      }
    }

    up(lip_2_lift) {
      attach(BOTTOM, BOTTOM, inside=true) {
        tube(
          id1=insert_od, id2=insert_od,
          od1=insert_od, od2=insert_od + lip_2_size * 2,
          h=lip_2_size
        );
      }
    }

    up(lip_3_lift) {
      attach(BOTTOM, BOTTOM, inside=true) {
        tube(
          id=insert_od - lip_3_size,
          od=insert_od + lip_3_size,
          h=lip_3_size * 2,
          chamfer=lip_3_size / 2,
        );
      }
    }
  }

  union() {
    up(lip_2_lift + lip_2_size) {
      for (i = [0, 90, 180, 270]) {
        zrot(i) {
          translate([4, 4, 0]) {
            cuboid([insert_od, insert_od, 10], anchor=BOTTOM + LEFT + FRONT);
          }
        }
      }
    }
  }
}
