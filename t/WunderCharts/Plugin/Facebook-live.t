#!/usr/bin/env perl;

use strict;
use warnings;

use Test::More;
use Test::RequiresInternet (
    'graph.facebook.com' => 443,
    'www.facebook.com'   => 443,
);

use lib 't/lib';
use Test::WunderCharts::Plugin qw( config_for_service plugin_for_service );

my $config = config_for_service('Faebook');

SKIP: {
    skip 'No live config', 1 unless $config->{live};

    my $plugin = plugin_for_service('Facebook');
    {
        my $user = $plugin->get_user_by_nick('JustinBieber');
        ok( $user, 'got JustinBieber user' );
    }
}

done_testing();
