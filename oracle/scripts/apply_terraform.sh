#!/bin/sh


doppler run terraform init

until ! doppler run --command "terraform apply -auto-approve" | grep -q 'Out of host capacity'
do
    sleep 10
done
