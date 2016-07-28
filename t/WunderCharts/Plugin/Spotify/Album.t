#!/usr/bin/env perl;

use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( resource_for_service );

my $artist
    = resource_for_service( 'Spotify', 'Album', 'cyndi-lauper.json' );

is_deeply(
    $artist->trackable_data,
    { popularity => 39, }, 'trackable_data'
);

is(
    $artist->resource_url,
    'https://open.spotify.com/album/0sNOF9WDwhWunNAHPD3Baj',
    'resource_url'
);

done_testing();
