#!/usr/bin/env perl;

use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( user_object_for_service );

my $user = user_object_for_service( 'Spotify', 'oalders' );

is_deeply( $user->trackable_data, { followers_count => 1 } );

done_testing();
