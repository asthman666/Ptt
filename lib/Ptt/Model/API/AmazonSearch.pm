package Ptt::Model::API::AmazonSearch;
use Moose;
extends 'Ptt::Model::API';
use URI::Escape;
use namespace::autoclean;
use Amazon;
use Debug;

has 'amazon' => (is => 'rw', lazy_build => 1);

sub _build_amazon {
    my $self = shift;
    my $amazon = Amazon->new(
	access_key => $self->{aws_access_key},
	secret_key => $self->{aws_secret_key},
	associate_tag => $self->{aws_associate_tag}, 
	);
    return $amazon;
}

sub search {
    my ( $self, $qh ) = @_;

    my $request = {
	Operation => 'ItemSearch',
	SearchIndex => 'Books',
	Power => 'keywords:' . $qh->{k},
	ResponseGroup => 'ItemAttributes,Images',
	ItemPage => $qh->{p},
    };

    my $url = $self->amazon->url($request);
    $self->request($url);
}

__PACKAGE__->meta->make_immutable;

1;

