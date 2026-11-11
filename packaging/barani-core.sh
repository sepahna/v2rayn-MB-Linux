#!/bin/sh
set -eu

if [ -x /opt/barani-core/v2rayN ]; then
  cd /opt/barani-core
  exec ./v2rayN "$@"
fi

here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$here"
exec ./v2rayN "$@"
