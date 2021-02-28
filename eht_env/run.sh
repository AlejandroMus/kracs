#! /bin/bash
#
# Copyright 2021 Alejandro Mus <alejandro.mus@uv.es>
# Copyright 2021 Universitat de Valencia
#
# Licensed under the Apache License, Version 2.0 (the "License"); you
# may not use this file except in compliance with the License.  You
# may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.  See the License for the specific language governing
# permissions and limitations under the License.

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
docker pull alejandromus/kracs:eht_m87_latest
. ./x11-flags.sh
docker run -dit -P --name ${VOLUME_NAME} -p $PORT --env="QT_X11_NO_MITSHM=1" $DISENV -v ${LOCAL_FOLDER}:/host alejandromus/kracs:eht_m87_latest
docker attach
fi
