package Taobao::Taobaoke::ItemsConvert;
use strict;
use warnings;
use base qw(Taobao);

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    return $self;
}

sub get {
    my $self = shift;
    my %conf = @_;

    my $num_iids = $conf{num_iids};
    my $nick     = $conf{nick};
    my $fields   = $conf{fields} || 'num_iid,title,nick,pic_url,price,click_url,seller_credit_score,volume,item_location,commission,commission_rate';

    my $api_params = {
	fields    => $fields,
	method    => 'taobao.taobaoke.items.convert',
	nick      => $nick,
	num_iids  => $num_iids,
    };
    
    my $ref = $self->ref($api_params);

    my $results       = $ref->{taobaoke_items_convert_response}->{taobaoke_items}->{taobaoke_item};
    my $total_results = $ref->{taobaoke_items_convert_response}->{total_results};

    $self->finalize($results);

    return ($results, $total_results);
}

1;
