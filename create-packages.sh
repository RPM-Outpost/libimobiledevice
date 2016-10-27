#!/bin/sh
# Author: TheElectronWill
# This script downloads the latest source code of libimobiledevice, from github, and creates RPM packages.
# The build architecture is chosen automatically.

# Directories
work_dir=$PWD/work
source_dir=$work_dir/SOURCES
rpm_dir=$PWD/RPMs

# Checks that rpmbuild is installed
if ! type 'rpmbuild' > /dev/null
then
	echo "You need the rpm development tools to create rpm packages"
	read -p "Do you want to install rpmdevtools now? This will run sudo dnf install rpmdevtools. [y/N]" answer
	case $answer in
		[Yy]* ) sudo dnf install rpmdevtools;;
		* ) 
			echo "Ok, I won't install rpmdevtools."
			exit
		;;
	esac
else
	echo "rpmbuild detected!"
fi

# Downloads the source in a tar.gz file
echo 'Downloading the source code of libimobiledevice...'
mkdir -p $source_dir
wget -q --show-progress -O "$source_dir/libimobiledevice.tar.gz" https://github.com/libimobiledevice/libimobiledevice/archive/master.tar.gz

echo 'Building RPM packages...'
# Chooses the spec file based on the system's architecture
arch=$(uname -m)
spec_file="libimobiledevice_$arch.spec"

# Creates rpm packages
rpmbuild -bb --quiet $spec_file --define "_topdir $work_dir" --define "_rpmdir $rpm_dir" --define "release_number $modif_date"

# If error
if [ $? -ne 0 ]
then
	lib_install='sudo dnf install python-devel openssl-devel libplist-devel libusbmuxd-devel openssl libplist libusbmuxd libgcrypt glibc'
	echo '-----------'
	echo 'Error!'
	read -p "Do you want to install the required libraries to try to fix the error? [y/N]" answer
	case $answer in
		[Yy]* ) 
			echo "This will run $lib_install"
			$lib_install
			echo "Packages installed. Retrying to build the RPM packages..."
			rpmbuild -bb --quiet $spec_file --define "_topdir $work_dir" --define "_rpmdir $rpm_dir"
			if [ $? -ne 0 ] # Still an error!
			then
				echo '-----------'
				echo 'Still an error?!'
				echo "Sorry. You'll have to figure out what the problem is without my automatic help."
				exit
			fi
			;;
		* ) echo 
			"Ok, I won't install the libraries." 
			exit
			;;
	esac
fi

# Done without error
echo '-----------'
echo 'Done!'
echo "The RPMs files are located in the \"RPMs/$arch\" folder."

# Removes the work directory if the user wants to
read -p "Do you want to remove the work directory? [y/N]" answer
case $answer in
	[Yy]* )
		rm -r $work_dir
		echo "Work directory removed."		
		;;
	* ) echo "Ok, I won't remove it." ;;
esac
