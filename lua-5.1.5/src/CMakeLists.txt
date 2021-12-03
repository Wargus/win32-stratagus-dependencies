cmake_minimum_required(VERSION 3.1)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set(LUA_LIB_SRC
 "lapi.c"
 "lcode.c"
 "ldebug.c"
 "ldo.c"
 "ldump.c"
 "lfunc.c"
 "lgc.c"
 "llex.c"
 "lmem.c"
 "lobject.c"
 "lopcodes.c"
 "lparser.c"
 "lstate.c"
 "lstring.c"
 "ltable.c"
 "ltm.c"
 "lundump.c"
 "lvm.c"
 "lzio.c"
 "lauxlib.c"
 "lbaselib.c"
 "ldblib.c"
 "liolib.c"
 "lmathlib.c"
 "loslib.c"
 "ltablib.c"
 "lstrlib.c"
 "loadlib.c"
 "linit.c"
)

set(LUA_SRC "lua.c")

add_library(lua51_static STATIC "${LUA_LIB_SRC}")
set_target_properties(lua51_static PROPERTIES OUTPUT_NAME "lua51")
set_target_properties(lua51_static PROPERTIES PUBLIC_HEADER "lua.h;lualib.h;lauxlib.h;luaconf.h")

add_executable(lua51 "${LUA_SRC}" "${LUA_LIB_SRC}")

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

set(CMAKE_CXX_FLAGS_DEBUG "-g")
set(CMAKE_CXX_FLAGS_RELEASE "-O2")

if(UNIX)
target_compile_definitions(lua51_static PUBLIC "LUA_USE_DLOPEN" "LUA_USE_MKSTEMP")
target_compile_definitions(lua51 PUBLIC "LUA_USE_DLOPEN" "LUA_USE_MKSTEMP")
target_link_libraries(lua51 PUBLIC ${CMAKE_DL_LIBS})
target_link_libraries(lua51_static PUBLIC ${CMAKE_DL_LIBS})
endif()

target_include_directories(lua51_static PUBLIC ./)

set_target_properties(lua51_static PROPERTIES LINKER_LANGUAGE CXX)
set_target_properties(lua51 PROPERTIES LINKER_LANGUAGE CXX)


install(TARGETS lua51 DESTINATION ${CMAKE_INSTALL_BINDIR})
install(TARGETS lua51_static 
LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
PUBLIC_HEADER DESTINATION  ${CMAKE_INSTALL_INCLUDEDIR}
)
