# Lab 3 - Validate & build the kit

*(~10 min)*

## Step 1 - Fast descriptor validation

This runs the kit frontend over your descriptor and resolves the overlay
**without producing an image** - the quickest way to catch a schema or path
error:

```bash
docker buildx build box-mount -f box-mount/box-mount.yaml --output type=cacheonly
```

A clean run means the descriptor is valid and the overlay recipe resolves. If
you see an error about a missing `bin/linux/<arch>/box-mount`, go back to Lab 2.

---

## Step 2 - Build the kit into an OCI layout

Now build the real artifact (binary baked in, descriptor attached) into a local
OCI layout - we'll conformance-check it in Lab 7. `PUSH=0` means build-only, no
registry:

```bash
PUSH=0 ./scripts/push-kit.sh mynamespace
```

This writes `/tmp/sbx-kit-box-mount-layout`. The `mynamespace` argument is only
used to name the image tag here; nothing is pushed.

> **Single-arch, faster:** add `PLATFORMS=linux/arm64` (or `linux/amd64`) before
> the command to build just your host's arch:
>
> ```bash no-run-button
> PUSH=0 PLATFORMS=linux/arm64 ./scripts/push-kit.sh mynamespace
> ```

Confirm the layout exists:

```bash
ls -la /tmp/sbx-kit-box-mount-layout
```

> **Checkpoint:** both commands succeed and `/tmp/sbx-kit-box-mount-layout` exists.
