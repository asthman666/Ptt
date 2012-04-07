package Page;
use Moose;

has 'step' => (isa => 'Int', is => 'rw', lazy => 1, default => 3);
has 'more' => (isa => 'Int', is => 'rw');
has 'before_page_list' => (isa => 'ArrayRef', is => 'rw', lazy => 1, default => sub{[]});
has 'after_page_list' => (isa => 'ArrayRef', is => 'rw', lazy => 1, default => sub {[]});
has 'data_page' => (isa => 'Data::Page', is => 'rw');

sub paging {
    my $self = shift;
    my $step = shift;
    $self->step($step) if $step;
    
    my $current_page = $self->data_page->current_page;

    foreach (1..$self->step) {
	my $before_tmp_p = $current_page - $_;
	if ( $before_tmp_p > 0 ) {
	    unshift @{$self->before_page_list}, $before_tmp_p;
	} else {
	    last;
	}
    }

    foreach (1..$self->step) {
	my $after_tmp_p = $current_page + $_;
	if ( $after_tmp_p <= $self->data_page->last_page ) {
	    push @{$self->after_page_list}, $after_tmp_p;
	} else {
	    last;
	}
    }
    $self->more($self->data_page->current_page + $self->step < $self->data_page->last_page ? 1 : 0);
}


1;

