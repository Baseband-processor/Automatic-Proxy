package Automatic::Proxy;

# Made by Edoardo Mantovani, 2020
# scrape automatic proxies

use strict;
no strict 'refs';
use warnings;
use List::MoreUtils qw(uniq);

use LWP::UserAgent;

# interface for hidemy.name

use constant HIDEMYNAME => "https://hidemy.name/en/proxy-list/?";
use constant ALL_COUNTRY => "AFALARAMAUATBDBYBEBZBJBOBWBRBGBFBIKHCMCACLCNCOCDCRHRCYCZDJDOECEGGQFIFRGEDEGHGRGTGNHTHNHKHUINIDIRIQIEITJPKZKEKRLALVLBLYLTMYMVMTMXMDMNMZMMNPNLNINGPKPSPAPYPEPHPLPRRORUSARSSGSKSISOZAESSECHSYTWTHTRUGUAAEGBUSUZVEVNVGZMZW";

use constant SPYSONE => "spys.one";

my $lwp = LWP::UserAgent->new(
      protocols_allowed => ['http', 'https'],
);

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

# set ms to 100 (maximun)
my @ip_array;
sub scrape_hidemy{
  my( $port, $type, $anonimity, $all_country ) = @_;
  my $final_url;
  if( $port > 65535 || undef( $port ) ){
    die "not inserted port variable or maximun port number is wrong!\n";
  }
  if( undef(  $proxy_types{$type} ) ){
    die "wrong proxy type!\n";
  }
  
  if( undef( $anonimity_levels{$anonimity} ) ){
    die "wrong anonimity level!\n";
  }
  if( defined($all_country) && $all_country == 1 ){
  $final_url  = "https://hidemy.name/en/proxy-list/?country=AFALARAMAUATBDBYBEBZBJBOBWBRBGBFBIKHCMCACLCNCOCDCRHRCYCZDJDOECEGGQFIFRGEDEGHGRGTGNHTHNHKHUINIDIRIQIEITJPKZKEKRLALVLBLYLTMYMVMTMXMDMNMZMMNPNLNINGPKPSPAPYPEPHPLPRRORUSARSSGSKSISOZAESSECHSYTWTHTRUGUAAEGBUSUZVEVNVGZMZW&ports=" . $port . "&maxtime=100&type=" . $proxy_types{$type} . "&anon=" .  $anonimity_levels{$anonimity} . "#list";
  }else{
    $final_url  = "https://hidemy.name/en/proxy-list/?ports=" . $port . "&maxtime=100&type=" . $proxy_types{$type} . "&anon=" .  $anonimity_levels{$anonimity} . "#list";
  }
  
  local $html = $lwp->get( $final_url );
  foreach( local $ip = $html =~ /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/ ){
      $ip = $1;
      push( $ip, @ip_array );
    }
  return( \@ip_array );
}


sub scrape_spysone{
      local $spysone = $lwp->get("https://spys.one/en/");
      foreach( local $spyIP = $spysone =~ /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/ ){
            $spyIP = $1;
            push($spyIP, @ip_array);
      }
    return( \@ip_array );
}

# scrape best proxy with highest anonimity level and socks5 

sub set_bestProxy {
      my ( $port, $timeout, $LWP_istance ) = @_; # $timeout refers to sProxy reflesh
      if( ! ( ref( $LWP_istance ) =~ "lwp" || ref( $LWP_istance ) =~ "LWP" ) ){
            return -1;
      }
      my @candidates = uniq( @{ &scrape_hidemy( $port, "Socks5", "High", 1) } ); # remove duplicates
      foreach( uniq( &scrape_spysone() ) ){
            push ($_, @candidates);
      }
      $LWP_istance->proxy( ['http'], $candidates[0] );
      return 1;
      }

1;
