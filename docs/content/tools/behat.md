---
title: "Behat"
---


## Setup

Add a custom `behat` command to your project.

>     .docksal/commands
>       \_ behat

See [docksal/drupal7-advanced/.docksal/commands/behat](https://github.com/docksal/drupal7-advanced/blob/master/.docksal/commands/behat) as an example.

## Expected folder structure

Docksal expects your Behat tests to be in the `tests/behat` folder of the project repo.

>     tests/behat
>       \_ bin/behat
>       \_ behat.yml
>       \_ composer.json
>       \_ composer.lock

See [docksal/drupal7-advanced](https://github.com/docksal/drupal7-advanced) repo for a working Drupal 7 + Behat setup or [docksal/qa-suite](https://github.com/docksal/qa-suite) for example of QA-oriented suite with Behat,  Selenium and Backstop with PhantomJS, SlimerJS plus CasperJS.


## Running tests

Run `fin behat` to launch Behat tests.

This will download Composer dependencies and run Behat using the pre-configured `docker` profile.


## Behat goutte driver

The basic configuration (see [behat.common.yml](https://github.com/docksal/drupal7-advanced/blob/master/tests/behat/behat.common.yml) as an example) 
uses goutte as the default driver. Goutte is a very basic browser emulator. It is much faster than real browsers, but also very limited. 
It can make HTTP requests, but does not parse CSS, execute JS, or do any rendering.

Goutte can be used in many cases and does not require additional configuration/installation.


## Behat Selenium2 driver

If your tests require javascript support, the `selenium2-driver` should be used. It can be set as the default one.
Selenium2 works with real browsers, using them as zombies for testing purposes. 
You get a standard, feature reach, real browser, with CSS styling, JS and AJAX execution - all supported out of the box.

The easiest way to add Selenium support is to use the stock Selenium docker images.  

To do this, add the `browser` service under the `services` section in `.docksal/docksal.yml`:

```yaml
# Browser
browser:
  hostname: browser
  image: selenium/standalone-chrome
  dns:
    - ${DOCKSAL_DNS1}
    - ${DOCKSAL_DNS2}
```

You can also use the Firefox image instead of Chrome: `selenium/standalone-firefox`.

After that you have to tell Behat to use Selenium.  
Add your Selenium configuration in `tests/behat/behat.yml`.

Example:

```yaml
# Docker profile.
# For use inside the CLI container in Docksal.
docker:
  extensions:
    Behat\MinkExtension:
      # URL of the site when accessed inside Docksal.
      base_url: http://web
      # Configure browser to be used. Browser must be available on wd_host.
      # Stick with chrome by default. It's 2x faster than firefox or phantomjs (your results may vary).
      browser_name: chrome
      selenium2:
        wd_host: http://browser:4444/wd/hub
        capabilities: { "browser": "chrome", "version": "*" }
    Drupal\DrupalExtension:
      drupal:
        # Site docroot inside Docksal.
        drupal_root: /var/www/docroot
      drush:
        # Site docroot inside Docksal.
        root: /var/www/docroot
```


## Behat selenium2 driver and VNC

If you use Selenium with a browser in a container, you can obtain the test screenshots, however you cannot see the browser itself.  
Sometimes it is very useful to watch the tests running in the browser (e.g., when you are creating a new test and want to see how it performs).  
In such cases, a [VNC](https://en.wikipedia.org/wiki/Virtual_Network_Computing) client can be used.

1) Install a VNC client on your computer (there are many versions for all platforms).  
2) Update the `browser` service configuration in the project's `.docksal/docksal.yml` file as follows:

```yaml
# Browser
browser:
  ...
  image: selenium/standalone-chrome-debug
  ports:
    - "5900:5900"
  ...
```

You have to use `selenium/standalone-chrome-debug` or `selenium/standalone-firefox-debug` images. They both include a VNC server.  

Use `192.168.64.100:5900` as the host and `secret` as the password in your VNC client.

Now if you connect with the VNC client and run behat tests, you will be able to see tests running in a browser inside the `browser` container.

Note: If you are working with several projects concurrently, it is a good idea to have a separate VNC port assigned per project (e.g., `5901:5900`, `5902:5900`, etc.).


## Integration with PhpStorm

It is possible to connect PhpStorm with the `cli` container and run behat tests from within PhpStorm.
PhpStorm uses ssh to connect to and use remote interpreters and tools.

1) Add the following line in `.docksal/docksal.yml` to expose the ssh server in the `cli`container:

```yaml
cli:
 ...
 ports:
   - "2223:22"
 ...
```

2) Update the container configuration with `fin project start` (`fin p start`).
3) You should now be able to connect to the `cli` container via ssh. Use username `docker` and password `docker`:

```bash
ssh docker@192.168.64.100 -p 2223
```

Note: If you are working with several projects concurrently, it is a good idea to have a separate SSH port assigned per project (e.g., `2222:22`, `2223:22`, etc.).

### Add a new deployment server

Open settings (menu item *File->Settings...*). In the opened window on the left side, select item *Build, Execution, Deployment->Deployment*:

![Screenshot](/images/behat-phpstorm-deployment-configure.png)

Create a new SFTP connection and fill-out the form. Don't forget to fill-out *Web server root URL*.
Press the *Test SFTP connection...* button and if everything is ok, you will see that test is successful.

On the second tab, you should check and correct the mapping:

![Screenshot](/images/behat-phpstorm-deployment-configure-mapping.png)

Local path is the path to your project on the host machine. Deployment path is `/var/www`.

### Add a new PHP interpreter

Open settings (menu item *File->Settings...*). In the opened window on the left side, select item *Languages & Frameworks->PHP*:

![Screenshot](/images/behat-phpstorm-PHP-configuration.png)

To add a new interpreter, click on **...** button on *Interpreter:* line.

![Screenshot](/images/behat-phpstorm-PHP-configuration-deployment.png)

In the opened window, add a new interpreter and choose the **Deployment configuration** option and deployment server from the select list (it should be server from previous step).

### Add a Behat interpreter configuration

Open settings (menu item *File->Settings...*). In the opened window on the left side, select item *Languages & Frameworks->PHP->Behat*:

![Screenshot](/images/behat-phpstorm-PHP-Behat-configuration.png)

Add a new PHP interpreter for Behat (it should be the interpreter from previous step).

Path to Behat is the path in the `cli` container: `/var/www/tests/behat/bin/behat`

Default configuration file: `/var/www/tests/behat/behat.yml`

Check that your `behat.yml` contains `wd_host` for selenium in `Behat\MinkExtension` part:

![Screenshot](/images/behat-behat-yml.png)

It should be the same as in `behat.common.yml` for `docker` part.

### Add a Behat debug configuration

Open *Run/Debug Configurations* (menu item *Run->Edit Configurations...*). In the opened window on the left side, add the new Behat configuration:

![Screenshot](/images/behat-run-debug-configuration.png)

Choose the Test Runner option *Defined in the configuration file*.

### Run tests

On the PhpStorm panel, choose Behat debug configuration and run it:

![Screenshot](/images/behat-run-tests.png)

If everything is ok, you will see a window with your test results (all tests are run in this case):

![Screenshot](/images/behat-run-window.png)

You can re-run any scenario from this window. If you click on scenario or test, PhpStorm will open window with this scenario/test.

You can also open the folder with Behat features (`tests/behat/features` directory in your project) and
run any feature tests by right clicking on it and choosing the **Run 'feature-name'** option.

![Screenshot](/images/behat-test-features.png)


## Using host's Selenium2 driver

You can use selenium from your host machine instead of the one in a container.

Selenium Standalone Server is available [here](http://www.seleniumhq.org/download/).
WebDriver for Chrome is available [here](https://sites.google.com/a/chromium.org/chromedriver/downloads).

Run selenium with Chrome webdriver:

```bash
java -jar selenium-server-standalone-2.53.0.jar -Dwebdriver.chrome.driver=/path/to/webdriver/chromedriver
```

By default, it is running on port `4444`, which can be verified by opening `http://localhost:4444/wd/hub/static/resource/hub.html` in a browser.

Update `tests/behat/behat.yml`:

```yaml
# Local overrides to the default profile
default:
  extensions:
    Behat\MinkExtension:
      # URL of the site when accessed locally.
      base_url: http://drupal7.docksal
      # Configure browser to be used. Browser must be available on wd_host.
      browser_name: chrome
      selenium2:
        wd_host: http://192.168.64.1:4444/wd/hub/static/resource/hub
...
```

- `base_url: http://drupal7.docksal` should match the URL you are using to access the site from your host.  
- `wd_host: http://192.168.64.1:4444/wd/hub/static/resource/hub` should point to your host machine's Selenium server.  
- `192.168.64.1` is your host machine's IP address in the Docksal subnet.
