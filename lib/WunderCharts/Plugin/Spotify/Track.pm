package WunderCharts::Plugin::Spotify::Track;

use Moo;
use MooX::StrictConstructor;

use Types::Common::Numeric qw( PositiveOrZeroInt );

with 'WunderCharts::Plugin::Role::HasRawData';

has popularity => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{popularity} },
);

with 'WunderCharts::Plugin::Role::HasTrackableData';

sub _build_trackables {
    return ['popularity'];
}

1;
