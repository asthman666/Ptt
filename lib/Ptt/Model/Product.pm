package Ptt::Model::Product;
use Moose;
extends 'Catalyst::Model';
use Data::Dumper;
use Debug;

has 'property' => (is => 'rw', isa => 'ArrayRef', default => sub {[]});

sub BUILD {
    my $self = shift;
    foreach ( Ptt->model('PttDB::Property')->search({active => 'y'}) ) {
        push @{$self->property}, $_;
    }
}

sub add {
    my ($self, $h) = @_;
    my $product = Ptt->model('PttDB::Product');    

    my $now = "now()";

    my $p;
    if ( $p = $product->find( { asin => $h->{asin} }, { key => 'asin' } ) ) {
        
    } else {
        $p = $product->create( {title => $h->{title}, image_url => $h->{image_url}, asin => $h->{asin}, dt_created => \$now, dt_updated => \$now} );
    }

    my $product_id = $p->product_id;

    # add property
    foreach my $prop ( @{$self->property} ) {
        if ( $h->{$prop->property_name} ) {
            if ( $prop->is_array eq 'y' ) {
		Ptt->model('PttDB::Product' . ucfirst($prop->type))->search({product_id => $product_id, property_id => $prop->property_id})->delete;
                my $display_order = 0;
                foreach my $value ( @{$h->{$prop->property_name}} ) {
                    Ptt->model('PttDB::Product' . ucfirst($prop->type))->create({dt_created => \$now, dt_updated => \$now, product_id => $product_id, property_id => $prop->property_id, value => $value, display_order => $display_order++});
                }
            } else {
		if ( Ptt->model('PttDB::Product' . ucfirst($prop->type))->search({product_id => $product_id, property_id => $prop->property_id, value => $h->{$prop->property_name}}) ) {
	
		} else {
                    Ptt->model('PttDB::Product' . ucfirst($prop->type))->create({dt_created => \$now, dt_updated => \$now, product_id => $product_id, property_id => $prop->property_id, value => $h->{$prop->property_name}});
		}
            }
        }
    }
}

__PACKAGE__->meta->make_immutable;

1;

