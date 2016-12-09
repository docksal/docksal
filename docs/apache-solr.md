# Enabling Apache Solr service

## Docksal configuration

1. Add Apache Solr service to `docksal.yml`:

    ```yml
    # Solr
    solr:
      hostname: solr
      image: docksal/solr:3.x-stable
    ```

2. Apply new configuration with `fin up`

## Drupal configuration

1. Enable all required Drupal modules for Solr search integration on your site  

2. Add your Solr server on page `admin/config/search/apachesolr/settings/add` with following server url: 

    Solr server URL: `http://solr:8983/solr`
