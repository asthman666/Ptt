package Ptt::Model::Analysis::Query;
use Moose;
use utf8;
use Business::ISBN qw( valid_isbn_checksum );
use namespace::autoclean;
use Debug;
extends 'Catalyst::Model';

sub parse_q {
    my $self = shift;
    my $q = shift;
    return unless $q;
    
    my $qh;

    $q =~ s{输入手机型号, 例如:}{};
    $q =~ s{^\s+}{};
    $q =~ s{\s+$}{};
    $q =~ s{\s{2,}}{ }g;
    
    if ( $q =~ m{^\d{10}$} ) {
	if ( valid_isbn_checksum($q) ) {
	    my $isbn10 = Business::ISBN->new($q);
	    $qh->{ean} = $isbn10->as_isbn13->isbn;
	}
    } elsif ( $q =~ m{^\d{13}$} ) {
	if ( valid_isbn_checksum($q) ) {
	    $qh->{ean} = $q;
	}
    } elsif ( $q =~ m{site_id:\s*(\d+)} ) {
        $qh->{site_id} = $1;
    } else {
	$qh->{k} = $q;
    }

    return $qh;
}

__PACKAGE__->meta->make_immutable;

1;
