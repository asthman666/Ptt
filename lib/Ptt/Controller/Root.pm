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
    $self->best_item($c, $c->req->params->{p});
}

sub best_item {
    my ( $self, $c, $p ) = @_;
    $p ||= 1;

    my $rs = $c->model("PttDB::BestItem")->search(undef, 
						  {
						      page => $p,
						      rows => $c->config->{page_size},
						      order_by => "volume desc",
						  });
    my $results = [$rs->all];
    my $data_page = $rs->pager;
    my $page = Page->new(data_page => $data_page);
    $page->paging;
    
    $c->stash(results => $results,
	      page => $page,
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
