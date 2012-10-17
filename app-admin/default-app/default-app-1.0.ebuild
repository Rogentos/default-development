# Copyright 2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3" #EAPI, read docs for this. natural we use 3

inherit eutils #Object-oriented packaging, inherit classes with functions that will follow

DESCRIPTION="Example X"
HOMEPAGE="http://gentoo.org/"
SRC_URI="http://whatever-you-want-to-download-from1/default-app.tar.gz
	http://whatever-you-want-to-download-from2/default-app.tar.gz"

LICENSE="GPL-2"
SLOT="0" #How many times do you want this package to exist/to be installed, to coexist in different versions
KEYWORDS="~* ~amd64 ~x86" #Every architecture you like
IUSE="config1 -config2 config3" #Configure flags, also known as ./configure --features --enable/disable features to be used

RDEPEND="" #runtime deps
DEPEND="" #build deps
YDEPEND="" #Your deps, if you want to handle your own dep-control

S="${WORKDIR}" #optional. declare S from the working sandbox folder

src_prepare() { #unpacked files in the sandbox can be easily modified before all instalation process in this way
	epatch "${FILESDIR}/example1.patch" || die #Adding patch from filesdir directory
	sed -i 's/Whatever1/Whatever2/g' example.file || die #Some sed function before the compilation of the package begins
}

src_install() { #while compilation
	if use config1 ; then #if USE="config1" emerge package, do this
		dodir /var/tmp/test1 || die #Creates directory
		insinto /var/tmp/test1 || die #cd into created directory
		doins example.file || die #from within the sandboxed unpacked in the src_prepare, copy the file into our future installed-within directory
	fi

	if ! use config2 ; then #if not USE="-config2" emerge package, do this
		sed -i 's/Whatever3/Whatever3/g' "${S}"/example.file || die #Sed again, but this time while install/compile
		doins "${S}"/creation.sh /var/tmp || die #Do the same thing, but from one dir to another
	fi
}

#src_postinst() {
	#some post install function here, read doc for all the classes used
#}
