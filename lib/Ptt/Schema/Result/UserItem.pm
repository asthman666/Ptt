use utf8;
package Ptt::Schema::Result::UserItem;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Ptt::Schema::Result::UserItem

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<user_item>

=cut

__PACKAGE__->table("user_item");

=head1 ACCESSORS

=head2 uid

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 id

  data_type: 'char'
  default_value: (empty string)
  is_nullable: 0
  size: 22

=cut

__PACKAGE__->add_columns(
  "uid",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "id",
  { data_type => "char", default_value => "", is_nullable => 0, size => 22 },
);

=head1 PRIMARY KEY

=over 4

=item * L</uid>

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("uid", "id");


# Created by DBIx::Class::Schema::Loader v0.07024 @ 2012-06-18 22:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bL6+bS2Gz/cZbfb3YPRmaA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
