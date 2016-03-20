package WunderCharts::Plugin::Role::Twitter::HasServiceURL;

use Moo::Role;

with 'WunderCharts::Plugin::Role::HasServiceURL';

sub _build_service_url { 'https://twitter.com/' }

1;
