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
package RT::BugTracker;

use v5.8.3;
our $VERSION = '0.03';

1;

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

=head1 SEE ALSO

L<RT::BugTracker::Public>, L<RT::Extension::rt_cpan_org>

=head1 AUTHOR

Kevin Riggle E<lt>kevinr@bestpractical.comE<gt>

=cut
