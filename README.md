# Docker KallistiOS - Dreamcast SDK
This image provides a full powered [KallistiOS](http://gamedev.allusion.net/softprj/kos/) SDK for Developing Homebrew for the Sega Dreamcast.
It has been build, so you don't have to compile/setup the KOS-Toolchain yourself & keep your system clean.

## Included Software
This Docker image contains:
 - Based on Debian "Jessie"
 - Latest KallisiOS Toolchain + Ported Libraries
 - Latest [mksdiso](https://github.com/Nold360/mksdiso) Toolkit for creating SD-ISOs, scrambling & more
 - mds4dc & cdi4dc for Image creation ([source](https://github.com/kazade/img4dc))
 - makeip for custom IP.BIN creation (taken from mksdiso)

I've also created a wrapper-script called "**[dcbuild](https://github.com/Nold360/docker-kallistios-sdk/blob/master/dcbuild.sh)**" which already handles some development tasks for you!

## Using the image
If you have created your first KOS project and built a Makefile for it, you can compile your sourcecode like this:
```
$ docker run -ti -v $(pwd):/src nold360/kallisios-sdk make
```

The Volume `-v $(pwd):/src`will include your current working directory (aka your KOS-project directory) into the container.
The `make` command at the end is default and can be changed as needed. (Like `make dreamcast` or whatever).

## Installing dcbuild
You will find an additional shellscript called "dcbuild" in the [Github](https://github.com/nold360/docker-kallisios-sdk) of this container.
Install the script inside the PATH of your **HOST** running this container:
```
$ sudo wget -O/usr/local/bin/dcbuild https://raw.githubusercontent.com/Nold360/docker-kallistios-sdk/master/dcbuild.sh
$ sudo chmod +x /usr/local/bin/dcbuild
```

## Using dcbuild
dcbuild is a wrapper for this container. It'll give you some nice possibillities like:
 - Building your Project
 - Creating .bin, .iso & .cdi
 - Creating (custom) IP.BIN
 - Get a bash-shell inside the container (for debugging)

### Examples
#### Build Project (using Makefile):
```
~/myproject $> dcbuild make
```
Example Output:
```
######### KallistiOS Environment ##########
# CMD: make
rm -f example1.elf romdisk.*
kos-cc  -c example1.c -o example1.o
kos-cc -o example1.elf example1.o
```

#### Create binary from elf:
```
~/myproject $> dcbuild bin example1.elf 
```
Example Output:
```
######### KallistiOS Environment ##########
# CMD: sh-elf-objcopy -R .stack -O binary example1.elf main.bin
```

#### Create IP.BIN:
Note: IP.BIN can be customized by editing "ip.txt" & rerun "dcbuild ip"
```
 ~/myproject $> dcbuild ip
```
Example Output:
```
######### KallistiOS Environment ##########
# CMD: cp /opt/mksdiso/src/makeip/ip.txt /opt/mksdiso/src/makeip/IP.TMPL /src
######### KallistiOS Environment ##########
# CMD: makeip ip.txt IP.BIN
Setting CRC to B6D8 (was 0000)
```

#### Create CDI-Image
```
 ~/myproject $> dcbuild cdi
```
Example Output:
```
######### KallistiOS Environment ##########
# CMD: scramble main.bin iso/1ST_READ.BIN
######### KallistiOS Environment ##########
# CMD: genisoimage -V MY_GAME -G IP.BIN -joliet -rock -l -o mygame.iso iso
Total translation table size: 0
Total rockridge attributes bytes: 253
Total directory bytes: 0
Path table size(bytes): 10
Max brk space used 0
336 extents written (0 MB)
######### KallistiOS Environment ##########
# CMD: cdi4dc mygame.iso mygame.iso.cdi -d
CDI4DC - 0.4b - Written by SiZiOUS
http://www.sizious.com/

Image method............: Data/Data
Volume name.............: MY_GAME
Writing data pregap.....: OK
Writing datas track.....: [688128/688128] - 100%
                          338 block(s) written (27.16MB used)
Writing pregap tracks...: OK
Writing header track....: OK
Writing CDI header......: OK

Woohoo... All done OK!
You can burn it now (TO A CD-RW PLEASE AGAIN... BETA VERSION !!!)...
```

#### Cleanup Everything
Watch out: This will run "make clean" and delete all *.iso, *.cdi & IP.BIN-related files in your current directory. Also it deletes the "iso"-folder & main.bin (if existing).
```
 ~/myproject $> dcbuild clean
```
Example Output:
```
######### KallistiOS Environment ##########
# CMD: make clean
rm -f example1.elf example1.o romdisk.*
+ rm -rf iso/
+ rm -f '*.iso' '*.cdi' main.bin IP.BIN IP.TMPL ip.txt
+ set +x

```


## Environment Variables
There are a few variables that can be customized by setting them inside your environment.
### ISO
Name of the ISO/CDI created by dcbuild
`export ISO=my_game_name.iso"`

### GAME_TITLE
Title of your game (will be used in ISO, **not** IP.BIN)
`export GAME_TITLE="MY_AWESOME_GAME"`

## Troubleshooting
You can run bash in your SDK Environemnt, too. This might help finding the problem. Also feel free to open issues on [github](https://github.com/Nold360/docker-kallisios-sdk)
`$ docker run -ti -v $(pwd):/src nold360/kallisios-sdk bash`