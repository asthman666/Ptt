#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use Crawler::StoreLoader;
use AnyEvent;
use AnyEvent::HTTP;
use HTTP::Message;
use HTTP::Headers;
use Ptt;
use Data::Dumper;
use Debug;

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
    debug $item->url;
    $cv->begin;

    http_get $item->url,
    headers => { "user-agent" => "Mozilla/5.0 (Windows NT 6.1; rv:13.0) Gecko/20100101 Firefox/13.0.1",
		 "Accept-Encoding" => "gzip, deflate",
    },
    sub {
	my ( $body, $hdr ) = @_;
	debug $hdr->{Status};
	my $object = $store_loader->get_object($item->store_id);

	my $header = HTTP::Headers->new('Content-Encoding' => "gzip, deflate");
	my $mess = HTTP::Message->new( $header, $body );
	my $output = $mess->decoded_content;

	my $results = $object->parse($output);

	foreach ( @$results ) {
	    if ($_->{availability} && $_->{availability} eq 'out of stock') {
		debug "item id: " . $item->id . ", out of stock";
		next;
	    }

	    unless ( $_->{price} ) {
		debug "item id: " . $item->id . ", no price";
		next;
	    }

	    $_->{price} =~ s{,}{}g;
	    $schema->resultset('ItemPrice')->create({id => $item->id,
						     dt_created => \"now()",  #"
     					             price => $_->{price}}

		);
	}
	$cv->end;
    };
}

$cv->recv;

