# Pre-flight: install `sbx` & confirm the toolchain

Every exercise depends on `sbx` running correctly on **your host machine**. Do
not skip this section.

---

## What you'll need

| Requirement | Notes |
|---|---|
| **macOS Apple Silicon** or **Windows 11 (x86_64)** | the sbx runtime does not emulate - your host arch *is* the sandbox arch |
| **Docker** with **`docker buildx`** | bundled with modern Docker Desktop / Rancher Desktop; the daemon must be running to build the kit |
| The **`sbx` CLI** | installed below |
| A **Box developer token** | free, ~60 min lifetime - we get one in Lab 2 |
| *(optional)* the real **`box-mount` binary** | a one-command mock lets you complete every build/validate/compose step without it |

> Docker Desktop is **not** required to *run* `sbx` - but you **do** need a
> Docker daemon with `buildx` to *build* this kit. Docker Desktop or Rancher
> Desktop both work.

---

## Step 1 - The repo is already here

This Labspace cloned the workshop repo into your project directory on startup.
Switch to it in the terminal:

```bash
cd ~/sbx-kits-box-demo || cd "$(find ~ -maxdepth 3 -type d -name sbx-kits-box-demo 2>/dev/null | head -1)"
pwd
```

From here on, **all commands assume you're in `sbx-kits-box-demo`**. Have a look around:

```bash
ls box-mount          # the Kit v3: descriptor, overlay recipe, agent context
ls scripts            # build/publish helper + optional mock-binary stager
```

---

## Step 2 - Install the `sbx` CLI

**macOS (Apple Silicon):**

```bash no-run-button
brew install docker/tap/sbx
```

**Windows 11 (x86_64)** - enable the hypervisor (elevated PowerShell, restart when prompted), then install:

```powershell no-run-button
Enable-WindowsOptionalFeature -Online -FeatureName HypervisorPlatform -All
winget install -h Docker.sbx
```

---

## Step 3 - Sign in and set a network policy

```bash no-run-button
sbx login
```

On your **very first run** the daemon asks for a default network policy. Choose
**Balanced** (default-deny with common dev hosts allowed) - this kit adds the
Box hosts it needs on top, via its `network-policy@1` capability.

---

## Step 4 - Confirm the toolchain

```bash
sbx version                 # sbx CLI present
docker version              # the SERVER section must be present (daemon running)
docker buildx version       # buildx present (needed to build the kit)
```

> If `docker version` shows no **Server** section, start Docker/Rancher Desktop
> before continuing - the kit build fails silently if the daemon is down.

> **Checkpoint:** `sbx version`, `docker version` (Server present), and
> `docker buildx version` all succeed.
