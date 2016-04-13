package WunderCharts::Plugin::HackerNews::Poll;

use Moo;
use MooX::StrictConstructor;

with 'WunderCharts::Plugin::Role::HackerNews::Item';

sub belongs_to {
    ['User'];
}

sub _build_trackables {
    [ 'kids_count', 'score' ];
}

1;
