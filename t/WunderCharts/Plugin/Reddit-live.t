#!/usr/bin/env perl;

use strict;
use warnings;

use Test::More;
use Test::RequiresInternet ( 'oath.reddit.com' => 443, );

use lib 't/lib';
use Test::WunderCharts::Plugin qw(
    config_for_service plugin_for_service trackables_ok
);

my $config = config_for_service('Reddit');

SKIP: {
    skip 'No live config', 1 unless $config->{live};

    my $plugin = plugin_for_service('Reddit');
    trackables_ok( $plugin->get_user_by_nick('oalders') );
    trackables_ok( $plugin->get_subreddit_by_nick('running') );

    my %urls = (
        'https://www.reddit.com/r/running' => [ 'subreddit', 'running' ],
        'https://www.reddit.com/u/oalders' => [ 'user',      'oalders' ],
        '/r/running' => [ 'subreddit', 'running' ],
        '/u/oalders' => [ 'user',      'oalders' ],
        'https://www.reddit.com/r/running/about' =>
            [ 'subreddit', 'running' ],
    );

    foreach my $url ( keys %urls ) {
        my $detected = [ $plugin->detect_resource($url) ];
        is_deeply( $detected, $urls{$url}, "detected $url" );
        my $resource = $plugin->get_resource($url);
        ok( $resource, "get_resource for $url" );
        trackables_ok($resource);
    }
}

done_testing();
