# Создание базы данных и пользователя
sudo -u postgres psql -c "CREATE DATABASE hardware_store;"
sudo -u postgres psql -c "CREATE USER demo_user WITH PASSWORD 'demo_password';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE hardware_store TO demo_user;"

# Импорт данных
sudo -u postgres psql -d hardware_store -f hardware_store.sql

echo "База данных успешно установлена!"
