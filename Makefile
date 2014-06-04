VERSION:=4.0.0
EXTRACT_DIR:=varnish-$(VERSION)
SOURCE_TARBALL:=$(EXTRACT_DIR).tar.gz
SOURCE_URL:=https://repo.varnish-cache.org/source/$(SOURCE_TARBALL)
DEPENDENCIES:=autoconf automake1.1 autotools-dev groff-base libedit-dev libncurses-dev libpcre3-dev libtool pkg-config python-docutils curl runit

all: apt get-src build

apt:
	apt-get update -qq
	apt-get install -y $(DEPENDENCIES)

get-src:
	curl -O $(SOURCE_URL)
	tar -xvzf $(SOURCE_TARBALL)

build:
	cd $(EXTRACT_DIR) && sh autogen.sh
	cd $(EXTRACT_DIR) && sh configure
	cd $(EXTRACT_DIR) && $(MAKE)
#	cd $(EXTRACT_DIR) && $(MAKE) check

install:
	cd $(EXTRACT_DIR) && make install
	install -D -o root -g root etc/default/varnish /etc/default/
	install -D -o root -g root etc/varnish/default.vcl /etc/varnish/default.vcl
	mkdir -p /etc/service
	openssl rand -base64 15 > /etc/varnish/secret
