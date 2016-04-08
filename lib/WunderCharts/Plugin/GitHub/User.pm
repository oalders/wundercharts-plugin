package WunderCharts::Plugin::GitHub::User;

use Moo;
use MooX::StrictConstructor;

use Types::Common::Numeric qw( PositiveOrZeroInt );
use Types::Standard qw( ArrayRef HashRef Str);

has followers_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{followers} },
);

has following_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{following} },
);

has id => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{id} },
);

has login => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->_raw->{login} },
);

has name => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->_raw->{name} },
);

has nick => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->_raw->{login} },
);

has public_gists_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{public_gists} },
);

has public_repos_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{public_repos} },
);

with 'WunderCharts::Plugin::Role::HasRawData',
    'WunderCharts::Plugin::Role::HasResourceURL',
    'WunderCharts::Plugin::Role::HasTrackableData';

sub _build_trackables {
    [
        'followers_count', 'following_count', 'public_gists_count',
        'public_repos_count',
    ];
}

sub _build_resource_url {
    my $self = shift;
    return $self->_raw->{html_url};
}

1;
