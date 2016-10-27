Name:		libimobiledevice
Version:	1.2.1
Release:	git.head%{?dist}
Summary:	Library for connecting to iOS devices.

Group:		System Environment/Libraries
License:	LGPLv2+
URL:		https://github.com/libimobiledevice/libimobiledevice
Source0:	libimobiledevice.tar.gz
# local source file (must be downloaded manually)
BuildArch:	x86_64

BuildRequires:	python-devel openssl-devel libplist-devel libusbmuxd-devel
Requires:	openssl libplist libusbmuxd libgcrypt glibc

%description
Library to communicate with iOS devices.
This package has been build from github source by Guillaume R. Inspired from the libimobiledevice.spec of v1.2.0 for fedora.

## devel subpackage
%package devel
Summary:	Development package of libimobiledevice
Group:		Development/Libraries
Requires:	%{name}%{?_isa} = %{version}-%{release}

%description devel
The %{name}-devel package contains the files needed for development with %{name}.

## utils subpackage
%package utils
Summary:	Utilites for libimobiledevice
Group: 		Applications/System
Requires: 	%{name}%{?_isa} = %{version}-%{release}

%description utils
Command utilities for libimobiledevice.

## preparation
%prep
%autosetup -n libimobiledevice-master

## build
%build
./autogen.sh
%configure --disable-static
%make_build

## installation
%install
export "QA_RPATHS=\$[0x0002]"
# ignore errors 0x0002 (or else the install might fails).

rm -rf $RPM_BUILD_ROOT
%make_install
find $RPM_BUILD_ROOT -name '*.la' -exec rm -f {} ';'

## post actions
%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

## files included in the basic "libimobiledevice" package
%files
%license COPYING.LESSER
%doc AUTHORS README
%{_libdir}/*.so.*

##files included in the "libimobiledevice-utils" package
%files utils
%doc %{_mandir}/*
%{_bindir}/*

## files included in the "libimobiledevice-devel" package
%files devel
%{_includedir}/*
%{_libdir}/*
