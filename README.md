## Libimobiledevice
To communicate with iOS devices, there exists a great library: [libimobiledevice](https://github.com/libimobiledevice/libimobiledevice).
Unfortunately, the latest official release is a bit old and doesn't support the most recent versions of iOS.
The upstream version is much better, but it isn't easily available in Linux distros (because it's not a release).

## This repository
This repository provides some tools to build RPM packages of the latest libimobiledevice.
The script [create-packages.sh](https://github.com/TheElectronWill/libimobiledevice-rpm/blob/master/create-packages.sh) automatically downloads the latest source from github and creates ready-to-use RPM packages for your system.

## What package(s) do I need?
| Package's name | Description |
| -------------- | ----------- |
| libimobiledevice | Main package. Provides the core library. Allows the nautilus file browser to connect to your iOS device.
| libimobiledevice-debuginfo | Useful only for debugging libimobiledevice. |
| libimobiledevice-devel | Development package. Useful to develop applications that use libimobiledevice. |
| libimobiledevice-utils | Utilities package. Provides a lot of command-line tools to interact with iOS devices |

## How do I update to the latest upstream version?
When a new commit is pushed to the libimobiledevice's repository, you just you have to run the `create-packages.sh` again, and to install the RPM packages normally (ie with `sudo dnf install <rpm file>`).
This will update any old libimobiledevice's package.

## Supported distributions
- Fedora 24
- Fedora 25
It probably work on other RPM-based distros but I haven't tested it. Let me know if it works for you!
