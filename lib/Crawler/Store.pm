package Crawler::Store;
use UA;

sub new {
    my $class = shift;
    my $self  = {};
    bless $self, $class;
    $self->init();
    return $self;
}

sub init {
    my $self = shift;
    $self->{ua} = UA->new();
}

1;
