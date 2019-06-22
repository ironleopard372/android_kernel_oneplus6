#!/bin/bash
############################################################
### Build script for NetHunter OnePlus 6/6T kernel ###
############################################################

# This is the full build script used to build the official kernel zip.

# Minimum requirements to build:
# Already working build environment
#
# In this script:
# You will need to change the 'Source path to kernel tree' to match your current path to this source.
# You will need to change the 'Compile Path to out' to match your current path to this source.
# You will also need to edit the '-j32' under 'Start Compile' section and adjust that to match the amount of cores you want to use to build.
#
# In Makefile:
# You will need to edit the 'CROSS_COMPILE=' line to match your current path to this source.
#
# Once those are done, you should be able to execute './build.sh' from terminal and receive a working zip.

############################################################
# Build Script Variables
############################################################

# Source defconfig used to build
	dc=nethunter_defconfig

# Source Path to kernel tree
	k=$pwd

# Source Path to clean(empty) out folder
	co=out/

# Compile Path to out
	o="O=/root/Downloads/op6-NetHunter/out"

# Source Path to compiled Image.gz-dtb
	i=out/arch/arm64/boot/Image.gz-dtb

# Destination Path for compiled modules
	zm=build/system/lib/modules

# Destination path for compiled Image.gz-dtb
	zi=build/Image.gz-dtb

# Source path for building kernel zip
	zp=build/

# Destination Path for uploading kernel zip
	zu=../

# Kernel zip Name
##############################
	kn=NETHUNTER.zip

############################################################
# Cleanup
############################################################

	echo "  Removing all cache and files generated"
	sh cleanup.sh
	echo "  Done, now.. removing the rest"

	echo "	Cleaning up out directory"
	rm -Rf out/
	echo "	Out directory removed!"

############################################################
# Make out folder
############################################################

	echo "	Making new out directory"
	mkdir -p "$co"
	echo "	Created new out directory"

############################################################
# Establish defconfig
############################################################

	echo "	Establishing build environment.."
	make "$o" "$dc"

############################################################
# Start Compile
############################################################

	echo "	First pass started.."
	make "$o" -j2
	echo "	First pass completed!"
	echo "	"
	echo "	Starting Second Pass.."
	make "$o" -j2
	echo "	Second pass completed!"

############################################################
# Copy image.gz-dtb to /build
############################################################

	echo "	Copying kernel to zip directory"
	cp "$i" "$zi"
#	find . -name "*.ko" -exec cp {} "$zm" \;
	echo "	Copying kernel completed!"

############################################################
# Generating Changelog to /build
############################################################

	./changelog

############################################################
# Make zip and move to /upload
############################################################

	echo "	Making zip file.."
	cd "$zp"
	zip -r "$kn" *
	echo "	Moving zip to upload directory"
	mv "$kn" "$zu"
	echo "	Completed build script!"
	echo "	Returning to start.."
	cd "$k"
