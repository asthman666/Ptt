package Crawler::Store::101;
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

    if ( $url =~ m{key=} ) {
        # need to find url
	my $time = time;
        my $tree = HTML::TreeBuilder->new_from_content($content);
        if ( my $li = $tree->look_down(_tag => 'li', class => qr/line\d+/) ) {
            my $item_url = $li->look_down(_tag => 'p', class => 'name')->look_down(_tag => 'a')->attr('href');
            $item_url =~ s{#.+}{};
            $self->add_url({site_id => $self->{site_id}, url => $item_url});
        }
	$tree->delete;
	debug("find url cost: " . (time - $time));
    } elsif ( $url =~ m{product\.aspx\?product_id=(\d+)} ) {
        # need to find item info
        my %h;

        $h{sku} = $1;
        $h{url} = $url;

        if ( $content =~ m{<h1>(.+?)<} ) {
            $h{title} = $1;
        }

        if ( $content =~ m{<span class="yen">&yen;</span>(.+?)</b>} ) {
            $h{price} = $1;
        }
        
        $h{site_id} = $self->{site_id};
        $h{id} = $h{sku} . "-" . $h{site_id};
        
        $self->add_item(\%h);
    }
}

1;

