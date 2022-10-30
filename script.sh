#!/bin/bash​
docker run -d -i --name centos7 centos:7
docker run -d -i --name ubuntu matthewfeickert/docker-python3-ubuntu:3.10.5
docker run -d -i --name fedora fedora:latest
echo "PRINT VAULT PASSWORD (YOU CAN FIND IT IN README.MD)"
ansible-playbook -i playbook/inventory/prod.yml playbook/site.yml --ask-vault-pass
docker stop fedora
docker stop ubuntu
docker stop centos7
docker rm fedora
docker rm ubuntu
docker rm centos7