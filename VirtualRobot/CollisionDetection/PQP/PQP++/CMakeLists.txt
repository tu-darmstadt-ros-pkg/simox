PROJECT(ColCheckerPQP)

MESSAGE (STATUS " **** Configuring PQP")

ADD_DEFINITIONS(-DUSE_PQP)

# Specify headers and sources
FILE(GLOB SRCS ${PROJECT_SOURCE_DIR}/*.cpp)
FILE(GLOB INCS ${PROJECT_SOURCE_DIR}/*.h)

INCLUDE_DIRECTORIES(${PROJECT_SOURCE_DIR})

ADD_LIBRARY(${PROJECT_NAME} STATIC ${SRCS} ${INCS})
SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES FOLDER "3rd_Party")
IF(UNIX)
	# We are on Linux
	ADD_DEFINITIONS(-fPIC)
ENDIF(UNIX)

MESSAGE(STATUS " ** ${PROJECT_NAME}  will be placed into " ${Simox_LIB_DIR})


# .DLL path
SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${Simox_BIN_DIR})
# .so path
SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${Simox_LIB_DIR})
# .lib path (this is needed for setting the DLL-import library path on windows)
SET_TARGET_PROPERTIES(${PROJECT_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${Simox_LIB_DIR})


  
  
#######################################################################################
############################ Setup for installation ###################################
#######################################################################################


#set_target_properties(${PROJECT_NAME} PROPERTIES
#  PUBLIC_HEADER "${INCS}")

install(TARGETS ${PROJECT_NAME}
  # IMPORTANT: Add the library to the "export-set"
  EXPORT SimoxTargets
  RUNTIME DESTINATION "${INSTALL_BIN_DIR}" COMPONENT bin
  LIBRARY DESTINATION "${INSTALL_LIB_DIR}" COMPONENT shlib
  ARCHIVE DESTINATION "${INSTALL_LIB_DIR}" COMPONENT library
  COMPONENT dev)
#  PUBLIC_HEADER DESTINATION "${INSTALL_INCLUDE_DIR}/VirtualRobot"
