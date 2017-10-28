#!/bin/bash
set -euo pipefail

beg='### help start'
end='### help stop'

tmp=$(mktemp)
trap 'rm -f $tmp' EXIT

(
	. usr/lib/initcpio/install/archivetmpfs
	help
) > $tmp

awk -v data="$(<$tmp)" '
BEGIN {p=1}
/'"$beg"'/ {print; print "\n```" data "\n```\n"; p=0}
/'"$end"'/ {p=1}
p' README.md | sponge README.md

