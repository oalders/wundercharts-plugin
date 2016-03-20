#!/usr/bin/env perl;

use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( resource_for_service );

my $artist
    = resource_for_service( 'Spotify', 'Artist', 'band-of-horses.json' );

is_deeply(
    $artist->trackable_data,
    { followers_count => 306565, popularity => 59, }, 'trackable_data'
);

is(
    $artist->resource_url,
    'https://open.spotify.com/artist/0OdUWJ0sBjDrqHygGUXeCF',
    'resource_url'
);

done_testing();
