package Ptt::Model::Analysis::Query;
use Moose;
extends 'Catalyst::Model';
use Business::ISBN qw( valid_isbn_checksum );
use namespace::autoclean;
use Debug;

sub parse_q {
    my $self = shift;
    my $q = shift;
    return unless $q;
    
    my $qh;

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
    } else {
	$qh->{k} = $q;
    }

    return $qh;
}

__PACKAGE__->meta->make_immutable;

1;
