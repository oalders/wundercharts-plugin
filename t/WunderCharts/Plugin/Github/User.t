#!/usr/bin/env perl;

use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( user_object_for_service );

my $user = user_object_for_service( 'Github', 'oalders.pl' );

is_deeply(
    $user->trackable_data,
    {
        followers    => 96,
        following    => 94,
        public_gists => 58,
        public_repos => 191,
    },
    'trackable_data'
);

is( $user->id,           96205,                        'id' );
is( $user->nick,         'oalders',                    'nick' );
is( $user->resource_url, 'https://github.com/oalders', 'resource_url' );

done_testing();
