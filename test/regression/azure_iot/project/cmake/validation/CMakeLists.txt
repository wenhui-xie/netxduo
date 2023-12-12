cmake_minimum_required(VERSION 3.13 FATAL_ERROR)

if(NOT DEFINED THREADX_ARCH)
  if(WIN32)
    set(CMAKE_TOOLCHAIN_FILE
        "../configs/win32.cmake"
        CACHE STRING "")
  elseif(UNIX)
    set(CMAKE_TOOLCHAIN_FILE
        "../configs/linux.cmake"
        CACHE STRING "")
  else()
    message(FATAL_ERROR "Error: Architecture not supported")
  endif()
endif()

# Project
project(Validation LANGUAGES C ASM)

# CFLAGS
if(WIN32)
  set(ADDITIONAL_C_FLAGS $ENV{CFLAGS} "/MP -DWIN32 -D_CRT_SECURE_NO_WARNINGS")
else()
  if(THREADX_ARCH STREQUAL "linux")
    set(ADDITIONAL_C_FLAGS
        "$ENV{CFLAGS} -O0 -g3 -ggdb -m32 -gdwarf-2 -fdiagnostics-color -fprofile-arcs -ftest-coverage"
    )
  endif()
endif()

add_definitions(${ADDITIONAL_C_FLAGS})

set(NX_USER_FILE "${CMAKE_CURRENT_LIST_DIR}/nx_user.h" CACHE STRING "Enable NX user configuration")
set(NXD_ENABLE_FILE_SERVERS OFF CACHE BOOL "Disable fileX dependency by netxduo")
set(TX_FOLDER "${PROJECT_SOURCE_DIR}/../../../threadx")
set(NXD_FOLDER "${PROJECT_SOURCE_DIR}/../../../../../..")
add_subdirectory(${NXD_FOLDER} netxduo)
add_subdirectory(${TX_FOLDER} threadx)
