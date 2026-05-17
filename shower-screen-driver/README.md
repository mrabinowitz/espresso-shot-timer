# Shower Screen Driver (Rhino-style) — La Marzocco Linea Micra

A 3D-printable equivalent of the **Rhino Coffee Gear Screen Driver**: a
**capture cup**, not a screwdriver.

## What it is / how the real one works

The Rhino tool is "a piece of plastic with a little piece of metal." The
shower screen seats **into** a recessed cup so the whole screen is held
captive and centred while a central drive feature engages the slot of the
diffuser screw. Machine cool, you press the cup over the screen, turn
**counter-clockwise**, and the screw backs out with the screen captured in
the cup — no slipping, no screw dropped up into the group, fingers clear of
the hot group. To refit: drop the screen + screw into the cup, offer it to
the group, turn **clockwise**, withdraw. A bare flat screwdriver, by
contrast, only touches the slot, cams out, scratches the screen and can drop
the screw inside the group — the cup is the whole point.

(Sources: La Marzocco / noto-studio / The Kitchen Barista maintenance guides
confirm the Linea Micra screen (LM OEM F.3.040.01: 57.5 mm OD, 4.4 mm rim,
Ø7 mm centre hole) is held by a single central **slotted** diffuser screw,
removed with a flat-head; Rhino/WebstaurantStore
listings describe the cup + metal drive piece and the push-up / turn usage.)

## Two drive options (you pick — no random metal needed)

Set the `tip` parameter / pick the matching STL:

| `tip` | File | What you need | Notes |
|---|---|---|---|
| `"plastic"` | `shower-screen-driver-plastic.stl` | nothing — fully printed | Default. Print in PETG. Fine for a normally hand/coin-snug screw. |
| `"hexbit"` | `shower-screen-driver-hexbit.stl` | one **1/4" hex flat-/slotted-head screwdriver insert bit** (cheap, common) | Steel tip does the driving — robust for a stiff/scaled screw. |

The `hexbit` cup has a 1/4" hex socket at the base of the centre relief. Push
a standard slotted insert bit in (press-fit; add a dab of epoxy or drop a
6 mm magnet in the socket if you want it permanent). A small hole under the
socket lets you knock the bit back out. The bit's flat tip protrudes through
the relief to engage the screw slot; the cup keeps everything coaxial so it
can't cam out.

Export a variant yourself:

```
openscad -o out.stl -D '$fn=160' -D 'tip="hexbit"' shower-screen-driver.scad
```

## Print settings

- **Material:** PETG (recommended), Nylon/PA-CF, ABS or ASA. Avoid plain PLA
  (brittle, softens ~55 °C). Remove the screen with the machine **off and
  cooled** regardless.
- **Walls:** 4+; **infill:** 40–60 % (plastic-bar variant: 100 %, it's small).
- **Layer height:** 0.16 mm.
- **Orientation:** print **as exported** — knob end on the bed, cup mouth up,
  bar/socket up the centre. **No supports.**
- For the `plastic` bar, torque crosses the layer lines at the bar root (the
  root fillet helps). If it flexes or rounds over on a stiff screw, print the
  **`hexbit`** variant and drop in a steel bit.

## Fitting it to your machine

Defaults match the LM OEM screen F.3.040.01 (Linea Micra): `screen_od = 57.5`,
rim `screen_rim = 4.4`, centre hole Ø7; single slotted diffuser screw
`slot_width = 2.8`, `slot_length = 14`. They are
deliberately a touch loose (clearances + lead-in chamfers) so it seats without
forcing. If you have calipers, measure and adjust in the `.scad`, then
re-export:

- Screen won't seat in the cup → raise `cup_clearance`.
- Cup bottoms out before the screw engages → increase `cup_depth` or
  `relief_depth`.
- Plastic bar loose/tight in the slot → adjust `blade_fit_clearance`.
- Bit too loose/tight in the socket → adjust `bit_clear`.
- Bit tip not reaching the slot → increase `bit_protrusion` (re-export).

## Using it (Linea Micra)

1. Machine **off and fully cooled**; portafilter removed.
2. Press the cup squarely over the shower screen so the screen seats into the
   recess and the bar/bit drops into the screw slot.
3. Hold pressure, turn **counter-clockwise** to unscrew; lift away — screen +
   screw stay captured in the cup.
4. Clean/replace. To refit, put screen + screw in the cup, offer up, turn
   **clockwise**, snug only (do not over-tighten), withdraw the cup.

## Key parameters (`.scad`)

| Parameter | Default | Meaning |
|---|---|---|
| `tip` | "plastic" | `plastic` or `hexbit` |
| `screen_od` | 57.5 | Shower screen outer diameter |
| `screen_rim` | 4.4 | Screen rim / dish wall height |
| `cup_clearance` | 0.8 | Diametral clearance so the screen slots in |
| `cup_wall` | 3.0 | Wall thickness around the screen |
| `cup_depth` | 12.0 | Internal cup depth |
| `relief_dia` / `relief_depth` | 18 / 4 | Domed recess clearing the screw head |
| `slot_width` / `slot_length` | 2.8 / 14 | Screw slot (plastic-bar fit) |
| `blade_fit_clearance` | 0.30 | Bar fit + print tolerance |
| `blade_protrusion` | 8.0 | Plastic bar height off the relief floor |
| `bit_af` / `bit_clear` | 6.35 / 0.18 | 1/4" hex socket size + fit |
| `bit_total_len` / `bit_protrusion` | 25 / 8 | Your bit length; tip stand-off |
| `flat_count` | 7 | Concave finger flats on the knob |
| `knurl_count` / `knurl_depth` | 32 / 0.9 | Knurl texture on the lobes |

## Standalone repo

This folder is self-contained. To lift it into its own GitHub repo:

```
cp -r shower-screen-driver /path/to/new-repo && cd /path/to/new-repo
git init && git add . && git commit -m "Initial commit"
git remote add origin <your-new-repo-url> && git push -u origin main
```

## License

MIT — see `LICENSE`.
