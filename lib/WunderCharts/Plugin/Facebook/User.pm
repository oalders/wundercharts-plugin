package WunderCharts::Plugin::Facebook::User;

use Moo;
use MooX::StrictConstructor;

use Types::Common::Numeric qw( PositiveOrZeroInt );
use Types::Standard qw( ArrayRef HashRef Str);

has checkins => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_user->{checkins} },
);

has id => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_user->{id} },
);

has likes => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_user->{likes} },
);

has login => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    builder => '_build_login',
);

has name => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->_user->{name} },
);

has _user => (
    is       => 'ro',
    isa      => HashRef,
    init_arg => 'user',
    required => 1,
);

has talking_about_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_user->{talking_about_count} },
);

has were_here_count => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->_user->{were_here_count} },
);

with 'WunderCharts::Plugin::Role::HasTrackableData';

sub _build_login {
    my $self = shift;
    return $self->_user->{username} if $self->_user->{username};
    if ( $self->_user->{link} =~ m{https://www.facebook.com/(.*)/} ) {
        return $1;
    }
    return $self->_user->{link};
}

sub _build_trackables {
    [ 'checkins', 'likes', 'talking_about_count', 'were_here_count', ];
}

1;
