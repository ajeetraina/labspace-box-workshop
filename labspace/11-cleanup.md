# Lab 9 - Clean up kit images (the right way)

*(~8 min - a real-world gotcha worth knowing)*

Kit images are easy to build and surprisingly easy to get *stuck* when deleting.
This lab shows why, and the one command that always works.

---

## Why deleting a kit image fails

The build tags **one image ID with multiple tags** - `:latest` **and** the
pinned `:0.4.0` - and often under more than one repository name
(`sbx-kit-box-mount` *and* `box-demo/sbx-kit-box-mount`). List yours:

```bash no-run-button
docker images | grep sbx-kit-box-mount
```

You'll see the **same short ID** on several rows. Now try to delete by ID:

```bash no-run-button
docker rmi <that-image-id>
# Error response from daemon: conflict: unable to delete <id> (must be forced)
#   - image is referenced in multiple repositories
```

Docker (and the **trash icon in Docker Desktop**, which deletes by ID) refuses
to remove an ID while multiple tags point at it. In the UI this surfaces as the
unhelpful *"An unhandled error occured. Your image(s) may not have been
deleted."*

A second trap: `docker rmi <name:tag>` can say **"No such image"** if you type
the wrong repository name - the real one may include a path segment like
`box-demo/`. Always copy the exact name from `docker images` first.

---

## The fix - force-delete by ID

The image **ID** is the one address that always resolves. `-f` clears every tag
on it and removes the image in a single command:

```bash no-run-button
docker rmi -f <image-id>
```

Or sweep every box-mount image regardless of repo/tag, by ID:

```bash no-run-button
docker images --format '{{.ID}} {{.Repository}}' \
  | grep sbx-kit-box-mount | awk '{print $1}' | sort -u | xargs -r docker rmi -f
```

---

## If a tag is *listed* but won't delete by name

On the **containerd image store** (Docker Desktop's default), a half-finished UI
deletion can leave a tag that shows in `docker images` but returns "No such
image" when you delete it by name. Reconcile the store:

```bash no-run-button
docker image prune -a -f     # sweep dangling / unreferenced
```

…then **restart Docker Desktop** (Quit → reopen) - the restart reconciles the
containerd store against its content and clears orphaned tag records. Last
resort for a truly wedged store: **Settings → Troubleshoot → Clean / Purge
data**.

> **Checkpoint:** you can delete a multi-tagged kit image with `docker rmi -f
> <id>`, and you know why the Docker Desktop trash icon failed.

---

## Clean up this workshop's sandboxes

Remove the sandboxes you created (force-skips the confirmation prompt):

```bash no-run-button
sbx ls                                   # find the ones you made
sbx rm --force <sandbox-name> [<name>…]  # or: sbx prune   (removes all stopped)
```
