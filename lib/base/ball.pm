package base::ball;

use strict;
use warnings;
use File::Spec;

use version;our $VERSION = qv('0.0.4');

require base;

sub import {
    shift;

    return if !@_;

    my $caller = caller(0);
    local $Carp::Level = ( $Carp::Level || 0 ) + 1;

    local $ENV{'base::ball::sort'} = defined $ENV{'base::ball::sort'} && ref $ENV{'base::ball::sort'} eq 'CODE' 
        ? $ENV{'base::ball::sort'} 
        : sub {
	        my ($pkg, @pms) = @_;
	        return sort { $a cmp $b } @pms;	
          }
        ;

    if( ref $_[-1] eq 'CODE' ) {
        $ENV{'base::ball::sort'} = pop @_;
    }

    PKG:
    for my $pkg ( @_ ) {
	    eval qq{
            package $caller;
            base->import( '$pkg' );
        };
        Carp::croak $@ if $@; # die for base()

	    my $file = $pkg;
	    $file    = File::Spec->catdir( split( '::', $file ) );
	
	    my $dir  = $INC{ $file . '.pm' };
	    $dir     =~ s{\.pm$}{};
	    
	    if( opendir my $pm_dh, $dir ) {
            my @pms = grep /\.pm$/, readdir( $pm_dh );
            closedir $pm_dh;

            next PKG if !@pms;

            PMS:
            for my $pm ( $ENV{'base::ball::sort'}->( $pkg, @pms) ) {
	            my $ns = $pm;
	            $ns    =~ s{\.pm}{};
	
                my $imp = $pkg . '::' . $ns;

	            eval qq{
	                package $caller;
	                base::ball->import( '$imp' );
	            };
	            Carp::croak $@ if $@; # die for base()
            }
        }
    }
}

1;

__END__

=head1 NAME

base::ball - "b" all the namespaces under the given one(s)

=head1 VERSION

This document describes base::ball version 0.0.4

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

Note it does not follow directories who do not first have a .pm, in other words:

Foo/Utils/Whatever/Fiddle.pm will no get Foo:Utils::Whatever::Fiddle as base 
unless Foo/Utils/Whatever.pm exists (and therefore Foo::Utils::Whatever is a base)

This is by design for good reasons and given enough popular demand may lead to support for it.

=head1 INTERFACE

pass one or more name spaces to the use() call.

If the last item in the arguments is a coderef, that will be used to sort the .pm's from readdir.

If not then this is used instead:

  sub {
      my ($pkg, @pms) = @_;
      return sort { $a cmp $b } @pms;	
  }

=head1 DO NOT USE THIS MODULE IF:

You are trying to make a god class. They are bad. L<http://en.wikipedia.org/wiki/God_object>

You are misusing IS-A inheritance

=head1 ONLY USE THIS MODULE IF:

You have a project where you organize an object's methods into individual "utility" modules and want 
to replace multiple, maintenance intensive, 'use base' lines with a single, maintenance free use base::ball line.

=head2 IF THIS MODULE SCARES YOU

Some folks are scared of this module. The funny name confused them (its a joke, see 'NAME' for an explanation), the magic seems to magical (look at the POD and the source, there's not much to it), it does evil stuff, etc...

I think the main "fear" trying to be expressed is this: "You can use this module to mis-use inheritance". 

So I urge you: don't use it (or anything else) to mis-use anything

Yes, there are things it should not be used for ( See 'DO NOT USE THIS MODULE IF' ) but at the same time it does have a very practical and beneficial place ( See 'ONLY USE THIS MODULE IF' ).

With great power comes great responsibility: so read the POD, don't misuse inheritance, and use whatever does what you need (like L<Module::Pluggable> or L<Moose> for example).

=begin comment

=over

=item BUILD()

=back

=end comment

=head1 DIAGNOSTICS

base::ball throws no warnings or errors itself

=head1 CONFIGURATION AND ENVIRONMENT

base::ball requires no configuration files. It uses internally a local()ized $ENV{'base::ball::sort'} but it isn't left after the use()

Setting $ENV{'base::ball::sort'} directly is kinda dumb (since use() is likley done before it'll be set) but knock yourself out if you really want to.

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
