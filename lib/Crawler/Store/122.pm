package Crawler::Store::122;
use base qw(Crawler::Store);
use HTML::TreeBuilder;
use Debug;
use Time::HiRes qw(time);

sub new {
    my $class = shift;
    my $self = $class->SUPER::new();
    $self->_init();
    return $self;
}

sub _init {
    my $self = shift;
    ($self->{site_id}) = __PACKAGE__ =~ m{Store::(\d+)};
}

sub parse {
    my $self = shift;
    my $url  = shift;
    my $content = shift;
    return unless $content;
    
    if ( $url =~ m{search\.aspx} ) {
        # need to find url
	my $time = time;
        my $tree = HTML::TreeBuilder->new_from_content($content);
        if ( my $div = $tree->look_down(class => 'mbd') ) {
            if ( my $ul = $div->look_down(_tag => 'ul') ) {
                if ( my $li = $ul->look_down(_tag => 'li') ) {
                    if ( my $url = $li->look_down(_tag => 'a')->attr('href') ) {
                        $self->add_url({site_id => $self->{site_id},url => $url});
                    }
                }
            }
        }
	$tree->delete;
	debug("find url cost: " . (time - $time));
    } elsif ( $url =~ m{wl\.cn/(\d+)} ) {
        # need to find item info
        my $time = time;
        my %h;

        $h{sku} = $1;
        $h{url} = $url;

	my $sku_tree = HTML::TreeBuilder->new_from_content($content);

	if ( my $h1 = $sku_tree->look_down(_tag => 'h2') ) {
	    $h{title} = $h1->as_trimmed_text;
	}

	if ( my $ul = $sku_tree->look_down('class', 'lh wl') ) {
            $h{price} = $ul->as_trimmed_text;
        }
	$sku_tree->delete;

        $h{site_id} = $self->{site_id};
        $h{id} = $h{sku} . "-" . $h{site_id};

        $h{price} =~ s{[^\d,.]}{}g;

        $self->add_item(\%h);
        debug("parse item cost: " . (time - $time));
    }
}

1;


