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

is( $plugin->url_for_page('X'), 'https://facebook.com/X', 'url_for_page' );

done_testing();
