package Ptt::Model::API::Search;
use Moose;
extends 'Ptt::Model::API';
use URI::Escape;
use namespace::autoclean;

sub search {
    my ( $self, $qh, $sort ) = @_;

    my %assistant;

    if ( $sort ) {
	if ( $sort eq "-price" ) {
	    $assistant{sort} = "price desc";
	} elsif ( $sort eq "price" ) {
	    $assistant{sort} = "price asc";
	}
    }

    my $path;
    if ( $qh->{ean} ) {
	$path = "/solr/collection1/select?q=ean:$qh->{ean}&wt=json";
    } elsif ( $qh->{k} ) {
	$path = "/solr/collection1/select?q=title:" . uri_escape_utf8($qh->{k}) . "&wt=json";
    }

    if ( $qh->{p} ) {
	$path .= "&rows=10&start=" . (10*($qh->{p}-1));
    }

    foreach my $k ( keys %assistant ) {
	$path .= "&$k=" . uri_escape($assistant{$k});
    }

    $self->request($path);
}

__PACKAGE__->meta->make_immutable;

1;

