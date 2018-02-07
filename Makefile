# Makefile to build DreamShell-SDK Docker-Image
# and copy dsbuild script

default: build

build:
	docker build -t kallistios-sdk:dreamshell .

install: build
	cp dsbuild.sh /usr/local/bin/dsbuild

uninstall:
	rm /usr/local/bin/dsbuild
