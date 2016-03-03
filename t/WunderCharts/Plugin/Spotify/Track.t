#!/usr/bin/env perl;

use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( resource_for_service );

my $track = resource_for_service( 'Spotify', 'Track', 'mr-brightside.json' );

is_deeply( $track->trackable_data, { popularity => 11 } );

done_testing();
