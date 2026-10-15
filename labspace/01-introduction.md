# Build a Docker Sandboxes Kit: The Box Mount Kit

Welcome! In the next 90 minutes you'll **build, run, verify, and publish** a
**Kit v3** that brings Box's **Box Mount** client into a Docker Sandbox -
mounting a Box folder into an isolated microVM and keeping it in two-way sync,
with the Box token injected by the sandbox proxy so **the real token never
enters the container**.

> This Labspace runs **locally**. `sbx` executes on *your own host* (Apple
> Silicon or Windows 11 x86_64) because it uses real microVMs and does **not**
> emulate. The browser terminal to the right runs on your host - everything you
> type there is a real command on your machine.

---

## What you'll learn

By the end you'll be able to:

- Explain how a Docker Sandbox isolates an agent and how its **proxy injects credentials** without leaking them
- Read and write a **Kit v3 descriptor** - the `network-policy@1`, `credential@1`, and `agent-context@1` capabilities
- Understand why a **v3 mixin carries its own overlay** (removing the v2 `sbx template load` step)
- Stage a private binary into a kit **build context** and bake it into a `FROM scratch` overlay
- **Validate**, **build**, **run**, and **conformance-check** (`kit-tck`) a kit
- Prove the **security model**: the real Box token stays on the host; the container only ever sees a sentinel
- **Publish** the kit as a single OCI image to a private registry

---

## How Docker Sandboxes and kits work

**Docker Sandboxes** (`sbx`) run an AI agent - or a plain shell - inside a
lightweight **microVM**: its own Linux kernel, its own private Docker daemon,
and your workspace directory live-mounted in. Everything the agent does is
contained; nothing escapes to your host, your other containers, or any network
destination you haven't explicitly allowed.

All outbound HTTP/HTTPS traffic leaves the VM through a **host-side proxy**. The
proxy does two jobs that matter for this workshop:

1. **Network policy** - it only lets the VM reach hosts you've allowed.
2. **Credential injection** - it rewrites outgoing request headers to add a real
   secret that lives on the host. The agent sends a placeholder (`proxy-managed`);
   the proxy swaps in the real value on the wire. **The container never sees the
   real token.**

### What a *kit* is

A **kit** packages a capability and layers it onto a sandbox. There are two kinds:

- **Workload** - the thing the sandbox runs (e.g. `docker/sbx-kit-shell`, a Claude agent).
- **Mixin** - adds a capability *onto* a workload. **Box Mount is a mixin.**

### Why Kit v3 (and why this kit ships its own binary)

The previous schema (v2) could declare policy and credentials but a mixin could
**carry no content** - kit file injection is capped at ~4 MB and the `box-mount`
binary is ~20-34 MB. So v2 baked the binary into a *separate* prebuilt image you
had to `sbx template load` first.

**Kit v3 lifts that limit:** a mixin carries its **own overlay**. The binary
ships *inside the kit*, so the kit is **one OCI image** that composes onto
**any** v3 workload - no separate image, no `sbx template load`.

| | v2 | **v3 (this kit)** |
|---|---|---|
| Kit is | a spec **+** a separately-built image | **one OCI image** (binary baked into the overlay) |
| Deliver binary | `build` → `sbx template load` | baked at build; **nothing to load** |
| Config | `permissions` / `credentials` / `environment` / `agentInstructions` | typed `capabilities[]` |
| Run | `sbx run shell --template … --kit ./ .` | `sbx run docker/sbx-kit-shell:1.0.0 --kit ./box-mount .` |

> **Checkpoint:** you can explain (a) what the proxy does with the Box token, and
> (b) why a v3 mixin can carry the binary but a v2 mixin could not.

When you're ready, move to the next section to get your toolchain ready.
