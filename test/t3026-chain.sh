#! /bin/sh -e
# tup - A file-based build system
#
# Copyright (C) 2010-2014  Mike Shal <marfey@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

# Try to chain !-macros

. ./tup.sh
cat > Tupfile << HERE
!cc = foreach |> gcc -c %f -o %o |> %B.o
!ld = |> gcc %f -o %o |>

*chain = !cc |> !ld

srcs += foo.c
srcs += bar.c
: \$(srcs) |> *chain |> prog.exe
HERE
echo 'int main(void) {return 0;}' > foo.c
tup touch foo.c bar.c Tupfile
update

check_exist foo.o bar.o prog.exe
tup_dep_exist . foo.c . 'gcc -c foo.c -o foo.o'
tup_dep_exist . bar.c . 'gcc -c bar.c -o bar.o'
tup_dep_exist . foo.o . 'gcc foo.o bar.o -o prog.exe'
tup_dep_exist . bar.o . 'gcc foo.o bar.o -o prog.exe'

eotup
