package Taobao::Taobaoke::ItemsGet;
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
    my $q = shift;

    my $api_params = {
	fields    => 'num_iid,title,nick,pic_url,price,click_url,seller_credit_score,volume,item_location,commission,commission_rate',
	method    => 'taobao.taobaoke.items.get',
	nick      => $self->{nick},
	page_size => $self->{page_size},
	keyword   => uri_escape_utf8($q),
    };
    
    my $ref = $self->before_get($api_params);

    my $results       = $ref->{taobaoke_items_get_response}->{taobaoke_items}->{taobaoke_item};
    my $total_results = $ref->{taobaoke_items_get_response}->{total_results};

    $self->finalize($results);

    return ( $results, $total_results );
}

1;
