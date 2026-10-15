# Lab 4 - Run it: compose the mixin onto a workload

*(~10 min)*

## Step 1 - Store the Box token as a secret (host-side)

The secret lives in your host keychain; the proxy injects it. The service name
`box` matches `service: box` in the descriptor:

```bash no-run-button
echo "<paste-your-box-token>" | sbx secret set box
```

```bash
sbx secret ls                 # confirm a 'box' secret exists
```

> **Windows (PowerShell):** piping can mangle the token - run `sbx secret set
> box` with no pipe and paste it interactively instead.

---

## Step 2 - Compose the mixin onto a shell workload

You don't need to publish the kit to run it - point `--kit` at the local
directory and sbx builds it on demand and layers it onto a stock v3 shell
workload:

```bash no-run-button
sbx run docker/sbx-kit-shell:1.0.0 --kit ./box-mount .
```

This drops you into a shell **inside the sandbox**, with `box-mount` on PATH.
Try (inside the sandbox):

```bash no-run-button
box-mount --version           # agent-mount --version works too (it's an alias)
```

> With the **real** binary you'll see `box-mount 0.4.0`. With the **mock** you'll
> see `0.4.0 (MOCK - workshop placeholder)` - enough to prove the kit composed
> correctly; real sync needs the real binary.

Leave this sandbox shell open for the next lab (or exit with `exit` / `Ctrl-D`
and reconnect later).

> **Checkpoint:** `box-mount --version` runs *inside* the sandbox - the kit
> successfully layered the binary onto the shell workload.
