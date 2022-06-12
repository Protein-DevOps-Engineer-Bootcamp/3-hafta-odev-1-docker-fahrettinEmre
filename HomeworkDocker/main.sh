#!/bin/bash
################################
#Author : Fahrettin Emre Dalga
#Date : 11.06.2022
#Usage : Docker Build
################################


#usage message
USAGE_MSG="
Usage: $(basename $0) [OPTION] <ARGUMENT> ...
OPTIONS:    ARGUMENTS:         DESCRIPTION:              
[-m]        <mode>             Build-deploy-template                  
[-n]        <name>             İmage name                                   
[-t]        <tag>              İmage Tag       
[-r]        <registary>        For push Dockerhub or Gitlab        
[-e]        <memory>           If this parameter is not given, it works by default. 
[-p]        <cpu>              If this parameter is not given, it works by default.
[-a]        <applicationname>  sql or mongo 
"

while getopts m:n:t:r:e:p:a: flag
do
    case "${flag}" in
        m) mode=${OPTARG};;
        n) name=${OPTARG};;
        t) tag=${OPTARG};;
        r) registary=${OPTARG};;
        e) memory=${OPTARG};;
        p) cpu=${OPTARG};;
        a) applicationname=${OPTARG};;


    esac
done


#build mod
if [ "$mode" = "build" ]; then             
if [ -z "$name" ] || [ -z "$tag" ]; then  #İmagename ve imagetag kontorlü yapıyoruz. Yoksa script kırılıyor.
echo "Name or tag can't be null !"          # Name veya tag null olamaz mesajı veriyoruz.
exit 0                                    # script kırılıyor.                     
fi
docker build -t ${name}:${tag} .          #build


#deploy mode
elif [ "$mode" = "deploy" ];then          
if [ -z "$name" ] || [ -z "$tag" ]; then  #İmagename ve imagetag kontorlü yapıyoruz. Yoksa script kırılıyor.
echo "Name or tag can't be null !"
exit 0
fi                                    
if [ -z "$memory" ] && [ -z "$cpu" ]; then # Null check yapıyoruz alt satırda memory ve cpu verilmemişse limitleri vermeden çalıştırıyoruz.
docker run ${name}:${tag}                  # İkisi birlikte verilmişse 2 limitide set ederek çalıştırıyoruz. 
else
docker run -m $memory --cpus $cpu ${name}:${tag}  
fi
if [ -z "$registary" ];then  #registery kontrol ediyoruz.
echo ""
else
docker push ${name}:${tag} # -r dockerhub veya gitlab 'a register etmek  için öncelikle login yapılmalıdır.
fi

# template mod
elif [ "$mode" = "template" ];then   
echo $applicationname     
docker-compose -f docker-compose-${applicationname} up #sql veya mongo servisleri ayağa kalkar.
fi