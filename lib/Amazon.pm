package Amazon;
use strict;
use warnings;

use Amazon::RequestSignatureHelper;

sub new {
    my $class = shift;
    my $self = {@_};
    bless $self, $class;
    $self->init();
    return $self;
}

sub init {
    my $self = shift;
    $self->{helper} = Amazon::RequestSignatureHelper->new(
	+Amazon::RequestSignatureHelper::kAWSAccessKeyId => $self->{access_key},
	+Amazon::RequestSignatureHelper::kAWSSecretKey => $self->{secret_key},
	+Amazon::RequestSignatureHelper::kEndPoint => $self->{myendpoint},
	);
}

sub url {
    my $self   = shift;
    my $params = shift;
    my $signed_request = $self->{helper}->sign($params);
    my $query_string = $self->{helper}->canonicalize($signed_request);
    return "http://" . $self->{myendpoint} . "/onca/xml?" . $query_string;
    
}

1;



