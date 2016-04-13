package WunderCharts::Plugin::HackerNews::Comment;

use Moo;
use MooX::StrictConstructor;

with 'WunderCharts::Plugin::Role::HackerNews::Item';

sub belongs_to {
    ['User'];
}

sub _build_trackables {
    ['kids_count'];
}

1;
