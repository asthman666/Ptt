package Ptt::Model::Analysis::Model;
use Moose;
use utf8;
use namespace::autoclean;
use Debug;
extends 'Catalyst::Model';

sub is_model {
    my $self = shift;
    my $model = shift;
    return 0 unless $model;

    my $length = length($model);
    return 0 if ( $length <=2 || $length >= 20 );
    if ( $model =~ m{^[-a-zA-Z0-9+/]+$} ) {
        return 0 if $model =~ m{^\d+$};
        return 0 if $model =~ m{^[a-zA-Z]+$};
        return 0 if $model =~ m{\d+(g|gb|ml)}i;
        return 0 if $model !~ m{\d};

        if ( my $num = () = $model =~ m{\+}g ) {
            return 0 if ( $num > 1 );
        }
        
        if ( my $num = () = $model =~ m{-}g ) {
            return 0 if ( $num > 1 );
        }
        
        if ( my $num = () = $model =~ m{/}g ) {
            return 0 if ( $num > 1 );
        }

        return 1;
    }

    return 0;
}

__PACKAGE__->meta->make_immutable;

1;
