# This is a shell script that calls functions and scripts from
# tml@iki.fi's personal work environment. It is not expected to be
# usable unmodified by others, and is included only for reference.

MOD=glib
VER=2.24.0
REV=2
ARCH=win32

THIS=${MOD}_${VER}-${REV}_${ARCH}

RUNZIP=${MOD}_${VER}-${REV}_${ARCH}.zip
DEVZIP=${MOD}-dev_${VER}-${REV}_${ARCH}.zip

HEX=`echo $THIS | md5sum | cut -d' ' -f1`
TARGET=c:/devel/target/$HEX

usedev
usemsvs6

(

set -x

DEPS=`latest --arch=${ARCH} gettext-runtime gettext-tools glib pkg-config`
PROXY_LIBINTL=`latest --arch=${ARCH} proxy-libintl`
ZLIB=`latest --arch=${ARCH} zlib`

PKG_CONFIG_PATH=/dummy
for D in $DEPS; do
    PATH=/devel/dist/${ARCH}/$D/bin:$PATH
    [ -d /devel/dist/${ARCH}/$D/lib/pkgconfig ] && PKG_CONFIG_PATH=/devel/dist/${ARCH}/$D/lib/pkgconfig:$PKG_CONFIG_PATH
done

patch -p1 <<EOF
commit 70a4217ba35492cd8e3549ca8da3fcc950421790
Author: Tor Lillqvist <tml@iki.fi>
Date:   Tue Mar 30 19:39:19 2010 +0300

    Clarify _g_stat_struct mess
    
    Use "struct stat" instead of "struct _stat" in the MinGW-or-64-bit
    case. Should fix bug #614372.

diff --git a/glib/gstdio.c b/glib/gstdio.c
index 542a95e..5e33c50 100644
--- a/glib/gstdio.c
+++ b/glib/gstdio.c
@@ -473,7 +473,7 @@ g_stat (const gchar           *filename,
       (!g_path_is_absolute (filename) || len > g_path_skip_root (filename) - filename))
     wfilename[len] = '\0';
 
-  retval = _wstat (wfilename, buf);
+  retval = _wstat (wfilename, (void*) buf);
   save_errno = errno;
 
   g_free (wfilename);
diff --git a/glib/gstdio.h b/glib/gstdio.h
index b61bc6b..501186b 100644
--- a/glib/gstdio.h
+++ b/glib/gstdio.h
@@ -110,7 +110,7 @@ int g_chdir     (const gchar *path);
 
 #else
 
-#define _g_stat_struct _stat
+#define _g_stat_struct stat
 
 #endif
 
EOF

lt_cv_deplibs_check_method='pass_all' \
CC='gcc -mtune=pentium3 -mthreads' \
CPPFLAGS="-I/devel/dist/${ARCH}/${PROXY_LIBINTL}/include \
-I/devel/dist/${ARCH}/${ZLIB}/include" \
LDFLAGS="-L/devel/dist/${ARCH}/${PROXY_LIBINTL}/lib -Wl,--exclude-libs=libintl.a -Wl,--enable-auto-image-base \
-L/devel/dist/${ARCH}/${ZLIB}/lib" \
CFLAGS=-O2 \
./configure \
--enable-silent-rules \
--disable-gtk-doc \
--prefix=$TARGET &&

make glibconfig.h.win32 &&
make glibconfig.h &&
mv glibconfig.h glibconfig.h.autogened &&
cp glibconfig.h.win32 glibconfig.h &&
PATH="/devel/target/$HEX/bin:$PATH" make -j3 install &&

./glib-zip &&

mv /tmp/glib-$VER.zip /tmp/$RUNZIP &&
mv /tmp/glib-dev-$VER.zip /tmp/$DEVZIP

) 2>&1 | tee /devel/src/tml/packaging/$THIS.log

(cd /devel && zip /tmp/$DEVZIP src/tml/packaging/$THIS.{sh,log}) &&
manifestify /tmp/$RUNZIP /tmp/$DEVZIP
