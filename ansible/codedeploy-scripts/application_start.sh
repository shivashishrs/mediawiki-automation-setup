#!/bin/bash

# Deploy hooks are run via absolute path, so taking dirname of this script will give us the path to
# our deploy_hooks directory.
. $(dirname $0)/common_variables.sh
ansible-galaxy collection install -r $DESTINATION_PATH/playbooks/collections/requirements.yml
ansible-playbook $DESTINATION_PATH/playbooks/webserver.yml -i $DESTINATION_PATH/playbooks/hosts --connection=local --extra-vars is_codedeploy=True