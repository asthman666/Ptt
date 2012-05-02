#!/usr/bin/perl
use strict;
use warnings;

use Data::Dumper;

use Amazon::RequestSignatureHelper;
use LWP::UserAgent;
use XML::Simple;

my $access_key = shift;
my $secret_key = shift;

use constant myEndPoint	    => 'webservices.amazon.cn';

print "$access_key, $secret_key\n";

# Set up the helper
my $helper = new Amazon::RequestSignatureHelper (
    +Amazon::RequestSignatureHelper::kAWSAccessKeyId => $access_key,
    +Amazon::RequestSignatureHelper::kAWSSecretKey => $secret_key,
    +Amazon::RequestSignatureHelper::kEndPoint => myEndPoint,
);

# A simple ItemLookup request
my $request = {
    Service => 'AWSECommerceService',
    Operation => 'ItemLookup',
    AssociateTag => 'putaotao',
    Version => '2011-08-01',
    IdType => 'ASIN',
    ItemId => 'B007765FMI',
    ResponseGroup => 'ItemAttributes,Offers,Images,Reviews',
};

# Sign the request
my $signedRequest = $helper->sign($request);
# We can use the helper's canonicalize() function to construct the query string too.
my $queryString = $helper->canonicalize($signedRequest);
my $url = "http://" . myEndPoint . "/onca/xml?" . $queryString;
print "Sending request to URL: $url \n";

my $ua = new LWP::UserAgent();
my $response = $ua->get($url);
my $content = $response->content();
print "Recieved Response: $content \n";

my $xmlParser = new XML::Simple();
my $xml = $xmlParser->XMLin($content);

print "Parsed XML is: " . Dumper($xml) . "\n";

if ($response->is_success()) {
    my $title = $xml->{Items}->{Item}->{ItemAttributes}->{Title};
    print "titled \"$title\"\n";
} else {
    my $error = findError($xml);
    if (defined $error) {
	print "Error: " . $error->{Code} . ": " . $error->{Message} . "\n";
    } else {
	print "Unknown Error!\n";
    }
}

sub findError {
    my $xml = shift;
    
    return undef unless ref($xml) eq 'HASH';

    if (exists $xml->{Error}) { return $xml->{Error}; };

    for (keys %$xml) {
	my $error = findError($xml->{$_});
	return $error if defined $error;
    }

    return undef;
}

