#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( resource_for_service );

my $user = resource_for_service( 'Instagram', 'User', 'oalders.pl' );

is_deeply(
    $user->trackable_data,
    {
        followers_count => 45,
        following_count => 2,
        media_count     => 7,
    },
    'trackable_data'
);

is( $user->resource_url, 'https://instagram.com/oalders', 'resource_url' );

done_testing();
