package WunderCharts::Plugin::Role::RequiresOAuth2;

use Moo::Role;

use Types::Standard qw( Str );

has _access_token => (
    is       => 'ro',
    isa      => Str,
    required => 1,
    init_arg => 'access_token',
);

has _consumer_key => (
    is       => 'ro',
    isa      => Str,
    required => 1,
    init_arg => 'consumer_key',
);

has _consumer_secret => (
    is       => 'ro',
    isa      => Str,
    required => 1,
    init_arg => 'consumer_secret',
);

1;

__END__
# ABSTRACT: Provides methods required for OAuth2 setup

=pod

=head2 access_token

=head2 consumer_key

=head2 consumer_secret

=cut
