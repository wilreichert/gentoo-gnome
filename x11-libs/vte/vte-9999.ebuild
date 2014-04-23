# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $

EAPI="5"
GCONF_DEBUG="yes"

inherit eutils gnome3

DESCRIPTION="Library providing a virtual terminal emulator widget"
HOMEPAGE="https://wiki.gnome.org/action/show/Apps/Terminal/VTE"

LICENSE="LGPL-2+"
SLOT="2.90"
IUSE="debug glade +introspection"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~x64-solaris ~x86-solaris"

PDEPEND="=x11-libs/gnome-pty-helper-${PV}"
RDEPEND="
	>=dev-libs/glib-2.31.13:2
	>=x11-libs/gtk+-3.1.9:3[introspection?]
	>=x11-libs/pango-1.22.0

	sys-libs/ncurses
	x11-libs/libX11
	x11-libs/libXft

	glade? ( >=dev-util/glade-3.9:3.10 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.0 )
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig
"

# https://bugzilla.gnome.org/show_bug.cgi?id=663779
PATCHES=( "${FILESDIR}/${PN}-0.30.1-alt-meta.patch" )
DOCS=( "AUTHORS" "ChangeLog" "HACKING" "NEWS" "README" )
src_prepare() {


	gnome3_src_prepare
}

src_configure() {
	if [[ ${CHOST} == *-interix* ]]; then
		local myeconfargs=( "--disable-Bsymbolic" )

		# interix stropts.h is empty...
		export ac_cv_header_stropts_h=no
	fi

	# Python bindings are via gobject-introspection
	# Ex: from gi.repository import Vte
	# Do not disable gnome-pty-helper, bug #401389
	gnome3_src_configure \
		--disable-deprecation \
		--disable-static \
		$(use_enable debug) \
		$(use_enable glade glade-catalogue) \
		$(use_enable introspection)
}

src_install() {
	gnome3_src_install
	rm -v "${ED}usr/libexec/gnome-pty-helper" || die
}