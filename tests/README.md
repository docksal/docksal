# Bats tests for dsh

You need to install [Bats](https://github.com/sstephenson/bats) before running tests.
You need to have [Drupal 7 sample project](https://github.com/blinkreaction/drude-d7-testing) installed in your projects directory.
You must have next structure of projects directory:
>     projects
>       ...
>       \_ drude
>       \_ drude-d7-testing
>       ...

You need to install additional bats sub-modules. To perform this, perform next actions.
```
cd ~/projects/drude/tests
git submodule init
git submodule update
```

You can run any test from **drude-d7-testing** directory using next command:
```
bats ../drude/tests/start.bats
```

By default OS is "OS X" (mac). You can set enviroment for test (OS is mac|linux|win):
```
OS=linux bats ../drude/tests/start.bats
```

You can run all tests using next command (it must be run from **drude/tests directory**):
```
./run-tests.sh
```

Or you can set OS:
```
OS=linux ./run-tests.sh
```
or specify parameter:

```
./run-tests.sh linux
```


## Tests overview

In most cases test name is same as commands name:
```
init.bats => dsh init
start.bats => dsh start
...
```

There are also files with tests for dsh functions:
```
helper_functions.bats - Helper functions
basics_check_functions.bats - Basics check functions
control_functions.bats - Control functions
```

## Troubleshooting test

Tests directory contains ```troubleshooting.bats```, which should not be started in general and not included in ```run-tests.sh```.
This test have to be performed when something goes wrong.
