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

sub add_url {
    my $self = shift;
    my $url = shift;
    push @{$self->{url}}, $url;
}

sub clean_url {
    my $self = shift;
    return delete $self->{url};
}

sub add_item {
    my $self = shift;
    my $item = shift;
    push @{$self->{item}}, $item;
}

sub clean_item {
    my $self = shift;
    return delete $self->{item};
}

1;

