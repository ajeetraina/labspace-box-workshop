# Lab 8 - Publish the kit

*(~5 min)*

A v3 kit is one OCI image - publishing is a single push. **But this image embeds
the private Box binary**, so the script refuses to push unless you explicitly
confirm the target repo is private:

```bash no-run-button
# ⚠️ push ONLY to a PRIVATE repo - a public image would expose the Box binary
I_KNOW_THIS_IS_PRIVATE=1 ./scripts/push-kit.sh <your-namespace>
#   → docker.io/<your-namespace>/sbx-kit-box-mount  :latest + :0.4.0
```

Then anyone cleared for that repo composes the kit straight from the registry -
no clone, no local binary:

```bash no-run-button
sbx run docker/sbx-kit-shell:1.0.0 --kit docker.io/<your-namespace>/sbx-kit-box-mount:0.4.0 .
```

> **Checkpoint:** the push prints `:latest` and `:0.4.0`, and you understand why
> the repo must be private.
