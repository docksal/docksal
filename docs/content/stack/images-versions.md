---
title: "Stock Images Versions"
weight: 6
---

## Understanding Versions

Image tags follow the next pattern: 

    <image-repo>:<software-version>[-<image-stability-tag>][-<flavor>]

Take an example: `docksal/mysql:5.7-1.3`. 

`5.7` means software version, in this case MySQL 5.7. 

`1.3` means image stability tag. Stability tag is the image version. 
Same software version might have several image versions. 
Let's say we have added something to the MySQL 5.7 image (like a new default configuration), 
we would increase the stability tag to `1.4` in that case, but the software version `5.7` would remain the same,
resulting in `docksal/mysql:5.7-1.4` tag.

Note: `cli` is a special case, `cli` itself is seen as software here with `-php...` being just a flavor of it. 

## Latest image version

You may notice that there are two versions of the same, e.g.:

```
docksal/nginx:1.21
docksal/nginx:1.21-1.2
```

As described above `...-1.2` means image version here. `docksal/nginx:1.21` will always refer to the latest 
available image version. At some point, `docksal/nginx:1.21` is the same as `docksal/nginx:1.21-1.2`, but should
we release `docksal/nginx:1.21-1.3`, and `docksal/nginx:1.21` would refer to `docksal/nginx:1.21-1.3`, while
`docksal/nginx:1.21-1.1` would still exist for backwards compatibility. 

Having this latest image tag is a convenient shortcut, but in stacks that are delivered with Docksal, 
the exact version will always be used to avoid a situation when the newer image version was not pulled to your local.

In your custom stacks or custom Dockerfiles, you can use these latest image tags.

{{% notice info %}}
This page may not always show the latest image versions available because newer versions can be tagged between Docksal
releases. See [GitHub image repositories](https://github.com/docksal?q=service) for the list of releases with release notes or run `fin image registry <image>`, 
e.g., `fin image registry docksal/cli`, to see list of available CLI images. [See image commands](/fin/fin-help/#image)
{{% /notice %}}

## CLI

[![CLI on Github](https://img.shields.io/badge/Release%20notes-black.svg?logo=github&style=flat-square&classes=inline)](https://github.com/docksal/service-cli/releases)
[![CLI on Docker hub](https://img.shields.io/badge/View%20on%20Docker%20Hub-gray.svg?logo=docker&style=flat-square&classes=inline)](https://hub.docker.com/r/docksal/cli/tags)

| Image| Notes |
|------|-------|
| `docksal/cli:php8.0-3.0` | PHP 8.0, Nodejs 14.17.3, Ruby 2.5.5, Python 2.7.16, msmtp |
| `docksal/cli:php7.4-3.0` | *Default image* PHP 7.4, Nodejs 14.17.3, Ruby 2.7.2, Python 2.7.16, msmtp |
| `docksal/cli:php7.3-3.0` | PHP 7.3, Nodejs 14.17.3, Ruby 2.5.5, Python 3.8.3, msmtp |
| `docksal/cli:php8.0-3`    | Latest 3.x image version of PHP 8.0 flavor, convenient when [extending images](/stack/extend-images)
| `docksal/cli:php7.4-3`    | Latest 3.x image version of PHP 7.4 flavor, convenient when [extending images](/stack/extend-images)
| `docksal/cli:php7.3-3`    | Latest 3.x image version of PHP 7.3 flavor, convenient when [extending images](/stack/extend-images)
| `docksal/cli:2.13-php7.4` | PHP 7.4, Nodejs 14.15.0, Ruby 2.7.2, Python 3.8.3, msmtp |
| `docksal/cli:2.13-php7.3` | PHP 7.3, Nodejs 14.15.0, Ruby 2.7.2, Python 3.8.3, msmtp |
| `docksal/cli:2.11-php7.2` | *Deprecated* PHP 7.2, Nodejs 12.18.1, Ruby 2.7.1, Python 3.8.3, msmtp |
| `docksal/cli:2.10-php7.1` | *Deprecated* PHP 7.1, Nodejs 12.13.0, Ruby 2.6.5, Python 3.8.3, msmtp |
| `docksal/cli:2.5-php7.0`  | *Deprecated* PHP 7.0, mhsendmail |
| `docksal/cli:2.5-php5.6`  | *Deprecated* PHP 5.6, mhsendmail |

{{% notice warning %}}
v3 images use a new image tag naming convention, which aligns with the rest of the recent Docksal images. 
"2.13-php7.4" => "php7.4-3.0"
{{% /notice %}}

{{% notice info %}}
v3 images bundle stock Debian versions of Ruby and Python, thus there is a version drop for those compared to v2 images.
{{% /notice %}}

## Apache

[![Apache on Github](https://img.shields.io/badge/Release%20notes-black.svg?logo=github&style=flat-square&classes=inline)](https://github.com/docksal/service-apache/releases)
[![Apache on Docker hub](https://img.shields.io/badge/View%20on%20Docker%20Hub-gray.svg?logo=docker&style=flat-square&classes=inline)](https://hub.docker.com/r/docksal/apache/tags)

| Image| Notes |
|------|-------|
| `docksal/apache:2.4-2.4` | *Default* Apache 2.4 |
| `docksal/apache:2.4`     | Apache 2.4 (latest) |

## Nginx 

[![Nginx on Github](https://img.shields.io/badge/Release%20notes-black.svg?logo=github&style=flat-square&classes=inline)](https://github.com/docksal/service-nginx/releases)
[![Nginx on Docker hub](https://img.shields.io/badge/View%20on%20Docker%20Hub-gray.svg?logo=docker&style=flat-square&classes=inline)](https://hub.docker.com/r/docksal/nginx/tags)

| Image| Notes |
|------|-------|
| `docksal/nginx:1.21-1.2` | Nginx 1.21 (pinned version) |
| `docksal/nginx:1.21`     | Nginx 1.21 (latest version) |
| `docksal/nginx:1.20-1.2` | Nginx 1.20 (pinned version, default) |
| `docksal/nginx:1.20`     | Nginx 1.20 (latest version) |
| `docksal/nginx:1.15`     | Nginx 1.15 (legacy version) |
| ...                      | ... |

## MySQL 

[![MySQL on Github](https://img.shields.io/badge/Release%20notes-black.svg?logo=github&style=flat-square&classes=inline)](https://github.com/docksal/service-mysql/releases)
[![MySQL on Docker hub](https://img.shields.io/badge/View%20on%20Docker%20Hub-gray.svg?logo=docker&style=flat-square&classes=inline)](https://hub.docker.com/r/docksal/mysql/tags)

| Image| Notes |
|------|-------|
| `docksal/mysql:8.0-2.0`  | MySQL 8.0 (pinned version, default) |
| `docksal/mysql:8.0`      | MySQL 8.0 (latest version) |
| `docksal/mysql:5.7`      | MySQL 5.7 (legacy version) |
| ...                      | ... |

## MariaDB

[![MariaDB on Github](https://img.shields.io/badge/Release%20notes-black.svg?logo=github&style=flat-square&classes=inline)](https://github.com/docksal/service-mariadb/releases)
[![MariaDB on Docker hub](https://img.shields.io/badge/View%20on%20Docker%20Hub-gray.svg?logo=docker&style=flat-square&classes=inline)](https://hub.docker.com/r/docksal/mariadb/tags)

| Image| Notes |
|------|-------|
| `docksal/mariadb:10.3-1.1`     | MariaDB 10.3 (default) |
| `docksal/mariadb:10.3`         | MariaDB 10.3 (latest image version) |
| `docksal/mariadb:10.2-1.1`     | MariaDB 10.2 |
| `docksal/mariadb:10.2`         | MariaDB 10.2 (latest image version) |
| `docksal/mariadb:10.1-1.1`     | MariaDB 10.1 |
| `docksal/mariadb:10.1`         | MariaDB 10.1 (latest image version) |
| `docksal/mariadb:10.0-1.1`     | MariaDB 10.0 |
| `docksal/mariadb:10.0`         | MariaDB 10.0 (latest image version) |
| `docksal/mariadb:5.5-1.1`      | MariaDB 5.5 |
| `docksal/mariadb:5.5`          | MariaDB 5.5 (latest image version) |

## Apache Solr

[![Solr on Github](https://img.shields.io/badge/Release%20notes-black.svg?logo=github&style=flat-square&classes=inline)](https://github.com/docksal/service-solr/releases)
[![Solr on Docker hub](https://img.shields.io/badge/View%20on%20Docker%20Hub-gray.svg?logo=docker&style=flat-square&classes=inline)](https://hub.docker.com/r/docksal/solr/tags)

| Image| Notes |
|------|-------|
| `docksal/solr:8.1-2.1`      | Apache Solr 8.1 |
| `docksal/solr:8-2.1`        | Apache Solr 8.1 |
| `docksal/solr:8.1`          | Apache Solr 8.1 (latest image version) |
| `docksal/solr:7.7-2.1`      | Apache Solr 7.7 |
| `docksal/solr:7-2.1`        | Apache Solr 7.7 |
| `docksal/solr:7.7`          | Apache Solr 7.7 (latest image version) |
| `docksal/solr:7.5-2.1`      | Apache Solr 7.5 |
| `docksal/solr:7.5`          | Apache Solr 7.5 (latest image version) |
| `docksal/solr:6.6-2.1`      | Apache Solr 6.6 |
| `docksal/solr:6-2.1`        | Apache Solr 6.6 |
| `docksal/solr:5.5-2.1`      | Apache Solr 5.5 |
| `docksal/solr:5-2.1`        | Apache Solr 5.5 |


## Web 

**DEPRECATED:** Use `docksal/apache` or `docksal/nginx` instead

[![Web on Docker hub](https://img.shields.io/badge/View%20on%20Docker%20Hub-gray.svg?logo=docker&style=flat-square&classes=inline)](https://hub.docker.com/r/docksal/web/tags)

| Image| Notes |
|------|-------|
| `docksal/web:apache2.4`     | Apache 2.4 |
| `docksal/web:apache2.2`     | Apache 2.2 |
