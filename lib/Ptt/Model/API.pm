package Ptt::Model::API;
use Moose;
extends 'Catalyst::Model';

has [qw(api)] => ( is => 'ro' );

use Encode ();
use JSON;
use Try::Tiny 0.09;
use AnyEvent::HTTP qw(http_request);
use Debug;
use namespace::autoclean;
use XML::Simple;

{
    no warnings 'once';
    $AnyEvent::HTTP::PERSISTENT_TIMEOUT = 0;
    $AnyEvent::HTTP::USERAGENT = 'Ptt/Spider';
}

sub cv {
    AE::cv;
}

sub COMPONENT {
    my $self = shift;
    my ( $app, $config ) = @_;
    $config = $self->merge_config_hashes(
        {   api  => $app->config->{api},
	    aws_access_key => $app->config->{aws_access_key},
	    aws_secret_key => $app->config->{aws_secret_key},
	    aws_associate_tag => $app->config->{aws_associate_tag},
        },
        $config
    );
    return $self->SUPER::COMPONENT( $app, $config );
}

sub model {
    my ( $self, $model ) = @_;
    return Ptt->model('API') unless $model;
    return Ptt->model("API::$model");
}

sub request {
    my ( $self, $path, $method ) = @_;
    my $req = $self->cv;

    http_request $method ? $method
        : 'get' => $path,
        persistent => 0,
        sub {
            my ( $data, $headers ) = @_;
	    if ( $headers->{Status} ne '200' ) {
		debug("get Status $headers->{Status} for URL $headers->{URL}, Reason: $headers->{Reason}");
	    }
	    
	    if ( $data =~ m{^<\?xml} ) {
		my $xml = eval{ XMLin($data, ForceArray => ['Item', 'Author', 'EAN']) };
		$req->send( $@ ? $self->raw_api_response($data) : $xml );
	    } else {
		my $json = eval { decode_json($data) };
		$req->send( $@ ? $self->raw_api_response($data) : $json );
	    }
    };

    return $req;
}

my $encoding = Encode::find_encoding('utf-8-strict')
  or warn 'UTF-8 Encoding object not found';
my $encode_check = ( Encode::FB_CROAK | Encode::LEAVE_SRC );

sub raw_api_response {
    my ($self, $data) = @_;

    # will http_response ever return undef or a blessed object?
    $data  = '' if ! defined $data; # define
    $data .= '' if       ref $data; # stringify

    # we have to assume an encoding; doing nothing is like assuming latin1
    # we'll probably have the least number of issues if we assume utf8
    try {
      # decode so the template doesn't double-encode and return mojibake
        $data &&= $encoding->decode( $data, $encode_check );
    }
    catch {
      warn $_[0];
    };

    return +{ raw => $data };
}

__PACKAGE__->meta->make_immutable;

1;

