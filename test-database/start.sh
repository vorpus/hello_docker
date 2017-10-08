#!/bin/sh

# Run the MySQL container, with a database named 'users' and credentials
# for a users-service user which can access it.
echo "Starting DB..."
# --name assign name 'db' to container
# -d --detatch detatched (run in background)
# -e --env set environment variables
# -p --publish publish container ports to host
docker run --name db -d \
  -e MYSQL_ROOT_PASSWORD=123 \
  -e MYSQL_DATABASE=users -e MYSQL_USER=users_service -e MYSQL_PASSWORD=123 \
  -p 3306:3306 \
  mysql:latest

sleep 5

# Wait for the database service to start up.
echo "Waiting for DB to start up..."
docker exec db mysqladmin --silent --wait=30 -u users_service -p 123 ping || exit 1

sleep 5

# Run the setup script.
echo "Setting up initial data..."
docker exec -i db mysql -u users_service -p123 users < setup.sql
