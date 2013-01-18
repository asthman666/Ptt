#!/usr/bin/env perl
use strict;
use warnings;
use AnyEvent::HTTP qw(http_request);
use Data::Dumper;

{
    no warnings 'once';
    $AnyEvent::HTTP::PERSISTENT_TIMEOUT = 0;
    $AnyEvent::HTTP::USERAGENT = 'Ptt/Spider';
    $AnyEvent::HTTP::TIMEOUT = 1;
}

sub cv {
    AE::cv;
}

sub request {
    my ( $path, $method ) = @_;
    
    my $req = cv();
    http_request $method ? $method
        : 'get' => "http://localhost:8983" . $path,
        persistent => 0,
        sub {
            my ( $data, $headers ) = @_;
	    if ( $headers->{Status} ne '200' ) {
		debug("get Status $headers->{Status} for URL $headers->{URL}, Reason: $headers->{Reason}");
	    }
	    my $json = eval { decode_json($data) };
	    $req->send( $@ ? $data : $json );
    };

    return $req;
}

my $p = "/solr/collection1/select?q=ean:9787549529322&wt=json";

foreach ( 1..10 ) {
    my $req = request($p);
    my $data = $req->recv();
    print "index: $_, data: $data\n";
    sleep 5;
}

