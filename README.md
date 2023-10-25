[![Actions Status](https://github.com/tbrowder/QueryOS/actions/workflows/linux.yml/badge.svg)](https://github.com/tbrowder/QueryOS/actions) [![Actions Status](https://github.com/tbrowder/QueryOS/actions/workflows/macos.yml/badge.svg)](https://github.com/tbrowder/QueryOS/actions) [![Actions Status](https://github.com/tbrowder/QueryOS/actions/workflows/windows.yml/badge.svg)](https://github.com/tbrowder/QueryOS/actions)

NAME
====

**QueryOS** - Provides a class and an executable, `query-os`, to list OS details

SYNOPSIS
========

```raku
use QueryOS;
```

DESCRIPTION
===========

**QueryOS** is a module that provides a class, `OS`, with methods and attributes to simplify module authors' porting their work to various operating systems by identifying important system discriminators. The module relies on the attributes of Raku's `$*DISTRO` vatiable and parses out additional details in parts of those attributes.

Current attributes and methods are:

  * name - from `$*DISTRO.name`

  * version - from `$*DISTRO.version`

  * version-name - text part of `$*DISTRO.name`

  * version-serial - number part of `$*DISTRO.name`

  * is-debian

  * is-windows

  * is-macos

  * is-ubuntu

AUTHOR
======

Tom Browder <tbrowder@acm.org>

COPYRIGHT AND LICENSE
=====================

© 2023 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.

