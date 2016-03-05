package WunderCharts::Plugin::Spotify::Track;

use Moo;
use MooX::StrictConstructor;

use Types::Common::Numeric qw( PositiveOrZeroInt );
use Types::Standard qw( Str );

with 'WunderCharts::Plugin::Role::HasRawData';

has name => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    builder => sub { shift->_raw->{name} },
);

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
