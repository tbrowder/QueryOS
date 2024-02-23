use Test;
use QueryOS;

my $o = OS.new;


with $o.name {
    # known system names
    when /:i mswin / {
        is 1, 1, "is Windows";
        ok $o.is-windows.so, "is-windows";
    }
    when /:i debian / {
        is 1, 1, "is Debian";
        ok $o.is-linux.so, "is-linux";
    }
    when /:i ubuntu / {
        is 1, 1, "is Ubuntu";
        ok $o.is-linux.so, "is-linux";
    }
    when /:i macos / {
        is 1, 1, "is MacOS";
        ok $o.is-macos.so, "is-macos";
    }
    when /:i suse / {
        is 1, 1, "is Suse";
        ok $o.is-linux.so, "is-linux";
    }
    when /:i Gentoo / {
        is 1, 1, "is gentoo";
        ok $o.is-linux.so, "is-linux";
    }
    default {
       is 1,1, "unknown distro";
       # warn of unknown distribution
       note "NOTE: Unknown distro name: '$_'";
       note qq:to/HERE/;
              Please file an issue report and include the
              output of:
                say $*DISTRO.name
                say $*DISTRO.version
       HERE
    }
}

done-testing;
