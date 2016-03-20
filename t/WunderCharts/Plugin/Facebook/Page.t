#!/usr/bin/env perl;

use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( resource_for_service );

my $user = resource_for_service( 'Facebook', 'Page', 'justin-bieber.pl' );

is_deeply(
    $user->trackable_data,
    {
        checkins            => 16_324,
        likes               => 72_926_638,
        talking_about_count => 1_312_378,
        were_here_count     => 0,
    },
    'trackable_data'
);

is(
    $user->resource_url, 'https://www.facebook.com/JustinBieber',
    'resource_url'
);

done_testing();
