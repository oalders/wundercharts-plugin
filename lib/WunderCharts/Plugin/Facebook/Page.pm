package WunderCharts::Plugin::Facebook::Page;

use Moo;
use MooX::StrictConstructor;

use Types::Common::Numeric qw( PositiveOrZeroInt );
use Types::Common::String qw( NonEmptyStr );
use Types::Standard qw( ArrayRef HashRef Str);

has checkins => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{checkins} },
);

has id => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{id} },
);

has likes => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{likes} },
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
    default => sub { shift->_raw->{name} },
);

has resource_url => (
    is      => 'ro',
    isa     => NonEmptyStr,
    lazy    => 1,
    default => sub { shift->_raw->{link} },
);

has talking_about_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{talking_about_count} },
);

has were_here_count => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->_raw->{were_here_count} },
);

with 'WunderCharts::Plugin::Role::HasRawData',
    'WunderCharts::Plugin::Role::HasTrackableData';

sub _build_login {
    my $self = shift;
    return $self->_raw->{username} if $self->_raw->{username};
    if ( $self->_raw->{link} =~ m{https://www.facebook.com/(.*)/} ) {
        return $1;
    }
    return $self->_raw->{link};
}

sub _build_trackables {
    [ 'checkins', 'likes', 'talking_about_count', 'were_here_count', ];
}

1;
