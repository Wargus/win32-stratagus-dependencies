cmake_minimum_required(VERSION 3.10)
project(win32_stratagus_dependencies)

include(ExternalProject)

set(ENV{ExternalCompilerOptions} "/DWINVER=0x0601 /D_WIN32_WINNT=0x0601")

ExternalProject_Add(
  bzip2
  PREFIX bzip2
  GIT_REPOSITORY https://gitlab.com/bzip2/bzip2.git
  CMAKE_ARGS -DCMAKE_SYSTEM_VERSION=8.1
             -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/contrib
			 -DENABLE_STATIC_LIB=ON
			 -DENABLE_SHARED_LIB=OFF
			 -DENABLE_APP=OFF
			 -DENABLE_DOCS=OFF
			 -DENABLE_EXAMPLES=OFF
			 )

ExternalProject_Add(
  zlib
  PREFIX zlib
  DOWNLOAD_DIR "${CMAKE_BINARY_DIR}/zlib"
  URL https://www.zlib.net/zlib-1.2.11.tar.gz
  BUILD_IN_SOURCE 1
  URL-HASH
  SHA256=c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1
  CMAKE_ARGS -DCMAKE_SYSTEM_VERSION=8.1
             -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/contrib
			 -DSKIP_INSTALL_FILES=ON)
			 
ExternalProject_Add(
  png
  PREFIX png
  DOWNLOAD_DIR "${CMAKE_BINARY_DIR}/png"
  URL http://prdownloads.sourceforge.net/libpng/lpng1637.zip?download
  BUILD_IN_SOURCE 1
  CMAKE_ARGS -DCMAKE_SYSTEM_VERSION=8.1
             -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/contrib
			 -DSKIP_INSTALL_FILES=ON
			 -DPNG_STATIC=ON
  DEPENDS zlib)
  
ExternalProject_Add(
  jpeg
  PREFIX jpeg
  GIT_REPOSITORY https://github.com/mozilla/mozjpeg.git
  GIT_TAG v4.0.3
  CMAKE_ARGS -DCMAKE_SYSTEM_VERSION=8.1
             -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/contrib
             -DCMAKE_PREFIX_PATH=${CMAKE_BINARY_DIR}/contrib
  DEPENDS zlib png)


  
  ExternalProject_Add(mng
  PREFIX mng
  DOWNLOAD_DIR "${CMAKE_BINARY_DIR}/mng"
  URL https://downloads.sourceforge.net/libmng/libmng-2.0.3.tar.xz
  BUILD_IN_SOURCE 1
  CMAKE_ARGS -DCMAKE_SYSTEM_VERSION=8.1
             -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/contrib
             -DCMAKE_PREFIX_PATH=${CMAKE_BINARY_DIR}/contrib
  DEPENDS zlib jpeg
  )

ExternalProject_Add(
  ogg
  PREFIX ogg
  GIT_REPOSITORY https://github.com/xiph/ogg.git
  GIT_TAG v1.3.5
  CMAKE_ARGS -DCMAKE_SYSTEM_VERSION=8.1
             -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/contrib
             -DCMAKE_PREFIX_PATH=${CMAKE_BINARY_DIR}/contrib
			 -DINSTALL_DOCS=OFF
			 -DINSTALL_PKG_CONFIG_MODULE=OFF
			 )
			 
			 

ExternalProject_Add(
  vorbis
  PREFIX vorbis
  GIT_REPOSITORY https://github.com/xiph/vorbis.git
  GIT_TAG v1.3.7
  CMAKE_ARGS -DCMAKE_SYSTEM_VERSION=8.1
             -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/contrib
             -DCMAKE_PREFIX_PATH=${CMAKE_BINARY_DIR}/contrib
	)

ExternalProject_Add(
  theora
  PREFIX theora
  GIT_REPOSITORY https://github.com/abenedic/theora.git
  GIT_TAG feature/cmake
  CMAKE_ARGS -DCMAKE_SYSTEM_VERSION=8.1
             -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/contrib
             -DCMAKE_PREFIX_PATH=${CMAKE_BINARY_DIR}/contrib
  DEPENDS ogg vorbis
  )



ExternalProject_Add(
  stormlib
  PREFIX stormlib
  GIT_REPOSITORY https://github.com/ladislav-zezula/StormLib.git
  CMAKE_ARGS -DCMAKE_SYSTEM_VERSION=8.1
             -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/contrib
             -DCMAKE_PREFIX_PATH=${CMAKE_BINARY_DIR}/contrib -DWITH_STATIC=ON
  DEPENDS theora
          vorbis
          ogg
          jpeg
          zlib
          png
          bzip2)
		  

ExternalProject_Add(
  lua
  PREFIX lua
  SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/lua-5.1.5/
	CMAKE_ARGS -DCMAKE_SYSTEM_VERSION=8.1
             -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/contrib
             -DCMAKE_PREFIX_PATH=${CMAKE_BINARY_DIR}/contrib
  )