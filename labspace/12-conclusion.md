# Conclusion & Next Steps

You built a **Kit v3 mixin** from scratch: three typed capabilities, a `FROM
scratch` overlay that bakes a private binary per-arch, validated and
conformance-checked it, ran it by composing onto a stock shell workload, proved
the Box token never enters the container, published it as a single OCI image,
and learned how to clean it up without fighting Docker.

## The three ideas to take away

1. **A v3 mixin carries its own overlay** - no separate image, no `sbx template load`.
2. **The proxy injects credentials** - the container holds a sentinel (`proxy-managed`); the real token stays on the host.
3. **Capabilities are typed and phase-scoped** - `network-policy@1` / `credential@1` / `agent-context@1`, each granting only what its phase declares.

## Where to go next

Adapt this kit for another Box client or service - change the `allow` hosts, the
`service:` name, and the baked binary. The pattern is the same.

---

## Appendix - CLI quick reference

```bash no-run-button
# ── This kit ─────────────────────────────────────────────────────────────────
./scripts/stage-mock-binary.sh                    # optional: mock binary (no real sync)
docker buildx build box-mount -f box-mount/box-mount.yaml --output type=cacheonly   # validate descriptor
PUSH=0 ./scripts/push-kit.sh <ns>                 # build-only → /tmp/sbx-kit-box-mount-layout
kit-tck validate --layout /tmp/sbx-kit-box-mount-layout 0.4.0                        # conformance check
I_KNOW_THIS_IS_PRIVATE=1 ./scripts/push-kit.sh <ns>   # push (PRIVATE repo only)

# ── Run / compose ────────────────────────────────────────────────────────────
sbx run docker/sbx-kit-shell:1.0.0 --kit ./box-mount .            # compose local kit, interactive
sbx run docker/sbx-kit-shell:1.0.0 --kit ./box-mount -- <cmd>     # run one command, then exit

# ── Box Mount (inside the sandbox) ───────────────────────────────────────────
box-mount --version                               # (agent-mount is an alias)
box-mount mount "/home/agent/workspace/box" "<box-folder-id>"    # root folder = 0
box-mount status ; box-mount unmount "/home/agent/workspace/box"

# ── Secrets & policy (host-side) ─────────────────────────────────────────────
echo "<box-token>" | sbx secret set box           # store the Box token (service: box)
sbx secret ls ; sbx policy log [<sandbox>]

# ── Clean up ─────────────────────────────────────────────────────────────────
docker rmi -f <image-id>                           # force-remove a multi-tagged kit image
sbx rm --force <sandbox>                            # remove a sandbox
```

Thanks for building along! 🎉
