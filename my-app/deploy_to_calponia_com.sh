#! /usr/bin/env sh

CALPONIA_PROJECT=$1
CALPONIA_APP=$2
HOST=$3

cd $(realpath $(dirname $0))

# edit the path for IdentityFile in config to ./my-app/.ssh/calponia.com-* from .ssh/calponia.com-*
if [ -n $CALPONIA_PROJECT ] && [ -n $CALPONIA_APP ] && [ -n $HOST ];
then

   # Check if necessary files for apps to deploy are exist
   if [ ! -f ./config ] && [ ! -f ./.ssh/calponia.com-$CALPONIA_APP ]; then
        echo "config file and ssh file is missing to push the apps"
        echo "Setup details for config file and ssh folder mentioned in Developer area"
        echo "Abort deploy progress"
        exit 1
    fi

    # take git sha
    git_sha=$(git rev-parse HEAD)

    # Copy to _temp folder
    rm -rf _temp/
    mkdir -p _temp/my-app
    rsync -r --exclude=_temp --exclude=node_modules . ./_temp/my-app

    # Copy config and ssh to root of repo
    cp ./config _temp/config
    cp -r ./.ssh _temp/.ssh

    # Copy production docker-compose to root of repo
    cp ./docker-compose.prod.yml _temp/docker-compose.yml

    # Configure for push
    cd _temp/
    echo 'reached'
    git init . --quiet
    echo 'reAC'
    git config core.sshCommand "ssh -F ./my-app/config"
    echo "reached jjj"
    git add *
    git commit -m "Taken from $git_sha"
    echo "reached yyj"
    git remote add calponia git@git.$HOST:$CALPONIA_APP.git
    git push -fu calponia master

    # cleanup
    #cd ..
    echo " To do rm -rf _temp/"
    #rm -rf _temp/

    echo "Done"
else
    echo "Missing parameters"
fi
