package Batter::Up;

use Test::More tests => 9;

use lib qw(../lib t/);
BEGIN {
    use_ok( 'base::ball' );
}

diag( "Testing 'base::ball' $base::ball::VERSION" );

use base::ball qw(Foo);

ok( exists $INC{'Foo.pm'}, 'base class' );
ok( exists $INC{'Foo/Baz.pm'}, '.pm only' );
ok( exists $INC{'Foo/Bar.pm'}, '.pm w/ both' );
ok( exists $INC{'Foo/Bar/Wop.pm'}, 'dir w/ both' );
ok( !exists $INC{'Foo/Zip/Wap.pm'}, 'dir only not followed' );

is_deeply( 
	\@ISA, 
    [
		'Foo',
		'Foo::Bar',
		'Foo::Bar::Wop',
		'Foo::Bar::Zap',
		'Foo::Baz',
    ],
    'default ISA order',
);

local @ISA;
base::ball->import( 'Foo', sub { shift;return sort { $b cmp $a } @_; } );

is_deeply( 
	\@ISA,
	[
		'Foo',
		'Foo::Baz',
		'Foo::Bar',
		'Foo::Bar::Zap',
		'Foo::Bar::Wop',
	],
    'specified ISA order',
);

ok( !exists $ENV{'base::ball::sort'}, 'unpolluted ENV')