

SNS_ARN=`aws sns list-topics | grep emf_cloudwatch |cut -f2- -d':' | tr -d '"' | tr -d ' '`
echo $SNS_ARN
