package WunderCharts::Plugin::Github::User;

use Moo;
use MooX::StrictConstructor;

use Types::Common::Numeric qw( PositiveOrZeroInt );
use Types::Standard qw( ArrayRef HashRef Str);

has followers => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_user->{followers} },
);

has following => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_user->{following} },
);

has id => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_user->{id} },
);

has login => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->_user->{login} },
);

has name => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->_user->{name} },
);

has public_gists => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_user->{public_gists} },
);

has public_repos => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_user->{public_repos} },
);

has _user => (
    is       => 'ro',
    isa      => HashRef,
    init_arg => 'user',
    required => 1,
);

with 'WunderCharts::Plugin::Role::HasTrackableData';

sub _build_trackables {
    [ 'followers', 'following', 'public_gists', 'public_repos', ];
}

1;
