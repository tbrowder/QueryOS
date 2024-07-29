unit module QueryOS::Subs;

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

=begin comment
sub is-debian(--> Bool) {
    my $vnam = $*DISTRO.name.lc;
    $vnam eq 'debian';
}
sub is-ubuntu(--> Bool) {
    my $vnam = $*DISTRO.name.lc;
    $vnam eq 'ubuntu';
}
=end comment

sub run-cli(@args) is export {

    if not @args.elems {
        print qq:to/HERE/;
        Usage: {$*PROGRAM.basename} query | list
        HERE
        exit;
    }

    for @args {
        when /:i q/ {
            query
        }
        when /:i l/ {
            list-known-distros
        }
        when /silent/ {
            exit
        }
    }

} # sub run-cli(@args) is export {

sub query {

    my $o = QueryOS.new;
    my $vnum = $o.version-serial;
    my $vnam = $o.version-name;

    my $user    = $*USER.lc;
    my $is-root = $user eq 'root' ?? True !! False;
    my $host    = $*KERNEL.hostname;
    my $system  = $*KERNEL.hardware // "Unknown system";
    my $distro  = $*DISTRO.name;
    my $version = $*DISTRO.version;

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
    README for more information or use the 'list'
    option to this program.
    HERE

    if $distro-is-known {
        print qq:to/HERE/;

        *NOTE: If the 'Distro' name is not recognized,
               it will be so stated in parentheses
               following the reported name.
        HERE
    }
} # sub query

sub list-known-distros {
    say "Known distro names:";
    say "  $_" for %known-distros.keys.sort;
} # sub list-known-distros
