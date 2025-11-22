#! /bin/bash

aws cloud9 create-environment-ec2 \
    --name ambiente_aws_pipeline_data_proj \
    --description "Ambiente Cloud9 com Ubuntu 22.04 e m5.large." \
    --instance-type m5.large \
    --image-id ubuntu-22.04-x86_64 \
    --automatic-stop-time-minutes 60 \
    --connection-type CONNECT_SSH