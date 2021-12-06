cmake_minimum_required(VERSION 3.1)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set(TOLUA_BIN_SRC
tolua.c
toluabind.c
)

set(TOLUA_LIB_SRC
tolua_event.c
tolua_is.c
tolua_map.c
tolua_push.c
tolua_to.c
)


include_directories("${CMAKE_CURRENT_LIST_DIR}/../src/")

add_library(tolua++5.1-lib STATIC "${TOLUA_LIB_SRC}")
add_executable(tolua++5.1 "${TOLUA_BIN_SRC}" "${TOLUA_LIB_SRC}")

set_target_properties(tolua++5.1-lib PROPERTIES OUTPUT_NAME "tolua++5.1")

target_link_libraries(tolua++5.1-lib PUBLIC lua51_static ${CMAKE_DL_LIBS})
target_link_libraries(tolua++5.1 PUBLIC lua51_static ${CMAKE_DL_LIBS})

set_target_properties(tolua++5.1-lib PROPERTIES PUBLIC_HEADER "tolua++.h")

set_target_properties(tolua++5.1-lib PROPERTIES LINKER_LANGUAGE CXX)
set_target_properties(tolua++5.1 PROPERTIES LINKER_LANGUAGE CXX)

install(TARGETS tolua++5.1 DESTINATION ${CMAKE_INSTALL_BINDIR})
install(TARGETS tolua++5.1-lib 
LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
PUBLIC_HEADER DESTINATION  ${CMAKE_INSTALL_INCLUDEDIR}
)

