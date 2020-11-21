# Made by Edoardo Mantovani, 2020
# scrape automatic proxies

package Automatic::Proxy;

use strict;
no strict 'refs';
use warnings;

use LWP::UserAgent;

# interface for hidemy.name

use constant HIDEMYNAME => "https://hidemy.name/en/proxy-list/?";

my $lwp = LWP::UserAgent->new();

my %anonimity_levels = {
  'High' => 4,
  'Average' => 3,
  'Low' => 2,
  'No' => 1,
};

my %proxy_types = {
  'Http' => "h",
  'Https' => "s",
  'Socks4' => 4,
  'Socks5' => 5,
};

my @ip_array;
sub scrape_hidemy{
  my( $port, $type, $anonimity ) = @_;
  if( $port > 65535 || undef( $port ) ){
    die "not inserted port variable or maximun port number is wrong!\n";
  }
  if( undef(  $proxy_types{$type} ) ){
    die "wrong proxy type!\n";
  }
  
  if( undef( $anonimity_levels{$anonimity} ) ){
    die "wrong anonimity level!\n";
  }
  
  
  my $final_url  = "https://hidemy.name/en/proxy-list/?ports=" . $port . "&type=" . $proxy_types{$type} . "&anon=" .  $anonimity_levels{$anonimity} . "#list";
  local $html = $lwp->get( $final_url );
  foreach( my $ip = $html =~ /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/ ){
      $ip = $1;
      push( $ip, @ip_array );
    }
  return( \@ip_array );
}


1;
