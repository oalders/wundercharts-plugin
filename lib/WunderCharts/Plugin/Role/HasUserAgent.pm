package WunderCharts::Plugin::Role::HasUserAgent;

use Moo::Role;

use LWP::ConsoleLogger::Easy qw( debug_ua );
use WWW::Mechanize;
use Types::Standard qw( InstanceOf );

has _user_agent => (
    is      => 'ro',
    isa     => InstanceOf ['LWP::UserAgent'],
    lazy    => 1,
    handles => [ 'get', 'post' ],
    builder => '_build_user_agent',
);

sub _build_user_agent {
    my $self = shift;

    my $ua = WWW::Mechanize->new( autocheck => 0, timeout => 10 );
    if ( $ENV{WC_UA_DEBUG} ) {
        debug_ua( $ua, $ENV{WC_UA_DEBUG} );
    }
    return $ua;
}

1;

__END__
# ABSTRACT: Provides UserAgent with optional debugging via Moo role

=pod

=head1 DESCRIPTION

Adds a C<_user_agent()> attribute to plugins.  To enable debugging, set the
WC_UA_DEBUG environment variable.

    # Maximum debugging output
    WC_UA_DEBUG=7 perl test-my-plugin.pl

    # Minimum debugging output
    WC_UA_DEBUG=1 perl test-my-plugin.pl

=cut
