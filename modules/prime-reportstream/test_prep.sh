#!/bin/bash

source lib/args.sh

wsl -d $distro -u $user -e bash -c \
' \
gradle --version; \
docker --version; \
git --version; \
java --version; \
psql --version; \
az --version; \
docker-compose --version; \
mkdir -p ~/repos/; \
cd ~/repos/; \
git clone --filter=tree:0 https://github.com/CDCgov/prime-reportstream.git; \
cd prime-reportstream/; \
sudo chown -R '"$user"':'"$user"' .git/; \
cd prime-router/; \
echo ""; \
echo "cleanslate.sh started"; \
./cleanslate.sh --prune-volumes; \
echo "cleanslate.sh finished"; \
export $(xargs < .vault/env/.env.local); \
echo ""; \
echo "docker-compose started"; \
docker-compose --file "docker-compose.build.yml" up --detach; \
echo "docker-compose finished"; \
echo ""; \
echo "devenv-infrastructure.sh started"; \
./devenv-infrastructure.sh; \
echo "devenv-infrastructure.sh finished"; \
./prime create-credential --type=UserPass \
        --persist=DEFAULT-SFTP \
        --user foo \
        --pass pass; \
./prime multiple-settings \
        set --input settings/organizations.yml; \
'
