package Ptt::Model::API::Search;
use Moose;
extends 'Ptt::Model::API';
use URI::Escape;
use namespace::autoclean;

sub search {
    my ( $self, $q, $sort ) = @_;

    my %qh;

    if ( $sort ) {
	if ( $sort eq "-price" ) {
	    $qh{sort} = "price desc";
	} elsif ( $sort eq "price" ) {
	    $qh{sort} = "price asc";
	}
    }

    my $path = "/solr/collection1/select?q=ean:$q&wt=json";
    foreach my $k ( keys %qh ) {
	$path .= "&$k=" . uri_escape($qh{$k});
    }

    $self->request($path);
}

__PACKAGE__->meta->make_immutable;

1;

