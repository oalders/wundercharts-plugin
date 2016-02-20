package WunderCharts::Plugin::Facebook;

use Moo;
use MooX::StrictConstructor;

use Facebook::Graph;
use Types::Standard qw( InstanceOf );
use URI ();
use WunderCharts::Plugin::Facebook::User;

has _client => (
    is      => 'lazy',
    isa     => InstanceOf ['Facebook::Graph'],
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

    return Facebook::Graph->new(
        app_id       => $self->_consumer_key,
        secret       => $self->_consumer_secret,
        access_token => $self->_access_token,
    );
}

sub _build_url_for_service {'https://facebook.com'}

# use the id 'me' to get info about the user who is connecting
sub get_user_by_id {
    return shift->get_user_by_nick( @_ );
}

sub get_user_by_nick {
    my $self = shift;
    my $id   = shift;

    my $info = $self->_client->fetch( $self->maybe_extract_id( $id ) );

    return WunderCharts::Plugin::Facebook::User->new( user => $info );
}

1;
