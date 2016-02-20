package WunderCharts::Plugin::Spotify::User;

use Moo;
use MooX::StrictConstructor;

use Types::Common::Numeric qw( PositiveOrZeroInt );
use Types::Standard qw( ArrayRef HashRef Str);

has followers_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_user->{followers}->{total} },
);

has id => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->_user->{id} },
);

has login => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->id },
);

has name => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub {
        my $self = shift;
        return $self->_user->{display_name} || $self->id;
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
    return ['followers_count'];
}

# The Spotify logic doesn't seem generic enough to include the in the role
sub maybe_extract_id {
    my $self = shift;

    my $identifier = shift;

    if ( substr( $identifier, 0, 1 ) eq '@' ) {
        $identifier = substr( $identifier, 1 );
        return $identifier;
    }

    if ( $identifier =~ m{spotify:user:(\w*)} ) {
        return $1;
    }

    # looks like an URL?
    return $identifier unless $identifier =~ m{/};

    my $uri      = URI->new($identifier);
    my @segments = $uri->path_segments;

    return $segments[2] if $uri->host =~ m{\A(open|play).spotify.com\z};
    return $segments[3] if $uri->host eq 'api.spotify.com';

    # for an absolute URL the first segment is an empty string
    my $id = $segments[1];

    # https://www.facebook.com/Morph-Productions-8144912092/timeline/
    if ( $id =~ m{\-(\d*)\z} ) {
        return $1;
    }
    return $id;
}

1;
