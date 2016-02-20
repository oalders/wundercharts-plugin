package WunderCharts::Plugin::Twitter::User;

use Moo;
use MooX::StrictConstructor;

use Types::Common::Numeric qw( PositiveOrZeroInt );
use Types::Standard qw( HashRef Str);

has followers_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_user->{followers_count} },
);

has friends_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_user->{friends_count} },
);

has id => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_user->{id} },
);

has listed_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_user->{listed_count} },
);

has name => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->_user->{name} },
);

has login => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->_user->{screen_name} },
);

has statuses_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_user->{statuses_count} },
);

has _user => (
    is       => 'ro',
    isa      => HashRef,
    init_arg => 'user',
    required => 1,
);

with 'WunderCharts::Plugin::Role::HasTrackableData';

sub _build_trackables {
    [ 'followers_count', 'friends_count', 'listed_count', 'statuses_count', ];
}

1;
