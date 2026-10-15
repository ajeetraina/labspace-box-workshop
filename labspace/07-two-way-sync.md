# Lab 5 - Use Box Mount: two-way sync

*(~10 min - needs the real binary and a valid token)*

> Using the **mock** binary? The commands below will print `MOCK: …` and not
> actually sync. Read along, then come back with the real binary for live sync.

Inside the sandbox shell, find a Box **folder id** - the number at the end of a
folder's URL on box.com (the root folder is `0`). Then:

```bash no-run-button
# <local-dir>: absolute path to sync into   <box-id>: the folder id (root = 0)
box-mount mount "/home/agent/workspace/box" "<box-folder-id>"
box-mount status
```

**Down-sync** - the mount lists the Box folder's files:

```bash no-run-button
ls /home/agent/workspace/box
```

**Up-sync** - a file created in the mount appears in Box within a few seconds:

```bash no-run-button
echo "hello from the sandbox" > /home/agent/workspace/box/e2e.txt
# now check box.com (or the Box API) - e2e.txt should appear in that folder
```

Unmount when done:

```bash no-run-button
box-mount unmount "/home/agent/workspace/box"
```

> **Do NOT run `box-mount config`** or write `~/.box-mount/box-config.json` -
> that starts an interactive OAuth/JWT handshake and flips the client out of the
> simple token mode the proxy relies on. Auth is already wired through the proxy.

> **Checkpoint:** a file you create in the mount shows up in Box (and vice-versa).
