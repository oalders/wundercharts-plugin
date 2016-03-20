package WunderCharts::Plugin::Role::Twitter::HasServiceURL;

use Moo::Role;

with 'WunderCharts::Plugin::Role::HasServiceURL';

sub _build_url_for_service { 'https://twitter.com/' }

1;
