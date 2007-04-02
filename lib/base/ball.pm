package base::ball;

use strict;
use warnings;
use File::Spec;

use version;our $VERSION = qv('0.0.2');

require base;

sub import {
    shift;

    my $caller = caller(0);

    PKG:
    for my $pkg ( @_ ) {
	    eval qq{
            package $caller;
            base->import( '$pkg' );
        };

	    my $file = $pkg;
	    $file    = File::Spec->catdir( split( '::', $file ) );
	
	    my $dir  = $INC{ $file . '.pm' };
	    $dir     =~ s{\.pm$}{};
	    
	    if( opendir my $pm_dh, $dir ) {
            my @pms = grep /\.pm$/, readdir( $pm_dh );
            closedir $pm_dh;

            next PKG if !@pms;

            PMS:
            for my $pm ( @pms ) {
	            my $ns = $pm;
	            $ns    =~ s{\.pm}{};
	
                my $imp = $pkg . '::' . $ns;
	
	            eval qq{
	                package $caller;
	                base::ball->import( '$imp' );
	            };
            }
        }
    }
}

1;

__END__

=head1 NAME

base::ball - "b" all the namespaces under the given one(s)

=head1 VERSION

This document describes base::ball version 0.0.2

=head1 SYNOPSIS

    use base::ball qw(Foo::Utils);

equivalent to:

   use base qw(Foo::Utils);
   use base qw(Foo::Utils::Data);
   use base qw(Foo::Utils::UI);
   use base qw(Foo::Utils::Sys);
   use base qw(Foo::Utils::Sys::Unix);
   use base qw(Foo::Utils::Sys::Win32);
   use base qw(Foo::Utils::Run);

=head1 DESCRIPTION

Recursively searches the directory that the given name spaces are in to also 'use base' on their 
"child" name spaces based on any .pm files found and any directories that belong to that .pm

In other words, assuming that the Foo/ that Foo::Utils is in has:

Utils/Data.pm, Utils/UI.pm, Utils/Sys.pm, Utils/Sys/Unix.pm, Utils/Sys/Win32.pm, Utils/Run.pm

then the synopsis is correct.

Note it does not follow directories who do not firts have a .pm, in other words:

Foo/Utils/Whatever/Fiddle.pm will no get Foo:Utils::Whatever::Fiddle as base 
unless Foo/Utils/Whatever.pm exists (and therefore Foo::Utils::Whatever is a base)

This is by design for good reasons and given enough popular demand may lead to support for it.

=head1 INTERFACE

pass one or more name spaces to the use() call.

=begin comment

=over

=item BUILD()

=back

=end comment

=head1 DIAGNOSTICS

base::ball throws no warnings or errors itself

=head1 CONFIGURATION AND ENVIRONMENT
  
base::ball requires no configuration files or environment variables.


=head1 DEPENDENCIES

L<File::Spec>


=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-base-ball@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 AUTHOR

Daniel Muey  C<< <http://drmuey.com/cpan_contact.pl> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2007, Daniel Muey C<< <http://drmuey.com/cpan_contact.pl> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.