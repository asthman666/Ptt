package Ptt::Model::API::Search;
use Moose;
extends 'Ptt::Model::API';
use URI::Escape;
use namespace::autoclean;

sub search {
    my ( $self, $qh ) = @_;

    my %assistant;

    if ( $qh->{sort} ) {
	if ( $qh->{sort} eq "-price" ) {
	    $assistant{sort} = "price desc";
	} elsif ( $qh->{sort} eq "price" ) {
	    $assistant{sort} = "price asc";
	}
    }

    my $path;
    if ( $qh->{site_id} ) {
       $path = "/solr/collection1/select?q=site_id:$qh->{site_id}&wt=json";
    } elsif ( $qh->{ean} ) {
	$path = "/solr/collection1/select?q=ean:$qh->{ean}&wt=json";
    } elsif ( $qh->{k} ) {
	$path = "/solr/collection1/select?q=title:(" . uri_escape_utf8($qh->{k}) . ")&wt=json&q.op=AND";
    }

    if ( $qh->{p1} || $qh->{p2} ) {
        my $p1 = $qh->{p1} || "*";
        my $p2 = $qh->{p2} || "*";
        my $pr = "price:[$p1 TO $p2]";
        $path .= "&fq=" . uri_escape($pr);
    }

    my $stock;
    if ( $qh->{stock} == 1 ) {
	$stock = 'available:"in stock"';
    } elsif ( $qh->{stock} == 2 ) {
	$stock = 'available:"out of stock"';
    } elsif ( $qh->{stock} == 3 ) {
	$stock = 'available:"pre order"';
    }
    
    if ( $stock ) {
	$path .= "&fq=" . uri_escape($stock);
    }

    if ( $qh->{p} && $qh->{page_size} ) {
	$path .= "&rows=$qh->{page_size}&start=" . ($qh->{page_size}*($qh->{p}-1));
    }

    foreach my $k ( keys %assistant ) {
	$path .= "&$k=" . uri_escape($assistant{$k});
    }

    $self->request($path);
}

__PACKAGE__->meta->make_immutable;

1;

