include <../BOSL2/std.scad>
include <shared.scad>

$fn = $preview ? 18 : 360;

tube(
  od1=136, id1=insert_od + 10,
  od2=130, id2=insert_od + 10,
  h=2,
);
