include(tools)

# set build type to Release if not provided via command line
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "Built type" FORCE)
endif()

if(CMAKE_CXX_COMPILER MATCHES [Cc]lang)
    set(CXX_COMPILER Clang)
elseif(CMAKE_CXX_COMPILER MATCHES "(g\\+\\+)|(c\\+\\+)")
    set(CXX_COMPILER GNU)
else()
    message(WARNING Unidentified CXX_COMPILER)
endif()

# set the C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

string(TOUPPER ${CMAKE_BUILD_TYPE} BUILD_TYPE)
set(CXX_FLAGS)
set(CXX_FLAGS_DEBUG ) # -fprofile-arcs -ftest-coverage
set(CXX_FLAGS_RELEASE)
set(CXX_DEFS)
set(CXX_DEFS_DEBUG "DEGUB")
set(CXX_DEFS_RELEASE "NDEBUG")


if(CXX_COMPILER STREQUAL "Clang")
    list(APPEND CXX_FLAGS "-Wall" "-Wextra" "-pedantic" "-fcolor-diagnostics")
    list(APPEND CXX_FLAGS_DEBUG "-Wdocumentation") 
    list(APPEND CXX_FLAGS_RELEASE "-O3" "-Wno-unused")
endif()

if(CXX_COMPILER STREQUAL "GNU")
    list(APPEND CXX_FLAGS "-fPIC" "-Wall" "-Wextra" "-pedantic")
    list(APPEND CXX_FLAGS_RELEASE "-O3" "-Wno-unused")
endif()

list(APPEND CXX_FLAGS ${CXX_FLAGS_${BUILD_TYPE}})
list(APPEND CXX_DEFS ${CXX_DEFS_${BUILD_TYPE}})

add_compile_options(${CXX_FLAGS})
add_compile_definitions(${CXX_DEFS})

info("BUILD TYPE: ${BUILD_TYPE}" "compilation")
info("CXX_STANDARD: ${CMAKE_CXX_STANDARD}" "compilation")
info("COMPILER: ${CXX_COMPILER}" "compilation")
info("OPTIONS: ${CXX_FLAGS}" "compilation")
info("DEFINITIONS: ${CXX_DEFS}" "compilation")
