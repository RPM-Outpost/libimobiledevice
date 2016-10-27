## Libimobiledevice
To communicate with iOS devices, there exists a great library: [libimobiledevice](https://github.com/libimobiledevice/libimobiledevice). Unfortunately, the latest official release is a bit old and doesn't support the most recent versions of iOS. The upstream version is much better, but it isn't easily available in Linux distros (because it's not a release).

## This repository
This repository provides some tools to build RPM packages of the latest libimobiledevice. The script `create-packages.sh` automatically downloads the latest source from github and creates ready-to-use RPM packages.  

You'll also find 64 bits RPM packages in the [folder RPMs/x86_64](https://github.com/TheElectronWill/libimobiledevice-rpm/tree/master/RPMs/x86_64). Download them, install them and restart your computer to enjoy using your iOS 10 Device with your distro!

## What package(s) do I need?
| Package's name | Description |
| -------------- | ----------- |
| libimobiledevice-1.2.1-git.head | Main package. Provides the core library. Allows the nautilus file browser to connect to your iOS device.
| libimobiledevice-debuginfo-1.2.1-git.head | Useful only for debugging libimobiledevice. |
| libimobiledevice-devel-1.2.1-git.head | Development package. Useful to develop applications that use libimobiledevice. |
| libimobiledevice-utils-1.2.1-git.head | Utilities package. Provides a lot of command-line tools to interact with iOS devices |

## How do I update to the latest upstream version?
When a new commit is pushed to the libimobiledevice's repository, all you have to do is to run `create-packages.sh` again, and to install the RPM packages normally (ie with `sudo dnf install package-name.rpm`). This will update any old libimobiledevice's package.

## Supported distributions
For now, only Fedora 24 is supported. But it might work on other RPM-based distros. Let me know if it works for you!
