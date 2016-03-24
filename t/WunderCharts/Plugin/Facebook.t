#!/usr/bin/env perl;

use strict;
use warnings;

use Test::More;
use WunderCharts::Plugin::Facebook;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( plugin_for_service);

my $plugin = plugin_for_service('Facebook');

isa_ok( $plugin, 'WunderCharts::Plugin::Facebook' );

is(
    $plugin->maybe_extract_id('https://www.facebook.com/JustinBieber'),
    'JustinBieber', 'extracts id from url'
);

is(
    $plugin->maybe_extract_id(
        'https://www.facebook.com/Morph-Productions-8144912092/timeline/'
    ),
    '8144912092',
    'extracts id from hybrid name-id url'
);

is(
    $plugin->maybe_extract_id('JustinBieber'),
    'JustinBieber', 'returns pure id intact'
);

is(
    $plugin->url_for_user_by_id('X'),
    'https://facebook.com/app_scoped_user_id/X/',
    'url_for page'
);

done_testing();
