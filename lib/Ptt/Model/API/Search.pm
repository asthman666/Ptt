package Ptt::Model::API::Search;
use Moose;
extends 'Ptt::Model::API';
use namespace::autoclean;

sub search {
    my ( $self, $q ) = @_;
    $self->request("/solr/collection1/select?q=ean:$q&wt=json");
}

__PACKAGE__->meta->make_immutable;

1;

