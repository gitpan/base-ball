use Test::More tests => 6;

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

# TODO, check ISA and actual inheritance