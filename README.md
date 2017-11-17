# Docker KallistiOS - Dreamcast SDK
This image provides a full powered [KallistiOS](http://gamedev.allusion.net/softprj/kos/) SDK for Developing Homebrew for the Sega Dreamcast.
It has been build, so you don't have to compile/setup the KOS-Toolchain yourself & keep your system clean.

## Included Software
This Docker image contains is 100% free software! :)
 - Based on Debian "Jessie"
 - Latest KallisiOS Toolchain + Ported Libraries
 - Latest [mksdiso](https://github.com/Nold360/mksdiso) Toolkit for creating SD-ISOs


## Using the image
If you have created your first KOS project and built a Makefile for it, you can compile your sourcecode like this:
```
$ docker run -ti -v $(pwd):/src nold360/kallisios-sdk make
```

The Volume `-v $(pwd):/src`will include your current working directory (aka your KOS-project directory) into the container.
The `make` command at the end is default and can be changed as needed. (Like `make dreamcast` or whatever).


## Troubleshooting
You can run bash in your SDK Environemnt, too. This might help finding the problem. Also feel free to open issues on [github](https://github.com/Nold360/docker-kallisios-sdk)
`$ docker run -ti -v $(pwd):/src nold360/kallisios-sdk bash`