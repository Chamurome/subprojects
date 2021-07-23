#   module:     config_target.cmake 
#   version:    0.1.0
#   brief:      automatiza la creación de objetivos simples.

#
# Determina atributos para un objetivo dado
#
# ROOT Directorio raiz del objetivo(p.o. el del projecto)
# TYPE APP, STATIC, SHARED o INTERFACE (tipo de objetivo)
# INC_DIR       directorio de cabeceras relativo a ROOT(p.o. ROOT)
# SCR_DIR       directorio de fuentes relativo a ROOT(p.o. ROOT)
# INC_FILES     ficheros de cabecera(p.o. los .h .hpp .hxx contenidos en INC_DIR o INC_DIR/INC_SUFFIX)
# SRC_FILES     ficheros de cabecera(p.o. los .c .cpp .cxx contenidos en SRC_DIR)
# INC_SUFFIX    Indica la carpeta dentro de INC_DIR donde estan las cabeceras esto hace que
#               los objetivos que se vinculen deban usar #include "INC_SUFFIX/traget-name" mientras que en el propio
#               projecto se puede usar #include "target-name"
# ALIAS         Alias para los objetivos de biblioteca
# LIBRARIES     Librerias a que vincular el objetivo
function(target_attributes NAME)
    set(options)
    set(singles ROOT TYPE INC_DIR SRC_DIR INC_FILES SRC_FILES INC_SUFFIX ALIAS)
    set(multiples LIBRARIES)

    string(TOUPPER ${NAME} ID)
    cmake_parse_arguments(${ID} "${options}" "${singles}" "${multiples}" ${ARGN} )

    ensure("${ID}_TYPE" "app")
    ensure("${ID}_ALIAS" ${NAME})
    cond("${ID}_ROOT" "${PROJECT_SOURCE_DIR}/${${ID}_ROOT}" "${PROJECT_SOURCE_DIR}")
    cond("${ID}_INC_DIR" "${${ID}_ROOT}/${${ID}_INC_DIR}" "${${ID}_ROOT}")
    cond("${ID}_SRC_DIR" "${${ID}_ROOT}/${${ID}_SRC_DIR}" "${${ID}_ROOT}")
    
    string(TOUPPER "${${ID}_TYPE}" "${ID}_TYPE")

    if("${${ID}_SRC_FILES}" STREQUAL "")
        get_sources("${${ID}_SRC_DIR}" "${ID}_SRC_FILES")
    endif("${${ID}_SRC_FILES}" STREQUAL "")

    if(NOT "${${ID}_SRC_FILES}" STREQUAL "")
        set("${ID}_SRC_FILES"       "${${ID}_SRC_FILES}"    PARENT_SCOPE)
    endif(NOT "${${ID}_SRC_FILES}" STREQUAL "")

    if("${${ID}_INC_FILES}" STREQUAL "")
        if("${${ID}_INC_SUFFIX}" STREQUAL "")
            get_headers("${${ID}_INC_DIR}" "${ID}_INC_FILES")
        else("${${ID}_INC_SUFFIX}" STREQUAL "")
            get_headers("${${ID}_INC_DIR}/${${ID}_INC_SUFFIX}" "${ID}_INC_FILES")
        endif("${${ID}_INC_SUFFIX}" STREQUAL "")
    endif("${${ID}_INC_FILES}" STREQUAL "")

    if(NOT "${${ID}_INC_FILES}" STREQUAL "")
        set("${ID}_INC_FILES"       "${${ID}_INC_FILES}"    PARENT_SCOPE)
    endif(NOT "${${ID}_INC_FILES}" STREQUAL "")


    if(NOT "${${ID}_TYPE}" STREQUAL "app")
        set("${ID}_TYPE"            "${${ID}_TYPE}"         PARENT_SCOPE)
        set("${ID}_ALIAS"           "${${ID}_ALIAS}"        PARENT_SCOPE)
    endif(NOT "${${ID}_TYPE}" STREQUAL "app")
    
    if(NOT "${${ID}_LIBRARIES}" STREQUAL "")
        set("${ID}_LIBRARIES"       "${${ID}_LIBRARIES}"    PARENT_SCOPE)
    endif(NOT "${${ID}_LIBRARIES}" STREQUAL "")

    if(NOT "${${ID}_INC_SUFFIX}" STREQUAL "")
        set("${ID}_LOC_INC_DIR" "${${ID}_INC_DIR}/${${ID}_INC_SUFFIX}" PARENT_SCOPE)
    endif(NOT "${${ID}_INC_SUFFIX}" STREQUAL "")

    set(ID                      ${ID}                   PARENT_SCOPE)
    set("${ID}_SRC_DIR"         "${${ID}_SRC_DIR}"      PARENT_SCOPE)
    set("${ID}_INC_DIR"         "${${ID}_INC_DIR}"      PARENT_SCOPE)

endfunction(target_attributes)

# Muestra los atributos del objetivo ${ID}
macro(show_attributes)
    info("${ID}_TYPE: ${${ID}_TYPE}")
    info("${ID}_ALIAS: ${${ID}_ALIAS}")
    info("${ID}_SRC_DIR: ${${ID}_SRC_DIR}")
    info("${ID}_INC_DIR: ${${ID}_INC_DIR}")
    info("${ID}_SRC_FILES: ${${ID}_SRC_FILES}")
    info("${ID}_INC_FILES: ${${ID}_INC_FILES}")
    info("${ID}_LIBRARIES: ${${ID}_LIBRARIES}")
    info("${ID}_LOC_INC_DIR: ${${ID}_LOC_INC_DIR}")
endmacro(show_attributes)

# configura una libreria con los parámetros determinados por target_attributes
function(config_library NAME)
    target_attributes(${NAME} ${ARGN})

    cmake_language(CALL
        add_library
        "${NAME}"
        "${${ID}_TYPE}"
        "${${ID}_INC_FILES}" 
        "${${ID}_SRC_FILES}"
    )

    if("${${ID}_LOC_INC_DIR}" STREQUAL "")
        target_include_directories(${NAME}
            PUBLIC "${${ID}_INC_DIR}"
        )
    else("${${ID}_LOC_INC_DIR}" STREQUAL "")
        target_include_directories(${NAME}
            PUBLIC "${${ID}_INC_DIR}"
            PRIVATE "${${ID}_LOC_INC_DIR}"
        )
    endif("${${ID}_LOC_INC_DIR}" STREQUAL "")
    
    if(NOT "${${ID}_ALIAS}" STREQUAL "${NAME}")
        add_library("${${ID}_ALIAS}" ALIAS ${NAME})
    endif(NOT "${${ID}_ALIAS}" STREQUAL "${NAME}")
    
    if(NOT "${${ID}_LIBRARIES}" STREQUAL "")
        target_link_libraries(${NAME}
            "${${ID}_LIBRARIES}"
        )
    endif(NOT "${${ID}_LIBRARIES}" STREQUAL "")

endfunction(config_library NAME)

# configura un executable con los parámetros determinados por target_attributes
function(config_executable  NAME)
    target_attributes(${NAME} ${ARGN})
    add_executable(${NAME}
        "${${ID}_SRC_FILES}"
    )

    if(NOT "${${ID}_INC_FILES}" STREQUAL "")
        if("${${ID}_LOC_IND_DIR}" STREQUAL "")
            target_include_directories(${NAME}
                PUBLIC "${${ID}_INC_DIR}"
            )
        else("${${ID}_LOC_IND_DIR}" STREQUAL "")
            target_include_directories(${NAME}
                PUBLIC "${${ID}_INC_DIR}"
                PRIVATE "${${ID}_LOC_INC_DIR}"
            )
        endif("${${ID}_LOC_IND_DIR}" STREQUAL "")
    endif(NOT "${${ID}_INC_FILES}" STREQUAL "")
    
    
    if(NOT "${${ID}_LIBRARIES}" STREQUAL "")
        target_link_libraries(${NAME}
            "${${ID}_LIBRARIES}"
        )
    endif(NOT "${${ID}_LIBRARIES}" STREQUAL "")
    

endfunction(config_executable NAME)

# configura una linreria de cabeceras con los parámetros determinados por target_attributes
function(config_interface NAME)
    target_attributes(${NAME} ${ARGN})

    add_library(${NAME} INTERFACE)

    if(NOT "${${ID}_ALIAS}" STREQUAL "${NAME}")
        add_library("${${ID}_ALIAS}" ALIAS ${NAME})
    endif(NOT "${${ID}_ALIAS}" STREQUAL "${NAME}")
    
    target_include_directories(${NAME}
        INTERFACE 
            "${${ID}_INC_DIR}"
    )
    

endfunction(config_interface NAME)

# configura cualquiera de los tres anteriores
function(config_target NAME)
    target_attributes(${NAME} ${ARGN})
    show_attributes()
    if("${${ID}_TYPE}" STREQUAL "APP")
        config_executable(${NAME} ${ARGN})
    elseif("${${ID}_TYPE}" STREQUAL "INTERFACE")
        config_interface(${NAME} ${ARGN})
    else()
        config_library(${NAME} ${ARGN})
    endif()
    
endfunction(config_target NAME)
