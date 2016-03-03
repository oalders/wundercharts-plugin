package WunderCharts::Plugin::Instagram::User;

use Moo;
use MooX::StrictConstructor;

use Types::Common::Numeric qw( PositiveInt PositiveOrZeroInt );
use Types::Standard qw( HashRef Str);

has followers_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{counts}->{followed_by} },
);

has following_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{counts}->{follows} },
);

has id => (
    is      => 'ro',
    isa     => PositiveInt,
    lazy    => 1,
    default => sub { shift->_raw->{id} },
);

has login => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->_raw->{username} },
);

has media_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{counts}->{media} },
);

has name => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub {
        my $self = shift;
        return $self->_raw->{full_name} || $self->id;
    },
);

with 'WunderCharts::Plugin::Role::HasRawData',
    'WunderCharts::Plugin::Role::HasTrackableData';

sub _build_trackables {
    return [ 'followers_count', 'following_count', 'media_count', ];
}

1;
