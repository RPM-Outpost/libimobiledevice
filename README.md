# RPM Package for libimobiledevice
To communicate with iOS devices, there exists a great library: [libimobiledevice](https://github.com/libimobiledevice/libimobiledevice).
Unfortunately, the latest official release is a bit old and doesn't support the most recent versions of iOS.
The upstream version is much better, but it isn't easily available in Linux distros (because it's not a release).
That's why I've made a little script that downloads, builds and makes an RPM package of libimobiledevice!

## How to use
1. Run the [create-package.sh](https://github.com/RPM-Outpost/libimobiledevice-rpm/blob/master/create-package.sh) script from the command line. It will download the latest version of libimobiledevice and build several RPM packages.
2. Then, install the packages you want with `sudo dnf install <rpm files>`.

### Requirements
You need the following packages to make the script work:
rpmdevtools, usbmuxd, libtool, automake, autoconf, make, gcc, pkgconfig,
python-devel, libusbmuxd-devel, libplist-devel, python2-Cython, libplist-python,
openssl-devel (or gnutls-devel)  

Don't worry: the script detects any missing requirement and can install it for you.

### About root privileges
Building an RPM package with root privileges is **dangerous**, because a mistake in SPEC file could result in running nasty commands.
See http://serverfault.com/questions/10027/why-is-it-bad-to-build-rpms-as-root.

## What package(s) do I need?
| Package's name | Description |
| -------------- | ----------- |
| libimobiledevice | Main package. Provides the core library. Allows the nautilus file browser to connect to your iOS device.
| libimobiledevice-debuginfo | Useful only for debugging libimobiledevice. |
| libimobiledevice-devel | Development package. Useful to develop applications that use libimobiledevice. |
| libimobiledevice-utils | Utilities package. Provides a lot of command-line tools to interact with iOS devices |

## How do I update to the latest upstream version?
When a new commit is pushed to the libimobiledevice's repository, you just you have to run the `create-packages.sh` again, and to install the RPM packages normally (ie with `sudo dnf install <rpm files>`).
This will update any old libimobiledevice's package.

## Supported distributions
- Fedora 26

It probably work on other RPM-based distros but I haven't tested it. Let me know if it works for you!
