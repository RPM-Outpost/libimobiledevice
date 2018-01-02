#!/bin/bash
# Author: TheElectronWill
# This script downloads the latest source code of libimobiledevice, from github, and creates RPM packages.
# The build architecture is chosen automatically.

source terminal-colors.sh # Adds color variables
source common-functions.sh # Adds utilities functions
source basic-checks.sh # Checks that rpmbuild is available and that the script isn't started as root

# Defines the needed paths
rpm_dir=$PWD/RPMs
work_dir=$PWD/work
source_dir=$work_dir/SOURCES

archive_name='libimobiledevice.tar.gz'
archive_file="$source_dir/$archive_name"

# Installs the specified package with DNF
install_package() {
	echo "You need the $1 package."
	ask_yesno "Install the $1 package now?"
	case "$answer" in
		y|Y)
			sudo -p "Enter your password to install $1: " dnf install "$1"
			if [ $? -ne 0 ]; then
				echo "The required package $1 wasn't installed. Exiting now."
				exit 1
			fi
			;;
		*) 
			echo "The package won't be installed. Exiting now."
			exit 1
	esac
}

# Ensures that at least one of the specified packages is installed.
ensure_available_or() {
	set +e
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
	set +e
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

echo 'Checking requirements...'
ensure_available_and 'rpmdevtools' 'usbmuxd' 'libtool' 'automake' 'autoconf' 'make'\
	'gcc' 'pkgconf-pkg-config' 'python2-devel' 'libusbmuxd-devel' 'libplist-devel'\
	'python2-Cython' 'libplist-python'
ensure_available_or 'openssl-devel' 'gnutls-devel'
echo 'Requirements OK!'

manage_dir "$work_dir" 'work'
manage_dir "$rpm_dir" 'RPMs'
manage_dir "$source_dir" 'sources'

# Downloads the source in a tar.gz file
if [ -f "$archive_file" ]; then
	echo "Found the archive \"$archive_name\"."
	ask_yesno 'Do you want to use this archive instead of downloading a new one?' answer
	case "$answer" in
		y|Y)
			echo 'Existing archive selected.'
			;;
		*)
			rm "$archive_file"
			download_lib
	esac
else
	download_lib
fi

# Extracts the files:
extract "$archive_file" "$work_dir"

# Gets the last modification date of libimobiledevice to determine the package's version
echo 'Analysing the files...'
modif_date=$(date -r "$work_dir/libimobiledevice-master/README" +%Y.%m.%d)
disp "${green}The last modification of libimobiledevice was on $modif_date"
style $reset

# Chooses the spec file based on the system's architecture and builds the packages
set -e
disp "${yellow}Creating the RPM packages (this may take a while)..."
arch=$(uname -m)
spec_file="libimobiledevice_$arch.spec"
rpmbuild -bb --quiet "$spec_file" --define "_topdir $work_dir" --define "_rpmdir $rpm_dir"\
	--define "release_number $modif_date"

disp "${bgreen}Done!${reset_font}"
disp "The RPM package is located in the \"RPMs/$arch\" folder."
disp '----------------'

ask_remove_dir "$work_dir"
ask_installpkg "all"
