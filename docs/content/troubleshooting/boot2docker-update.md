---
title: "Boot2Docker Update"
weight: 3
---

{{% notice warning %}}
BREAKING CHANGE
{{% /notice %}}

Docker 18.09 removed the deprecated `AUFS` filesystem support and made `overlay2` the default.
`AUFS` has been the default for a while and therefore most of the updates have been fine. Unfortunately, because
there doesn't seem to be a clear upgrade path for boot2docker-based VMs, the only suggestion we have is to destroy and
rebuild. This will not delete your project files but it will destroy the Docksal VirtualBox VM and rebuild it.
