#!/usr/bin/env perl;

use strict;
use warnings;

use Test::More skip_all => 'credentials required';
use Test::RequiresInternet (
    'graph.facebook.com' => 443,
    'www.facebook.com'   => 443,
);

use WunderCharts::Plugin::Facebook;

# live tests go here
ok(1);

done_testing();
