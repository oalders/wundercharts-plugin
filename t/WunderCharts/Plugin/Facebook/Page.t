#!/usr/bin/env perl;

use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( user_object_for_service );

my $user = user_object_for_service( 'Facebook', 'justin-bieber.pl' );

is_deeply(
    $user->trackable_data,
    {
        checkins            => 16_324,
        likes               => 72_926_638,
        talking_about_count => 1_312_378,
        were_here_count     => 0,
    }
);

done_testing();
