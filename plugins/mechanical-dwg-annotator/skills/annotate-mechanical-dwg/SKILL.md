---
name: annotate-mechanical-dwg
description: Analyze and complete mechanical three-view DWG drawings by adding a suitable drawing frame, title block, center marks, dimensions, tolerances, surface-finish symbols, and drafting notes, then save a new DWG through a locally installed AutoCAD-compatible engine. Use for mechanical-industry DWG dimensioning, three-view annotation, drawing completion, or standards-based CAD cleanup when the user supplies a .dwg input.
---

# Annotate Mechanical DWG

Produce a new DWG; never overwrite the source. Use AutoCAD Core Console or another installed AutoCAD-compatible engine for every DWG write.

## Required inputs

- Require one readable `.dwg` containing aligned orthographic views.
- Ask only for missing decisions that cannot be recovered from geometry, title-block attributes, or the user's request: part name, drawing scale, sheet size, projection method, units, material, tolerances, and surface requirements.
- Default to millimetres, first-angle projection, an automatically selected GB sheet size, and blank title-block fields when choices are absent. State assumptions before final execution.

## Workflow

1. Create a dedicated working directory. Copy the source DWG there and preserve the original unchanged.
2. Locate `accoreconsole.exe`. Prefer the installed AutoCAD version. Run `scripts/run_autocad.ps1 -Mode inspect` to export an entity/bounds report.
3. Read `references/机械制图国家标准体系.md`. Treat it as a standards index, not as full normative text. Use `references/annotation-rules.md` for conservative implementation rules. Verify exact current clauses against an authoritative source before claiming compliance.
4. Compare view arrangement, layers, dimension style, title block, and scale with `assets/传动轴-template.dwg`. Use the template as a style/layout reference; never copy its part geometry or dimensions into an unrelated part.
5. Build an annotation plan before editing. Identify view bounding boxes and correspondence; choose functional baselines; list overall, locating, size, diameter/radius, chamfer, thread, and repeated-feature dimensions; flag ambiguous or duplicated dimensions.
6. Do not invent design intent. Geometry can justify nominal sizes and locations. It cannot justify fits, dimensional tolerances, datum schemes, geometric tolerances, material, heat treatment, roughness, or manufacturing notes. Omit or request those values.
7. Generate an AutoLISP file defining `C:APPLYANNOTATIONS`. Use explicit coordinates, layers, styles, and associative dimension commands or ActiveX entities. Put added objects on `DIM`, `CENTER`, `BORDER`, `TEXT`, and `SYMBOL` layers.
8. Run `scripts/run_autocad.ps1 -Mode apply -Plan <plan.lsp> -OutputDwg <new.dwg>`. Treat a fatal error, missing output, or unchanged timestamp as failure.
9. Re-run inspection on the output. Confirm expected layers and dimension entities exist, model geometry remains present, units are correct, and the output opens. When possible, plot a PDF and check overlaps, clipped text, crossing extension lines, and congestion.
10. Return the new `.dwg`, concise assumptions, and unresolved engineering decisions. Do not claim full GB compliance when only the bundled index was consulted.

## Annotation priorities

Apply overall and functional sizes first; feature locations second; diameters, radii, holes, threads, keyways, grooves, chamfers, and tapers third; centerlines next; then only user-supplied tolerances, fits, geometric tolerances, roughness, and process notes.

Prefer the view where a feature appears in true shape. Avoid duplicate, closed-chain, hidden-line, and purely derivable dimensions unless explicitly requested. Place dimensions outside view outlines where practical, with smaller dimensions nearest the view.

## AutoCAD execution

```powershell
& <skill>/scripts/run_autocad.ps1 -Mode inspect -InputDwg <input.dwg> -WorkDir <work>
& <skill>/scripts/run_autocad.ps1 -Mode apply -InputDwg <input.dwg> -WorkDir <work> -Plan <plan.lsp> -OutputDwg <output.dwg>
```

AutoCAD may require user approval to launch. If no compatible engine exists, stop and explain that this Skill cannot truthfully emit DWG; offer DXF only if the user accepts that change.

## Safety checks

- Keep operations local unless the user requests external lookup.
- Never run embedded macros or unknown LISP/VBA content from the source drawing.
- Load only the bundled inspector and generated annotation plan.
- Write to a new `.dwg` path and preserve a command log beside it.
