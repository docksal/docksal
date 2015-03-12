# Public Access

In certain cases you may need to share or expose you local web server on the internet.
E.g. share access with a teammate or customer to demonstrate the work or discuss the progress.
Working with external web services that expect a callback URL is also generally not possible with a local environment.

## Welcome to ngrok!

ngrok creates a tunnel from the public internet **http://subdomain.ngrok.com** to a port on your local machine.
You can give this URL to anyone to allow them to try out a web site you're developing without doing any deployment.

## How to use

Uncomment the **share** service definition section in [`docker-compose.yml`](../../docker-compose.yml) to start using ngrok.

To get the *.ngrok.com address, check the container's logs:

    docker-compose logs share

The ngrok web inspection interface is running on port 4040. E.g. `http://192.168.10.10:4040`
