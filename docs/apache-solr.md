# Enabling Apache Solr service

## Drude configuration

1. Add Apache Solr service to `docker-compose.yml`:

    Replace `<project_name>` with your project name.

    ```yml
    # Solr node
    # Uncomment the service definition section below to start using Solr.
    solr:
      hostname: solr
      image: blinkreaction/drupal-solr:3.x-stable
      environment:
        - DOMAIN_NAME=solr.<project_name>.drude
    ```

2. Apply new configuration with `dsh up`

## Drupal configuration

1. Enable all required Drupal modules for Solr search integration on your site  

2. Add your Solr server on page `admin/config/search/apachesolr/settings/add` with following server url: 

    Solr server URL: `http://solr.<project_name>.drude:8983/solr`
