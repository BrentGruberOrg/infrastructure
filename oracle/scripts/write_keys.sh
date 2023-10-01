#!/bin/bash

echo $DEFAULT_SSH_KEY > id_rsa.pub
echo $TF_VAR_PRIVATE_KEY > id_rsa.pem