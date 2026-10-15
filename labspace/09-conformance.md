# Lab 7 - Conformance-check with `kit-tck`

*(~7 min)*

`kit-tck` is the kit **conformance suite** - it checks your built artifact
against the v3 spec (descriptor shape, overlay ownership rules, declared
version, etc.). Run it against the OCI layout you built in Lab 3, passing the
kit's version:

```bash
kit-tck validate --layout /tmp/sbx-kit-box-mount-layout 0.4.0
```

A passing run reports **✓ conforms**. Common things it catches:

- Overlay files not owned `0:0` or `1000:1000` (our `COPY --chown=root:root` satisfies this).
- A `version:` in the descriptor that doesn't match the `0.4.0` you pass here.
- Inject domains missing from the same phase's allow-list.

> If `kit-tck` isn't installed, this is the one tool you may need to obtain
> alongside `sbx`; skip this lab if it's unavailable and note it for follow-up.

> **Checkpoint:** `kit-tck validate … 0.4.0` reports the kit conforms.
