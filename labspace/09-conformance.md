# Lab 7 - Conformance-check with `kit-tck`

*(~7 min)*

`kit-tck` is the kit **conformance suite** - it checks your built artifact
against the v3 spec (descriptor shape, overlay ownership rules, declared
version, etc.).

## Step 1 - Install `kit-tck`

> **`kit-tck` does not ship with `sbx`** - it's a separate tool from the
> `sandbox-kit-spec` repo, installed with `go install`. You need a **Go
> toolchain** (`go version` should work).

```bash
go install github.com/docker/sandbox-kit-spec/v3/cmd/kit-tck@latest

# make sure Go's bin directory is on PATH, then confirm:
export PATH="$PATH:$(go env GOPATH)/bin"
kit-tck --version
```

> No Go toolchain? Install it (`brew install go` on macOS), or skip this lab and
> note it for follow-up - it validates the artifact but isn't required to run
> the kit.

## Step 2 - Validate the built artifact

Run it against the OCI layout you built in Lab 3, passing the kit's version:

```bash
kit-tck validate --layout /tmp/sbx-kit-box-mount-layout 0.4.0
```

A passing run reports **✓ conforms**. Common things it catches:

- Overlay files not owned `0:0` or `1000:1000` (our `COPY --chown=root:root` satisfies this).
- A `version:` in the descriptor that doesn't match the `0.4.0` you pass here.
- Inject domains missing from the same phase's allow-list.

> **Checkpoint:** `kit-tck validate … 0.4.0` reports the kit conforms.
