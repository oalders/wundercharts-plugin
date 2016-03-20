package WunderCharts::Plugin::Spotify::Artist;

use Moo;
use MooX::StrictConstructor;

use Types::Common::Numeric qw( PositiveOrZeroInt );
use Types::Standard qw( HashRef Str);

has followers_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{followers}->{total} },
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

has id => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->_raw->{id} },
);

with(
    'WunderCharts::Plugin::Role::HasRawData',
    'WunderCharts::Plugin::Role::HasTrackableData',
    'WunderCharts::Plugin::Spotify::HasResourceURL',
);

sub _build_trackables {
    return [ 'followers_count', 'popularity' ];
}

1;
