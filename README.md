# NAME

WunderCharts::Plugin - WunderCharts Plugins for 3rd Party Web Services

[![Build Status](https://travis-ci.org/oalders/wundercharts-plugin.png?branch=master)](https://travis-ci.org/oalders/wundercharts-plugin)

# VERSION

version 0.000001

# DESCRIPTION

This package contains the plugins which WunderCharts uses to connect to various
3rd party APIs.

# CONTRIBUTING

If you'd like to use a Vagrant VM you will have a full development environment
at your disposal.

    vagrant up
    vagrant ssh

    # run tests
    prove -lvr t

A friendly synopsis of the terms under which this software is licensed can be
found here: [http://choosealicense.com/licenses/gpl-3.0/](http://choosealicense.com/licenses/gpl-3.0/)

## LEARN BY EXAMPLE

See [WunderCharts::Plugin::Twitter](https://metacpan.org/pod/WunderCharts::Plugin::Twitter) for an example of working with an OAuth app.

See [WunderCharts::Plugin::Instagram](https://metacpan.org/pod/WunderCharts::Plugin::Instagram) for an example of working with an OAuth2 app.

See [WunderCharts::Plugin::HackerNews](https://metacpan.org/pod/WunderCharts::Plugin::HackerNews) for an example of using an API which
requires no authentication whatsoever.

## REQUIREMENTS

- Respect the TOS

    Plugins may not violate the Terms of Service for the web service in question.

- Official, Supported APIs

    Plugins must only use official, supported APIs.  (No screen scraping).  If you
    want to use an unofficial, but supported API (such as the Hacker News plugin
    does), please open a GitHub issue so that we can discuss this first.

# TESTING

To run the live tests, copy the file `sample-config.pl` to `config.pl`.  Add
the services you'd like to test, with valid OAuth credentials.  This file must
contain a valid Perl hash as it just gets eval'd by
`t/lib/Test/WunderCharts/Plugin.pm`

Currently you may test the following services:

- facebook
- github
- instagram
- spotify
- twitter

# AUTHOR

Olaf Alders <olaf@wundercounter.com>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2016 by Olaf Alders.

This is free software, licensed under:

    The GNU General Public License, Version 3, June 2007
