# Shower Screen Screwdriver (Rhino-style) — La Marzocco Linea Micra

A 3D-printable equivalent of the Rhino Coffee Gear Screen Driver: a one-piece
knurled knob with concave finger flats that drives the wide slotted
dispersion / shower-screen screw on a La Marzocco Linea Micra (also fits other
LM machines and any wide "coin-slot" screen screw).

Parametric OpenSCAD source plus ready-to-slice STLs.

## Files

| File | What it is |
|---|---|
| `shower-screen-driver.scad` | Parametric source. Edit the variables at the top. |
| `shower-screen-driver-printed.stl` | **Default.** Integral plastic blade. |
| `shower-screen-driver-steel.stl` | Knob with a pocket + cross-pin hole to capture a wide flat steel blade. |
| `shower-screen-driver-hex.stl` | Knob with a 1/4" hex socket for a slotted insert bit. |
| `preview-*.png` | Rendered previews of each variant. |

## Which variant?

The blade has to be thin (~2.5 mm) to enter the screw slot, so it can't be
made strong by making it thicker. Pick based on how hard your screw is:

- **`printed`** — easiest, no extra parts. Fine for a screw that comes out
  hand/coin-snug. Print in **PETG** (or Nylon/ABS/ASA). Not plain PLA — it is
  brittle and softens around 55 °C.
- **`steel`** — **most robust, recommended if the screw may be scaled/seized.**
  The knob is just an ergonomic handle; a wide flat steel blade (a reground
  flat-blade screwdriver tip, or ground steel bar stock to the slot width)
  drops into the top pocket and is locked with a 3 mm / M3 pin or rod through
  the cross-hole. Steel strength *and* correct full-width slot engagement; the
  hot tip is metal so heat is irrelevant.
- **`hex`** — accepts a 1/4" slotted insert bit. Modular, but standard slotted
  bits are narrower than the wide LM slot, so they can cam out and chew the
  slot. Use only if that's what you have.

Export a variant yourself:

```
openscad -o out.stl -D '$fn=128' -D 'tip_mode="steel"' shower-screen-driver.scad
```

## Print settings

- **Material:** PETG (recommended), Nylon / PA-CF, ABS, or ASA. Avoid plain
  PLA. Always remove the screen with the machine **off and cooled**.
- **Walls/perimeters:** 4+ (5–6 for the `printed` blade).
- **Infill:** 40–60 % (or 100 % for the `printed` variant — it's small).
- **Layer height:** 0.16 mm.
- **Orientation:** Print **as exported** — the large flat face sits on the
  bed and the blade/socket points up. No supports needed.
- **Strength note (`printed`):** torque is carried across the layer lines at
  the blade root. The root fillet helps. For maximum strength you *can* instead
  lay the tool on its side and print the blade horizontally, but that needs
  supports and distorts the knurl/flats — only do this if the upright print
  fails. If it flexes or rounds over, print the **`steel`** variant.

## Fitting it to your screw

Defaults are best-known values for the LM Linea Micra dispersion screw:
`slot_width = 2.8 mm`, `slot_length = 14 mm`. They are intentionally a little
undersized (blade = slot − clearance, with a lead-in chamfer) so it seats
without forcing.

If you have calipers, measure your screw slot and set `slot_width` and
`slot_length` in the `.scad`, then re-export. If the printed blade is loose,
lower `blade_fit_clearance`; if it won't enter, raise it — reprint and check.

## Using it (Linea Micra)

1. Machine **off and fully cooled**. Remove the portafilter.
2. Seat the blade fully in the screw slot, press firmly so it doesn't cam out,
   turn counter-clockwise to remove the screw, then lift out the screen.
3. Clean / replace the screen. Reinstall: screen, then screw — **snug only**,
   do not over-tighten (it only needs to seal the screen).

## Key parameters (`.scad`)

| Parameter | Default | Meaning |
|---|---|---|
| `slot_width` | 2.8 | Screw slot width |
| `blade_fit_clearance` | 0.30 | Fit + print tolerance subtracted from blade |
| `slot_length` | 14 | Slot length across the head |
| `blade_width_margin` | 1.0 | Blade narrower than slot by this |
| `blade_length` | 12 | Blade protrusion |
| `blade_tip_chamfer` | 1.0 | Lead-in chamfer at the tip |
| `fillet_radius` | 3.0 | Blade↔knob root fillet |
| `tip_mode` | "printed" | `printed` / `steel` / `hex` |
| `handle_diameter` | 45 | Knob diameter |
| `handle_height` | 28 | Knob height |
| `flat_count` | 7 | Concave finger flats |
| `flat_depth` | 4 | Flat depth into the rim |
| `knurl_count` / `knurl_depth` | 28 / 0.9 | Knurl texture on the lobes |
| `steel_blade_width/thickness` | 13 / 2.6 | Your steel blade size (steel mode) |
| `crosspin_dia` | 3.2 | Retaining pin hole (3 mm / M3) |
| `hex_af` | 6.35 | 1/4" hex across-flats (hex mode) |

## Standalone repo

This folder is self-contained (own `.scad`, STLs, README, LICENSE,
`.gitignore`) and is committed as its own local git history here. To lift it
into its own GitHub repo later:

```
cp -r shower-screen-driver /path/to/new-repo && cd /path/to/new-repo
git init && git add . && git commit -m "Initial commit"
git remote add origin <your-new-repo-url> && git push -u origin main
```

## License

MIT — see `LICENSE`.
