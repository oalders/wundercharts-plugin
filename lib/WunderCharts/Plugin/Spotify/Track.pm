package WunderCharts::Plugin::Spotify::Track;

use Moo;
use MooX::StrictConstructor;

use Types::Common::Numeric qw( PositiveOrZeroInt );
use Types::Standard qw( Str );

has id => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->_raw->{id} },
);

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

with(
    'WunderCharts::Plugin::Role::HasRawData',
    'WunderCharts::Plugin::Role::HasTrackableData',
    'WunderCharts::Plugin::Spotify::HasResourceURL',
);

sub _build_trackables {
    return ['popularity'];
}

1;
