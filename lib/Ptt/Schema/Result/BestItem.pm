use utf8;
package Ptt::Schema::Result::BestItem;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Ptt::Schema::Result::BestItem

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<best_item>

=cut

__PACKAGE__->table("best_item");

=head1 ACCESSORS

=head2 item_id

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 dt_created

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 dt_updated

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 pic_url

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 price

  data_type: 'decimal'
  default_value: 0.00
  is_nullable: 0
  size: [10,2]

=head2 click_url

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 512

=head2 nick

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 score

  data_type: 'tinyint'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 volume

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 root_cid

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 cid

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 freight_payer

  data_type: 'enum'
  default_value: 'buyer'
  extra: {list => ["buyer","seller"]}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "item_id",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "dt_created",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "dt_updated",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "title",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "pic_url",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "price",
  {
    data_type => "decimal",
    default_value => "0.00",
    is_nullable => 0,
    size => [10, 2],
  },
  "click_url",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 512 },
  "nick",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "score",
  {
    data_type => "tinyint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "volume",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "root_cid",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "cid",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "freight_payer",
  {
    data_type => "enum",
    default_value => "buyer",
    extra => { list => ["buyer", "seller"] },
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</item_id>

=back

=cut

__PACKAGE__->set_primary_key("item_id");


# Created by DBIx::Class::Schema::Loader v0.07024 @ 2012-05-12 10:42:57
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:MM6pEwiQp3Lmrp7Klkv1vg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
