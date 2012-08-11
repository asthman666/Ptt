package Ptt::Controller::Profile;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base : Chained("/") : PathPart("profile") : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    unless ( $c->user_exists() ) {
	$c->res->redirect($c->uri_for($c->controller('User')->action_for('login')));
	$c->detach();
	return;
    }
}

sub profile : Chained("base") : PathPart("") : Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(template => "profile.tt");
}

sub list : Chained("base") : PathPart : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash(template => "list.tt");
}

sub list_result : Chained("base") : PathPart : Args(0) {
    my ( $self, $c ) = @_;

    my $uid = $c->user->uid;
    my $tag_id = $c->req->params->{tag_id};

    my ($results, $tags);

    $tags = [$c->model('PttDB::Tag')->search({uid => $uid})];

    my $items_rs;
    if ( $tag_id ) {
	$items_rs = $c->model("PttDB::Tag")->find($tag_id)->items;
    } else {
	$items_rs = $c->model('PttDB::User')->find($uid)->items;
    }

    while ( my $item = $items_rs->next ) {
	my $item_price_rs = $item->item_price->search({}, 
						      { page => 1, 
							rows => 10,
							select   => [ 'id', 'dt_created', { min => 'price' } ],
							as => [ 'id', 'dt_created', 'price' ],
							group_by => [("date(dt_created)")],
							order_by => "date(dt_created) desc",
						      });
	
	my %hh = $item->get_columns;

	my $item_tag_rs = $item->tags;
	while ( my $tag = $item_tag_rs->next ) {
	    push @{$hh{tag}}, $tag->value;
	}

	while ( my $item_price = $item_price_rs->next ) {
	    my %p = $item_price->get_columns;
	    $p{dt_created} =~ s{\-}{\/}g;
	    push @{$hh{$hh{id}}}, \%p;
	}

	if ( $hh{$hh{id}} ) {
	    $hh{price} = $hh{$hh{id}}->[0]->{price};
	    @{$hh{$hh{id}}} = sort { $a->{dt_created} cmp $b->{dt_created} } @{$hh{$hh{id}}};
	}

	$Template::Stash::PRIVATE = undef;

	#next if @{$hh{$hh{id}}} < 2;  # FIXME: why need to add this, because jqPlot when x-axis have only one value, will cause some wrong!!!

	push @$results, \%hh;
    }

    $c->stash(template => "list_result.tt", results => $results, tags => $tags);
}

sub del_item : Chained("base") : PathPart : Args(0) {
    my ( $self, $c ) = @_;

    my $uid = $c->user->uid;
    my $id = $c->req->params->{id};

    $c->model("PttDB::UserItem")->search({uid => $uid, id => $id})->delete;
    my $tag_rs = $c->model("PttDB::Tag")->search({uid => $uid});

    while ( my $tag = $tag_rs->next ) {
	my $tag_item_rs = $c->model("PttDB::TagItem")->search({tag_id => $tag->tag_id, id => $id});
	$tag_item_rs->delete if $tag_item_rs;
    }

    $c->res->redirect($c->uri_for($c->controller('Profile')->action_for('list_result')));
    $c->detach();
}

1;
