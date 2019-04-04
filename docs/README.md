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

Before starting, you must install the [Learn Theme](https://github.com/docksal/hugo-theme-learn). This can be done by running `git submodule update` within the local repository.

To have submodules pulled automatically in the future set this within your global git configuration.

```
git config --global submodule.recurse true
```

Run `make serve` and point your browser to http://localhost:1313 to open the site. Building is done via a docker container. Docker binary is expected in $PATH (see below if you use Docker via VirtualBox).

Other available `make` commands (`make` required):

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

### Building without Docker binary on local

If you use Docksal via VirtualBox, then `fin docker` command can be used as a replacement for Docker binary:

```bash
DOCKER="fin docker" make serve
```

In this case to access the site you would use the IP address assigned to your VirtualBox machine (i.e., http://192.168.64.100:1313).
