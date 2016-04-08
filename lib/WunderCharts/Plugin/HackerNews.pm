package WunderCharts::Plugin::HackerNews;

use Moo;
use MooX::StrictConstructor;

use Types::Standard qw( InstanceOf );
use URI;
use URI::QueryParam;
use WebService::HackerNews;
use WunderCharts::Plugin::HackerNews::Comment;
use WunderCharts::Plugin::HackerNews::Story;
use WunderCharts::Plugin::HackerNews::User;

has _client => (
    is  => 'lazy',
    isa => InstanceOf ['WebService::HackerNews'],
);

with(
    'WunderCharts::Plugin::Role::HasIDFilter',
    'WunderCharts::Plugin::Role::HasServiceURL',
);

sub _build__client {
    my $self = shift;
    return WebService::HackerNews->new;
}

sub _build_service_url { 'https://news.ycombinator.com' }

sub get_item_by_id {
    my $self = shift;
    my $id   = shift;

    my $item  = $self->_client->item($id);
    my $class = 'WunderCharts::Plugin::HackerNews::' . ucfirst( $item->type );
    return $class->new( item => $self->_client->item($id) );
}

sub get_user_by_id {
    my $self = shift;
    my $id   = shift;

    return WunderCharts::Plugin::HackerNews::User->new(
        user => $self->_client->user($id) );
}

# https://news.ycombinator.com/user?id=oalders
# https://news.ycombinator.com/item?id=11424372

sub detect_resource {
    my $self     = shift;
    my $maybe_id = shift;
    unless ( $maybe_id =~ m{/} ) {

        # @username
        $maybe_id =~ s{\A\@}{};
        return ( 'user', $maybe_id );
    }

    my $uri = URI->new($maybe_id);

    if ( $uri->path && $uri->path eq '/user' ) {
        return ( 'user', $uri->query_param('id') );
    }

    if ( $uri->path && $uri->path eq '/item' ) {
        return ( 'item', $uri->query_param('id') );
    }
    return;
}

sub get_resource {
    my $self = shift;
    my $url  = shift;

    my ( $resource_type, $id ) = $self->detect_resource($url);
    my $method = sprintf( 'get_%s_by_id', $resource_type );
    return $self->$method($id) if $self->can($method);

    die sprintf(
        'Cannot fetch resource type %s for %s', $resource_type,
        $url
    );
}

1;
__END__
