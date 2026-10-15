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

## Requirements

- Each machine runs this Labspace locally; `sbx` microVMs run on the host, so no
  central infrastructure is needed.
- Each machine must be **Apple Silicon or Windows 11 x86_64** with
  virtualization available — `sbx` does not emulate, so Intel Macs are not
  supported.
- No real `box-mount` binary? Pre-stage the **mock binary** so the build,
  validate, and compose steps all work without it.

---

## How it's wired

| File | Role |
|---|---|
| `compose.yaml` | includes `oci://dockersamples/labspace-content-dev` + the override |
| `compose.override.yaml` | points the interface at the **host** ttyd terminal; sets `PROJECT_CLONE_URL` for cloud/standard mode |
| `labspace/labspace.yaml` | title, metadata, two host terminals, and the section list |
| `labspace/*.md` | the step-by-step guide (synced to the interface at `/instructions`) |
| `project/` | the hands-on kit (`box-mount/`, `scripts/`) — synced to the workspace at `/project` |
| `start-labspace.sh` | checks prereqs, starts ttyd on the host (:8085), brings up the Labspace |

This repo is **self-contained**: the guide (`labspace/`) and the kit it builds
(`project/`) ship together, mirroring the layout of
[`sbx-kits-box-demo`](https://github.com/ajeetraina/sbx-kits-box-demo).

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
