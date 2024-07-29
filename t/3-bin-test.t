use Test;

use QueryOS;
use QueryOS::Classes;
use QueryOS::Subs;

plan 1;
lives-ok {
    my @args = "silent";
    run-cli(@args);
}, "cli test";


done-testing;
