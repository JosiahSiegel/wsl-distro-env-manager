#!/bin/bash

wsl -d $1 -u $3 -e bash -c \
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
sudo chown -R '"$3"':'"$3"' .; \
cd prime-router/; \
echo "cleanslate.sh started"; \
./cleanslate.sh --prune-volumes; \
echo "cleanslate.sh finished"; \
export $(xargs < .vault/env/.env.local); \
echo "docker-compose started"; \
docker-compose --file "docker-compose.build.yml" up --detach; \
echo "docker-compose finished"; \
echo "devenv-infrastructure.sh started"; \
./devenv-infrastructure.sh; \
echo "devenv-infrastructure.sh finished"; \
./prime create-credential --type=UserPass \
        --persist=DEFAULT-SFTP \
        --user foo \
        --pass pass; \
./prime multiple-settings \
        set --input settings/organizations.yml; \
cd ../; \
echo "cd ~/repos/prime-reportstream/" >>~/.bashrc; \
cp operations/app/src/environments/configurations/dev-sample.tfbackend operations/app/src/environments/configurations/dev.tfbackend; \
cp operations/app/src/environments/configurations/dev-sample.tfvars operations/app/src/environments/configurations/dev.tfvars; \
cp /mnt/c/repos/wsl-distro-env-manager/backups/dev.tfbackend operations/app/src/environments/configurations/; \
cp /mnt/c/repos/wsl-distro-env-manager/backups/dev.tfvars operations/app/src/environments/configurations/; \
code .; \
'
