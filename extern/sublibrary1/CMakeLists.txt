# Set the project name
project (sublib1)

config_target(sub1
    TYPE static
    INC_DIR include
    SRC_DIR src
    INC_SUFFIX sublib1
    ALIAS sub::lib1
)

