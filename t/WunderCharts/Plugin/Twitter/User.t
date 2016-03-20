#!/usr/bin/env perl;

use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( user_object_for_service );

my $user = user_object_for_service( 'Twitter', 'wundercounter.json' );

is_deeply(
    $user->trackable_data,
    {
        followers_count => 869,
        friends_count   => 1778,
        listed_count    => 67,
        statuses_count  => 2035,
    }
);

is( $user->screen_name, 'wundercounter', 'screen_name' );
is( $user->resource_url, 'https://twitter.com/wundercounter' );

done_testing();
