USAGE_MSG="
Usage: $(basename $0) [OPTION] <ARGUMENT> ...
OPTIONS:    ARGUMENTS:         DESCRIPTION:                             DEFAULT VALUE:
[-m]        <mode>      Branch name to get the build from.       Current Branch
[-n]        <name>       Compress format of the artifact.         tar.gz
[-t]        <tagh>    Output path of compressed artifacts.     Current Directory
[-r]        <registaryh>    Output path of compressed artifacts.     Current Directory
"

while getopts m:n:t:r:c:e:p:a flag
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
if [ $mode == "build" ];then
docker build -t ${name}:${tag} .
echo $mode
elif [ $mode == "deploy" ];then
echo "zsdasds"
# todo cpu dinamik olarak alınlaı -p yazarak cpu datası alınamıyor
docker run -m $memory --cpus 1 ${name}:${tag} 
echo $cpu
elif [ $mode == "template" ];then
echo $applicationname
# todo cpu dinamik olarak alınlaı -p yazarak cpu datası alınamıyor
docker-compose -f docker-compose-${applicationname} up
fi