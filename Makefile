NAME = dr.gopaktor.com/down/caddy
VERSION = 0.10.3

.PHONY: all build tag_latest release update_caddy full_release

all: build

update_caddy:
	mkdir tmp &&\
	cd tmp && \
	curl -o caddy.tgz https://caddyserver.com/download/linux/amd64 &&\
	tar -zxf caddy.tgz &&\
	cp caddy ../rootfs/bin/caddy &&\
	chmod +x ../rootfs/bin/caddy &&\
	cd ..&&\
	rm -rf tmp

build: 
	docker build -t $(NAME):$(VERSION) .

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

release: tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)

full_release: update_caddy build release
	