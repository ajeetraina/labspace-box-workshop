# Box Mount Kit — Labspace

A **90-minute, hands-on Labspace** that walks you through building, running,
verifying, and publishing a **Docker Sandboxes Kit v3** mixin for Box's
**Box Mount** client — mounting a Box folder into an isolated microVM with
two-way sync, where the Box token is injected by the sandbox proxy and **never
enters the container**.

Runs **locally** on each attendee's machine. The guide + terminal are served in
the browser; `sbx` executes on the host (it uses real microVMs and does **not**
emulate).

---

## Run it

```bash
git clone https://github.com/ajeetraina/labspace-box-workshop.git
cd labspace-box-workshop
bash start-labspace.sh
```

Then open **http://localhost:3030**. Stop with `bash start-labspace.sh down`.

### Prerequisites (per attendee)

| Requirement | Install |
|---|---|
| **macOS Apple Silicon** or **Windows 11 x86_64** | — (sbx does not emulate) |
| **Docker** + `buildx` | Docker Desktop or Rancher Desktop |
| **ttyd** | `brew install ttyd` (macOS) / `sudo apt install ttyd` |
| **sbx** CLI | `brew install docker/tap/sbx` |
| A **Box developer token** | [Box Developer Console](https://app.box.com/developers/console) (free, ~60 min) |

> No real `box-mount` binary? The workshop's `stage-mock-binary.sh` lets you
> complete every build/validate/compose step without it.

---

## For 40 people (local / BYO delivery)

- Each attendee runs this Labspace on **their own laptop** — `sbx` microVMs run
  per-host, so there is **no central capacity limit** and no per-seat cloud cost.
- Scaling to 40 (or 400) is trivial; the only requirement is that each laptop is
  **Apple Silicon or Windows 11 x86_64** with virtualization available (Intel
  Macs can't participate).
- Pre-stage the **mock binary** so nobody is blocked waiting on the real Box
  private-preview client.

---

## How it's wired

| File | Role |
|---|---|
| `compose.yaml` | includes `oci://dockersamples/labspace-content-dev` + the override |
| `compose.override.yaml` | clones [`sbx-kits-box-demo`](https://github.com/ajeetraina/sbx-kits-box-demo) into the attendee's project dir; points the interface at the **host** ttyd terminal |
| `labspace/labspace.yaml` | title, metadata, two host terminals, and the 9-lab section list |
| `labspace/*.md` | the step-by-step guide |
| `start-labspace.sh` | checks prereqs, starts ttyd on the host (:8085), brings up the Labspace |

The workshop **content/kit** lives in the companion repo
[`ajeetraina/sbx-kits-box-demo`](https://github.com/ajeetraina/sbx-kits-box-demo)
— this repo is the Labspace wrapper around it.

---

## Labs

1. Anatomy of a Kit v3
2. Get a Box token & stage the client
3. Validate & build the kit
4. Run it: compose the mixin onto a workload
5. Use Box Mount: two-way sync
6. Verify the security model 🔥
7. Conformance-check with `kit-tck`
8. Publish the kit
9. Clean up kit images (the right way)
