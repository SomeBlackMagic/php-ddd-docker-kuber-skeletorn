#!/usr/bin/env bash

set -eux

/app/bin/console d:m:m -n --force

echo
echo 'Init process done. Ready for start up.'
echo

exec "$@"
