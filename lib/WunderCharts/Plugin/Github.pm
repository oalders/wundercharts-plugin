package WunderCharts::Plugin::Github;

use Moo;
use MooX::StrictConstructor;

use Pithub;
use Types::Standard qw( InstanceOf );
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
        app_id       => $self->_consumer_key,
        secret       => $self->_consumer_secret,
        access_token => $self->_access_token,
    );
}

sub _build_url_for_service { 'https://github.com' }

sub get_user_by_nick {
    my $self = shift;

    # XXX add some Type::Tiny checking here
    my $nick = $self->maybe_extract_id(shift);

    my $response = $self->_client->users->get( user => $nick );
    return unless $response->success;

    return WunderCharts::Plugin::Github::User->new(
        raw => $response->content );
}

1;
