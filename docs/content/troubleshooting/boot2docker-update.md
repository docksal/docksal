---
title: "Boot2Docker Update to 18.09"
weight: 1
---

{{% notice warning %}}
BREAKING CHANGE
{{% /notice %}}

Boot2Docker's update for Docker 18.09 removes the deprecated AUFS filesystem and makes Overlay2 the default.
AUFS has been the default for a while and therefore most of the updates have been fine. Unfortunately because
there doesn't seem to be a clear upgrade path for Boot2Docker the only suggestion we have is to destroy and
rebuild. This will not delete your project files but it will destory the Virtual Machine (VM) and rebuild it.
