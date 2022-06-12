#!/bin/bash
################################
#Author : Fahrettin Emre Dalga
#Date : 11.06.2022
#Usage : Docker Build
################################


#usage message
msg="
Usage: $(basename $0) [OPTION] <ARGUMENT> ...
OPTIONS:    ARGUMENTS:         DESCRIPTION:              
[-m]        <mode>             <build-deploy-template> Exp: -m deploy              
[-n]        <name>             İmage name Exp: -n imagename                                   
[-t]        <tag>              İmage Tag  Exp: -t tagname
[-r]        <registary>        For push Dockerhub or Gitlab Exp: -r dockerhub        
[-e]        <memory>           If this parameter is not given, it works by default. Exp: -e 1g 
[-p]        <cpu>              If this parameter is not given, it works by default. Exp: -p 1
[-a]        <applicationname>  <sql-mongo> Exp: -a sql
"
help() {
    echo "${msg}"
    exit 1
}
while getopts m:n:t:r:e:p:a:h flag
do
    case "${flag}" in
        m) mode=${OPTARG};;
        n) name=${OPTARG};;
        t) tag=${OPTARG};;
        r) registary=${OPTARG};;
        e) memory=${OPTARG};;
        p) cpu=${OPTARG};;
        a) applicationname=${OPTARG};;
        h) help;;
    esac
done


#build mod
if [ "$mode" = "build" ]; then             
if [ -z "$name" ] || [ -z "$tag" ]; then          #İmage name ve image tag kontrolü yapıyoruz. Yoksa script kırılıyor.
echo "Name or Tag can't be null or empty!"        # Name veya tag null olamaz mesajı veriyoruz.
exit 0                                            # script kırılıyor.                     
fi
docker build -t ${name}:${tag} .                  #docker build alıyoruz template bir Dockerfile ile , istenen docker file buraya eklenebilir.


#deploy mode
elif [ "$mode" = "deploy" ];then          
if [ -z "$name" ] || [ -z "$tag" ]; then         #İmage name ve image tag kontorlü yapıyoruz. Yoksa script kırılıyor.
echo "Name or Tag can't be null or empty!"
exit 0
fi                                    
if [ -z "$memory" ] && [ -z "$cpu" ]; then        # Null check yapıyoruz ,memory ve cpu verilmemişse limitleri vermeden çalıştırıyoruz.
docker run ${name}:${tag}                         #docker image run edilir.         
else
docker run -m $memory --cpus $cpu ${name}:${tag}  # İkisi birlikte verilmişse 2 limitide set ederek çalıştırıyoruz. 
fi
if [ -z "$registary" ];then                       #opsiyonel olarak registery kontrol ediyoruz. Eklenmesi durumunda hangi image registry olduğu girilmelidir..
echo ""
else
docker push ${name}:${tag}                        # dockerhub veya gitlab 'a register etmek  için öncelikle login olunmalıdır.
fi

# template mod
elif [ "$mode" = "template" ];then   
echo $applicationname     
docker-compose -f docker-compose-${applicationname} up       #sql veya mongo servisleri ayağa kalkar.
fi