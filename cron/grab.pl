#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use Crawler::StoreLoader;
use AnyEvent;
use AnyEvent::HTTP;
use Encode;
use Ptt;
use Data::Dumper;

binmode STDOUT, ":encoding(UTF-8)";

my $connect_info = Ptt->config->{"Model::PttDB"}->{connect_info};
my $dsn      = delete $connect_info->{dsn};
my $user     = delete $connect_info->{user};
my $password = delete $connect_info->{password};

my $schema = Ptt::Schema->connect(
    $dsn,
    $user,
    $password,
    $connect_info,
);

my $rs = $schema->resultset('Item')->search({});

my $store_loader = Crawler::StoreLoader->new();

my $cv = AnyEvent->condvar;

while ( my $item = $rs->next ) {
    print $item->url, "\n";
    $cv->begin;

    http_get $item->url,
    headers => { "user-agent" => "Mozilla/5.0 (Windows NT 6.1; rv:13.0) Gecko/20100101 Firefox/13.0.1",
		 "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
		 "Accept-Language" => "zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3",
		 #"Accept-Encoding" => "gzip, deflate",
    },
    sub {
	my ( $body, $hdr ) = @_;
	print $hdr->{Status}, "\n";
	#$body = Encode::decode("gbk", $body);
	my $object = $store_loader->get_object(1);
	my $results = $object->parse($body);
	foreach ( @$results ) {
	    $_->{price} =~ s{,}{}g;
	    $schema->resultset('ItemPrice')->create({id => $item->id,
						     dt_created => \"now()",  #"
     					             price => $_->{price}}

		);
	}
	$cv->end;
    };
    last;
}

$cv->recv;

