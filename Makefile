help:
	@cat Makefile

IMAGE="siana/keras-gpu"
DOCKER_FILE=Dockerfile
BACKEND=tensorflow
PYTHON_VERSION?=3.6
CUDA_VERSION?=9.0
CUDNN_VERSION?=7
TEST=tests/
SRC?=$(shell dirname `pwd`)

build:
	docker build -t $(IMAGE) --build-arg python_version=$(PYTHON_VERSION) --build-arg cuda_version=$(CUDA_VERSION) --build-arg cudnn_version=$(CUDNN_VERSION) -f $(DOCKER_FILE) .

test: build
	nvidia-docker run -it -v $(SRC):/src/workspace --env KERAS_BACKEND=$(BACKEND) $(IMAGE) py.test $(TEST)

