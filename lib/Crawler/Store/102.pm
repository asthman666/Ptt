package Crawler::Store::102;
use base qw(Crawler::Store);

sub new {
    my $class = shift;
    my $self = $class->SUPER::new();
    return $self;
}

sub parse {
    my $self = shift;
    my $content = shift;
    return unless $content;

    #print $content, "\n";

    my %h;
    if ( $content =~ m{<h1>(.+?)<} ) {
	$h{name} = $1;
    }

    return [\%h];
}

1;
