#!/bin/bash
set -e

echo "=== Docker Entrypoint ==="
echo "PORT: ${PORT:-not set}"
echo "RAILS_ENV: ${RAILS_ENV:-not set}"

if [ -z "$PORT" ]; then
  echo "ERROR: PORT is not set!"
  exit 1
fi

echo "Starting Puma on port $PORT..."
exec bundle exec puma -C config/puma.rb
