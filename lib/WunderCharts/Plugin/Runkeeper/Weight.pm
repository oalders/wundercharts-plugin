package WunderCharts::Plugin::Runkeeper::Weight;

use Moo;
use MooX::StrictConstructor;

use Types::Common::Numeric qw( PositiveOrZeroNum );
use Types::Standard qw( HashRef Maybe Str);

my @floats = ( 'bmi', 'fat_percent', 'mass_weight', 'weight' );

for my $attr (@floats) {
    has $attr => (
        is      => 'ro',
        isa     => Maybe [PositiveOrZeroNum],
        lazy    => 1,
        default => sub { shift->_raw->{$attr} },
    );
}

has timestamp => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->_raw->{timestamp} },
);

with(
    'WunderCharts::Plugin::Role::HasRawData',
    'WunderCharts::Plugin::Role::HasTrackableData',
    'WunderCharts::Plugin::Spotify::HasResourceURL',
);

sub _build_trackables {
    return \@floats;
}

1;
