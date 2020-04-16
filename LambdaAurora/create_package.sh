#/bin/bash
env=$1
severity=$2

if [ -z ${1+x} ]; then
   echo "Please supply environment"
   echo "sh create_package.sh [dev/prod]"
   exit 1
fi
if [ $env = 'dev' ]; then
  sed -ie 's/azure_api_key_placeholder/3b1ee4874d9e4196abd48b579bd43d28/g' pdba_emf_cloudwatch_ec2.py
  sed -ie 's/azure_api_key_placeholder/3b1ee4874d9e4196abd48b579bd43d28/g' pdba_emf_cloudwatch_rds.py
  sed -ie 's/Environment_placeholder/'"$env"'/g' pdba_emf_cloudwatch_rds.py
  sed -ie 's/Environment_placeholder/'"$env"'/g' pdba_emf_cloudwatch_ec2.py
  sed -ie 's/Url_placeholder/emfapilab.azure-api.net/g' pdba_emf_cloudwatch_ec2.py
  sed -ie 's/Url_placeholder/emfapilab.azure-api.net/g' pdba_emf_cloudwatch_rds.py
  sed -ie 's/Part_placeholder/EMFAPILab/g' pdba_emf_cloudwatch_ec2.py
  sed -ie 's/Part_placeholder/EMFAPILab/g' pdba_emf_cloudwatch_rds.py
elif [ $env = 'prod' ]; then
  sed -ie 's/azure_api_key_placeholder/c0379fc8cda243acb4694a9a520cf7bc/g' pdba_emf_cloudwatch_ec2.py
  sed -ie 's/azure_api_key_placeholder/c0379fc8cda243acb4694a9a520cf7bc/g' pdba_emf_cloudwatch_rds.py
  sed -ie 's/Environment_placeholder/'"$env"'/g' pdba_emf_cloudwatch_ec2.py
  sed -ie 's/Environment_placeholder/'"$env"'/g' pdba_emf_cloudwatch_rds.py
  sed -ie 's/Url_placeholder/emfapi.azure-api.net/g' pdba_emf_cloudwatch_ec2.py
  sed -ie 's/Url_placeholder/emfapi.azure-api.net/g' pdba_emf_cloudwatch_rds.py
  sed -ie 's/Part_placeholder/emfapi/g' pdba_emf_cloudwatch_ec2.py
  sed -ie 's/Part_placeholder/emfapi/g' pdba_emf_cloudwatch_rds.py
else
  echo "Please supply environment"
  echo "sh create_package.sh [dev/prod] "
  exit 1
fi
zip -r9 pdba_emf_cloudwatch_ec2.zip pdba_emf_cloudwatch_ec2.py
zip -r9 pdba_emf_cloudwatch_ec2.zip pip
zip -r9 pdba_emf_cloudwatch_ec2.zip pkg_resources
zip -r9 pdba_emf_cloudwatch_ec2.zip requests
zip -r9 pdba_emf_cloudwatch_ec2.zip setuptools
zip -r9 pdba_emf_cloudwatch_ec2.zip wheel
zip -r9 pdba_emf_cloudwatch_ec2.zip easy_install.py
zip -r9 pdba_emf_cloudwatch_ec2.zip easy_install.pyc

zip -r9 pdba_emf_cloudwatch_rds.zip pdba_emf_cloudwatch_rds.py
zip -r9 pdba_emf_cloudwatch_rds.zip pip
zip -r9 pdba_emf_cloudwatch_rds.zip pkg_resources
zip -r9 pdba_emf_cloudwatch_rds.zip requests
zip -r9 pdba_emf_cloudwatch_rds.zip setuptools
zip -r9 pdba_emf_cloudwatch_rds.zip wheel
zip -r9 pdba_emf_cloudwatch_rds.zip easy_install.py
zip -r9 pdba_emf_cloudwatch_rds.zip easy_install.pyc
