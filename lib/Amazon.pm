package Amazon;
use strict;
use warnings;

use Amazon::RequestSignatureHelper;
use XML::Simple;
use LWP::UserAgent;

sub new {
    my $class = shift;
    my $self = { 
	acess_key     => undef,
	secret_key    => undef,
	associate_tag => undef,
	service       => 'AWSECommerceService',
	version       => '2011-08-01',
	myendpoint    => 'webservices.amazon.cn',
	@_,
    };
    bless $self, $class;
    $self->init();
    return $self;
}

sub init {
    my $self = shift;
    $self->{helper} = Amazon::RequestSignatureHelper->new(
	+Amazon::RequestSignatureHelper::kAWSAccessKeyId => $self->{access_key},
	+Amazon::RequestSignatureHelper::kAWSSecretKey   => $self->{secret_key},
	+Amazon::RequestSignatureHelper::kEndPoint       => $self->{myendpoint},
	);
    $self->{ua} = LWP::UserAgent->new();
}

sub url {
    my $self   = shift;
    my $request = shift;

    $request->{Service}      = $self->{service};
    $request->{AssociateTag} = $self->{associate_tag};
    $request->{Version}      = $self->{version};

    my $signed_request = $self->{helper}->sign($request);
    my $query_string = $self->{helper}->canonicalize($signed_request);
    return "http://" . $self->{myendpoint} . "/onca/xml?" . $query_string;
    
}

sub ref {
    my $self   = shift;
    my $request = shift;

    my $url = $self->url($request);
    my $res = $self->{ua}->get($url);
    my $content = $res->content;
    my $ref = XMLin($content, ForceArray => [ 'Items' ]);

    return $ref;
}

1;



