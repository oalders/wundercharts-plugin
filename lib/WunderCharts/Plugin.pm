package WunderCharts::Plugin;

use strict;
use warnings;

1;

# ABSTRACT: WunderCharts Plugins for 3rd Party Web Services

=pod

=head1 DESCRIPTION

This package contains the plugins which WunderCharts uses to connect to various
3rd party APIs.

=head1 CONTRIBUTING

If you'd like to use a Vagrant VM you will have a full development environment
at your disposal.

    vagrant up
    vagrant ssh

    # run tests
    prove -lvr t

A friendly synopsis of the terms under which this software is licensed can be
found here: L<http://choosealicense.com/licenses/gpl-3.0/>

=head2 LEARN BY EXAMPLE

See L<WunderCharts::Plugin::Twitter> for an example of working with an OAuth app.

See L<WunderCharts::Plugin::Instagram> for an example of working with an OAuth2 app.

See L<WunderCharts::Plugin::HackerNews> for an example of using an API which
requires no authentication whatsoever.

=head2 REQUIREMENTS

=over

=item Respect the TOS

Plugins may not violate the Terms of Service for the web service in question.

=item Official, Supported APIs

Plugins must only use official, supported APIs.  (No screen scraping).  If you
want to use an unofficial, but supported API (such as the Hacker News plugin
does), please open a GitHub issue so that we can discuss this first.

=back

=head1 TESTING

To run the live tests, copy the file C<sample-config.pl> to C<config.pl>.  Add
the services you'd like to test, with valid OAuth credentials.  This file must
contain a valid Perl hash as it just gets eval'd by
C<t/lib/Test/WunderCharts/Plugin.pm>

Currently you may test the following services:

=over

=item facebook

=item github

=item instagram

=item spotify

=item twitter

=back

=cut
