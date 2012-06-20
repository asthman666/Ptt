use utf8;
package Ptt::Schema::Result::Item;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Ptt::Schema::Result::Item

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<item>

=cut

__PACKAGE__->table("item");

=head1 ACCESSORS

=head2 id

  data_type: 'char'
  default_value: (empty string)
  is_nullable: 0
  size: 22

=head2 active

  data_type: 'enum'
  default_value: 'y'
  extra: {list => ["y","n"]}
  is_nullable: 0

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

=head2 image_url

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 url

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 1024

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "char", default_value => "", is_nullable => 0, size => 22 },
  "active",
  {
    data_type => "enum",
    default_value => "y",
    extra => { list => ["y", "n"] },
    is_nullable => 0,
  },
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
  "image_url",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "url",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 1024 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07024 @ 2012-06-19 21:55:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5Ed8tWay+1ca+WSPhQP7Xw

__PACKAGE__->has_many(user_item => 'Ptt::Schema::Result::UserItem', 'id');
__PACKAGE__->has_many(item_price => 'Ptt::Schema::Result::ItemPrice', 'id');

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
