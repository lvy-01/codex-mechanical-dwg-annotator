# Conservative mechanical annotation rules

- Preserve source geometry, coordinates, units, layers, blocks, attributes, layouts, and existing annotations unless a change is required.
- Infer nominal geometry only from reliable visible/model entities. Do not dimension raster underlays or approximate splines without confirmation.
- Use first-angle projection by default for GB mechanical drawings, but honor an existing projection symbol or explicit user choice.
- Select the smallest standard sheet that fits views, annotations, title block, and reasonable margins at the chosen scale.
- Use continuous thick lines for visible outlines, dashed thin lines for hidden edges, chain thin lines for axes/centers, and continuous thin lines for dimensions, extension lines, hatching, and leaders.
- Keep dimension text readable from the sheet reading directions. Use consistent text height and arrow size scaled to paper space.
- Use the diameter symbol for cylindrical features and radius for arcs. Dimension repeated equal features with a count when unambiguous.
- Place dimensions in the view showing true shape. Avoid dimensioning to hidden lines when another view makes the feature clear.
- Do not repeat dimensions. Avoid closed chains unless a functional requirement demands them.
- Treat title-block metadata, tolerances, fits, datum references, geometric tolerances, roughness, coating, heat treatment, and material as engineering intent requiring evidence or user input.
- Keep a machine-readable annotation plan and execution log beside the output.

The bundled `机械制图国家标准体系.md` is a user-supplied index, not normative text.
