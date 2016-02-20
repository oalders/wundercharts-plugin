package WunderCharts::Plugin::Role::HasUserURL;

use Moo::Role;

sub url_for_user {
    my $self     = shift;
    my $username = shift;

    my $url = $self->url_for_service->clone;
    $url->path( $username );
    return $url;
}

1;

__END__
# ABSTRACT: Provides an url_for_user method

=pod

=head1 DESCRIPTION

Adds a C<url_for_user()> method to plugins.

=cut
