#!/usr/bin/env perl;

use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( user_object_for_service );

my $user = user_object_for_service( 'Spotify', 'oalders.pl' );

is_deeply(
    $user->trackable_data, { followers_count => 1 },
    'trackable_data'
);

is(
    $user->resource_url, 'https://open.spotify.com/user/oalders',
    'resource_url'
);

done_testing();
