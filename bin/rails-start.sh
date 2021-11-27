#!/bin/sh

set -x


# echo "Stopping existing app server"
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

echo 'Create db and migrate'
bundle exec rails db:create db:migrate

echo 'Starting app server'
bundle exec rails s -p 3000 -b '0.0.0.0'