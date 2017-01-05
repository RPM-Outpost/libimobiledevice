#!/bin/sh
# Author: TheElectronWill
# This script downloads the latest source code of libimobiledevice, from github, and creates RPM packages.
# The build architecture is chosen automatically.

# Defines the needed paths
rpm_dir=$PWD/RPMs
work_dir=$PWD/work
source_dir=$work_dir/SOURCES

archive_file="$source_dir/libimobiledevice.tar.gz"

# It's a bad idea to run rpmbuild as root!
if [ "$(id -u)" = "0" ]; then
	echo '----- WARNING -----'
	echo 'This script should NOT be executed with root privileges!'
	echo 'Building rpm packages as root is dangerous and may harm the system!'
	echo 'Actually, badly written RPM spec files may execute dangerous command in the system directories.'
	echo 'So it is REALLY safer not to run this script as root.'
	echo 'If you still want to run this script as root, type "do it!" within 5 seconds (type anything else to exit):'
	read -t 5 -n 6 -p 'Do you really want to do it (not recommended)? ' answer
	if [ "$answer" != "do it!" ]; then
		exit
	fi
fi

# Installs the specified package with DNF
install_package() {
	echo "You need the $1 package."
	read -n 1 -p "Do you want to install the $1 package now? [y/N]" answer
	echo
	case "$answer" in
		y|Y)
			sudo -p "Enter your password to install $1: " dnf install "$1"
			if [ $? -ne 0 ]; then
				echo "The required package $1 wasn't installed. Exiting now."
				exit 1
			fi
			;;
		*) 
			echo "Ok, I won't install this package."
			exit 1
	esac
}

# Ensures that at least one of the specified packages is installed.
ensure_available_or() {
	for arg in "$@"; do
		rpm -q "$arg" >/dev/null 2>&1
		if [ $? -eq 0 ]; then
			return 0
		fi
	done
	install_package "$1"
}

# Ensures that all the specified packages are installed.
ensure_available_and() {
	for arg in "$@"; do
		rpm -q "$arg" >/dev/null 2>&1
		if [ $? -ne 0 ]; then
			install_package "$arg"
		fi
	done
}

# Downloads the libimobiledevice tar.gz archive
download_lib() {
	echo 'Downloading the source code of libimobiledevice...'
	wget -q --show-progress -O "$archive_file" 'https://github.com/libimobiledevice/libimobiledevice/archive/master.tar.gz'
}

# Asks the user if they want to remove the specified directory, and removes it if they want to.
ask_remove_dir() {
	read -n 1 -p "Do you want to remove the \"$1\" directory? [y/N]" answer
	echo
	case "$answer" in
		y|Y)
			rm -r "$1"
			echo "\"$1\" directory removed."		
			;;
		*)
			echo "Ok, I won't remove it."
	esac
}

# If the specified directory exists, asks the user if they want to remove it.
# If it doesn't exist, creates it.
manage_dir() {
	if [ -d "$1" ]; then
		echo "The $2 directory already exist. It may contain outdated things."
		ask_remove_dir "$1"
	fi
	mkdir -p "$1"
}

echo 'Checking requirements...'
ensure_available_and 'rpmdevtools' 'usbmuxd' 'libtool' 'automake' 'autoconf' 'make'\
	'gcc' 'pkgconfig' 'python-devel' 'libusbmuxd-devel' 'libplist-devel'\
	'python2-Cython' 'libplist-python'
ensure_available_or 'openssl-devel' 'gnutls-devel'
echo 'Requirements OK!'

manage_dir "$work_dir" 'work'
manage_dir "$rpm_dir" 'RPMs'
manage_dir "$source_dir" 'sources'

# Downloads the source in a tar.gz file
if [ -f "$archive_file" ]; then
	echo "Found $archive_file"
	read -n 1 -p 'Do you want to use this archive instead of downloading a new one? [y/N]' answer
	echo
	case "$answer" in
		y|Y)
			echo 'Ok, I will use this archive.'
			;;
		*)
			rm "$archive_file"
			download_lib
	esac
else
	download_lib
fi

# Gets the last modification date of libimobiledevice to determine the package's version
echo 'Analysing the files...'
tar -xzf "$archive_file" -C "$work_dir"
modif_date=$(date -r "$work_dir/libimobiledevice-master/README" +%Y.%m.%d)
echo "The last modification of libimobiledevice was on $modif_date"

# Chooses the spec file based on the system's architecture and build the packages
echo 'Building RPM packages...'
arch=$(uname -m)
spec_file="libimobiledevice_$arch.spec"
rpmbuild -bb --quiet "$spec_file" --define "_topdir $work_dir" --define "_rpmdir $rpm_dir"\
	--define "release_number $modif_date"

# Checks if there is an error
if [ $? -ne 0 ]; then
	echo '-----------'
	echo 'Error!'
	echo "Exit status: $?"
	echo 'It seems like something went wrong :('
else
	echo '-----------'
	echo 'Done!'
	echo "The RPMs files are located in the \"RPMs/$arch\" folder."
fi

# Removes directories if the user wants to
ask_remove_dir "$work_dir"
ask_remove_dir "$source_dir"
