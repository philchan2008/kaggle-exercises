#!/bin/bash
docker run -it --rm -p 8888:8888 \
-v /home/jovyan/work:/home/jovyan/work \
-v /home/sky/Playground:/home/jovyan/playground \
-v $(pwd)/startup.sh:/usr/local/bin/startup.sh \
mynotebook6 \
bash /usr/local/bin/startup.sh
