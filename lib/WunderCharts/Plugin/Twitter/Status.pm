package WunderCharts::Plugin::Twitter::Status;

use Moo;
use MooX::StrictConstructor;

use Types::Common::Numeric qw( PositiveOrZeroInt );
use Types::Standard qw( HashRef Str);

has favorite_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{favorite_count} },
);

has retweet_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{retweet_count} },
);

has id => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{id} },
);

with 'WunderCharts::Plugin::Role::HasRawData',
    'WunderCharts::Plugin::Role::HasTrackableData';

sub _build_trackables {
    [ 'favorite_count', 'retweet_count', ];
}

1;
