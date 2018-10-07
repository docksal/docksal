---
title: "Apache Solr"
---


## Docksal configuration

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


## Drupal configuration

Enable all required by your version of Drupal modules for the Apache Solr search integration.

For Apachesolr module add your Solr server using following server url:

```
http://solr:8983/solr
```

For the Search API module use these values:

| Name | Value |
|---|---|
| Protocol | `HTTP` |
| Host | `solr` |
| Port | `8983` |
| Solr path | `/solr` |
| Solr core | `collection1` |


## Updating Solr configuration

Say you need to update your `schema.xml` or other configuration.

You can put all your custom Solr config files to the `.docksal/etc/solr/conf` folder:

![Screenshot](/images/apache-solr-conf-folder.png?classes=inline)

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
docksal/solr:solr4
docksal/solr:solr3
docksal/solr:1.0-solr4
docksal/solr:1.0-solr3
docksal/solr:4.x
docksal/solr:3.x
```

Legend: 

- `solr4` - the latest stable `Solr 4` image versions
- `1.0-solr4` - stable `Solr 4` image version `1.0`
- `solr:4.x` - `Solr 4` development image version  
