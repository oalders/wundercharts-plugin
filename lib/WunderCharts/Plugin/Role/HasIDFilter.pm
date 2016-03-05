package WunderCharts::Plugin::Role::HasIDFilter;

use Moo::Role;

sub maybe_extract_id {
    my $self       = shift;
    my $identifier = shift;

    # If it's just some alphanumeric string, there's nothing to extract
    return $identifier unless $identifier =~ m{[^0-9a-zA-Z]};

    # starts with @?
    if ( substr( $identifier, 0, 1 ) eq '@' ) {
        $identifier = substr( $identifier, 1 );
        return $identifier;
    }

    # looks like an URL?
    return $identifier unless $identifier =~ m{/};

    my $uri      = URI->new($identifier);
    my @segments = $uri->path_segments;

    # for an absolute URL the first segment is an empty string
    my $id = $segments[1];

    # https://www.facebook.com/Morph-Productions-8144912092/timeline/
    if ( $id =~ m{\-(\d*)\z} ) {
        return $1;
    }
    return $id;
}

1;

__END__
# ABSTRACT: Provides a method which can extract user IDs from URLs

=pod

=head1 DESCRIPTION

Adds a C<maybe_extract_id()> method to plugins.

=cut
