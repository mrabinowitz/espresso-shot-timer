// =============================================================================
//  Shower Screen Screwdriver  --  Rhino-style, for La Marzocco Linea Micra
// =============================================================================
//  A one-piece knurled knob with concave finger flats (Rhino Screen Driver
//  style) that drives the wide slotted dispersion / shower-screen screw.
//
//  Fully parametric. Edit the values below, then export:
//    openscad -o out.stl -D '$fn=128' -D 'tip_mode="printed"' shower-screen-driver.scad
//
//  Print orientation: as modeled the large FLAT face is on the bed (z=0) and
//  the blade points UP (+Z) so it prints with no supports. In use you flip it:
//  palm on the flat face, blade down into the screw.
// =============================================================================

/* [Screw / blade fit] */
slot_width          = 2.8;   // measured width of the screw slot (mm)
blade_fit_clearance = 0.30;  // subtracted for fit + print tolerance (mm)
slot_length         = 14;    // length of the slot across the screw head (mm)
blade_width_margin  = 1.0;   // make blade narrower than the slot by this (mm)
blade_length        = 12;    // blade protrusion (mm)
blade_tip_chamfer   = 1.0;   // lead-in chamfer at blade tip (mm)
fillet_radius       = 3.0;   // fillet at blade<->knob junction (mm)

/* [Tip mode] */
// "printed" = integral plastic blade (default)
// "steel"   = pocket + cross-pin to capture a wide flat steel blade (robust)
// "hex"     = 1/4" hex socket for a slotted insert bit
tip_mode = "printed"; // ["printed","steel","hex"]

/* [Steel blade pocket  (tip_mode = steel)] */
steel_blade_width     = 13;   // width of your steel blade (mm)
steel_blade_thickness = 2.6;  // thickness of your steel blade (mm)
steel_pocket_depth    = 14;   // how deep the blade seats into the knob (mm)
steel_pocket_clear    = 0.25; // clearance per side in the pocket (mm)
crosspin_dia          = 3.2;  // transverse retaining-pin hole (3 mm rod / M3)

/* [Hex socket  (tip_mode = hex)] */
hex_af           = 6.35;  // 1/4" across-flats (mm)
hex_clear        = 0.30;  // socket clearance across flats (mm)
hex_socket_depth = 16;    // socket depth (mm)

/* [Knob] */
handle_diameter  = 45;   // knob diameter (mm)
handle_height    = 28;   // knob height (mm)
edge_round       = 2.5;  // rounded top & bottom outer edges (mm)

/* [Finger flats] */
flat_count      = 7;   // number of concave finger flats
flat_cut_radius = 22;  // radius of the cylinder cut that forms each flat (mm)
flat_depth      = 4;   // how deep each flat bites into the rim (mm)

/* [Knurl texture] */
knurl_count = 28;   // number of fine vertical knurl ridges
knurl_depth = 0.9;  // knurl groove depth (mm)

/* [Quality] */
$fn = 96;  // curve resolution (export final with -D '$fn=128')

// ----------------------------- derived --------------------------------------
blade_thickness = slot_width - blade_fit_clearance;
blade_width     = slot_length - blade_width_margin;
eps  = 0.02;
z0   = handle_height;          // top of knob = blade junction plane
fr   = min(fillet_radius, handle_diameter/2 - 1);

// rounded rectangular bar footprint (4-cylinder hull), centred on origin
module bar_footprint(w, t, h) {
    cr = min(t/2, 1.2);
    hull() for (sx = [-1, 1], sy = [-1, 1])
        translate([sx*(w/2 - cr), sy*(t/2 - cr), 0])
            cylinder(r = cr, h = h);
}

module knob_body() {
    r = handle_diameter/2;
    e = min(edge_round, r/3, handle_height/3);
    rotate_extrude()
        offset(r = e) offset(delta = -e)
            square([r, handle_height]);   // axis-aligned profile, x>=0
}

module finger_flats() {
    r = handle_diameter/2;
    for (i = [0 : flat_count - 1])
        rotate([0, 0, i*360/flat_count])
            translate([r - flat_depth + flat_cut_radius, 0, -1])
                cylinder(r = flat_cut_radius, h = handle_height + 2);
}

module knurl() {
    r = handle_diameter/2;
    for (i = [0 : knurl_count - 1])
        rotate([0, 0, i*360/knurl_count])
            translate([r, 0, -1])
                cylinder(r = knurl_depth, h = handle_height + 2, $fn = 12);
}

module knob() {
    difference() {
        knob_body();
        knurl();          // texture all around...
        finger_flats();   // ...flats cut deeper, leaving knurl on the lobes
    }
}

// integral printed blade (root fillet -> shaft -> chamfered tip), points +Z
module printed_blade() {
    // root fillet flaring into the knob underside
    hull() {
        translate([0, 0, z0 - eps]) bar_footprint(blade_width, blade_thickness, eps);
        translate([0, 0, z0 - fr])
            bar_footprint(blade_width + 2*fr, blade_thickness + 2*fr, eps);
    }
    // shaft + chamfered tip
    tipw = blade_width     - 2*blade_tip_chamfer;
    tipt = blade_thickness - 2*blade_tip_chamfer*blade_thickness/blade_width;
    hull() {
        translate([0, 0, z0]) bar_footprint(blade_width, blade_thickness, eps);
        translate([0, 0, z0 + blade_length - blade_tip_chamfer])
            bar_footprint(blade_width, blade_thickness, eps);
        translate([0, 0, z0 + blade_length - eps])
            bar_footprint(tipw, tipt, eps);
    }
}

// negative for the captured steel blade: through-pocket + cross-pin hole
module steel_cut() {
    pw = steel_blade_width     + 2*steel_pocket_clear;
    pt = steel_blade_thickness + 2*steel_pocket_clear;
    translate([0, 0, z0 - steel_pocket_depth])
        bar_footprint(pw, pt, steel_pocket_depth + eps);
    // cross-pin: through the knob, intersecting the pocket
    pin_z = z0 - steel_pocket_depth/2;
    translate([0, 0, pin_z]) rotate([90, 0, 0])
        cylinder(d = crosspin_dia, h = handle_diameter + 4,
                 center = true, $fn = 24);
}

// ------------------------------ assembly ------------------------------------
if (tip_mode == "printed") {
    union() { knob(); printed_blade(); }
} else if (tip_mode == "steel") {
    difference() { knob(); steel_cut(); }
} else if (tip_mode == "hex") {
    af = hex_af + hex_clear;
    difference() {
        knob();
        translate([0, 0, z0 - hex_socket_depth])
            cylinder(h = hex_socket_depth + eps, $fn = 6,
                     r = af / cos(30) / 2);
    }
} else {
    assert(false, "tip_mode must be \"printed\", \"steel\", or \"hex\"");
}
