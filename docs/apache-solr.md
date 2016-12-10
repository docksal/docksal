# Enabling Apache Solr service

## Docksal configuration

### 1. Add Apache Solr service

Add Apache Solr service to `docksal.yml`

```yml
# Solr
solr:
  hostname: solr
  image: docksal/solr:3.x-stable
```

### 2. Apply new configuration

Run `fin up`

## Drupal configuration

### 1. Enable modules

Enble all required by your version of Drupal modules for Solr search integration on your site.

### 2. Add your Solr server

Add your Solr server on the `admin/config/search/apachesolr/settings/add` using following server url: `http://solr:8983/solr`
