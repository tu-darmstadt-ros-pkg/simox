# Locate Bullet. Original version from osgbullet, http://code.google.com/p/osgbullet/ 
#
# This script defines:
#   BULLET_FOUND, set to 1 if found
#   BULLET_LIBRARIES
#   BULLET_INCLUDE_DIR
#   BULLET_*_LIBRARY, one for each library (for example, "BULLET_BulletCollision_LIBRARY").
#   BULLET_*_LIBRARY_debug, one for each library.
#   BULLET_DEMOS_INCLUDE_DIR - Directory containing the Demos headers
#   BULLET_OPENGL_INCLUDE_DIR - Include path for OpenGL/DemoApplication/Glut headers
#
# This script will look in standard locations for installed Bullet. However, if you
# install Bullet into a non-standard location, you can use the BULLET_ROOT
# variable (in environment or CMake) to specify the location.
#
# You can also use Bullet out of a source tree by specifying BULLET_SOURCE_DIR
# and BULLET_BUILD_DIR (in environment or CMake).


SET( BULLET_ROOT "" CACHE PATH "Bullet install dir, parent of both header files and binaries." )
SET( BULLET_BUILD_DIR "" CACHE PATH "Parent directory of Bullet binary file directories such as src/BulletCollision." )
SET( BULLET_SOURCE_DIR "" CACHE PATH "Parent directory of Bullet header file directories such as src or include." )

#UNSET( BULLET_INCLUDE_DIR CACHE )
MARK_AS_ADVANCED( BULLET_INCLUDE_DIR )
FIND_PATH( BULLET_INCLUDE_DIR btBulletCollisionCommon.h
    PATHS
        ${BULLET_ROOT}
        $ENV{BULLET_ROOT}
        ${BULLET_SOURCE_DIR}
        $ENV{BULLET_SOURCE_DIR}
        "C:/Program Files/BULLET_PHYSICS"
    PATH_SUFFIXES
        /BulletCollision
        /src
        /include
        /include/bullet
        /src/BulletCollision
        /include/BulletCollision
        /include/bullet/BulletCollision
    )
IF( BULLET_INCLUDE_DIR )
    #SET( BULLET_DEMOS_INCLUDE_DIR ${BULLET_INCLUDE_DIR}/../Demos/OpenGL )
    FIND_PATH( BULLET_OPENGL_INCLUDE_DIR DemoApplication.h
    PATHS
        ${BULLET_INCLUDE_DIR}
        ${BULLET_INCLUDE_DIR}/..
        ${BULLET_INCLUDE_DIR}/../OpenGL
        ${BULLET_INCLUDE_DIR}/OpenGL
        ${BULLET_INCLUDE_DIR}/../Demos/OpenGL
    )
    FIND_PATH( BULLET_DEMOS_INCLUDE_DIR GlutDemoApplication.h
    PATHS
        ${BULLET_INCLUDE_DIR}
        ${BULLET_INCLUDE_DIR}/..
        ${BULLET_INCLUDE_DIR}/../OpenGL
        ${BULLET_INCLUDE_DIR}/OpenGL
        ${BULLET_INCLUDE_DIR}/../Demos/OpenGL
    )
    MESSAGE (STATUS " **** BULLET_OPENGL_INCLUDE_DIR: ${BULLET_OPENGL_INCLUDE_DIR}")
    MESSAGE (STATUS " **** BULLET_DEMOS_INCLUDE_DIR: ${BULLET_DEMOS_INCLUDE_DIR}")
ENDIF( BULLET_INCLUDE_DIR )

MACRO( FIND_BULLET_LIBRARY_DIRNAME LIBNAME DIRNAME )
    #UNSET( BULLET_${LIBNAME}_LIBRARY CACHE )
    #UNSET( BULLET_${LIBNAME}_LIBRARY_debug CACHE )
    MARK_AS_ADVANCED( BULLET_${LIBNAME}_LIBRARY )
    MARK_AS_ADVANCED( BULLET_${LIBNAME}_LIBRARY_debug )
    FIND_LIBRARY( BULLET_${LIBNAME}_LIBRARY
        NAMES
            ${LIBNAME}
        PATHS
            ${BULLET_ROOT}
            $ENV{BULLET_ROOT}
            ${BULLET_BUILD_DIR}
            $ENV{BULLET_BUILD_DIR}
            "C:/Program Files/BULLET_PHYSICS"
        PATH_SUFFIXES
            ./src/${DIRNAME}
            ./Extras/${DIRNAME}
            ./Demos/${DIRNAME}
            ./src/${DIRNAME}/Release
            ./Extras/${DIRNAME}/Release
            ./Demos/${DIRNAME}/Release
            ./libs/${DIRNAME}
            ./libs
            ./lib
            ./lib/Release # v2.76, new location for build tree libs on Windows
        NO_DEFAULT_PATH
        )
	# check for defualt path if BULLET_ROOT path failed
	FIND_LIBRARY( BULLET_${LIBNAME}_LIBRARY NAMES ${LIBNAME})
	
    FIND_LIBRARY( BULLET_${LIBNAME}_LIBRARY_debug
        NAMES
            ${LIBNAME}_d
            ${LIBNAME}_Debug
            ${LIBNAME}
        PATHS
            ${BULLET_ROOT}
            $ENV{BULLET_ROOT}
            ${BULLET_BUILD_DIR}
            $ENV{BULLET_BUILD_DIR}
            "C:/Program Files/BULLET_PHYSICS"
        PATH_SUFFIXES
            ./src/${DIRNAME}
            ./Extras/${DIRNAME}
            ./Demos/${DIRNAME}
            ./src/${DIRNAME}/Debug
            ./Extras/${DIRNAME}/Debug
            ./Demos/${DIRNAME}/Debug
            ./libs/${DIRNAME}
            ./libs
            ./lib
            ./lib/Debug # v2.76, new location for build tree libs on Windows
        NO_DEFAULT_PATH
        )
	# check for defualt path if BULLET_ROOT path failed
	FIND_LIBRARY( BULLET_${LIBNAME}_LIBRARY_debug NAMES ${LIBNAME}_d ${LIBNAME}_Debug ${LIBNAME} )

    #message( STATUS "${BULLET_${LIBNAME}_LIBRARY} and ${BULLET_${LIBNAME}_LIBRARY_debug}" )
    #message( SEND_ERROR ${LIBNAME} )
    IF( BULLET_${LIBNAME}_LIBRARY )
        SET( BULLET_LIBRARIES ${BULLET_LIBRARIES}
            "optimized" ${BULLET_${LIBNAME}_LIBRARY}
        )
    ENDIF( BULLET_${LIBNAME}_LIBRARY )
    IF( BULLET_${LIBNAME}_LIBRARY_debug )
        SET( BULLET_LIBRARIES ${BULLET_LIBRARIES}
            "debug" ${BULLET_${LIBNAME}_LIBRARY_debug}
        )
    ENDIF( BULLET_${LIBNAME}_LIBRARY_debug )
ENDMACRO( FIND_BULLET_LIBRARY_DIRNAME LIBNAME )

MACRO( FIND_BULLET_LIBRARY LIBNAME )
    FIND_BULLET_LIBRARY_DIRNAME( ${LIBNAME} ${LIBNAME} )
ENDMACRO( FIND_BULLET_LIBRARY LIBNAME )


FIND_BULLET_LIBRARY( BulletDynamics )
FIND_BULLET_LIBRARY( BulletSoftBody )
FIND_BULLET_LIBRARY( BulletCollision )
FIND_BULLET_LIBRARY( BulletMultiThreaded )
FIND_BULLET_LIBRARY( LinearMath )
FIND_BULLET_LIBRARY_DIRNAME( OpenGLSupport OpenGL )

# Hide BULLET_LIBRARY in the GUI, since most users can just ignore it
MARK_AS_ADVANCED( BULLET_LIBRARIES )
MARK_AS_ADVANCED( BULLET_LIBRARIES_debug )

SET( BULLET_FOUND 0 )
IF( BULLET_INCLUDE_DIR AND BULLET_LIBRARIES )
    SET( BULLET_FOUND 1 )
ENDIF( BULLET_INCLUDE_DIR AND BULLET_LIBRARIES )


# Possible future support for collision-only (no dynamics)
IF( BULLET_BulletDynamics_LIBRARY OR BULLET_BulletDynamics_LIBRARY_debug )
    SET( BULLET_DYNAMICS_FOUND 1 )
ENDIF( BULLET_BulletDynamics_LIBRARY OR BULLET_BulletDynamics_LIBRARY_debug )
