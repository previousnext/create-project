#!/usr/bin/env bash

echo "Create a new PNX Project"
echo "--------------------------"
echo "Enter a machine name to create a new project (e.g. myproject):"
read APP_NAME

if [ -d "$APP_NAME" ]; then
  echo "Directory $APP_NAME already exists!"
  exit 1
fi

git clone --depth 1 git@github.com:previousnext/pnx-project.git $APP_NAME
cd $APP_NAME
rm -rf .git
./scripts/rename-project.sh $APP_NAME
rm ./scripts/rename-project.sh
git init
git add .
git commit -m "Initial commit"
make composer

echo "Congratulations! You just created a..."
echo "  ____  _   ___  __  ____            _           _   ";
echo " |  _ \| \ | \ \/ / |  _ \ _ __ ___ (_) ___  ___| |_ ";
echo " | |_) |  \| |\  /  | |_) | '__/ _ \| |/ _ \/ __| __|";
echo " |  __/| |\  |/  \  |  __/| | | (_) | |  __/ (__| |_ ";
echo " |_|   |_| \_/_/\_\ |_|   |_|  \___// |\___|\___|\__|";
echo "                                  |__/               ";

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  DOCKER_COMPOSE_ARGS="-f docker-compose.yml -f docker-compose.linux.yml"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  DOCKER_COMPOSE_ARGS="-f docker-compose.yml -f docker-compose.osx.yml"
else
  DOCKER_COMPOSE_ARGS=""
fi

echo "Next steps:"
echo ""
echo "cd $APP_NAME"
echo "docker-compose ${DOCKER_COMPOSE_ARGS} up -d"
echo "docker-compose ${DOCKER_COMPOSE_ARGS} exec app bash"
echo "./bin/drush site-install ${APP_NAME}_profile \
  --site-name=$APP_NAME \
  --site-mail=devnull+$APP_NAME@previousnext.com.au \
  --account-name=$APP_NAME-admin \
  -y"
