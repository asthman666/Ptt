package Ptt::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

use Page;

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

use Data::Dumper;

=head1 NAME

Ptt::Controller::Root - Root Controller for Ptt

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    $self->best_item($c);
}

sub best_item {
    my ( $self, $c ) = @_;
    my $p   = $c->req->params->{p};
    my $cid = $c->req->params->{cid};

    $p ||= 1;
    
    my %search_cond;
    $search_cond{cid} = $cid if $cid;

    my $rs = $c->model("PttDB::BestItem")->search(\%search_cond,
						  {
						      page => $p,
						      rows => $c->config->{page_size},
						      order_by => "volume desc",
						  });
    my $results = [$rs->all];
    my $data_page = $rs->pager;
    my $page = Page->new(data_page => $data_page);
    $page->paging;

    my $facet_rs = $c->model("PttDB::BestItem")->search({}, 
						     {
							 select   => ['cid', 'root_cid', { count => "*" }], 
							 as       => [qw(id rcid count)],
							 group_by => [qw(cid)]
						     });
    
    my $db_facet = [$facet_rs->all];
    
    my @all_cids = map { $_->get_column('id') } @$db_facet;
    
    my %cid_map;

    my $cid_rs = $c->model("PttDB::Cid")->search({ cid => { -in => [@all_cids] } });
    
    while ( my $t = $cid_rs->next ) {
	$cid_map{$t->cid} = $t->name;
    }

    my $facet;
    foreach ( @$db_facet ) {
	my $t;
	$t->{name}      = $cid_map{$_->get_column('id')};
	$t->{id}        = $_->get_column('id');
	$t->{count}     = $_->get_column('count');
	$t->{rcid}      = $_->get_column('rcid');
	push @{$facet->{$_->get_column('rcid')}}, $t;
    }

    $c->stash(results => $results,
	      facet   => $facet,
	      page    => $page,
	);
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

mamaya,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
