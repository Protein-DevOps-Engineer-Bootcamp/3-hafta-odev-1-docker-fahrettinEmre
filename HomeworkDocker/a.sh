#!/bin/bash
######################
#Author : Fahrettin Emre Dalga
#Date : 27.05.2022
#Version:5.0.17
#Usage : Send Mail
######################

# -r dockerhub'a register etmek  için öncelikle docker login yapılmalıdır.

USAGE_MSG="
Usage: $(basename $0) [OPTION] <ARGUMENT> ...
OPTIONS:    ARGUMENTS:         DESCRIPTION:                             DEFAULT VALUE:
[-m]        <mode>          build-deploy-template                       Current Branch
[-n]        <name>          Compress format of the artifact.            tar.gz
[-t]        <tagh>          Output path of compressed artifacts.        Current Directory
[-r]        <registaryh>    Output path of compressed artifacts.        Current Directory
"

while getopts m:n:t:r:c:e:p:a: flag
do
    case "${flag}" in
        m) mode=${OPTARG};;
        n) name=${OPTARG};;
        t) tag=${OPTARG};;
        r) registary=${OPTARG};;
        c) containername=${OPTARG};;
        e) memory=${OPTARG};;
        p) cpu=${OPTARG};;
        a) applicationname=${OPTARG};;


    esac
done

if [ -z "$name" ] || [ -z "$tag" ]; then 
echo "name or tag cant be null "
exit 0
fi

if [ "$mode" = "build" ]; then
docker build -t ${name}:${tag} .
echo $mode
elif [ "$mode" = "deploy" ];then
# todo cpu dinamik olarak alınlaı -p yazarak cpu datası alınamıyor
# null check yapıyoruz alt satırda memory ve cpu verilmemişse limitleri vermeden çalıştırıyoruz ikisi birlikte verilmişse 
# 2 limitide set ederek çalıştırıyoruz
if [ -z "$memory" ] && [ -z "$cpu" ]; then 
docker run ${name}:${tag}
else
docker run -m $memory --cpus $cpu ${name}:${tag} 
fi
if [ -z "$registary" ];then 
echo ""
else
docker push ${name}:${tag}
fi
elif [ "$mode" = "template" ];then
echo $applicationname
# todo cpu dinamik olarak alınlaı -p yazarak cpu datası alınamıyor
docker-compose -f docker-compose-${applicationname} up
fi