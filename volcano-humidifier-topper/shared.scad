$fn = $preview ? 18 : 180;

insert_id = 63;
insert_od = 65;
insert_height = 22;

lip_1_size = 0.8;
lip_1_lift = 4.5;

lip_2_size = 2;
lip_2_lift = 15;

lip_3_size = 1.2;
lip_3_lift = 19.5;

peg_height = insert_height - lip_2_lift - lip_2_size;

slop = 0.6;

module base_negative() {
  tube(od=insert_od + slop, id=insert_id - slop, h=peg_height + slop) {
    // lip groove
    up(lip_3_lift - lip_2_lift - lip_2_size) {
      attach(BOTTOM, BOTTOM, inside=true) {
        tube(
          id=insert_od - lip_3_size - slop,
          od=insert_od + lip_3_size + slop,
          h=lip_3_size * 2,
          chamfer=lip_3_size / 2,
        );
      }
    }

    attach(TOP, CENTER) {
      // pointed top to avoid bridges
      tube(od=insert_od + slop, id=insert_id - slop, h=insert_od - insert_id, chamfer=(insert_od - insert_id) / 2);
    }
  }
}
