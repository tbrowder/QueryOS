use Test;

use QueryOS;
use QueryOS::Classes;
use QueryOS::Subs;

my $debug = 1;

lives-ok {
    my @args = "silent";
    if $debug {
        @args = "list";
    }
    run-cli(@args);
}, "cli test";


done-testing;
