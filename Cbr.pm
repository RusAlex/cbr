package Cbr;
use warnings;
use strict;
use Dumpvalue;
use LWP::UserAgent;
use XML::XPath;
use XML::XPath::XMLParser;

sub new {
    my $class = shift;
    my $self  = {};
    bless $self, $class;
    return $self;
}

sub usd {
  my $ua = LWP::UserAgent->new;
  $ua->agent("Chrome");
  my $req = HTTP::Request->new(GET => 'http://www.cbr.ru/scripts/XML_daily_eng.asp');
  my $res = $ua->request($req);
  if(!$res->is_success) {
    exit(0); # exit if no CBR value
  }

  my $xp = XML::XPath->new(xml=>$res->content);
  my $usdcbr = $xp->getNodeText('//Valute[@ID="R01235"]/Value');
  my %usd;
  my $date = $xp->findnodes('//ValCurs');
  my $dumper = new Dumpvalue;
  $date = $date->pop()->getAttribute('Date');
  $usdcbr =~ s/,/./;

  $usd{'value'} = $usdcbr;
  $usd{'date'} = $date;
  #return $usdcbr;
  return %usd;
}

# Just Quick fix for getting EUR price I know KISS is not here =)
sub eur {
  my $ua = LWP::UserAgent->new;
  $ua->agent("Chrome");
  my $req = HTTP::Request->new(GET => 'http://www.cbr.ru/scripts/XML_daily_eng.asp');
  my $res = $ua->request($req);
  if(!$res->is_success) {
    exit(0); # exit if no CBR value
  }

  my $xp = XML::XPath->new(xml=>$res->content);
  my $eurcbr = $xp->getNodeText('//Valute[@ID="R01239"]/Value');
  my %eur;
  my $date = $xp->findnodes('//ValCurs');
  my $dumper = new Dumpvalue;
  $date = $date->pop()->getAttribute('Date');
  $eurcbr =~ s/,/./;

  $eur{'value'} = $eurcbr;
  $eur{'date'} = $date;
  return %eur;
}
1;
