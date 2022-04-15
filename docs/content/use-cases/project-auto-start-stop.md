---
title: "Project Auto Start/Stop"
weight: 1
---

Auto starting/stopping projects makes most sense with [Docksal Sandboxes](https://github.com/docksal/sandbox-server) 
(CI/CD environments). However, these features can be used in local environments as well.

## Auto-stopping Projects {#auto-stop}

Docksal can automatically stop a project after a period on inactivity. Project's activity is determined based on the log 
output of the `web` container. No requests to `web` container => no access logs in `web` container => project is idling. 
After idling for a period of time (configurable), the project is consider inactive and is stopped. 

Stopped projects do not consume compute resources (CPU and RAM) and only occupy disk space.

You may want to use auto stopping when you run multiple projects locally with limited hardware resources.

Auto stop feature is **disabled** by default in Docksal.

To enable the auto-stop feature and set project inactivity timeout (this is a global setting):

```bash
fin config set --global PROJECT_INACTIVITY_TIMEOUT="0.5h"
fin system reset
```

To disable the auto-stop feature (this is a global setting):

```bash
fin config set --global PROJECT_INACTIVITY_TIMEOUT="0"
fin system reset
```

## Auto-starting Projects {#autostart}

What happens when you need to access a stopped project? You can start the project manually with `fin project start`.
 
Alternatively, Docksal can automatically start the project upon an HTTP request to the project's virtual-host 
(e.g., accessing the project URL in a browser).

Auto start feature is **disabled** by default in Docksal.

To enable the auto-start feature (this is a global setting):

```bash
fin config set --global PROJECT_AUTOSTART="1"
fin system reset
``` 

To disable the auto-start feature (this is a global setting):

```bash
fin config set --global PROJECT_AUTOSTART="0"
fin system reset
``` 
