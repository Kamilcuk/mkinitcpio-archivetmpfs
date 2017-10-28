#!/bin/bash
set -euo pipefail

beg='###### help start'
end='###### help stop'
f=README.md

cp $f $f.bak
awk -v data="$(
	. usr/lib/initcpio/install/archivetmpfs
        help
)" '
BEGIN {p=1}
/'"$beg"'/ {print; print "\n```" data "\n```\n"; p=0}
/'"$end"'/ {p=1}
p' $f | sponge $f

