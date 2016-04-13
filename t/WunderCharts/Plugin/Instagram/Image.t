#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( resource_for_service );

my $image = resource_for_service( 'Instagram', 'Image', 'oalders.json' );

is_deeply(
    $image->trackable_data,
    {
        comments_count => 0,
        likes_count    => 2,
    },
    'trackable_data'
);

is(
    $image->resource_url, 'https://www.instagram.com/p/dk4enZwWvP/',
    'resource_url'
);

done_testing();
