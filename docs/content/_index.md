---
title: "Docksal"
---

![Docksal](/images/docksald.png)

# What is Docksal?

Docksal is a tool for defining and managing development environments. It uses Docker to create fully containerized environments, 
along with VirtualBox to support macOS and Windows. Its main feature is the inclusion of a command-line tool called `fin` that 
simplifies the management of all components.

Docksal comes preloaded with common development tools, e.g., Composer, PHP Code Sniffer, php-cli, node, npm, ruby, bundler, and python.
For Drupal and WordPress development, it comes with drush, Drupal Console, and WP-CLI. 

There is built-in support for Apache Solr, Varnish, Memcache, Selenium, and Behat. And since services are containerized with Docker, 
any other service needed for a project can be added.

## Key features

Docksal does more than simply manage containers. Below is a list of some of Docksal's key features. While it is not
limited to these features, we think you'll find these to be some of its main selling points.

- Fully [containerized environments](advanced/stack.md)
    - all projects stay separated from each other
    - each can have its own requirements
    - each can have different versions of the same service
    - each can be managed independently (start, stop, restart, trash, etc.)
    - each can be extended with any service you want
- [Zero-configuration](advanced/stack-config.md#zero-configuration) projects - with two commands you can be up and running with an AMP stack without
having to create or understand any configurations
- Easy to create [configurations](advanced/stack-config.md) to partially or fully override any defaults
- Tools such as drush, console, and WP-CLI are built-in so you don't need to have them installed locally
- Automatic virtual host configuration
- Support for [custom commands](fin/custom-commands.md) using any interpreter you want
- Easily [share your site](tools/ngrok.md) over the internet using ngrok. This lets show your project to others without having to 
move your project to a web host somewhere
