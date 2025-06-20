#!/bin/bash
set -e

export RAILS_ENV=development

echo "[INFO] Reading secrets..."

if [ -f /run/secrets/my_app.env ]; then
  set -a
  source /run/secrets/my_app.env
  set +a
else
  echo "[ERROR] Secrets file not found"
  exit 1
fi

VIEW_FILE="app/views/hello/index.html.erb"
APP_PATH="/app"

cd $APP_PATH

if [ ! -f "$APP_PATH/config/application.rb" ]; then
  echo "[INFO] Generating new Rails App..."
  rails new . --skip-bundle --database=postgresql
fi

if ! grep -q "gem 'redis'" Gemfile; then
  echo "[INFO] Adding 'redis' gem..."
  echo "gem 'redis'" >> Gemfile
fi

echo "[INFO] Installing gems..."
bundle install

echo "[INFO] Preparing database..."
bundle exec rails db:prepare

if [ ! -f "$APP_PATH/app/controllers/hello_controller.rb" ]; then
  echo "[INFO] Generating Hello controller..."
  bundle exec rails generate controller Hello index
fi

if [ ! -f "$VIEW_FILE" ]; then
  echo "[INFO] Creating Hello World view..."
  mkdir -p "$(dirname "$VIEW_FILE")"
  echo '<h1>Hello, world!</h1>' > "$VIEW_FILE"
fi

if ! grep -q "root 'hello#index'" config/routes.rb; then
  echo "[INFO] Configuring root path..."
  echo "root 'hello#index'" >> config/routes.rb
fi

echo "[INFO] Initializing Rails server..."
exec bundle exec rails server -b 0.0.0.0
