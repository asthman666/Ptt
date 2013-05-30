use utf8;
package Ptt::Schema::Result::Property;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Ptt::Schema::Result::Property

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<property>

=cut

__PACKAGE__->table("property");

=head1 ACCESSORS

=head2 property_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 dt_created

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 active

  data_type: 'enum'
  default_value: 'y'
  extra: {list => ["y","n"]}
  is_nullable: 0

=head2 dt_updated

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 property_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 type

  data_type: 'enum'
  default_value: 'varchar'
  extra: {list => ["varchar","int"]}
  is_nullable: 0

=head2 is_array

  data_type: 'enum'
  default_value: 'n'
  extra: {list => ["y","n"]}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "property_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "dt_created",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "active",
  {
    data_type => "enum",
    default_value => "y",
    extra => { list => ["y", "n"] },
    is_nullable => 0,
  },
  "dt_updated",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "property_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "type",
  {
    data_type => "enum",
    default_value => "varchar",
    extra => { list => ["varchar", "int"] },
    is_nullable => 0,
  },
  "is_array",
  {
    data_type => "enum",
    default_value => "n",
    extra => { list => ["y", "n"] },
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</property_id>

=back

=cut

__PACKAGE__->set_primary_key("property_id");


# Created by DBIx::Class::Schema::Loader v0.07024 @ 2013-05-30 20:05:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Wh8vSlD+pU6ArVAFCguB8Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
