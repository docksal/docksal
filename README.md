# docker-fig-drupal
Docker and Fig based environment for Drupal

## Requirements
1. [Docker](https://www.docker.com/)
2. [Fig](http://www.fig.sh/)
3. Mac-only: [Boot2docker w/ NFS](https://github.com/blinkreaction/boot2docker-vagrant-nfs)

## Usage
 1. Clone this repo and copy `fig.yml` and `.docker` into your Drupal project folder (`</path/to/project>`).
 2. Make sure your docroot is in `</path/to/project>/docroot`
 3. `fig up -d`
 
