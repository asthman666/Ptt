package Crawler::Store::1;
use base qw(Crawler::Store);

sub new {
    my $class = shift;
    my $self = $class->SUPER::new();
    return $self;
}

sub parse {
    my $self = shift;
    my $body = shift;
    return unless $body;

    #print $body, "\n";

    my %h;
    if ( $body =~ m{<b class="priceLarge">￥\s*([\d.,]+)} ) {
	$h{price} = $1;
    }

    return [\%h];
}

1;
