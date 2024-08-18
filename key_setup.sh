#!/bin/bash

echo "Generating SSH key..."

ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa

# Get the public key and write it to a file
PUBLIC_KEY=$(cat ~/.ssh/id_rsa.pub)
echo "$PUBLIC_KEY" > id_rsa.pub