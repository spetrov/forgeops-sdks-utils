#!/usr/bin/env bash

FORGEOPS_ROOT=$1
AM="https://default.forgeops.petrov.ca/am"

# Make sure the script runs from the directory it is located in...
cd "$(dirname "$0")"

# If forgeops root path is not specified assume that it is one level up from where we run the script
if [ -z "$FORGEOPS_ROOT" ]; then 
  FORGEOPS_ROOT="../"
fi

# Remove trailing slashes if needed
FORGEOPS_ROOT=$(echo $FORGEOPS_ROOT | sed 's:/*$::')
echo $FORGEOPS_ROOT

# Check if AM is already running
if [ "`curl --silent --show-error --connect-timeout 1 -I -L $AM/| grep '200'`" != "" ]; then
  echo "AM is already running..."
  exit
fi

# Create a Minikube VM
minikube start --memory=10240 --cpus=3 --disk-size=40g --cni=true --vm=true --driver=virtualbox --bootstrapper kubeadm --kubernetes-version=stable

# Enable the ingress controller built into Minikube
minikube addons enable ingress

# Enable volume snapshots in Minikube
minikube addons enable volumesnapshots

# Create a sslcert secret in the 'default' namespace (default.forgeops.petrov.ca)
kubectl create secret tls sslcert --cert /etc/letsencrypt/live/jenkins.petrov.ca/fullchain.pem --key=/etc/letsencrypt/live/jenkins.petrov.ca/privkey.pem

# Deploy the CDK
${FORGEOPS_ROOT}/bin/cdk install --namespace default --fqdn default.forgeops.petrov.ca &

# Wait until deployment is ready
until [ "`curl --silent --show-error --connect-timeout 1 -I $AM/ | grep '200'`" != "" ];
do
  echo "Waiting for deployment to get ready. Sleeping for 10 seconds..."
  sleep 10
done
# Give a bit more time so that the deployment stabilize...
sleep 10
echo "forgeops deployment is ready!"

AMADMIN='amadmin'
AMADMIN_PASS=$($FORGEOPS_ROOT/bin/print-secrets $AMADMIN)
echo $AMADMIN_PASS

# Import all test artifacts...
./import-test-artifacts.sh $AM $AMADMIN $AMADMIN_PASS