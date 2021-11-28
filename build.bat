ECHO ON

mkdir build
mkdir build\bin
mkdir build\include
mkdir build\lib

set CL=/D_USING_V120_SDK71_ || exit /b
set _CL_=/D_USING_V120_SDK71_ || exit /b
set LINK=/SUBSYSTEM:CONSOLE,"5.01" || exit /b
set _LINK_=/SUBSYSTEM:CONSOLE,"5.01" || exit /b
set INCLUDE=..\build\include;$(DXSDK_DIR)Include;%INCLUDE% || exit /b
set LIB=..\build\lib;$(DXSDK_DIR)Lib\x86;%LIB% || exit /b

REM https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz || exit /b
cd bzip2* || exit /b
nmake /E -f makefile.msc || exit /b
copy /Y bzlib.h ..\build\include\bzlib.h || exit /b
copy /Y bzlib_private.h ..\build\include\bzlib_private.h || exit /b
copy /Y libbz2.lib ..\build\lib\bz2.lib || exit /b
cd .. || exit /b

REM https://www.zlib.net/zlib-1.2.11.tar.gz || exit /b
cd zlib* || exit /b
mkdir build
cd build || exit /b
cmake -G "Visual Studio 14 2015" -T v140_xp .. || exit /b
cmake --build . --config Release || exit /b
cd .. || exit /b
copy /Y build\Release\zlibstatic.lib ..\build\lib\zlib.lib || exit /b
copy /Y build\zconf.h ..\build\include\ || exit /b
copy /Y zlib.h ..\build\include\ || exit /b
cd .. || exit /b

REM https://www.ijg.org/files/jpegsr9d.zip || exit /b
cd jpeg* || exit /b
copy /Y jconfig.vc jconfig.h || exit /b
nmake /E -f jpeg.mak || exit /b
copy /Y Release\jpeg.lib ..\build\lib\ || exit /b
powershell -Command "& { cat jmorecfg.h | %%{$_ -replace \"typedef long INT32;\", \"\"} | Set-Content -Path jmorecfg.h.patched }" || exit /b
move /Y jmorecfg.h.patched jmorecfg.h || exit /b
copy /Y *.h ..\build\include\ || exit /b
cd .. || exit /b

REM http://prdownloads.sourceforge.net/libpng/lpng1637.zip?download || exit /b
cd libpng* || exit /b
mkdir build
cd build || exit /b
cmake -G "Visual Studio 14 2015" -T v140_xp -DZLIB_LIBRARY=..\..\build\lib\zlib.lib -DZLIB_INCLUDE_DIR=..\..\build\include\ .. || exit /b
cmake --build . --config Release || exit /b
cd .. || exit /b
copy /Y build\Release\libpng16_static.lib ..\build\lib\libpng.lib || exit /b
copy /Y build\pnglibconf.h ..\build\include\ || exit /b
copy /Y png*.h ..\build\include\ || exit /b
cd .. || exit /b

REM http://prdownloads.sourceforge.net/libmng/lm010010.zip?download || exit /b
cd libmng* || exit /b
powershell -Command "& { cat makefiles/makefile.vcwin32 | %%{$_ -replace \"0\", \"O\"} | Set-Content -Path makefiles/makefile.vcwin32.patched }" || exit /b
move /Y makefiles\makefile.vcwin32.patched makefiles\makefile.vcwin32 || exit /b
nmake /E -f makefiles/makefile.vcwin32 || exit /b
copy /Y libmng.lib ..\build\lib\mng.lib || exit /b
copy /Y libmng*.h ..\build\include\ || exit /b
cd .. || exit /b

REM https://downloads.xiph.org/releases/ogg/libogg-1.3.5.zip || exit /b
cd libogg* || exit /b
msbuild /p:Configuration=Release /p:PlatformToolset=v140_xp win32\VS2010\libogg_static.sln || exit /b
copy /Y win32\VS2010\Win32\Release\libogg_static.lib ..\build\lib\ogg_static.lib || exit /b
mkdir ..\build\include\ogg
copy /Y include\ogg\*.h ..\build\include\ogg\ || exit /b
cd .. || exit /b

REM https://downloads.xiph.org/releases/vorbis/libvorbis-1.3.7.zip || exit /b
cd libvorbis* || exit /b
move ..\libogg* ..\libogg || exit /b
msbuild /p:Configuration=Release /p:PlatformToolset=v140_xp win32\VS2010\vorbis_static.sln || exit /b
copy /Y win32\VS2010\Win32\Release\libvorbis_static.lib ..\build\lib\vorbis_static.lib || exit /b
copy /Y win32\VS2010\Win32\Release\libvorbisfile_static.lib ..\build\lib\vorbisfile_static.lib || exit /b
mkdir ..\build\include\vorbis
copy /Y include\vorbis\*.h ..\build\include\vorbis\ || exit /b
cd .. || exit /b

REM https://downloads.xiph.org/releases/theora/libtheora-1.1.1.zip || exit /b
cd libtheora* || exit /b
move ..\libvorbis* ..\libvorbis || exit /b
devenv win32\VS2008\libtheora_static.sln /upgrade || exit /b
msbuild /p:Configuration=Release_SSE2 /p:PlatformToolset=v140_xp win32\VS2008\libtheora_static.sln /t:libtheora_static || exit /b
copy /Y win32\VS2008\Win32\Release_SSE2\libtheora_static.lib ..\build\lib\theora_static.lib || exit /b
mkdir ..\build\include\theora
copy /Y include\theora\*.h ..\build\include\theora\ || exit /b
cd .. || exit /b

REM http://www.lua.org/ftp/lua-5.1.5.tar.gz || exit /b
cd lua-5.1.5 || exit /b
call etc\luavs.bat
copy /Y src\lua51.lib ..\build\lib\lua.lib || exit /b
copy /Y src\lua51.dll ..\build\bin\ || exit /b
copy /Y src\*.h ..\build\include\ || exit /b
cd ..

REM https://github.com/LuaDist/toluapp/archive/master.zip || exit /b
cd toluapp* || exit /b
mkdir build
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
mkdir build
cd build || exit /b
cmake -G "Visual Studio 14 2015" -T v140_xp -DCMAKE_PREFIX_PATH=..\build -DWITH_STATIC=ON .. || exit /b
cmake --build . --config Release || exit /b
cd .. || exit /b
copy /Y build\Release\storm.lib ..\build\lib\ || exit /b
copy /Y src\*.h ..\build\include\ || exit /b
cd .. || exit /b

REM https://www.libsdl.org/release/SDL2-devel-2.0.16-VC.zip
cd SDL2-2.0.12 || exit /b
copy /Y lib\x86\*.dll ..\build\bin\ || exit /b
copy /Y lib\x86\*.lib ..\build\lib\ || exit /b
copy /Y include\*.h ..\build\include\ || exit /b
cd .. || exit /b

REM https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-devel-2.0.4-VC.zip
cd SDL2_mixer-2.0.4 || exit /b
copy /Y lib\x86\*.dll ..\build\bin\ || exit /b
copy /Y lib\x86\*.lib ..\build\lib\ || exit /b
copy /Y include\*.h ..\build\include\ || exit /b
cd .. || exit /b

REM https://www.libsdl.org/projects/SDL_image/release/SDL2_image-devel-2.0.5-VC.zip
cd SDL2_image-2.0.5 || exit /b
copy /Y lib\x86\*.dll ..\build\bin\ || exit /b
copy /Y lib\x86\*.lib ..\build\lib\ || exit /b
copy /Y include\*.h ..\build\include\ || exit /b
cd .. || exit /b
