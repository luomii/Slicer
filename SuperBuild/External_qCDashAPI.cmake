
# Make sure this file is included only once
get_filename_component(CMAKE_CURRENT_LIST_FILENAME ${CMAKE_CURRENT_LIST_FILE} NAME_WE)
IF(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED)
  RETURN()
ENDIF()
SET(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED 1)

# Sanity checks
if(DEFINED qCDashAPI_DIR AND NOT EXISTS ${qCDashAPI_DIR})
  message(FATAL_ERROR "qCDashAPI_DIR variable is defined but corresponds to non-existing directory")
endif()

# Set dependency list
set(qCDashAPI_DEPENDENCIES "")

# Include dependent projects if any
SlicerMacroCheckExternalProjectDependency(qCDashAPI)
set(proj qCDashAPI)

if(NOT DEFINED qCDashAPI_DIR)
  #message(STATUS "${__indent}Adding project ${proj}")
  ExternalProject_Add(${proj}
    GIT_REPOSITORY "${git_protocol}://github.com/jcfr/qCDashAPI.git"
    GIT_TAG "origin/master"
    SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj}
    BINARY_DIR ${proj}-build
    CMAKE_GENERATOR ${gen}
    CMAKE_ARGS
      -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
      -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
      #-DCMAKE_C_FLAGS:STRING=${ep_common_c_flags} # Unused
      -DBUILD_TESTING:BOOL=OFF
      -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
    INSTALL_COMMAND ""
    DEPENDS 
      ${qCDashAPI_DEPENDENCIES}
    )
  set(qCDashAPI_DIR ${CMAKE_BINARY_DIR}/${proj}-build)
else()
  # The project is provided using qCDashAPI_DIR, nevertheless since other project may depend on qCDashAPI, 
  # let's add an 'empty' one
  SlicerMacroEmptyExternalProject(${proj} "${qCDashAPI_DEPENDENCIES}")
endif()

