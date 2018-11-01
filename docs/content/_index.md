---
title: "Docksal"
aliases:
  - /en/master/
---

![Docksal logo](/images/docksal-mark-color.svg)

# What is Docksal?

Docksal is a tool for defining and managing web development environments. It uses Docker and Docker Compose to create 
fully containerized environments for your projects.

Running Docker on macOS and Windows is supported via VirtualBox as well as Docker for Mac / Docker for Windows. 

Docksal project stacks are pre-loaded with common development tools, which include Composer, PHP Code Sniffer, php-cli, node, npm, 
ruby, bundler, and python. For PHP, Drupal, and WordPress development, it comes with Drush, Drupal Console, and WP-CLI. 

There is built-in support for Apache Solr, Varnish, Memcache, Selenium, and Behat. 
Since services are containerized with Docker, any other service needed for a project can be added.

Docksal features a command-line tool called `fin` that simplifies the management of all components.

## Key features

Docksal does more than simply manage containers. Below is a list of some of Docksal's key features. While it is not
limited to these features, we think you'll find these to be some of its main selling points.

- Fully [containerized environments](/stack/config/)
    - all projects stay separated from each other
    - each can have its own stack requirements
    - each can have different versions of the same service
    - each can be managed independently (start, stop, restart, trash, etc.)
    - each can be extended with any service you want
- [Zero-configuration](/stack/config/#zero-configuration) projects - with two commands you can be up and running with 
an AMP stack without having to create or understand any configurations
- Easy to create [configurations](/stack/config/) to partially or fully override any defaults
- Tools such as Composer, Drush, Drupal Console, and WP-CLI are built-in so you don't need to have them installed on your host computer
- Automatic virtual host configuration and routing
- Support for [custom commands](/fin/custom-commands/) using any interpreter you want
- Easily [share your site](/tools/ngrok/) over the internet using ngrok, which lets show your project to others without 
having to move your project to a web host
