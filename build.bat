ECHO ON

mkdir build || exit /b
mkdir build\bin || exit /b
mkdir build\include || exit /b
mkdir build\lib || exit /b

set CC=cl /D_USING_V140_SDK71_ || exit /b
set INCLUDE=..\build\include;$(DXSDK_DIR)Include;%INCLUDE% || exit /b
set LIB=..\build\lib;$(DXSDK_DIR)Lib\x86;%LIB% || exit /b

REM http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz || exit /b
cd bzip2* || exit /b
nmake /E -f makefile.msc || exit /b
copy /Y bzlib.h ..\build\include\bzlib.h || exit /b
copy /Y bzlib_private.h ..\build\include\bzlib_private.h || exit /b
copy /Y libbz2.lib ..\build\lib\bz2.lib || exit /b
cd .. || exit /b

REM http://zlib.net/zlib-1.2.8.tar.gz || exit /b
cd zlib* || exit /b
mkdir build || exit /b
cd build || exit /b
cmake -G "Visual Studio 14 2015" -T v140_xp .. || exit /b
cmake --build . --config Release || exit /b
cd .. || exit /b
copy /Y build\Release\zlibstatic.lib ..\build\lib\zlib.lib || exit /b
copy /Y build\zconf.h ..\build\include\ || exit /b
copy /Y zlib.h ..\build\include\ || exit /b
cd .. || exit /b

REM http://www.ijg.org/files/jpegsrc.v6b.tar.gz || exit /b
cd jpeg* || exit /b
copy /Y jconfig.vc jconfig.h || exit /b
nmake /E -f jpeg.mak || exit /b
copy /Y Release\jpeg.lib ..\build\lib\ || exit /b
powershell -Command "& { cat jmorecfg.h | %%{$_ -replace \"typedef long INT32;\", \"\"} | Set-Content -Path jmorecfg.h.patched }" || exit /b
move /Y jmorecfg.h.patched jmorecfg.h || exit /b
copy /Y *.h ..\build\include\ || exit /b
cd .. || exit /b

REM ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.21.tar.gz || exit /b
cd libpng* || exit /b
mkdir build || exit /b
cd build || exit /b
cmake -G "Visual Studio 14 2015" -T v140_xp -DZLIB_LIBRARY=..\..\build\lib\zlib.lib -DZLIB_INCLUDE_DIR=..\..\build\include\ .. || exit /b
cmake --build . --config Release || exit /b
cd .. || exit /b
copy /Y build\Release\libpng*_static.lib ..\build\lib\libpng.lib || exit /b
copy /Y build\pnglibconf.h ..\build\include\ || exit /b
copy /Y png*.h ..\build\include\ || exit /b
cd .. || exit /b

REM http://downloads.sourceforge.net/project/libmng/libmng-devel/1.0.10/libmng-1.0.10.tar.gz?use_mirror=freefr || exit /b
cd libmng* || exit /b
powershell -Command "& { cat makefiles/makefile.vcwin32 | %%{$_ -replace \"0\", \"O\"} | Set-Content -Path makefiles/makefile.vcwin32.patched }" || exit /b
move /Y makefiles\makefile.vcwin32.patched makefiles\makefile.vcwin32 || exit /b
nmake /E -f makefiles/makefile.vcwin32 || exit /b
copy /Y libmng.lib ..\build\lib\mng.lib || exit /b
copy /Y libmng*.h ..\build\include\ || exit /b
cd .. || exit /b

REM http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz || exit /b
cd libogg* || exit /b
msbuild /p:Configuration=Release /p:PlatformToolset=v140_xp win32\VS2010\libogg_static.sln || exit /b
copy /Y win32\VS2010\Win32\Release\libogg_static.lib ..\build\lib\ogg_static.lib || exit /b
mkdir ..\build\include\ogg || exit /b
copy /Y include\ogg\*.h ..\build\include\ogg\ || exit /b
cd .. || exit /b

REM http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.gz || exit /b
cd libvorbis* || exit /b
move ..\libogg* ..\libogg || exit /b
msbuild /p:Configuration=Release /p:PlatformToolset=v140_xp win32\VS2010\vorbis_static.sln || exit /b
copy /Y win32\VS2010\Win32\Release\libvorbis_static.lib ..\build\lib\vorbis_static.lib || exit /b
copy /Y win32\VS2010\Win32\Release\libvorbisfile_static.lib ..\build\lib\vorbisfile_static.lib || exit /b
mkdir ..\build\include\vorbis || exit /b
copy /Y include\vorbis\*.h ..\build\include\vorbis\ || exit /b
cd .. || exit /b

REM http://downloads.xiph.org/releases/theora/libtheora-1.1.1.zip || exit /b
cd libtheora* || exit /b
move ..\libvorbis* ..\libvorbis || exit /b
devenv win32\VS2008\libtheora_static.sln /upgrade || exit /b
msbuild /p:Configuration=Release_SSE2 /p:PlatformToolset=v140_xp win32\VS2008\libtheora_static.sln /t:libtheora_static || exit /b
copy /Y win32\VS2008\Win32\Release_SSE2\libtheora_static.lib ..\build\lib\theora_static.lib || exit /b
mkdir ..\build\include\theora || exit /b
copy /Y include\theora\*.h ..\build\include\theora\ || exit /b
cd .. || exit /b

REM cd lua5.1 || exit /b
REM msbuild /p:Configuration=Release /p:PlatformToolset=v140_xp mak.vs2008\lua5.1.sln || exit /b
REM copy /Y lib\static\lua5.1.lib ..\build\lib\lua.lib || exit /b
REM copy /Y include\* ..\build\include\ || exit /b
REM cd .. || exit /b

REM http://www.lua.org/ftp/lua-5.1.5.tar.gz || exit /b
cd lua-5.1.5 || exit /b
powershell -Command "& { cat etc/luavs.bat | %%{$_ -replace \"cl\", \"%CC%\"} | Set-Content -Path etc/luavs-patched.bat }" || exit /b
call etc\luavs-patched.bat
copy /Y src\lua51.lib ..\build\lib\lua.lib || exit /b
copy /Y src\*.h ..\build\include\ || exit /b
cd ..

REM https://github.com/LuaDist/toluapp/archive/master.zip || exit /b
cd toluapp* || exit /b
mkdir build || exit /b
powershell -Command "& { cat CMakeLists.txt | %%{$_ -replace [Regex]::Escape(\"add_library ( toluapp_lib \"), \"add_library ( toluapp_lib STATIC \"} | Set-Content -Path CMakeLists.txt.patched }" || exit /b
move /Y CMakeLists.txt.patched CMakeLists.txt || exit /b
cd build || exit /b
cmake -G "Visual Studio 14 2015" -T v140_xp -DCMAKE_PREFIX_PATH=..\build .. || exit /b
cmake --build . --config Release || exit /b
cd .. || exit /b
copy /Y build\Release\toluapp.exe ..\build\bin\ || exit /b
copy /Y build\Release\toluapp.lib ..\build\lib\ || exit /b
copy /Y include\*.h ..\build\include\ || exit /b
cd .. || exit /b

REM https://github.com/ladislav-zezula/StormLib/archive/master.zip || exit /b
cd StormLib* || exit /b
mkdir build || exit /b
cd build || exit /b
cmake -G "Visual Studio 14 2015" -T v140_xp -DCMAKE_PREFIX_PATH=..\build -DWITH_STATIC=ON .. || exit /b
cmake --build . --config Release || exit /b
cd .. || exit /b
copy /Y build\Release\storm.lib ..\build\lib\ || exit /b
copy /Y src\*.h ..\build\include\ || exit /b
cd .. || exit /b

REM https://www.libsdl.org/release/SDL-1.2.15.tar.gz || exit /b
cd SDL* || exit /b
devenv VisualC\SDL.sln /upgrade || exit /b
powershell -Command "& { cat VisualC\SDL\SDL.vcxproj | %%{$_ -replace \"dxguid.lib;\", \"\"} | Set-Content -Path VisualC\SDL\SDL.vcxproj.patched }" || exit /b
move /Y VisualC\SDL\SDL.vcxproj.patched VisualC\SDL\SDL.vcxproj || exit /b
powershell -Command "& { cat VisualC\SDL\SDL.vcproj | %%{$_ -replace \"dxguid.lib\", \"\"} | Set-Content -Path VisualC\SDL\SDL.vcproj.patched }" || exit /b
move /Y VisualC\SDL\SDL.vcproj.patched VisualC\SDL\SDL.vcproj || exit /b
powershell -Command "& { cat VisualC\SDLmain\SDLmain.vcxproj | %%{$_ -replace \"dxguid.lib;\", \"\"} | Set-Content -Path VisualC\SDLmain\SDLmain.vcxproj.patched }" || exit /b
move /Y VisualC\SDLmain\SDLmain.vcxproj.patched VisualC\SDLmain\SDLmain.vcxproj || exit /b
powershell -Command "& { cat VisualC\SDLmain\SDLmain.vcproj | %%{$_ -replace \"dxguid.lib\", \"\"} | Set-Content -Path VisualC\SDLmain\SDLmain.vcproj.patched }" || exit /b
move /Y VisualC\SDLmain\SDLmain.vcproj.patched VisualC\SDLmain\SDLmain.vcproj || exit /b
powershell -Command "& { cat src\video\windx5\directx.h | %%{$_ -replace \"#define _directx_h\", \"#define _directx_h`n#include `\"InitGuid.h`\"\"} | Set-Content -Path src\video\windx5\directx.h.patched }" || exit /b
move /Y src\video\windx5\directx.h.patched src\video\windx5\directx.h || exit /b
msbuild /p:Configuration=Release_NoSTDIO /p:PlatformToolset=v140_xp VisualC\SDL.sln || exit /b
copy /Y VisualC\SDL\Release\SDL.dll ..\build\bin\ || exit /b
copy /Y VisualC\SDL\Release\SDL.dll ..\build\lib\ || exit /b
copy /Y VisualC\Release\SDL.lib ..\build\lib\ || exit /b
copy /Y VisualC\SDLmain\Release_NOSTDIO\SDLmain.lib ..\build\lib\ || exit /b
copy /Y include\*.h ..\build\include\ || exit /b
copy /Y VisualC\SDL\*.h ..\build\include\ || exit /b
cd .. || exit /b

REM https://sourceforge.net/projects/fluidsynth/files/fluidsynth-1.1.6/fluidsynth-1.1.6.tar.gz/download || exit /b
cd fluidsynth* || exit /b
mkdir build || exit /b
cd build || exit /b
cmake -G "Visual Studio 14 2015" -T v140_xp -DCMAKE_PREFIX_PATH=..\fluidsynth-deps .. || exit /b
powershell -Command "& { cat config_win32.h | %%{$_ -replace \"#define snprintf _snprintf\", \"\"} | Set-Content -Path config_win32.h.patched }" || exit /b
move /Y config_win32.h.patched config_win32.h || exit /b
cmake --build . --config Release || exit /b
cd .. || exit /b
mkdir ..\build\include\fluidsynth || exit /b
copy /Y include\fluidsynth\*.h ..\build\include\fluidsynth\ || exit /b
copy /Y include\fluidsynth.h ..\build\include\ || exit /b
copy /Y build\include\fluidsynth\*.h ..\build\include\fluidsynth\ || exit /b
copy /Y build\src\Release\fluidsynth.lib ..\build\lib\ || exit /b
copy /Y build\src\Release\libfluidsynth.dll ..\build\lib\ || exit /b
copy /Y build\src\Release\libfluidsynth.dll ..\build\bin\ || exit /b
copy /Y ..\fluidsynth-deps\bin\libglib*.dll ..\build\bin\ || exit /b
copy /Y ..\fluidsynth-deps\bin\libgthread*.dll ..\build\bin\ || exit /b
cd .. || exit /b
