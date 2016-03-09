.PHONY: all build push

all: build

build:
	docker build -t pavlov/nginx-ssl-proxy .

push:
	docker push pavlov/nginx-ssl-proxy
