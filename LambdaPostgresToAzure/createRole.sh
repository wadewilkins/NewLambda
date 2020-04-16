#!/bin/sh
role_name="wade-role"
role_policy_arn="arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"

aws iam create-role \
    --role-name "wade-role" \
    --assume-role-policy-document file://assume-role-policy.txt
aws iam attach-role-policy \
    --role-name "${role_name}" \
    --policy-arn "${role_policy_arn}"
