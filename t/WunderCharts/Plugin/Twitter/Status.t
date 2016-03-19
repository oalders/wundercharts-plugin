#!/usr/bin/env perl;

use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( resource_for_service );

my $status = resource_for_service(
    'Twitter', 'Status',
    'wundercounter-linkedin.pl'
);

is_deeply(
    $status->trackable_data,
    {
        favorite_count => 1910,
        retweet_count  => 2717,
    },
    'trackable_data'
);

is( $status->id, 570454045099307008, 'id' );
ok( $status->name, 'name sourced from tweet text' );

done_testing();
