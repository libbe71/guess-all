#!/bin/bash

# Check if .env.local exists
if [ ! -f .env.local ]; then
  echo ".env.local file not found!"
  exit 1
fi

# Unset all variables from .env.local
while IFS='=' read -r key _; do
  # Ignore empty lines and comments
  if [[ -n "$key" && "$key" != "#"* ]]; then
    unset "$key"
    echo "Unset: $key"
  fi
done < <(grep -v '^#' .env.local)
