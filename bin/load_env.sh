#!/bin/bash

if [ ! -f .env.local ]; then
  echo ".env.local file not found!"
  exit 1
fi

set -a
source .env.local
set +a

exec "$@"
