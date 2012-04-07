package Taobao::ItemsSearch;
use strict;
use warnings;
use base qw(Taobao);
use URI::Escape;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    return $self;
}

sub get {
    my $self = shift;
    my %conf = @_;

    my $q = $conf{q};
    my $p = $conf{p};
    my $fields = $conf{fields};
    my $page_size = $conf{page_size};
    my $sort = $conf{sort} || "popularity:desc";

    my $api_params = {
	fields    => $fields,
	method    => 'taobao.items.search',
	page_size => $page_size,
	page_no   => $p,
	'q'       => uri_escape_utf8($q),
	order_by  => $sort,
    };
    
    my $ref = $self->ref($api_params);

    my $results       = $ref->{items_search_response}->{item_search}->{items}->{item};
    my $facet         = $ref->{items_search_response}->{item_search}->{item_categories}->{item_category};
    my $total_results = $ref->{items_search_response}->{total_results};

    $self->finalize($results);

    return ( $results, $total_results, $facet );
}

1;
