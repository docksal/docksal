---
title: "Available Images versions"
weight: 6
---

## Understanding versions

Image tags follow the next pattern: `<image-repo>:<software-version>[-<image-stability-tag>][-<flavor>]`.

E.g. in `docksal/mysql:5.7-1.4` the `5.7` means the software version (in this case MySQL) and `1.4` means image stability tag.
Stability tag is an image version. Same software version might have several of them. 
Let's say we have added something to the MySQL 5.7 image (like a new default configuration), 
we would update the stability tag by `.1` in that case, but software version would remain the same.

Note: `cli` is a special case, `cli` itself is seen as software here with `-php...` being just a flavor of it. 

## CLI [![CLI on Docker hub](https://img.shields.io/badge/Docker%20Hub-gray.svg?logo=docker&style=flat-square&classes=inline)](https://hub.docker.com/r/docksal/cli/tags)

| Image| Notes |
|------|------|
| `docksal/cli:2.6-php7.3` | PHP 7.3 (v. 2.6) |
| `docksal/cli:2-php7.3`   | PHP 7.3 (latest image version, convenient when [extending images](/stack/extend-images.md))
| `docksal/cli:2.6-php7.2` | PHP 7.2 **(current default)** |
| `docksal/cli:2-php7.2`   | PHP 7.2 image (latest image version, convenient when [extending images](/stack/extend-images.md))
| `docksal/cli:2.6-php7.1` | PHP 7.1 (v. 2.6) |
| `docksal/cli:2.5-php7.0` | (deprecated) PHP 7.0 (v. 2.5) Might still work with quirks |
| `docksal/cli:2.5-php5.6` | (deprecated) PHP 5.6 (v. 2.5) Might still work with quirks |

## Apache [![Apache on Docker hub](https://img.shields.io/badge/Docker%20Hub-gray.svg?logo=docker&style=flat-square&classes=inline)](https://hub.docker.com/r/docksal/apache/tags)

| Image| Notes |
|------|------|
| `docksal/apache:2.4`     | Apache 2.4 (latest image version) |
| `docksal/apache:2.4-2.3` | Apache 2.4 (image version 2.3) |

## Nginx [![Nginx on Docker hub](https://img.shields.io/badge/Docker%20Hub-gray.svg?logo=docker&style=flat-square&classes=inline)](https://hub.docker.com/r/docksal/nginx/tags)

| Image| Notes |
|------|------|
| `docksal/nginx:1.15`     | Nginx 1.15 (latest image version) |
| `docksal/nginx:1.15-1.0` | Nginx 1.15 (v. 1.0) |
| `docksal/nginx:1.14`     | Nginx 1.14 (latest image version) |
| `docksal/nginx:1.14-1.0` | Nginx 1.14 **(v. 1.0, default)** |
| `docksal/nginx:1.13`     | Nginx 1.13 (latest image version) |
| `docksal/nginx:1.13-1.0` | Nginx 1.13 (v. 1.0) |
| `docksal/nginx:1.12`     | Nginx 1.12 (latest image version) |
| `docksal/nginx:1.12-1.0` | Nginx 1.12 (v. 1.0) |
| `docksal/nginx:1.11`     | Nginx 1.11 (latest image version) |
| `docksal/nginx:1.11-1.0` | Nginx 1.11 (v. 1.0) |

## MySQL [![MySQL on Docker hub](https://img.shields.io/badge/Docker%20Hub-gray.svg?logo=docker&style=flat-square&classes=inline)](https://hub.docker.com/r/docksal/mysql/tags)

| Image| Notes |
|------|------|
| `docksal/mysql:5.6`      | MySQL 5.6 (latest image version) |
| `docksal/mysql:5.6-1.4`  | MySQL 5.6 (v. 1.4, **default**) |
| `docksal/mysql:5.7`      | MySQL 5.7 (latest image version) |
| `docksal/mysql:5.7-1.4`  | MySQL 5.7 (v. 1.4) |
| `docksal/mysql:8.0`      | MySQL 8.0 (latest image version) |
| `docksal/mysql:8.0-1.4`  | MySQL 8.0 (v. 1.4) |

## Web [![Web on Docker hub](https://img.shields.io/badge/Docker%20Hub-gray.svg?logo=docker&style=flat-square&classes=inline)](https://hub.docker.com/r/docksal/web/tags)

**DEPRECATED:** Use docksal/apache or docksal/nginx instead

| Image| Notes |
|------|------|
| `docksal/web:apache2.4`     | Apache 2.4 |
| `docksal/web:2.2-apache2.4` | Same as Apache 2.4 |
| `docksal/web:apache2.2`     | Apache 2.2 |
| `docksal/web:2.2-apache2.2` | Same as Apache 2.2 |