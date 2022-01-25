#!/bin/sh

#sleep 2
#echo $(ssh -o "StrictHostKeyChecking=no" git@ssh.dev.azure.com 'ssh-keyscan  -H localhost') >> ~/.ssh/known_hosts
java -jar app.jar
