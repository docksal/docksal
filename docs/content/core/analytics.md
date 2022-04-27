---
title: "Stats and Analytics"
weight: 3
aliases:
  - /en/master/advanced/analytics/
---


Docksal reports minimal statistics (OS/version and `fin` version) via Google Analytics.

This helps us better understand our user base size and composition and prioritize the work on the project accordingly.

If you prefer not to share this minimal information, change your global configuration:

```
fin config set --global DOCKSAL_STATS_OPTOUT=1`
```