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

converted="$(md2html -)" || die "failed to convert the documentation to html"

cat "$datadir/header.html"
echo "$converted"
cat "$datadir/footer.html"
