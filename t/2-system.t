use Test;
use QueryOS;

my $o = OS.new;


with $o.name {
    # known system names
    when /:i mswin / {
        is 1, 1, "is-windows";
    }
    when /:i debian / {
        is 1, 1, "is Debian";
        is $o.is-linux.so, True, "is-linux";
    }
    when /:i ubuntu / {
        is 1, 1, "is ubuntu";
        is $o.is-linux.so, True, "is-linux";
    }
    when /:i macos / {
        is 1, 1, "is-macos";
        is $o.is-macos.so, True, "is-macos";
    }
    when /:i suse / {
        is 1, 1;
        is $o.is-linux.so, True, "is-linux";
    }
    when /:i gentoo / {
        is 1, 1;
        is $o.is-linux.so, True, "is-linux";
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
