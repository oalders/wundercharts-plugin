package WunderCharts::Plugin::Role::Instagram::Media;

use Moo::Role;

use Types::Common::Numeric qw( PositiveInt PositiveOrZeroInt );
use Types::Standard qw( HashRef Maybe Str);

has comments_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{comments}->{count} },
);

has likes_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{likes}->{count} },
);

has id => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->_raw->{id} },
);

has name => (
    is      => 'ro',
    isa     => Maybe [Str],
    lazy    => 1,
    default => sub {
        my $self = shift;
        return $self->_raw->{caption};
    },
);

with(
    'WunderCharts::Plugin::Role::HasRawData',
    'WunderCharts::Plugin::Role::HasResourceURL',
    'WunderCharts::Plugin::Role::Instagram::HasServiceURL',
    'WunderCharts::Plugin::Role::HasTrackableData',
    'WunderCharts::Plugin::Role::HasUserURL',
);

sub _build_resource_url {
    my $self = shift;
    return $self->_raw->{link};
}

sub _build_trackables {
    return [ 'comments_count', 'likes_count', ];
}

1;