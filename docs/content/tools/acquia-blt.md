---
title: "Acquia BLT"

---

Acquia BLT (Build and Launch Tool) is an automation layer for building, testing, and deploying Drupal 8 applications. 
It uses a standardized composer-based template that was created from Acquia Professional Services’ best practices. 
It comes with a set of commands that facilitate development and automate repeated processes.

## Prerequisites
The composer package requirements for BLT require 2GB of RAM to install all components. To provide that RAM to composer 
inside the container, Virtual Box/Docker Desktop needs 3GB or more.

## Setting up BLT with Docksal

There are two ways to set up a BLT projects with Docksal:

### The Docksal Wizard (The Easy Way)

Use `fin project create` wizard and select `Drupal 8 (BLT Version)` from the list. This will download the 
[BLT Boilerplate Project](https://github.com/docksal/boilerplate-blt) and run the included `fin init` command.
This will download all composer require dependencies, set proper database settings for BLT, include the BLT
addon command, and install the Drupal site.

### The Manual Setup Process

You can [follow the documentation](https://docs.acquia.com/blt/install/alt-env/docksal/) to set up a BLT site with Docksal.

### A Detailed Explanation of the Manual Setup

We have a blog post on [Docksal and Acquia BLT](https://blog.docksal.io/docksal-and-acquia-blt-1552540a3b9f) that walks
through the manual setup process. It's a short 3 minute read.
