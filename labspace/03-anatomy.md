# Lab 1 - Anatomy of a Kit v3

*(~15 min - read the files you'll build)*

Open the three files in `box-mount/`. This is the entire kit.

```bash
ls -la box-mount
```

---

## 1.1 The descriptor - `box-mount/box-mount.yaml`

View it:

```bash
cat box-mount/box-mount.yaml
```

The first line is special:

```yaml
# syntax=docker/sandbox-kit:3
```

That tells BuildKit to pull the **kit frontend**, which validates the descriptor
and assembles the kit. The header block declares what the kit *is*:

```yaml
schemaVersion: "3"
kind: mixin                       # adds a capability onto a workload
displayName: Box Mount (two-way folder sync)
version: "0.4.0"                  # == the box-mount client version it ships
```

Then **three typed capabilities**:

**1. `network-policy@1`** - the Box hosts the client is allowed to reach. v3 is
**phase-scoped**: these live under `runtime:` (the running agent), and an absent
phase grants nothing. `*` matches a **single** DNS label - that's why
`*.realtime.services.box.net` is listed separately from `*.services.box.net`.

**2. `credential@1`** - the heart of the security model:

```yaml
- type: com.docker.sandbox/credential@1
  optional: true                  # sandbox still starts without a token
  config:
    service: box                  # matches `sbx secret set box`
    phase: runtime
    apiKey:
      name: BOX_ACCESS_TOKEN
      proxyManaged: true          # ← the real token stays on the host
      inject:                     # proxy adds this header on these hosts only
        - { domain: api.box.com,     header: Authorization, format: "Bearer %s" }
        - { domain: upload.box.com,  header: Authorization, format: "Bearer %s" }
        - { domain: dl.boxcloud.com, header: Authorization, format: "Bearer %s" }
```

`proxyManaged: true` keeps the real token out of the container. Every `inject`
domain **must** also appear in the same phase's `allow` list.

**3. `agent-context@1`** - instructions handed to the agent, pulled from a file
(`contentFile: ./box-mount-context.md`).

---

## 1.2 The overlay - `box-mount/box-mount.dockerfile`

This is what v3 adds over v2: a mixin's **own content**.

```bash
cat box-mount/box-mount.dockerfile
```

```dockerfile
FROM scratch                      # overlay only - no base, no ENTRYPOINT
ARG TARGETARCH                    # amd64 | arm64, set per-platform by buildx
COPY --chown=root:root --chmod=0755 bin/linux/${TARGETARCH}/box-mount /usr/local/bin/box-mount
COPY --chown=root:root --chmod=0755 bin/linux/${TARGETARCH}/box-mount /usr/local/bin/agent-mount
ENV BOX_ACCESS_TOKEN="proxy-managed"   # the sentinel the proxy rewrites
```

Three things to notice:

- `FROM scratch` - the overlay is *just* the binary + the `ENV`; it lands on top
  of whatever workload you compose it onto. **No ENTRYPOINT** - the workload
  keeps its own launch command.
- `${TARGETARCH}` picks the right binary per arch, so one build serves both.
- The binary is installed under **two** names: `box-mount` (required - its
  `mount` command self-invokes a `box-mount` helper on PATH) and `agent-mount`
  (alias).

---

## 1.3 The agent context - `box-mount/box-mount-context.md`

```bash
cat box-mount/box-mount-context.md
```

Plain instructions the agent reads: how to mount/status/unmount, and the rule
that auth is pre-wired through the proxy (so **don't** run `box-mount config`).

> **Checkpoint:** point to the one line that keeps the real token on the host
> (`proxyManaged: true`) and the one line that makes the kit arch-agnostic
> (`ARG TARGETARCH`).
