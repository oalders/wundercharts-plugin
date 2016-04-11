package WunderCharts::Plugin::HackerNews::Story;

use Moo;
use MooX::StrictConstructor;

with 'WunderCharts::Plugin::Role::HackerNews::Item';

sub _build_trackables {
    [ 'kids_count', 'score' ];
}

1;
