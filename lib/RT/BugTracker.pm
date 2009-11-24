# BEGIN BPS TAGGED BLOCK {{{
# 
# COPYRIGHT:
#  
# This software is Copyright (c) 1996-2008 Best Practical Solutions, LLC 
#                                          <jesse@bestpractical.com>
# 
# (Except where explicitly superseded by other copyright notices)
# 
# 
# LICENSE:
# 
# This work is made available to you under the terms of Version 2 of
# the GNU General Public License. A copy of that license should have
# been provided with this software, but in any event can be snarfed
# from www.gnu.org.
# 
# This work is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301 or visit their web page on the internet at
# http://www.gnu.org/copyleft/gpl.html.
# 
# 
# CONTRIBUTION SUBMISSION POLICY:
# 
# (The following paragraph is not intended to limit the rights granted
# to you to modify and distribute this software under the terms of
# the GNU General Public License and is only of importance to you if
# you choose to contribute your changes and enhancements to the
# community by submitting them to Best Practical Solutions, LLC.)
# 
# By intentionally submitting any modifications, corrections or
# derivatives to this work, or any other work intended for use with
# Request Tracker, to Best Practical Solutions, LLC, you confirm that
# you are the copyright holder for those contributions and you grant
# Best Practical Solutions,  LLC a nonexclusive, worldwide, irrevocable,
# royalty-free, perpetual, license to use, copy, create derivative
# works based on those contributions, and sublicense and distribute
# those contributions and any derivatives thereof.
# 
# END BPS TAGGED BLOCK }}}

use strict;
use warnings;

package RT::BugTracker;

use 5.008003;
our $VERSION = '0.05';

=head1 NAME

RT::BugTracker - Adds a UI designed for bug-tracking for developers to RT

=head1 DESCRIPTION

This extension changes RT's UI to make more useful when you want to
track bug reports in many distributions. This extension is a start
for setups like L<http://rt.cpan.org>. It's been developed to help
authors of perl modules.

It follows several rules to achieve the goal:

=over 4

=item Each queue associated with one package (distribution).

=item Queue's AdminCc list is used for maintainers of the
coresponding distribution.

=item Not everything was possible to implement using callbacks
and other clean extending methods, so some files have been
overriden. We currently in sync with RT 3.6.6.

=back

=cut

require RT::Queue;
package RT::Queue;

sub DistributionNotes {
    return (shift)->_AttributeBasedField(
        DistributionNotes => @_
    );
}

sub SetDistributionNotes {
    return (shift)->_SetAttributeBasedField(
        DistributionNotes => @_
    );
}

sub NotifyAddresses {
    return (shift)->_AttributeBasedField(
        NotifyAddresses => @_
    ) || [];
}

sub SetNotifyAddresses {
    return (shift)->_SetAttributeBasedField(
        NotifyAddresses => @_
    );
}

# XXX: should go with 3.8 port
sub SubjectTagRE {
    return qr/[a-z0-9 ._-]/i;
}
sub SubjectTag {
    return (shift)->_AttributeBasedField(
        SubjectTag => @_
    ) || '';
}
sub SetSubjectTag {
    my ($self, $value) = (shift, shift);
    if ( defined $value ) {
        my $re = $self->SubjectTagRE;
        return (0, $self->loc("Invalid characters in SubjectTag"))
            unless $value =~ /^$re*$/;
    }
    return $self->_SetAttributeBasedField(
        SubjectTag => $value, @_
    );
}

sub _AttributeBasedField {
    my $self = shift;
    my $name = shift;

    return undef unless $self->CurrentUserHasRight('SeeQueue');

    my $attr = $self->FirstAttribute( $name )
        or return undef;
    return $attr->Content;
}

sub _SetAttributeBasedField {
    my $self = shift;
    my $name = shift;
    my $value = shift;

#    return ( 0, $self->loc('Permission Denied') )
#        unless $self->CurrentUserHasRight('AdminQueue');

    my ($status, $msg);
    if ( defined $value && length $value ) {
        ($status, $msg) = $self->SetAttribute(
            Name    => $name,
            Content => $value,
        );
    } else {
        return (1, $self->loc("[_1] changed", $self->loc($name)))
            unless $self->FirstAttribute( $name );
        ($status, $msg) = $self->DeleteAttribute( $name );
    }
    unless ( $status ) {
        $RT::Logger->error( "Couldn't change attribute '$name': $msg");
        return (0, $self->loc("System error. Couldn't change [_1].", $self->loc($name)));
    }
    return ( 1, $self->loc("[_1] changed", $self->loc($name)) );
}

require RT::Action::SendEmail;
package RT::Action::SendEmail;

my $tag_re = RT::Queue->SubjectTagRE;
$RT::EmailSubjectTagRegex = qr/\Q$RT::rtname\E(?:\s+$tag_re+)?/;

my $old = \&SetSubjectToken;
*RT::Action::SendEmail::SetSubjectToken = sub {
    my $self = shift;
    $old->($self, @_);

    my $tag = $self->TicketObj->QueueObj->SubjectTag;
    return unless defined $tag && length $tag;

    my $id = $self->TicketObj->id;
    my $head = $self->TemplateObj->MIMEObj->head;
    my $subject = $head->get('Subject');
    my $tmp = $subject;
    $tmp =~ s{\[\Q$RT::rtname\E\s+#$id\]}{[$RT::rtname $tag #$id]}i;
    return if $tmp eq $subject;

    $head->replace( Subject => $tmp );
};

=head1 SEE ALSO

L<RT::BugTracker::Public>, L<RT::Extension::rt_cpan_org>

=head1 AUTHOR

Kevin Riggle E<lt>kevinr@bestpractical.comE<gt>

=cut

1;
