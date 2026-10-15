# Lab 2 - Get a Box token & stage the client

*(~10 min)*

## Step 1 - Get a Box developer token

In the [Box Developer Console](https://app.box.com/developers/console), open (or
create) an app, then **Configuration → Generate Developer Token**. Copy it. It
lasts ~60 minutes - fine for this workshop; just regenerate if it expires.

> A developer token is the quickest path. An OAuth/JWT access token works too -
> this kit injects whatever access token you store as the `box` secret.

---

## Step 2 - Stage the `box-mount` binary

A kit's build context is **its own directory**, so the binary must live under
`box-mount/bin/linux/<arch>/`. These paths are git-ignored.

**If you have the real binary from Box** (the `box-mount-0.4.0-linux-<arch>.tar.gz` archives):

```bash no-run-button
# arm64 (Apple Silicon)
mkdir -p box-mount/bin/linux/arm64
tar xzf /path/to/box-mount-0.4.0-linux-aarch64.tar.gz -C box-mount/bin/linux/arm64
chmod +x box-mount/bin/linux/arm64/box-mount
file box-mount/bin/linux/arm64/box-mount     # sanity: ELF … ARM aarch64

# amd64 (Intel / Windows)
mkdir -p box-mount/bin/linux/amd64
tar xzf /path/to/box-mount-0.4.0-linux-x86_64.tar.gz -C box-mount/bin/linux/amd64
chmod +x box-mount/bin/linux/amd64/box-mount
file box-mount/bin/linux/amd64/box-mount     # sanity: ELF … x86-64
```

**Don't have the real binary yet?** Stage the workshop mock so every
build/validate step still works (sync won't actually run):

```bash
./scripts/stage-mock-binary.sh
```

Either way, confirm your host's arch has a binary staged:

```bash
uname -m                                       # x86_64 → amd64 ; arm64 → arm64
ls box-mount/bin/linux/*/box-mount
```

> **Why both arches?** The sbx runtime does **not** emulate - the image arch
> must match your host. Staging both lets one build serve Apple Silicon and
> Intel alike.

> **Checkpoint:** `ls box-mount/bin/linux/*/box-mount` lists a binary for at
> least your host's arch, and you have a Box token on your clipboard.
