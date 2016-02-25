requires "Cpanel::JSON::XS" => "0";
requires "Data::Dumper" => "0";
requires "Data::Printer" => "0";
requires "Facebook::Graph" => "0";
requires "LWP::ConsoleLogger::Easy" => "0";
requires "Moo" => "0";
requires "Moo::Role" => "0";
requires "MooX::StrictConstructor" => "0";
requires "Net::Twitter" => "0";
requires "Pithub" => "0";
requires "Types::Common::Numeric" => "0";
requires "Types::Standard" => "0";
requires "Types::URI" => "0";
requires "URI" => "0";
requires "URI::FromHash" => "0";
requires "WWW::Mechanize" => "0";
requires "WWW::Spotify" => "0";
requires "perl" => "v5.10.0";
requires "strict" => "0";
requires "warnings" => "0";

on 'build' => sub {
  requires "Module::Build" => "0.28";
};

on 'test' => sub {
  requires "Module::Load" => "0";
  requires "Path::Tiny" => "0";
  requires "Sub::Exporter" => "0";
  requires "Test::Fatal" => "0";
  requires "Test::More" => "0";
  requires "Test::Most" => "0";
  requires "Test::RequiresInternet" => "0";
  requires "feature" => "0";
  requires "lib" => "0";
  requires "perl" => "v5.10.0";
};

on 'test' => sub {
  recommends "Data::Printer" => "0.38";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "Module::Build" => "0.28";
  requires "perl" => "5.006";
};

on 'develop' => sub {
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Test::CPAN::Changes" => "0.19";
  requires "Test::Pod::Coverage" => "1.08";
  requires "Test::Spelling" => "0.12";
  requires "Test::Synopsis" => "0";
};
