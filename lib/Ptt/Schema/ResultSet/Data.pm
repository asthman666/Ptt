package Ptt::Schema::ResultSet::Data;

use Moose;
use namespace::autoclean;
extends qw/DBIx::Class::ResultSet/;

use Debug;

sub create_data {
    my ($self, $info) = @_;

    debug("=========" . $info->{title});

    $self->find_or_create({ douban_id => $info->{douban_id},
			    summary   => $info->{summary},
			    title     => $info->{title},
			    image_url => $info->{image_url},
			  },
			  { key => 'primary' });
}

1;
