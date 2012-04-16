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
    my $api_params = shift;

    my $ref = $self->ref($api_params);

    my $results       = $ref->{taobaoke_items_get_response}->{taobaoke_items}->{taobaoke_item};
    my $total_results = $ref->{taobaoke_items_get_response}->{total_results};

    $self->finalize($results);

    return ( $results, $total_results );
}

1;
