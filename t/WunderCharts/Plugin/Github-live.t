#!/usr/bin/env perl;

use strict;
use warnings;

use Test::More;
use Test::RequiresInternet (
    'api.github.com' => 443,
);

use lib 't/lib';
use Test::WunderCharts::Plugin qw( config_for_service plugin_for_service );

my $config = config_for_service('Github');

SKIP: {
    skip 'No live config', 1 unless $config->{live};

    my $plugin = plugin_for_service('Github');
    {
        my $user = $plugin->get_user_by_nick('oalders');
        ok( $user, 'got oalders user' );
    }

    {
        my $repo = $plugin->get_repo( 'oalders', 'http-browserdetect' );
        ok( $repo, 'oalders/http-browserdetect repo' );
    }

    {
        my $repo = $plugin->get_resource_by_nick(
            'repo',
            'oalders/http-browserdetect'
        );
        ok( $repo, 'got oalders/http-browserdetect repo' );
    }

    {
        my $repo = $plugin->get_resource_by_nick( 'user', 'oalders' );
        ok( $repo, 'got oalders user' );
    }
}

done_testing();
