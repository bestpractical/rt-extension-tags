use strict;
use warnings;
package RT::Extension::Tags;

our $VERSION = '0.01';

=head1 NAME

RT-Extension-Tags - Provides simple tagging using custom fields

=head1 DESCRIPTION

This extension allows you to create tags using custom fields on
tickets. RT has a custom field type that allows you to select
multiple values with autocomplete from a list of values. This
extension allows users to add new values (tags) that will then be
added to the list of available autocomplete values for that custom
field.

The created tags become links to a search of all active tickets
with that tag.

=head2 Tag Custom Field

The initdb step installs a Tag custom field by default along with
the required condition, action, and scrip. The custom field is
global as installed, but you can limit it to specific queues
by editing the custom field configuration.

If you want to use this functionality with a different custom field,
create the custom field, then create a new scrip. You can use
the provided "On Custom Field Change" condition as is. Then
create a new action in the RT database using the same values as the
provided "Add New CF Value" but change the Argument to the name of your
new custom field. You can add this with a short initial data file,
directly in the database, or using the helpful extension
L<RT::Extension::AdminConditionsAndActions>.

=head1 RT VERSION

Works with RT 4.0, 4.2, 4.4

=head1 INSTALLATION

=over

=item C<perl Makefile.PL>

=item C<make>

=item C<make install>

May need root permissions

=item C<make initdb>

Only run this the first time you install the module. Creates a global
Tags custom field and adds the necessary scrip, action, and
condition.

=item Edit your F</opt/rt4/etc/RT_SiteConfig.pm>

If you are using RT 4.2 or greater, add this line:

    Plugin('RT::Extension::Tags');

For RT 4.0, add this line:

    Set(@Plugins, qw(RT::Extension::Tags));

or add C<RT::Extension::Tags> to your existing C<@Plugins> line.

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=back

=head1 AUTHOR

Best Practical Solutions, LLC E<lt>modules@bestpractical.comE<gt>

=head1 BUGS

All bugs should be reported via email to

    L<bug-RT-Extension-Tags@rt.cpan.org|mailto:bug-RT-Extension-Tags@rt.cpan.org>

or via the web at

    L<rt.cpan.org|http://rt.cpan.org/Public/Dist/Display.html?Name=RT-Extension-Tags>.

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2016 by Best Practical Solutions, LLC

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

1;
