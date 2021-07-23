cmake_minimum_required(VERSION 3.5)

set(SHOW_INFO FALSE CACHE BOOL "" FORCE)

list(APPEND CMAKE_MODULE_PATH  "${CMAKE_SOURCE_DIR}/cmake")
 
include(cxx_compiler_config)
include(tools)
include(config_target)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# add_subdirectory(extern/googletest)
project(MyProject)
add_subprojects(extern app)
 