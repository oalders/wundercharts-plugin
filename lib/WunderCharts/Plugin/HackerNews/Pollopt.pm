package WunderCharts::Plugin::HackerNews::Pollopt;

use Moo;
use MooX::StrictConstructor;

with 'WunderCharts::Plugin::Role::HackerNews::Item';

sub belongs_to {
    ['Poll'];
}

sub _build_trackables {
    ['score'];
}

1;
