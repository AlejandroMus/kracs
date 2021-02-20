#! /bin/bash


POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in 
    -v|--volume)
    VOLUME_NAME="$2"
    shift # past argument
    shift # past value
    ;;
    -lf|--localfolder)
    LOCAL_FOLDER="$2"
    shift # past argument
    shift # past value
    ;;
    -p|--port)
    PORT="$2"
    shift # past argument
    shift # past value
    ;;
    -h|--help)
    echo "Usage: bash run.sh -v VOLUME_NAME -lf LOCAL_FOLDER [-p PORT] [-verb VERBOSE]"
    shift # past argument
    shift # past value
    ;;
    -verb|--verbose)
    echo "VOLUME_NAME = ${VOLUME_NAME}"
    echo "LOCAL_FOLDER = ${LOCAL_FOLDER}"
    echo "PORT = ${PORT}"
    shift # past argument
    shift # past value
    ;;
    *)
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters



if [[ "$PORT" == "" ]]
then
PORT="8888:8888"
fi

if [[ "$VOLUME_NAME" == "" ]] || [[ "$LOCAL_FOLDER" == "" ]]
then
echo "$VOLUME_NAME"
echo "ERROR ---> Usage: bash run.sh -v VOLUME_NAME -lf LOCAL_FOLDER [-p PORT] [-verb VERBOSE]"
echo "Your values"
echo "VOLUME_NAME = ${VOLUME_NAME}"
echo "LOCAL_FOLDER = ${LOCAL_FOLDER}"
echo "PORT = ${PORT}"
echo ""
else
docker run -dit -P --name ${VOLUME_NAME} -p $PORT --env="QT_X11_NO_MITSHM=1" -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v ${LOCAL_FOLDER}:/host eht_m87
fi
