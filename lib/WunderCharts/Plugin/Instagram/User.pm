package WunderCharts::Plugin::Instagram::User;

use Moo;
use MooX::StrictConstructor;

use Types::Common::Numeric qw( PositiveInt PositiveOrZeroInt );
use Types::Standard qw( HashRef Str);

has followers_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_user->{counts}->{followed_by} },
);

has following_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_user->{counts}->{follows} },
);

has id => (
    is      => 'ro',
    isa     => PositiveInt,
    lazy    => 1,
    default => sub { shift->_user->{id} },
);

has login => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->_user->{username} },
);

has media_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_user->{counts}->{media} },
);

has name => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub {
        my $self = shift;
        return $self->_user->{full_name} || $self->id;
    },
);

has _user => (
    is       => 'ro',
    isa      => HashRef,
    init_arg => 'user',
    required => 1,
);

with 'WunderCharts::Plugin::Role::HasTrackableData';

sub _build_trackables {
    return [ 'followers_count', 'following_count', 'media_count', ];
}

1;
