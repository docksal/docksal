# Docksal Documentation Website

This is the official Docksal Documentation website.

## Tooling

- [Markdown](https://commonmark.org/) - Lightweight markup language with plain text formatting syntax
- [Hugo](https://gohugo.io/) - Crazy-fast static website generator
- [Hugo Learn Theme](https://github.com/matcornic/hugo-theme-learn/) - Nice and clean documentation theme for Hugo
- [Netlify](https://www.netlify.com) - Continuous deployment and hosting on a global CDN network

## Directory structure

In a nutshell:

- `content` - documentation sources
- `public` - static website build (gitignored)

For more info, see [Directory Structure](https://gohugo.io/getting-started/directory-structure/) in Hugo docs.

## Building

Before starting, you must install the [Learn Theme](https://github.com/matcornic/hugo-theme-learn). This can be done by running `git submodule update` within the local repository.

Building and previewing docs is done via a docker container.

Run `make serve` and point your browser to http://localhost:1313 to open the site.

If you do not have Docker installed natively and are using VirtualBox, you can run using the `fin` commmand. When accessing, you would use the IP address assigned to your VirtualBox machine (i.e., http://192.168.64.100:1313).

```bash
DOCKER="fin docker" make serve
```

Available `make` commands (`make` required):

```bash
$ make
help                 Show this help
all                  Build site with production settings and put deliverables in ./public
build                Build site with production settings and put deliverables in ./public
build-preview        Build site with drafts and future posts enabled
test                 Test for broken links with htmltest
serve                Boot the development server
```

It is also possible to use a locally installed `hugo` binary. `hugo` version must match the version defined in `Makefile`.
