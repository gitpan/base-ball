use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'base::ball',
    license             => 'perl',
    dist_author         => 'Daniel Muey <http://drmuey.com/cpan_contact.pl>',
    dist_version_from   => 'lib/base/ball.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'base-ball-*' ],
);

$builder->create_build_script();
