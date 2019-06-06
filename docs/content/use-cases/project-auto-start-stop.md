---
title: "Project Auto Start and Auto Stop"
weight: 1
---

The feature of "auto stopping projects" is mostly used with Docksal Sandboxes - CI/CD environments. However, it can be
used in local environments as well. It can be desirable to set it locally when you have many projects and your resources 
are more limited.

Set the global variables to the desired time limit and reset the system:
```
fin config set --global PROJECT_INACTIVITY_TIMEOUT="0.5h"
fin system reset
```

But what happens when you need to use the project again? Docksal will [auto-start your project](https://blog.docksal.io/docksal-will-auto-start-your-existing-projects-1aa53676163c)
when you access it in your browser.
