package Taobao::ItemList;
use strict;
use warnings;
use base qw/Taobao/;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    return $self;
}

sub get {
    my ($self, $num_iids) = @_;
    return if !$num_iids || @$num_iids > 20;

    my @fields = qw(num_iid cid freight_payer);
    my $api_params = { num_iids     => join(",", @$num_iids),
                       fields       => join(",", @fields),
                       method       => 'taobao.items.list.get' };

    my $ref = $self->ref($api_params);

    return $ref->{items_list_get_response}->{items}->{item};
}


1;
