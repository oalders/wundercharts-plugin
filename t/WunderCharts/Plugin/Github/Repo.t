#!/usr/bin/env perl;

use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( resource_for_service );

my $user = resource_for_service(
    'Github', 'Repo',
    'oalders-http-browserdetect.json'
);

is_deeply(
    $user->trackable_data,
    {
        forks_count       => 32,
        open_issues_count => 19,
        stargazers_count  => 48,
        subscribers_count => 13,
    },
    'trackable_data'
);

done_testing();
