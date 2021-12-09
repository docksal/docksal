---
title: "Elastic Search"
aliases:
  - /en/master/tools/elastic-search/
  - /tools/elasticsearch/
---


Add the `elasticsearch` service under the `services` section in `.docksal/docksal.yml`:

```yaml
  # Elastic Search
  elasticsearch:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: elasticsearch
```

Apply new configuration with `fin project start` (`fin p start`).

Elastic Search will be exposed on a random port. Use `fin project status` to determine which port Elastic Search is exposed on, e.g.,

```
14:06:05 ~/Projects/drupal8
§ fin ps
         Name                        Command                  State                     Ports              
-----------------------------------------------------------------------------------------------------------
drupal8_cli_1             /opt/startup.sh supervisord      Up (healthy)   22/tcp, 3000/tcp, 9000/tcp       
drupal8_db_1              /entrypoint.sh mysqld            Up             0.0.0.0:32768->3306/tcp          
drupal8_elasticsearch_1   /usr/local/bin/docker-entr ...   Up             0.0.0.0:32770->9200/tcp, 9300/tcp
drupal8_web_1             httpd-foreground   
```

In the example above, Elastic Search port `9200` is exposed on the host as `32770` and can be accessed at `192.168.64.100:32770`.

## Assigning a Static Port

To have a static port assigned, override the `ELASTICSEARCH_PORT_MAPPING` variable in `.docksal/docksal-local.env`:

```
ELASTICSEARCH_PORT_MAPPING='9200:9200'
```
In this case, the current project elastic search will be accessible at `192.168.64.100:9200`.

## Persistent Settings

If a settings value for elastic search such as `max_map_count` needs to be set and persist
through project starts, you may need to make modifications for your environment.

### Docker for Mac

Edit then `git commit` the following file:

```
~/Library/Containers/com.docker.docker/Data/database/com.docker.driver.amd64-linux/etc/sysctl.conf
```

### Docker Machine (VirtualBox)

```
fin vm ssh
sudo touch /var/lib/boot2docker/bootlocal.sh
sudo chmod +x /var/lib/boot2docker/bootlocal.sh
echo 'sysctl -w vm.max_map_count=262144' | sudo tee -a /var/lib/boot2docker/bootlocal.sh
```