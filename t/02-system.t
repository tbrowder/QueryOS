use Test;
use QueryOS;

my $o = OS.new;

with $o.name {
    when /:i mswin / {
        is 1, 1
    }
    when /:i debian / {
        is 1, 1
    }
    when /:i ubuntu / {
        is 1, 1
    }
    when /:i macos / {
        is 1, 1
    }
    default {
       # fatal, unknown distribution
       die "FATAL: Unknown distro name: '$_' (please file an issue report)";
    }
}

done-testing;
