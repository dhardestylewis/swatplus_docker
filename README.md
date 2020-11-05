# SWAT+ on Linux Dockerfile


**Docker instructions. Singularity instructions are below.**

SWAT+ may be run as one-off command from this Docker image:

```
docker run \
    --rm \
    -i \
    -t \
    --name swatplus_exe \
    --mount type=bind,source="$(pwd)",target="/mnt/host" \
    dhardestylewis/swatplus_docker:latest \
    bash -c "cd /opt/swatplus/TxtInOut_CoonCreek_aqu && \
        ./swatplus_exe"
```

An interactive shell in the Docker container may be used for troubleshooting or debugging:

```
docker run \
    --rm \
    -i \
    -t \
    --name swatplus_bash \
    --mount type=bind,source="$(pwd)",target="/mnt/host" \
    dhardestylewis/swatplus_docker:latest \
    bash
```

**Singularity instructions.**

The Singularity pull command is similar to the Docker pull command:

```
singularity pull \
    --name swatplus.sif \
    docker://dhardestylewis/swatplus_docker:latest
```

Once pulled, a one-off SWAT+ command using Singularity can be issued:

```
singularity exec \
    swatplus.sif \
    bash -c "cd /opt/swatplus/TxtInOut_CoonCreek_aqu && \
        ./swatplus_exe"
```

An interactive shell in the Singularity container may be used for troubleshooting or debugging:

```
singularity exec \
    swatplus.sif \
    bash
```


**SWAT+ combined with other commands in a shell script**

SWAT+ may be wrapped in a shell script and run using Docker:

```
docker run \
    --name swatplus_bash \
    --rm \
    -i \
    -t \
    dhardestylewis/swatplus_docker:latest \
    --mount type=bind,source="$(pwd)",target="/mnt/host" \
    bash -c './swatplus_commands.sh'
```

where the file `swatplus_commands.sh` may be written as:

```
#!/bin/bash

## Prepare environment
export SWATPLUS_DIR=/opt/swatplus/TxtInOut_CoonCreek_aqu
cp /opt/swatplus/swatplus_exe $SWATPLUS_DIR

## Execute SWAT+
cd $SWATPLUS_DIR
./swatplus_exe 
```

To do the same using Singularity, execute:

```
singularity exec \
    swatplus.sif \
    bash -c './swatplus_commands.sh'
```    

where `swatplus_commands.sh` is written as above.

