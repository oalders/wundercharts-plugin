#!/usr/bin/env perl;

use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( resource_for_service );

my $track = resource_for_service( 'Spotify', 'Artist', 'band-of-horses.json' );

is_deeply( $track->trackable_data, { followers_count => 306565, popularity => 59, } );

done_testing();
