#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( user_object_for_service );

my $user = user_object_for_service( 'Instagram', 'oalders.pl' );

is_deeply(
    $user->trackable_data,
    {
        followers_count => 45,
        following_count => 2,
        media_count     => 7,
    }
);

done_testing();
