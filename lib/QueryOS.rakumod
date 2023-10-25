unit module QueryOS;

# short names:
our %known-distros is export = set <
    debian
    gentoo
    macos
    mswin
    suse
    ubuntu
>;

# Debian releases
our %debian-vnames is export = %(
    etch => 4,
    lenny => 5,
    squeeze => 6,
    wheezy => 7,
    jessie => 8,
    stretch => 9,
    buster => 10,
    bullsye => 11,
    bookworm => 12,
    trixie => 13,
    forky => 14,
);
our %debian-vnum is export = %debian-vnames.invert;

# Ubuntu releases
our %ubuntu-vnames is export = %(
   trusty => 14,
   xenial => 16,
   bionic => 18,
   focal => 20,
   jammy => 22,
   lunar => 23,
);
our %ubuntu-vnum is export = %ubuntu-vnames.invert;

=begin comment
# sytems confirmed
# name ; version
ubuntu; 22.04.3.LTS.Jammy.Jellyfish
ubuntu; 20.04.6.LTS.Focal.Fossa
macos;  12.6.7
macos;  13.5
macos;  11.7.8
mswin32; 10.0.17763.52
opensuse-leap; v15.4
=end comment

=begin comment
from docs: var $*DISTRO
from docs: role Version does Systemic

basically, two methods usable:
  .name
  .version
    .Str
    .parts (a list of dot.separated items: integers, then strings)

=end comment

class OS is export {
    # the two parts of the $*DISTRO object:
    has $.name;              # debian, ubuntu, macos, mswin32, ...
    # the full Version string:
    has $.version;           # 1.0.1.buster, bookworm, ...

    # DERIVED PARTS
    # the serial part
    has $.version-serial = "";    # 10, 11, 20.4, ...
    # the string part
    has $.version-name   = "";      # buster, bookworm, xenial, ...
    # a numerical part for comparison between Ubuntu versions (x.y.z ==> x.y)
    # also used for debian version comparisons
    has $.vshort-name    = "";
    has $.vnum           = 0;

    # a hash to contain the parts
    # %h = %(
    #     version-serial => value,
    #     version-name   => value,
    #     vshort-name    => value,
    #     vnum           => value,
    # )

    submethod TWEAK {
        # TWO METHODS TO INITIATE
        unless $!name.defined and $!version.defined {
            # the two parts of the $*DISTRO object:
            $!name    = $*DISTRO.name.lc;
            $!version = $*DISTRO.version;
        }

        # what names does this module support?
        unless $!name ~~ /:i debian | ubuntu/ {
            note "WARNING: OS $!name is not supported. Please file an issue.";
        }

        my %h = os-version-parts($!version.Str); # $n.Num;    # 10, 11, 20.4, ...
        $!version-serial = %h<version-serial>;
        $!version-name   = %h<version-name>;
        # we have to support multiple integer chunks for numerical comparison
        $!vshort-name    = %h<vshort-name>;
        $!vnum           = %h<vnum>;
    }

    sub os-version-parts(Str $version --> Hash) is export {
        # break version.parts into serial and string parts
        # create a numerical part for serial comparison
        my @parts = $version.split('.');
        my $s = ""; # string part
        my $n = ""; # serial part
        my @c;      # numerical parts
        for @parts -> $p {
            if $p ~~ /^\d+$/ { # Int {
                # assign to the serial part ($n, NOT a Num)
                # separate parts with periods
                $n ~= '.' if $n;
                $n ~= $p;
                # save the integers for later use
                @c.push: $p;
            }
            elsif $p ~~ Str {
                # assign to the string part ($s)
                # separate parts with spaces
                $s ~= ' ' if $s;
                $s ~= $p;
            }
            else {
                die "FATAL: Version part '$p' is not an Int nor a Str";
            }
        }
        my $vname   = $s; # don't downcase here.lc;
        # extract the short name
        my $vshort = $vname.lc;
        if $vshort {
            $vshort ~~ s:i/lts//;
            $vshort = $vshort.words.head;
        }

        my $vserial = $n; # 10, 11, 20.04.2, ...
        if not @c.elems {
            # not usual, but there is no serial part, so make it zero
            @c.push: 0;
            $vserial = 0;
        }

        # for numerical comparison
        # use the first two parts as is, for now add any third part to the
        # second by concatenation
        my $vnum = @c.elems > 1 ?? (@c[0] ~ '.' ~ @c[1]) !! @c.head;
        if @c.elems > 2 {
            $vnum ~= @c[2];
        }

        # return the hash
        my %h = %(
            version-serial => $vserial,
            version-name   => $vname,
            vshort-name    => $vshort.lc,
            vnum           => $vnum.Num, # it MUST be a number
        );
        %h
    }

    method is-debian(--> Bool) {
        my $vnam = $*DISTRO.name.lc;
        $vnam eq 'debian';
    }

    method is-ubuntu(--> Bool) {
        my $vnam = $*DISTRO.name.lc;
        $vnam eq 'ubuntu';
    }

} # end of class OS definition


sub is-debian(--> Bool) {
    my $vnam = $*DISTRO.name.lc;
    $vnam eq 'debian';
}
sub is-ubuntu(--> Bool) {
    my $vnam = $*DISTRO.name.lc;
    $vnam eq 'ubuntu';
}

sub run-cli(@args) is export {

    my $o = OS.new;
    my $vnum = $o.version-serial;
    my $vnam = $o.version-name;

    my $user    = $*USER.lc;
    my $is-root = $user eq 'root' ?? True !! False;
    my $host    = $*KERNEL.hostname;
    my $system  = $*KERNEL.hardware // "Unknown system";
    my $distro  = $*DISTRO.name;
    my $version = $*DISTRO.version;

    if not @args.elems {
        print qq:to/HERE/;

        This program is currently running on:

            Host:           $host
            User:           $user
        HERE

        my $distro-is-known = %known-distros{$distro}:exists ?? True !! False;
        if $distro-is-known {
            say "    Distro:         $distro*";
        }
        else {
            print qq:to/HERE/;
                Distro:         $distro*
                                   (name not recognized,
                                    please file an issue)
            HERE
        }

        print qq:to/HERE/;
            Version name:   $vnam
            Version number: $vnum
            System:         $system

        This module provides class 'OS' whose attributes
        provide details of the system to aid module
        authors porting to multiple versions. See the
        README for more information.
        HERE

        if $distro-is-known {
            print qq:to/HERE/;

            *NOTE: If the 'Distro' name is not recognized,
                   it will be so stated in parentheses
                   following the reported name. Known names
                   are listed in the README.
            HERE
         }

        exit;
    }
} # sub run-cli(@args) is export {

=finish

for @*ARGS {
    when /^ d / { ++$debug }
    when /^ g / {
        ; # ok
    }

    default {
        note "FATAL: Unknown arg '$_'";
        exit;
    }
}
