// =============================================================================
//  Shower Screen Driver  --  Rhino-style, for La Marzocco Linea Micra
// =============================================================================
//  This is a CAPTURE CUP, not a screwdriver. The whole shower screen seats
//  *into* the cup recess so it is held captive and centred; a central drive
//  feature engages the slot of the diffuser screw. Press the cup over the
//  screen, twist counter-clockwise: the screw backs out and the screen lifts
//  away captured in the cup (no dropped screen, no slipping, fingers clear of
//  the hot group). To refit, drop the screen + screw into the cup and twist
//  clockwise onto the group.
//
//  The back of the cup is a knurled knob with concave finger flats for grip.
//
//  TWO DRIVE OPTIONS (parameter `tip`):
//   - "plastic" : a fully-printed integral plastic drive bar (no extra parts)
//   - "hexbit"  : a socket that holds a standard 1/4" hex flat-/slotted-head
//                 screwdriver insert bit, so a steel tip drives the screw
//
//  Export:
//    openscad -o out.stl -D '$fn=160' -D 'tip="plastic"' shower-screen-driver.scad
//    openscad -o out.stl -D '$fn=160' -D 'tip="hexbit"'  shower-screen-driver.scad
//
//  Print orientation: as modeled the KNOB END is on the bed (z=0) and the cup
//  mouth faces UP; the plastic bar / bit socket runs up the centre. No
//  supports needed. (In use you flip it and press down onto the screen.)
// =============================================================================

/* [Drive option] */
tip = "plastic"; // ["plastic","hexbit"]

/* [Shower screen (LM OEM F.3.040.01 — Linea Micra)] */
screen_od        = 57.5;  // outer diameter of the shower screen (mm)
screen_rim       = 4.4;   // height of the screen's rim / dish wall (mm)
cup_clearance    = 0.8;   // diametral clearance so the screen slots in (mm)
cup_wall         = 3.0;   // wall thickness around the screen (mm)
cup_depth        = 12.0;  // internal cup depth (captures rim + screw head)

/* [Centre relief — clears the proud screw head] */
relief_dia       = 18.0;  // recess at the cup floor for the screw head (mm)
relief_depth     = 4.0;   // depth of that recess (mm)

/* [Plastic drive bar  (tip = plastic)] */
slot_width          = 2.8;  // measured screw slot width (mm)
slot_length         = 14.0; // slot length across the screw head (mm)
blade_fit_clearance = 0.30; // subtracted from blade thickness for fit (mm)
blade_width_margin  = 1.0;  // blade shorter than the slot by this (mm)
blade_protrusion    = 8.0;  // how far the bar stands up off the relief floor
blade_tip_chamfer   = 1.0;  // lead-in chamfer at the bar tip (mm)
blade_root_fillet   = 2.0;  // fillet where the bar meets the floor (mm)

/* [1/4" hex bit holder  (tip = hexbit)] */
bit_af          = 6.35;  // 1/4" hex across-flats (mm)
bit_clear       = 0.18;  // press-fit clearance across flats (mm)
bit_total_len   = 25.0;  // length of your insert bit (mm) (typical 25)
bit_protrusion  = 8.0;   // bit tip standing past the relief floor (mm)
pushout_dia     = 4.0;   // hole under the socket to knock the bit out (mm)

/* [Knob / grip] */
knob_height      = 24.0;  // height of the solid knob behind the cup (mm)
edge_round       = 2.5;   // rounded outer edges (mm)
mouth_chamfer    = 1.5;   // lead-in chamfer at the cup mouth (mm)

/* [Finger flats] */
flat_count       = 7;     // number of concave finger flats
flat_cut_radius  = 24;    // radius of the cylinder cut forming each flat (mm)
flat_depth       = 4;     // how deep each flat bites into the rim (mm)

/* [Knurl texture] */
knurl_count      = 32;    // number of fine vertical knurl ridges
knurl_depth      = 0.9;   // knurl groove depth (mm)

/* [Quality] */
$fn = 96;  // curve resolution (export final with -D '$fn=160')

// ----------------------------- derived --------------------------------------
cavity_dia  = screen_od + cup_clearance;
body_od     = cavity_dia + 2*cup_wall;
total_h     = knob_height + cup_depth + (body_od/8);   // knob + cup-wall section
cup_floor_z = total_h - cup_depth;                     // inner floor plane
relief_z    = cup_floor_z - relief_depth;              // recessed floor plane
blade_thk   = slot_width - blade_fit_clearance;
blade_span  = slot_length - blade_width_margin;
socket_depth = max(8, bit_total_len - bit_protrusion); // hex socket depth
eps         = 0.02;

assert(tip == "plastic" || tip == "hexbit",
       "tip must be \"plastic\" or \"hexbit\"");

// rounded rectangular bar footprint (4-cylinder hull), centred on origin
module bar_footprint(w, t, h) {
    cr = min(t/2, 1.0);
    hull() for (sx = [-1, 1], sy = [-1, 1])
        translate([sx*(w/2 - cr), sy*(t/2 - cr), 0])
            cylinder(r = cr, h = h);
}

// solid outer body with rounded top & bottom outer edges
module body_solid() {
    r = body_od/2;
    e = min(edge_round, r/4, total_h/6);
    rotate_extrude()
        offset(r = e) offset(delta = -e)
            square([r, total_h]);
}

module finger_flats() {
    r = body_od/2;
    for (i = [0 : flat_count - 1])
        rotate([0, 0, i*360/flat_count])
            translate([r - flat_depth + flat_cut_radius, 0, -1])
                cylinder(r = flat_cut_radius, h = knob_height + 1);
}

module knurl() {
    r = body_od/2;
    for (i = [0 : knurl_count - 1])
        rotate([0, 0, i*360/knurl_count])
            translate([r, 0, -1])
                cylinder(r = knurl_depth, h = knob_height + 1, $fn = 12);
}

// cup cavity + mouth chamfer + domed centre relief, bored from the top;
// plus the hex bit socket + push-out hole when tip == "hexbit"
module cavity_negative() {
    translate([0, 0, cup_floor_z])
        cylinder(d = cavity_dia, h = cup_depth + eps);
    translate([0, 0, total_h - mouth_chamfer])
        cylinder(d1 = cavity_dia, d2 = cavity_dia + 2*mouth_chamfer,
                 h = mouth_chamfer + eps);
    // domed/conical relief: clears the proud dome-head screw and self-centres
    translate([0, 0, relief_z])
        cylinder(d1 = relief_dia*0.55, d2 = relief_dia, h = relief_depth + eps);
    if (tip == "hexbit") {
        af = bit_af + bit_clear;
        // hex socket bored down from the relief floor into the knob
        translate([0, 0, relief_z - socket_depth])
            cylinder(h = socket_depth + eps, $fn = 6, r = af / cos(30) / 2);
        // small hole below it to push/knock the bit back out
        translate([0, 0, -eps])
            cylinder(d = pushout_dia, h = relief_z - socket_depth + 2*eps);
    }
}

// central plastic drive bar standing up from the relief floor (tip = plastic)
module drive_bar() {
    f  = blade_root_fillet;
    tw = blade_span - 2*blade_tip_chamfer;
    tt = blade_thk  - 2*blade_tip_chamfer*blade_thk/blade_span;
    hull() {
        translate([0, 0, relief_z]) bar_footprint(blade_span, blade_thk, eps);
        translate([0, 0, relief_z + f])
            bar_footprint(blade_span + 2*f, blade_thk + 2*f, eps);
    }
    hull() {
        translate([0, 0, relief_z]) bar_footprint(blade_span, blade_thk, eps);
        translate([0, 0, relief_z + blade_protrusion - blade_tip_chamfer])
            bar_footprint(blade_span, blade_thk, eps);
        translate([0, 0, relief_z + blade_protrusion - eps])
            bar_footprint(tw, tt, eps);
    }
}

// ------------------------------ assembly ------------------------------------
union() {
    difference() {
        body_solid();
        knurl();         // texture all around the knob...
        finger_flats();  // ...flats cut deeper, leaving knurl on the lobes
        cavity_negative();
    }
    if (tip == "plastic")
        intersection() {                 // keep the bar within the relief column
            drive_bar();
            translate([0, 0, relief_z - 1])
                cylinder(d = relief_dia - 0.5,
                         h = blade_protrusion + relief_depth + 2);
        }
}
