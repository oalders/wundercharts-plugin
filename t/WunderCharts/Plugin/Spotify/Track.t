#!/usr/bin/env perl;

use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( resource_for_service );

my $track = resource_for_service( 'Spotify', 'Track', 'mr-brightside.json' );

is_deeply( $track->trackable_data, { popularity => 11 }, 'trackable_data' );

is(
    $track->resource_url,
    'https://open.spotify.com/track/0eGsygTp906u18L0Oimnem',
    'resource_url'
);

done_testing();
