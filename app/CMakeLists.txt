project(app)

config_target(lib
    TYPE STATIC
    INC_DIR include
    SRC_DIR lib    
)

config_target(main
    LIBRARIES lib sub::lib1 sub::lib2
)

