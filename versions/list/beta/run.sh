#!/bin/bash
source /etc/environment
#source "${PBIND_PATH}/utils/includes/functions.sh"

if (($1 == "start" || $1 == "run" ));then
bash "${PBIND_PATH}/app/start.sh $@"
exit 1
fi

if (($1 == "new" || $1 == "create" ));then
bash "${PBIND_PATH}/app/new.sh $@"
exit 1
fi

if (($1 == "services" || $1 == "remote" ));then
bash "${PBIND_PATH}/services.sh $@"
exit 1
fi