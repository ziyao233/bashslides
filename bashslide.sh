#!/bin/env bash
# SPDX-License-Identifier: CC-BY-SA-4.0
# Copyright (c) 2025 Yao Zi <ziyao@disroot.org>

warn() {
	echo "$@" 1>&2
}

die() {
	echo "$@" 1>&2
	exit 1
}

if ! command md2html -v >/dev/null 2>/dev/null; then
	die "Cannot find md2html"
fi

progdir="$(dirname "$0")"

if [ -d "$progdir"/../share/bashslide ]; then
	datadir="$progdir"/../share/bashslide
else
	datadir="$progdir"
fi

check_data_file() {
	if ! [ -f "$datadir/$1" ]; then
		die "Cannot find datafile \"$datadir/$1\""
	fi
}

check_data_file header.html
check_data_file footer.html

pageflipper="==="
mdargs="--fstrikethrough"

converted="$(md2html $mdargs -)" ||
	die "failed to convert the documentation to html"

paths=()

cat "$datadir/header.html"

while read line; do
	if echo "$line" | grep -q -o -- '$$[^$[:cntrl:]]\+\$\$'; then
		path=("$(echo "$line"				|
		       grep -o -- '$$[^$[:cntrl:]]\+\$\$'	|
		       sed -e 's/\$\$//g')")

		if ! [ -e "$path" ]; then
			die "Embedded file '$path' doesn't exist";
		fi

		paths+=("$path")
		_path=("$(echo "$path" | sed -e 's/\//\\\//g')")
		echo -nE "s/\\\$\\\$$_path\\\$\\\$/data:" > "$path.rep"
		file -b --mime-type $path | sed -e 's/\//\\\//g' |
			tr -d '\n' >> "$path.rep"
		echo -nE ";base64," >> "$path.rep"
		base64 -w 0 "$path" | sed -e 's/\//\\\//g' >> "$path.rep"
		echo -nE '/g' >> "$path.rep"
	fi
done <<< $(echo "$converted")

for ((i=0;i<"${#paths[@]}";i++)); do
	path=${paths[i]}
	converted="$(echo "$converted" | sed -f "$path.rep")"
done

echo "$converted"

cat "$datadir/footer.html"
