#!/usr/bin/env bash
#
# Copyright 2019 Chi-kwan Chan
# Copyright 2019 Steward Observatory
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

if [ -f /.dockerenv ]; then
        echo "This script tests the host's X11 setup; \
avoid running it inside a container"
        exit 1
fi

case $(uname) in
Darwin)
	# Docker actually runs inside a virtual machine through
	# HyperKit (which uses Hypervisor.framework) on MacOS.
	# Therefore, we cannot simply connect/mount the container and
	# host sockets.  Instead, we need to use network.
	#
	# For the following hack to work, you need to:
	#
	# 1. install X11 on your Mac;
	#
	# 2. in X11->Preferences->Security, you *have to* check "Allow
	#    connections from network clients";
	#
	# 3. in X11->Preferences->Security, you can optionally check
	#    "Authenticate connections".  If you check that, the
	#    following `xhost` command is required.  If you uncheck
	#    it, that command has no effect.
	#
	SS=$(echo $DISPLAY | \
	     sed -En 's/.*:(.*)/\1/p')
	xhost + 127.0.0.1 1>&2
	echo "-e DISPLAY=host.docker.internal:$SS"
	DISENV="-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw"
	;;
Linux)
	echo "-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw"
	DISENV="-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw"
	;;
esac 
