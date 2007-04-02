#!perl

use Test::More;

#if (!require Test::Perl::Critic) {
    Test::More::plan(
        'skip_all' => 'PBP eval skip', 
#        skip_all => "Test::Perl::Critic required for testing PBP compliance"
    );
#}

#Test::Perl::Critic::all_critic_ok();
