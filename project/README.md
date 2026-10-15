# Box Mount Kit — project files

This directory is the hands-on project for the **Box Mount Kit** Labspace. It is
self-contained: everything you build, run, and publish in the labs lives here.

```
box-mount/                 the Kit v3 mixin
  box-mount.yaml           descriptor (capabilities)
  box-mount.dockerfile     overlay recipe (bakes the box-mount binary)
  box-mount-context.md     agent context handed to the sandbox
scripts/
  push-kit.sh              build / publish the kit (PUSH=0 for build-only)
  stage-mock-binary.sh     stage a mock box-mount so builds work without the real binary
```

The real `box-mount` binary is a Box private-preview artifact and is **not**
included. Run `./scripts/stage-mock-binary.sh` to stage a mock so every
build / validate / compose step works, or drop the real binary under
`box-mount/bin/linux/<arch>/` (see Lab 2).
