package WunderCharts::Plugin::HackerNews::Comment;

use Moo;
use MooX::StrictConstructor;

with 'WunderCharts::Plugin::Role::HackerNews::Item';

sub _build_trackables {
    ['kids_count'];
}

1;
