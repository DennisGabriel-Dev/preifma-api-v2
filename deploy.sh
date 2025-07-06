#!/bin/bash

SERVER="root@45.79.223.162"
APP_PATH="./preifma-api-v2"

echo "🚀 Deploy remoto iniciando..."

ssh $SERVER << EOF
  cd $APP_PATH
  git pull origin main
  bundle install
  RAILS_ENV=production rails db:migrate
  sudo systemctl restart puma
EOF

echo "✅ Deploy concluído remotamente!"