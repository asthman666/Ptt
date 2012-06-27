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

    my $items_rs = $c->model('PttDB::User')->find($uid)->items;

    my $results;
    while ( my $item = $items_rs->next ) {
	my $item_price_rs = $item->item_price->search({}, {order_by => "dt_created desc"});
	
	my %hh = $item->get_columns;
	my %seen;

	my $i;
	while ( my $item_price = $item_price_rs->next ) {
	    $i++;
	    if ( $i == 1 ) {
		$hh{price} = $item_price->get_column('price');
	    }

	    my %p = $item_price->get_columns;
	    
	    $p{dt_created} =~ m{(\d{4}-\d\d-\d\d)};

	    push @{$seen{"$1"}}, \%p;
	}

	foreach my $date ( keys %seen ) {
	    @{$seen{$date}} = sort {$a->{price} <=> $b->{price}} @{$seen{$date}};
	    $seen{$date}->[0]->{dt_created} = $date;
	    push @{$hh{$hh{id}}}, $seen{$date}->[0];
	}

	$Template::Stash::PRIVATE = undef;

	next if @{$hh{$hh{id}}} < 2;  # FIXME: why need to add this, because jqPlot when x-axis have only one value, will cause some wrong!!!

	push @$results, \%hh;
    }

    $c->stash(template => "list_result.tt", results => $results);
}

1;
