package WunderCharts::Plugin::Github;

use Moo;
use MooX::StrictConstructor;

use Pithub;
use Types::Standard qw( InstanceOf );
use URI;
use WunderCharts::Plugin::Github::Repo;
use WunderCharts::Plugin::Github::User;

has _client => (
    is      => 'lazy',
    isa     => InstanceOf ['Pithub'],
    handles => { fetch => 'fetch' },
);

with(
    'WunderCharts::Plugin::Role::HasIDFilter',
    'WunderCharts::Plugin::Role::HasServiceURL',
    'WunderCharts::Plugin::Role::HasUserURL',
    'WunderCharts::Plugin::Role::RequiresOAuth2',
);

sub _build__client {
    my $self = shift;

    return Pithub->new(
        access_token => $self->_access_token,
        app_id       => $self->_consumer_key,
        secret       => $self->_consumer_secret,
    );
}

sub _build_service_url { 'https://github.com' }

# https://github.com/oalders/http-browserdetect/
# https://github.com/oalders/
# git@github.com:oalders/http-browserdetect.git
# https://github.com/oalders/http-browserdetect.git
# oalders
# oalders/http-browserdetect

sub detect_resource {
    my $self     = shift;
    my $maybe_id = shift;
    unless ( $maybe_id =~ m{/} ) {

        # @username
        $maybe_id =~ s{\A\@}{};
        return ( 'user', $maybe_id );
    }

    my $uri = URI->new($maybe_id);

    # toss out empty strings
    my @parts = grep { $_ } $uri->path_segments;
    if ( @parts > 1 ) {
        $parts[1] =~ s{\.git\z}{};
        return ( 'repo', $parts[0], $parts[1] );
    }

    return ( 'user', $parts[0] );
}

sub get_repo {
    my $self = shift;
    my $user = shift;
    my $repo = shift;

    my $response = $self->_client->repos->get( user => $user, repo => $repo );
    return unless $response->success;

    return WunderCharts::Plugin::Github::Repo->new(
        raw => $response->content );
}

sub get_resource {
    my $self = shift;
    my $id   = shift;

    my ( $resource_type, $username, $repo ) = $self->detect_resource($id);
    if ( $resource_type eq 'user' ) {
        return $self->get_user_by_nick($username);
    }
    if ( $resource_type eq 'repo' ) {
        return $self->get_repo( $username, $repo );
    }
    die 'Cannot fetch resource type ' . $resource_type;
}

sub get_resource_by_nick {
    my $self          = shift;
    my $resource_type = shift;
    my $nick          = shift;

    # $nick = 'oalders/http-browserdetect'
    if ( $resource_type eq 'repo' ) {
        return $self->get_repo( split m{/}, $nick );
    }

    return $self->get_user_by_nick($nick);
}

sub get_user_by_nick {
    my $self = shift;

    # XXX add some Type::Tiny checking here
    my $nick = $self->maybe_extract_id(shift);

    my $response = $self->_client->users->get( user => $nick );
    return unless $response->success;

    return WunderCharts::Plugin::Github::User->new(
        raw => $response->content );
}

sub url_for {
    my $self          = shift;
    my $resource_type = shift;
    my $id            = shift;

    return $self->url_for_user($id) if $resource_type eq 'user';
}

1;
__END__

=head2 get_resource_by_nick

The GitHub API provides numeric ids for resources, but doesn't appear to
provide a way to use these ids to fetch the resources directly.  So, having a
C<get_resource_by_id> method is not helpful here.  Instead we'll fetch
resources by nicks.  For users, we'll use the C<username> rather than C<id> and
for repositories we'll use the C<full_name> rather than the C<id>.

=cut
