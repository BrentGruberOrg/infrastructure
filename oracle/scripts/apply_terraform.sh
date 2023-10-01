#!/bin/sh


doppler run terraform init

keep_running="run"

while [ "$keep_running" = "run" ]
do
    doppler run --command "terraform apply -auto-approve" | tee terraform.log

    # if 'Out of host capacity' is not in the log, then stop running
    if ! grep -q 'Out of host capacity' terraform.log; then
        keep_running="stop"
    else
        echo "Failed with out of host capacity error, retrying...."
        sleep 10
    fi

    echo $keep_running
done
