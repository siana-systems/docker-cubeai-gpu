# STM32 Cube-AI Development Docker for GPU-Host

This repo provides a docker image for deep-learning development targeting the STMicroelectronics [Cube-AI](https://www.st.com/en/embedded-software/x-cube-ai.html). It is built on top of the TensorFlow Dockerfile for GPU and includes most typical packages needed to process & train a model using TensorFlow/Keras and compiling the resulting model using the Cube-AI command-line interface.

## Using the SIANA image

Note: the following instructions were tested on Linux/Ubuntu 20.04 LTS with nvidia driver 515.48.07.

To run a container from the SIANA hosted image on Docker Hub, you'll need to:
  * have an NVIDIA graphic card (to check, run: nvidia-smi)
  * install [Docker Engine](https://docs.docker.com/engine/install/)
  * install the [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-docker)
  * check that you have *make* installed, if not:
    * *sudo apt-get update*
    * *sudo apt-get install make*
  * download/save the *Makefile* from this repo in your training directory
  
To run the container in bash mode:
 ```console
 foo@bar: ~/$ make bash
 ```
The first time around, Docker will proceed to download the SIANA image form Docker Hub (which may take a while...) Then, it'll run a container and open a bash terminal. From this terminal, you can run your TensorFlow/Keras python scripts and/or the Cube-AI CLI (stm32ai.) The docker container maps its /src/workspace/ to your working/training folder on the host side.
 
Note: review the Makefile targets for different runtime options.

## How to build a new image

If you need to update the docker image...

### Pre-requisites

Notes:
  * the following instructions were tested on Linux/Ubuntu 20.04
  * the following instructions assumed the root path under: ~/docker-cubeai-gpu
 
You will need:
  * to install [Docker Engine](https://docs.docker.com/engine/install/)
  * a copy of ST Cube-AI:
    * download / install the [STM32CubeMX](https://www.st.com/en/development-tools/stm32cubemx.html)
    * install the latest [X-Cube-AI](https://www.st.com/content/st_com/en/products/embedded-software/mcu-mpu-embedded-software/stm32-embedded-software/stm32cube-expansion-packages/x-cube-ai.html) 
    * use CubeMX to create a dummy project and select the X-Cube-AI package => it will force download the remaining dependencies.
    * make a copy of X-Cube-AI linux in ~/docker-keras-cpu/cubeai
      you can find X-Cube-AI under:  ~/STM32Cube/Repository/Packs/STMicroelectronics/X-Cube-AI/<M.m.b>/Utility/linux
    * if needed: chmod 775 the copied cubeai/stm32ai

### building the image
Don't forget to edit the Makefile to change the version#

Open a terminal into your ~/docker-cubeai-gpu and run:
```console
 foo@bar: ~/docker-cubeai-gpu$ make build
```
Docker will launch and proceed to build a new image named: "tf-cubeai-gpu:vx"

On completion, you should see the new image listed: 
```console
foo@bar: ~/docker-cubeai-gpu$ docker image list
```

Opional: you can push the new release: 
```console
foo@bar: ~/docker-cubeai-gpu$ docker push
```

This new image will be used by the Makefile to launch a new container (as described in [Using the SIANA Image].)

