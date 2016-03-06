mkdir build
mkdir build\bin
mkdir build\include
mkdir build\lib

set CC=cl /D_USING_V140_SDK71_
set INCLUDE=..\build\include;$(DXSDK_DIR)Include;%INCLUDE%
set LIB=..\build\lib;$(DXSDK_DIR)Lib\x86;%LIB%

REM http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz
cd bzip2*
nmake /E -f makefile.msc
copy /Y bzlib.h ..\build\include\bzlib.h
copy /Y bzlib_private.h ..\build\include\bzlib_private.h
copy /Y libbz2.lib ..\build\lib\bz2.lib
cd ..

REM http://zlib.net/zlib-1.2.8.tar.gz
cd zlib*
mkdir build
cd build
cmake -G "Visual Studio 14 2015" -T v140_xp ..
cmake --build . --config Release
cd ..
copy /Y build\Release\zlibstatic.lib ..\build\lib\zlib.lib
copy /Y build\zconf.h ..\build\include\
copy /Y zlib.h ..\build\include\
cd ..

REM http://www.ijg.org/files/jpegsrc.v6b.tar.gz
cd jpeg*
copy /Y jconfig.vc jconfig.h
nmake /E -f jpeg.mak
copy /Y Release\jpeg.lib ..\build\lib\
powershell -Command "& { cat jmorecfg.h | %{$_ -replace \"typedef long INT32;", \"\"} | Set-Content -Path jmorecfg.h.patched }"
move /Y jmorecfg.h.patched jmorecfg.h
copy /Y *.h ..\build\include\
cd ..

REM ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.21.tar.gz
cd lpng*
mkdir build
cd build
cmake -G "Visual Studio 14 2015" -T v140_xp -DZLIB_LIBRARY=..\..\build\lib\zlib.lib -DZLIB_INCLUDE_DIR=..\..\build\include\ ..
cmake --build . --config Release
cd ..
copy /Y build\Release\libpng*_static.lib ..\build\lib\libpng.lib
copy /Y build\pnglibconf.h ..\build\include\
copy /Y png*.h ..\build\include\
cd ..

REM http://downloads.sourceforge.net/project/libmng/libmng-devel/1.0.10/libmng-1.0.10.tar.gz?use_mirror=freefr
cd libmng*
powershell -Command "& { cat makefiles/makefile.vcwin32 | %{$_ -replace \"0\", \"O\"} | Set-Content -Path makefiles/makefile.vcwin32.patched }"
move /Y makefiles\makefile.vcwin32.patched makefiles\makefile.vcwin32
nmake /E -f makefiles/makefile.vcwin32
copy /Y libmng.lib ..\build\lib\mng.lib
copy /Y libmng*.h ..\build\include\
cd ..

REM http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
cd libogg*
msbuild /p:Configuration=Release /p:PlatformToolset=v140_xp win32\VS2010\libogg_static.sln
copy /Y win32\VS2010\Win32\Release\libogg_static.lib ..\build\lib\ogg_static.lib
mkdir ..\build\include\ogg
copy /Y include\ogg\*.h ..\build\include\ogg\
cd ..

REM http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.gz
cd libvorbis*
move ..\libogg* ..\libogg
msbuild /p:Configuration=Release /p:PlatformToolset=v140_xp win32\VS2010\vorbis_static.sln
copy /Y win32\VS2010\Win32\Release\libvorbis_static.lib ..\build\lib\vorbis_static.lib
copy /Y win32\VS2010\Win32\Release\libvorbisfile_static.lib ..\build\lib\vorbisfile_static.lib
mkdir ..\build\include\vorbis
copy /Y include\vorbis\*.h ..\build\include\vorbis\
cd ..

REM http://downloads.xiph.org/releases/theora/libtheora-1.1.1.zip
cd libtheora*
move ..\libvorbis* ..\libvorbis
msbuild /p:Configuration=Release_SSE2 /p:PlatformToolset=v140_xp win32\VS2008\libtheora_static.sln /t:libtheora_static
copy /Y win32\VS2008\Win32\Release_SSE2\libtheora_static.lib ..\build\lib\theora_static.lib
mkdir ..\build\include\theora
copy /Y include\theora\*.h ..\build\include\theora\
cd ..

REM http://www.lua.org/ftp/lua-5.1.5.tar.gz
cd lua5.1
msbuild /p:Configuration=Release /p:PlatformToolset=v140_xp mak.vs2008\lua5.1.sln
copy /Y lib\static\lua5.1.lib ..\build\lib\lua.lib
copy /Y include\* ..\build\include\
cd ..

REM https://github.com/LuaDist/toluapp/archive/master.zip
cd toluapp*
mkdir build
powershell -Command "& { cat CMakeLists.txt | %{$_ -replace [Regex]::Escape(\"add_library ( toluapp_lib \"), \"add_library ( toluapp_lib STATIC \"} | Set-Content -Path CMakeLists.txt.patched }"
move /Y CMakeLists.txt.patched CMakeLists.txt
cd build
cmake -G "Visual Studio 14 2015" -T v140_xp -DCMAKE_PREFIX_PATH=..\build ..
cmake --build . --config Release
cd ..
copy /Y build\Release\toluapp.exe ..\build\bin\
copy /Y build\Release\toluapp.lib ..\build\lib\
copy /Y include\*.h ..\build\include\
cd ..

REM https://github.com/ladislav-zezula/StormLib/archive/master.zip
cd StormLib*
mkdir build
cd build
cmake -G "Visual Studio 14 2015" -T v140_xp -DCMAKE_PREFIX_PATH=..\build -DWITH_STATIC=ON ..
cmake --build . --config Release
cd ..
copy /Y build\Release\storm.lib ..\build\lib\
copy /Y src\*.h ..\build\include\
cd ..

REM https://www.libsdl.org/release/SDL-1.2.15.tar.gz
cd SDL*
powershell -Command "& { cat VisualC\SDL\SDL.vcxproj | %{$_ -replace \"dxguid.lib;\", \"\"} | Set-Content -Path VisualC\SDL\SDL.vcxproj.patched }"
move /Y VisualC\SDL\SDL.vcxproj.patched VisualC\SDL\SDL.vcxproj
powershell -Command "& { cat VisualC\SDL\SDL.vcproj | %{$_ -replace \"dxguid.lib\", \"\"} | Set-Content -Path VisualC\SDL\SDL.vcproj.patched }"
move /Y VisualC\SDL\SDL.vcproj.patched VisualC\SDL\SDL.vcproj
powershell -Command "& { cat VisualC\SDLmain\SDLmain.vcxproj | %{$_ -replace \"dxguid.lib;\", \"\"} | Set-Content -Path VisualC\SDLmain\SDLmain.vcxproj.patched }"
move /Y VisualC\SDLmain\SDLmain.vcxproj.patched VisualC\SDLmain\SDLmain.vcxproj
powershell -Command "& { cat VisualC\SDLmain\SDLmain.vcproj | %{$_ -replace \"dxguid.lib\", \"\"} | Set-Content -Path VisualC\SDLmain\SDLmain.vcproj.patched }"
move /Y VisualC\SDLmain\SDLmain.vcproj.patched VisualC\SDLmain\SDLmain.vcproj
powershell -Command "& { cat src\video\windx5\directx.h | %{$_ -replace \"#define _directx_h\", \"#define _directx_h`n#include `\"InitGuid.h`\"\"} | Set-Content -Path src\video\windx5\directx.h.patched }"
move /Y src\video\windx5\directx.h.patched src\video\windx5\directx.h
msbuild /p:Configuration=Release_NoSTDIO /p:PlatformToolset=v140_xp VisualC\SDL.sln
copy /Y VisualC\SDL\Release\SDL.dll ..\build\bin\
copy /Y VisualC\SDL\Release\SDL.dll ..\build\lib\
copy /Y VisualC\Release\SDL.lib ..\build\lib\
copy /Y VisualC\SDLmain\Release_NOSTDIO\SDLmain.lib ..\build\lib\
copy /Y include\*.h ..\build\include\
copy /Y VisualC\SDL\*.h ..\build\include\
cd ..

REM https://sourceforge.net/projects/fluidsynth/files/fluidsynth-1.1.6/fluidsynth-1.1.6.tar.gz/download
cd fluidsynth*
mkdir build
cd build
cmake -G "Visual Studio 14 2015" -T v140_xp -DCMAKE_PREFIX_PATH=..\fluidsynth-deps ..
powershell -Command "& { cat config_win32.h | %{$_ -replace \"#define snprintf _snprintf\", \"\"} | Set-Content -Path config_win32.h.patched }"
move /Y config_win32.h.patched config_win32.h
cmake --build . --config Release
cd ..
mkdir ..\build\include\fluidsynth
copy /Y include\fluidsynth\*.h ..\build\include\fluidsynth\
copy /Y include\fluidsynth.h ..\build\include\
copy /Y build\include\fluidsynth\*.h ..\build\include\fluidsynth\
copy /Y build\src\Release\fluidsynth.lib ..\build\lib\
copy /Y build\src\Release\libfluidsynth.dll ..\build\lib\
copy /Y build\src\Release\libfluidsynth.dll ..\build\bin\
copy /Y ..\fluidsynth-deps\bin\libglib*.dll ..\build\bin\
copy /Y ..\fluidsynth-deps\bin\libgthread*.dll ..\build\bin\
cd ..
