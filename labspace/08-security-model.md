# Lab 6 - Verify the security model 🔥

*(~8 min - the payoff: prove the token never enters the container)*

Run each of these from your **host** terminal; `--` runs a single command inside
a fresh sandbox and exits.

**1. The binary is present and matches the runtime arch:**

```bash no-run-button
sbx run docker/sbx-kit-shell:1.0.0 --kit ./box-mount -- box-mount --version
```

**2. The in-container env var holds the *sentinel*, not the real token:**

```bash no-run-button
sbx run docker/sbx-kit-shell:1.0.0 --kit ./box-mount -- printenv BOX_ACCESS_TOKEN
# → proxy-managed
```

This is the proof: inside the sandbox, `BOX_ACCESS_TOKEN` is literally the
string `proxy-managed`. The real token never left your host keychain.

**3. Credential injection actually works** - a Box API call from inside the
sandbox returns `200`, because the proxy swapped the sentinel for your real
token on the wire (needs a valid `box` secret):

```bash no-run-button
sbx run docker/sbx-kit-shell:1.0.0 --kit ./box-mount -- \
  curl -s -o /dev/null -w '%{http_code}\n' https://api.box.com/2.0/users/me
# → 200
```

**4. See what the sandbox reached (and what was blocked):**

```bash no-run-button
sbx policy log            # or: sbx policy log <sandbox-name>
```

If a Box request gets blocked, this log shows the host - add it to the
`network-policy@1` `runtime.allow` list in the descriptor and rebuild.

> **Checkpoint:** step 2 prints `proxy-managed` **and** step 3 prints `200`. The
> container authenticated to Box without ever holding the real token.
