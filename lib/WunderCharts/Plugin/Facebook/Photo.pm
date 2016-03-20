package WunderCharts::Plugin::Facebook::Photo;

use Moo;
use MooX::StrictConstructor;

use Types::Common::Numeric qw( PositiveInt PositiveOrZeroInt );
use Types::Common::String qw( NonEmptyStr );
use Types::Standard qw( ArrayRef HashRef Str);

has id => (
    is      => 'ro',
    isa     => PositiveInt,
    lazy    => 1,
    default => sub { shift->_raw->{id} },
);

has comments_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw_comments->{summary}->{total_count} },
);

has likes_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw_likes->{summary}->{total_count} },
);

has name => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->_raw->{name} },
);

has _raw_comments => (
    is       => 'ro',
    isa      => HashRef,
    init_arg => 'raw_comments',
    required => 1,
);

has _raw_likes => (
    is       => 'ro',
    isa      => HashRef,
    init_arg => 'raw_likes',
    required => 1,
);

has resource_url => (
    is      => 'ro',
    isa     => NonEmptyStr,
    lazy    => 1,
    default => sub { shift->_raw->{link} },
);

with 'WunderCharts::Plugin::Role::HasRawData',
    'WunderCharts::Plugin::Role::HasTrackableData';

sub _build_trackables {
    [ 'comments_count', 'likes_count', ];
}

1;
