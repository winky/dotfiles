#!/usr/bin/env bash
#
# install-tool.sh NAME VERSION URL BINDIR
# Put the binary NAME from the release tarball at URL into BINDIR, unless that version is
# already there. Called by `make tools`, which owns the list of tools and their versions.
#
# The tarball has to hold NAME at its top level. URL.md5, when the project publishes one,
# is checked: it catches a truncated or corrupted download, not a tampered one.
set -euo pipefail

if [ "$#" -ne 4 ]; then
  echo "Usage: $(basename "$0") NAME VERSION URL BINDIR" >&2
  exit 1
fi
name=$1 version=$2 url=$3 bindir=$4

# Every tool this is used for prints its version in `--version`, in one format or another.
if "${bindir}/${name}" --version 2>/dev/null | grep -qF "${version}"; then
  echo "${name} ${version} is already installed"
  exit 0
fi

tmp=$(mktemp -d)
trap 'rm -rf "${tmp}"' EXIT

echo "Downloading ${url}"
curl -fsSL -o "${tmp}/archive.tar.gz" "${url}"

if curl -fsSL -o "${tmp}/archive.md5" "${url}.md5" 2> /dev/null; then
  expected=$(awk '{ print $1 }' "${tmp}/archive.md5")
  actual=$({ md5sum "${tmp}/archive.tar.gz" 2> /dev/null || md5 -r "${tmp}/archive.tar.gz"; } | awk '{ print $1 }')
  if [ "${expected}" != "${actual}" ]; then
    echo "error: md5 mismatch for ${url} (expected ${expected}, got ${actual})" >&2
    exit 1
  fi
fi

tar -xzf "${tmp}/archive.tar.gz" -C "${tmp}" "${name}"
mkdir -p "${bindir}"
install -m 0755 "${tmp}/${name}" "${bindir}/${name}"
echo "Installed ${name} ${version} to ${bindir}"
