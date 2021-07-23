# Set the project name
project (sublibrary2)

config_target(sublib2
    TYPE interface
    INC_DIR include
    INC_SUFFIX sublib2
    ALIAS sub::lib2
)

