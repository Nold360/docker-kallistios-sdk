#!/bin/bash
# Wrapper script to use with nold360/kallistios-sdk
# This script is used on THE HOST running docker!
#
# By combining docker and this script, you can a full-featured,
# prebuild Dreamcast SDK in just like a minute!
ACTION=$1

if ! type docker &>/dev/null; then
	echo "You need to install docker to use dcbuild"
	exit 1
fi

# Environment Configuration Defaults
ISO=${ISO:-mygame.iso}
GAME_TITLE=${GAME_TITLE:-MY_GAME}
DOCKER_IMAGE="nold360/kallistios-sdk"
DCRUN="docker run -ti -v $(pwd):/src $DOCKER_IMAGE"

function usage {
	echo "Wrapper Script for Docker-Image nold360/kallistios-sdk"
	echo "By Nold 2017 - http://github.com/nold360/docker-kallistios-sdk"
	echo
	echo "Usage: $0 <make|ip|clean|bin|iso|cdi|...> [args...]"
	echo -e " - make\t\t Build Project"
	echo -e " - ip\t\t Create IP.BIN using makeip"
	echo -e " - clean\t Cleanup everything, deletes *.iso, *.cdi, IP.BIN + depends"
	echo -e " - bin <ARG>\t Convert ARG to 'main.bin"
	echo -e " - iso\t\t scramble main.bin to 1ST_READ.BIN & genisoimage from iso-folder"
	echo -e " - cdi\t\t convert iso-image to cdi"
	echo
	echo "You can also run things like 'dcbuild bash' to get a shell inside the container"
	echo "Or 'dcbuild mksdiso' to convert your project / a CDI-Image to Dreamshell SDISO"
}

if [ -z "$ACTION" ] ; then
	usage
	exit 1
fi

# Additional "clean" option, removes *.iso, *.cdi & IP.BIN related
if [ "$ACTION" == "clean" ] ; then
	$DCRUN make clean
	set -x
	rm -rf iso/
	rm -f *.iso *.cdi main.bin IP.BIN IP.TMPL ip.txt
	set +x

# Generate IP.BIN from scratch, change "ip.txt" to your needs and run "dcbuild ip" again
# to customize IP.BIN
elif [ "$ACTION" == "ip" ] ; then
	[ ! -f ip.txt ] || [ ! -f IP.TMPL ] && $DCRUN cp /opt/mksdiso/src/makeip/{ip.txt,IP.TMPL} /src
	$DCRUN makeip ip.txt IP.BIN

# Create Binary from ELF
elif [ "$ACTION" == "bin" ] ; then
	ELF=$2
	if [ ! -e "$ELF" ] ; then
		echo "Error: elf-file '$ELF' doesn't exist!"
		usage
		exit 1
	fi
	$DCRUN sh-elf-objcopy -R .stack -O binary $ELF main.bin

# Create CDI / ISO
elif [ "$ACTION" == "cdi" ] || [ "$ACTION" == "iso" ] ; then
	mkdir iso &>/dev/null
	$DCRUN scramble main.bin iso/1ST_READ.BIN
	[ ! -f iso/1ST_READ.BIN ] && exit 1

	[ ! -f IP.BIN ] && $0 ip
	$DCRUN genisoimage -V $GAME_TITLE -G IP.BIN -joliet -rock -l -o $ISO iso
else
	# Otherwise just run the command directly into the container
	$DCRUN $@
fi

# Convert ISO to CDI
if [ "$ACTION" == "cdi" ] ; then
	if [ -f "$ISO" ] ; then
		$DCRUN cdi4dc $ISO $ISO.cdi -d
	else
		echo "Error: ISO-file '$ISO' doesn't exist! Run 'dcbuild bin' first"
	fi
fi
exit 0
