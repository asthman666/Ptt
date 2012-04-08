package Taobao::ItemCatsGet;
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

    my $parent_cid = $conf{parent_cid};

    my $api_params = {
	fields    => 'cid,parent_cid,name,is_parent',
	method    => 'taobao.itemcats.get',
	parent_cid => $parent_cid,
    };
    
    my $ref = $self->ref($api_params);

    return $ref->{itemcats_get_response}->{item_cats}->{item_cat};
}

1;
