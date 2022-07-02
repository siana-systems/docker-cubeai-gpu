#------------------------------------------------------------------------------------------
# @author: SIANA
# @date: 06/2022 (update)
# @brief: Admin makefile to build a Cube.AI docker/keras image for CPU host.
# @description:
#       This image is meant to be used to train models using TF/Keras that are intended
#       to run on STM32 MCUs using Cube-AI. As such, it includes Cube-AI compatible
#       versions of TF/Keras and the Cube-AI CLI. It also includes typical packages used
#       to process data (images and audio.) See the Dockerfile for details.
#
# @note: The docker image is tagged using a human-readable version and its git commit#
#
# @ref: tagging = https://blog.container-solutions.com/tagging-docker-images-the-right-way
#------------------------------------------------------------------------------------------

help:
	@cat Makefile

# Docker image info
NAME="siana/tf-cubeai-gpu"
VERSION="v1"

# Docker-Hub
TAG=$(shell git log -1 --pretty=%h)
IMAGE=$(NAME):$(TAG)
BUILD=$(NAME):$(VERSION)
LATEST=$(NAME):latest

# configuration
BACKEND=tensorflow
TEST=tests/
SRC?=$(shell dirname `pwd`)

#--->> ADMIN Tasks <<------

version:
	@echo IMAGE is $(IMAGE)
	@echo BUILD is $(BUILD)

build:
	docker build --no-cache -t $(IMAGE) -f Dockerfile .
	docker tag $(IMAGE) $(BUILD)
	docker tag $(IMAGE) $(LATEST)

push:
	docker push $(LATEST)
	docker push $(BUILD)

#--->> USER Tasks <<--------

pull:
	docker run pull $(NAME)

bash:
	docker run --gpus all -it -v $(SRC):/src/workspace --env KERAS_BACKEND=$(BACKEND) $(LATEST) bash

ipython:
	docker run --gpus all -it -v $(SRC):/src/workspace --env KERAS_BACKEND=$(BACKEND) $(LATEST) ipython

notebook:
	docker run --gpus all -it -v $(SRC):/src/workspace --net=host --env KERAS_BACKEND=$(BACKEND) $(LATEST)

