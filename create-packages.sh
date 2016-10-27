#!/bin/sh
# Author: TheElectronWill
# This script downloads the latest source code of libimobiledevice, from github, and creates RPM packages.
# The build architecture is chosen automatically.

# Checks that rpmbuild is installed
if [ ! type 'rpmbuild' > /dev/null ]
then
	
	echo "You need the rpm development tools to create rpm packages"
	read -p "Do you want to install rpmdevtools now? This will run sudo dnf install rpmdevtools. [y/N]" answer
	case answer in
		[Yy]* ) sudo dnf install rpmdevtools;;
		* ) 
			echo "Ok, I won't install rpmdevtools."
			exit
		;;
	esac
fi


# Downloads the source in a tar.gz file
wget https://github.com/libimobiledevice/libimobiledevice/archive/master.tar.gz

# Chooses the spec file based on the system's architecture
arch=$(uname -m)
spec_file="libimobiledevice_$arch.spec"

# Creates rpm packages
rpmbuild -ba $spec_file


