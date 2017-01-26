use strict;
use warnings;

use Test::Most;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( plugin_for_service);

my $plugin = plugin_for_service('Reddit');

is(
    $plugin->url_for_user('oalders'), 'https://www.reddit.com/user/oalders',
    'url_for user'
);

my %resources = (
    'https://www.reddit.com/r/running'     => [ 'subreddit', 'running' ],
    'https://www.reddit.com/r/running/new' => [ 'subreddit', 'running' ],
    'oalders'                              => [ 'user',      'oalders' ],
    '@oalders'                             => [ 'user',      'oalders' ],
    '/r/running'                           => [ 'subreddit', 'running', ],
);

foreach my $resource ( keys %resources ) {
    my @detected = $plugin->detect_resource($resource);
    is_deeply( \@detected, $resources{$resource}, $resource );
}

done_testing();
