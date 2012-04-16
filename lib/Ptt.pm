package Ptt;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    ConfigLoader
    Static::Simple
    Unicode::Encoding

    Authentication

    Session
    Session::State::Cookie
    Session::Store::Memcached
/;

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in ptt.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'Ptt',

    encoding => 'UTF-8',

    'Plugin::Authentication' => {
	default_realm => 'members',
	members => {
	    credential => {
		class => 'Password',
		password_type => 'hashed',
		password_hash_type => 'MD5',
	    },
	    store => {
		class => 'DBIx::Class',
		user_model => 'PttDB::User',
	    }
	},	
    },

    'Plugin::Session' => {
        memcached_new_args => {
            'data' => [ "127.0.0.1:11211" ],
        },
        cookie_expires => 0,   # session cookie, which will die when the user's browser is shut down.
    },

    'View::TT' => {
	INCLUDE_PATH => [
	    __PACKAGE__->path_to( 'root', 'tmpl' ),
	    __PACKAGE__->path_to( 'root', 'lib' ),
            ],	
	WRAPPER => 'site/wrapper',	    
    },
    default_view => 'TT',

    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
);

# Start the application
__PACKAGE__->setup();


=head1 NAME

Ptt - Catalyst based application

=head1 SYNOPSIS

    script/ptt_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Ptt::Controller::Root>, L<Catalyst>

=head1 AUTHOR

mamaya,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
