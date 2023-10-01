#!/bin/sh


run=true

doppler run terraform init

while ["$run" = true]; do

if ![doppler run --command "terraform apply -auto-approve" | grep -q 'Out of host capacity']; then
    run=false
fi

sleep 10
done