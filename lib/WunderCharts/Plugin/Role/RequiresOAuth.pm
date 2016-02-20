package WunderCharts::Plugin::Role::RequiresOAuth;

use Moo::Role;

use Types::Standard qw( Str );

has _access_token_secret => (
    is       => 'ro',
    isa      => Str,
    required => 1,
    init_arg => 'access_token_secret',
);

with( 'WunderCharts::Plugin::Role::RequiresOAuth2' );

1;

__END__

# ABSTRACT: Provides methods required for OAuth setup

=pod

=head2 access_token_secret

=cut
