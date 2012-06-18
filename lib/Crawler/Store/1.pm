package Crawler::Store::1000;
use base qw(Crawler::Store);

sub new {
    my $class = shift;
    my $self = $class->SUPER::new();
    $self->init();
    return $self;
}

sub parse {
    my $body = shift;
    return unless $body;
    
    my %h;
    if ( $body =~ m{<h1>(.*?)<} ) {
	$h{title} = $1;
    }

    return [\%h];
}

1;
