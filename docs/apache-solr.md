# Enabling Apache Solr service

## Docksal configuration

Add the Apache Solr service to `.docksal/docksal.yml` under `services`.

```yml
# Solr
solr:
  hostname: solr
  image: docksal/solr:1.0-solr4
```

Run `fin up` to apply the new configuration.

## Drupal configuration

Enable all required by your version of Drupal modules for Solr search integration on your site.

For Apachesolr module add your Solr server using following server url:

```
http://solr:8983/solr
```

In case of Search API module use these values:

| Name | Value |
|---|---|
| Protocol | `HTTP` |
| Host | `solr` |
| Port | `8983` |
| Solr path | `/solr` |
| Solr core |  |

