#!/usr/bin/env perl;

use strict;
use warnings;

use Test::Fatal qw( exception );
use Test::More;
use Test::RequiresInternet (
    'graph.facebook.com' => 443,
    'www.facebook.com'   => 443,
);

use lib 't/lib';
use Test::WunderCharts::Plugin qw( config_for_service plugin_for_service );

my $config = config_for_service('Facebook');

SKIP: {
    skip 'No live config', 1 unless $config->{live};

    my $plugin = plugin_for_service('Facebook');
    {
        my $user = $plugin->get_user_by_nick('JustinBieber');
        ok( $user, 'got JustinBieber user' );
    }

    my $photo_id = 10154452100783797;
    my $photo    = $plugin->get_object($photo_id);

    ok( $photo->comments_count, 'comments' );
    ok( $photo->likes_count,    'likes' );

    like(
        exception { $plugin->get_object('foo') },
        qr{Cannot fetch data for foo},
        'exception on object not found'
    );
}

done_testing();
