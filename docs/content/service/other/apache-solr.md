---
title: "Apache Solr"
aliases:
  - /en/master/tools/apache-solr/
  - /tools/apache-solr/
---

## Docksal Configuration

Add the `solr` service under the `services` section in `.docksal/docksal.yml`:

```yaml
# Solr
solr:
  extends:
    file: ${HOME}/.docksal/stacks/services.yml
    service: solr
```

Apply new configuration with `fin project start` (`fin p start`).

Use `http://solr.<VIRTUAL_HOST>/solr` to access the Solr web UI.

## Drupal Configuration

Enable all required by your version of Drupal modules for the Apache Solr search integration.

For Apachesolr module add your Solr server using following server url:

```
http://solr:8983/solr
```

For the Search API module use these values:

| Name      | Value         |
| --------- | ------------- |
| Protocol  | `HTTP`        |
| Host      | `solr`        |
| Port      | `8983`        |
| Solr path | `/solr`       |
| Solr core | `collection1` |

## Updating Solr Configuration

Say you need to update your `schema.xml` or other configuration.

You can put all your custom Solr config files to the `.docksal/etc/solr/conf` folder:

![Solr config folder structure](/images/apache-solr-conf-folder.png?classes=inline)

Then update your `.docksal/docksal.yml` to mount them in the `solr` service:

```yaml
# Solr
solr:
  hostname: solr
  image: ...
  volumes:
    - ${PROJECT_ROOT}/.docksal/etc/solr/conf:/var/lib/solr/conf:ro
```

Apply configuration changes with `fin project start` (`fin p start`).

## Versions

Run `fin image registry docksal/solr` to get a list of available image tags.

```bash
fin image registry docksal/solr
docksal/sorl:1.0-solr3 (deprecated)
docksal/sorl:1.0-solr4 (deprecated)
docksal/solr:5.5-2.0
docksal/solr:6.6-2.0
docksal/solr:7.5-2.0
```

Legend:

- `<image-repo>:<software-version>[-<image-stability-tag>][-<flavor>]`

## Multiple Solr Cores

To run multiple Solr cores, follow version specific instructions below.

### Solr 4

To set up multiple Solr cores for use with the [Drupal Search API Solr module](https://www.drupal.org/project/search_api_solr),
modify your `.docksal/docksal.yml` or `.docksal/docksal-local.yml` file with the following:

```yaml
services:
  solr:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: solr
    labels:
      io.docksal.virtual-host: solr-a.${VIRTUAL_HOST},solr-b.${VIRTUAL_HOST}
    volumes:
      - ${PROJECT_ROOT}/.docksal/etc/solr/a:/opt/solr/example/solr/a:ro
      - /var/lib/solr/a/data:rw
      - ${PROJECT_ROOT}/.docksal/etc/solr/b:/opt/solr/example/solr/b:ro
      - /var/lib/solr/b/data:rw
```

Create the file `.docksal/etc/solr/a/core.properties` for instance a with the contents:

```bash
name=a
dataDir=/var/lib/solr/a/data
```

Create the file `.docksal/etc/solr/b/core.properties` for instance b with the contents:

```bash
name=b
dataDir=/var/lib/solr/b/data
```

### Solr 6

Docksal current has Solr 4 defined in the Docksal images. For users with a need to use Solr 6.x, you can set this in
your `docksal.yml` file.

```yaml
solr:
  volumes:
    - ${PROJECT_ROOT}/.docksal/etc/solr/a:/opt/solr/server/solr/a:ro
    - ${PROJECT_ROOT}/../data/a/solr:/var/solr/a/data:rw
    - ${PROJECT_ROOT}/.docksal/etc/solr/b:/opt/solr/server/solr/b:ro
    - ${PROJECT_ROOT}/../data/b/solr:/var/solr/b/data:rw
  image: solr:6.6-alpine
```

Create the file `.docksal/etc/solr/a/core.properties` for instance a with the contents:

```bash
dataDir=/var/solr/a/data
```

Create the file `.docksal/etc/solr/b/core.properties` for instance b with the contents:

```bash
dataDir=/var/solr/b/data
```

The files in .docksal/etc/solr/a/conf and .docksal/etc/solr/b/conf will also need to be updated too. If you are upgrading
from another version of solr, then I suggest that you delete the contents of the data directory and re-index.

### Solr 8

Specify the image to use in the docksal.env file

```bash
SOLR_IMAGE='docksal/solr:8'
```

This can also be set with `fin config set`.

```bash
fin config set SOLR_IMAGE='docksal/solr:8'
```

```yml
---
version: "3.9"
services:
  # Solr 8
  solr:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: solr
```

- You will need to `fin project reset` to create the new mount (see yml above).
- Generate the solr core with

  ```
  docker exec -ti $(docker ps --filter "name=solr" '{{ .ID }}') solr create_core -c {{your_core_name}} -n {{your_core_name}}
  ```

Once you have configured your solr instance in the Drupal Admin, and then
exported the configuration (via `drush cex`) to a
search_api.server.{{server_name}}.yml file, then it can look similar to this

    ```yml
    id: solr_8_1_1
    name: solr
    description: ''
    backend: search_api_solr
    backend_config:
      connector: standard
      connector_config:
        scheme: http
        host: solr
        port: 8983
        path: /
        core: {{your_new_core_name}}
        timeout: 10
        index_timeout: 9
        optimize_timeout: 10
        finalize_timeout: 30
        commit_within: 1000
        solr_version: ''
        http_method: AUTO
        skip_schema_check: false
        jmx: false
        jts: false
        solr_install_dir: ''
      ```

Notice the path does NOT have /solr in it. The search_api_solr php code adds
that in there already so if you add in /solr the request will have /solr/solr in the path.
