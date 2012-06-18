package Crawler::StoreLoader;

sub new {
    my $class = shift;
    my $self = {
	path => 'Crawler::Store::',
	@_,
    };
    bless $self, $class;
    return $self;
}

sub get_object {
    my ($self, $sid) = @_;
    return unless $sid;

    # we need to save store object into the parser object, so we don't create again and again
    return $self->{$sid} if ( $self->{$sid} );

    my $pkg_name = $self->get_pkg_name($sid);

    my $create_object = "use $pkg_name; $pkg_name->new;";

    my $object = eval $create_object;

    if ( $@ ) {
	print "error $@\n";
    }

    $self->{$sid} = $object;

    return $object;

}

sub get_pkg_name {
    my ($self, $sid) = @_;
    return $self->{path} . $sid;
}


1;
