include(CMakeParseArguments)

# Muestra mensaje de estado si SHOW_INFO es ON
# MSG           mensaje
# ARGV1         projecto que envia el mensaje(por omisión el actual)
function(info MSG )
    set(PRPT ${PROJECT_NAME})
    if(${ARGC} GREATER 1 )
        set(PRPT ${ARGV1})
    endif(${ARGC} GREATER 1 )
    if(SHOW_INFO)
        message(STATUS "${PRPT}> ${MSG}")
    endif()
endfunction(info MSG)

# asegura que VAR_NAME tenga un valor(p.o. DEFAULT_VALUE)
function(ensure VAR_NAME DEFAULT_VALUE)
    if("${${VAR_NAME}}" STREQUAL "")
        set(${VAR_NAME} ${DEFAULT_VALUE} PARENT_SCOPE)
    endif("${${VAR_NAME}}" STREQUAL "")
endfunction(ensure VAR_NAME DEFAULT_VALUE)

# Determina un valor en función de BOOL_VALUE.
# BOOL_VALUE        valor que determina la salida. Si se omite ARGV4(output)
#                   el valor determinado es reasignado a esta variable.
# TRUE_VALUE        Valor devuelto si BOOL_VALUE es true.
# FALSE_VALUE       Valor devuelto si BOOL_VALUE es false.
# ARV4(output)      Opcional. Variable de salida. Si se omite se asigna a BOOL_VALUE.
function(cond BOOL_VALUE TRUE_VALUE FALSE_VALUE)

    set(OUTPUT ${BOOL_VALUE})
    if(ARGC EQUAL 4)
        set(OUTPUT ${ARGV3})
    endif(ARGC EQUAL 4)
    
    set(EXPR ${${BOOL_VALUE}})
    if(EXPR)
        string(TOUPPER ${EXPR} EXPR)
        if(EXPR STREQUAL 0 OR EXPR STREQUAL OFF OR EXPR STREQUAL FALSE OR EXPR STREQUAL "")
            set(EXPR FALSE)
        else()
            set(EXPR TRUE)
        endif()
    endif(EXPR)

    if(EXPR)
        set(${OUTPUT} ${TRUE_VALUE} PARENT_SCOPE)
    else(EXPR)
        set(${OUTPUT} ${FALSE_VALUE} PARENT_SCOPE)
    endif(EXPR)

endfunction(cond BOOL_VALUE TRUE_VALUE FALSE_VALUE)

# Scanea el directorio en busca de los ficheros que coinciden con el glob.
function(get_files DIR PAT OUTPUT)

    set(RESULT "")
    
    if(IS_DIRECTORY ${DIR})
        file(GLOB RESULT CONFIGURE_DEPENDS "${DIR}/${PAT}")
    endif(IS_DIRECTORY ${DIR})

    set(${OUTPUT} ${RESULT} PARENT_SCOPE)

endfunction(get_files DIR PAT)

# escanea el directorio para las extensiones .cpp .cxx .c
function(get_sources DIR OUTPUT)

    set(RESULT "")
    
    if(IS_DIRECTORY ${DIR})
        file(GLOB_RECURSE RESULT LIST_DIRECTORIES false CONFIGURE_DEPENDS "${DIR}/*.cpp" "${DIR}/*.cxx" "${DIR}/*.c")
    endif(IS_DIRECTORY ${DIR})

    set("${OUTPUT}" ${RESULT} PARENT_SCOPE)

endfunction(get_sources DIR OUTPUT)

 
# escanea el directorio para las extensiones .hpp .hxx .h
function(get_headers DIR OUTPUT)

    set(RESULT "")
    
    if(IS_DIRECTORY ${DIR})
        file(GLOB_RECURSE RESULT LIST_DIRECTORIES false CONFIGURE_DEPENDS "${DIR}/*.hpp" "${DIR}/*.hxx" "${DIR}/*.h")
    endif(IS_DIRECTORY ${DIR})

    set("${OUTPUT}" ${RESULT} PARENT_SCOPE)

endfunction(get_headers DIR OUTPUT)

function(add_subprojects)
    foreach(IT ${ARGV})
        add_subdirectory("${IT}")
    endforeach(IT ${ARGV})
    
endfunction(add_subprojects)
 
 
