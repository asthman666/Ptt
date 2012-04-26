use utf8;
package Ptt::Schema::Result::DataAttr;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Ptt::Schema::Result::DataAttr

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<data_attr>

=cut

__PACKAGE__->table("data_attr");

=head1 ACCESSORS

=head2 douban_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 att_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 attr_value

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 display_order

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "douban_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "att_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "attr_value",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "display_order",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
);


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-04-25 21:14:24
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bhr6rf+odoxqI/ZVK2+7XA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
