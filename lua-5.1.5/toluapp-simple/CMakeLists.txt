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

add_library(toluapp51 STATIC "${TOLUA_LIB_SRC}")
add_executable(toluapp "${TOLUA_BIN_SRC}" "${TOLUA_LIB_SRC}")

target_link_libraries(toluapp51 PUBLIC lua51_static ${CMAKE_DL_LIBS})
target_link_libraries(toluapp PUBLIC lua51_static ${CMAKE_DL_LIBS})

set_target_properties(toluapp51 PROPERTIES PUBLIC_HEADER "tolua++.h")

set_target_properties(toluapp51 PROPERTIES LINKER_LANGUAGE CXX)
set_target_properties(toluapp PROPERTIES LINKER_LANGUAGE CXX)

install(TARGETS toluapp DESTINATION ${CMAKE_INSTALL_BINDIR})
install(TARGETS toluapp51 
LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
PUBLIC_HEADER DESTINATION  ${CMAKE_INSTALL_INCLUDEDIR}
)

