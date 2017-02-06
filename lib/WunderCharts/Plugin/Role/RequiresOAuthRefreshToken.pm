package WunderCharts::Plugin::Role::RequiresOAuthRefreshToken;

use Moo::Role;

use Types::Standard qw( Str );

has _refresh_token => (
    is       => 'ro',
    isa      => Str,
    required => 1,
    init_arg => 'refresh_token',
);

1;

__END__
# ABSTRACT: Provides methods required for OAuth with refresh tokens

=pod

=head2 refresh_token

=cut
