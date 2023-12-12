cmake_minimum_required(VERSION 3.13 FATAL_ERROR)

if(NOT DEFINED THREADX_ARCH)
  if(WIN32)
    set(CMAKE_TOOLCHAIN_FILE
        "configs/win32.cmake"
        CACHE STRING "")
  elseif(UNIX)
    set(CMAKE_TOOLCHAIN_FILE
        "configs/linux.cmake"
        CACHE STRING "")
  else()
    message(FATAL_ERROR "Error: Architecture not supported")
  endif()
endif()

# Project
project(AzureIoTMiddleware LANGUAGES C ASM)

# Set property for folder
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

set(DISABLE_TEST
    OFF
    CACHE BOOL "Disable test projects (default is OFF)")
set(NX_AZURE_DISABLE_IOT_SECURITY_MODULE
    OFF
    CACHE BOOL "Disable Azure IoT Security Module (default is OFF)")

# CFLAGS
if(WIN32)
  set(ADDITIONAL_C_FLAGS $ENV{CFLAGS} "/MP -DWIN32 -D_CRT_SECURE_NO_WARNINGS")
else()
  if(THREADX_ARCH STREQUAL "linux")
    set(ADDITIONAL_C_FLAGS
        "$ENV{CFLAGS} -O0 -g3 -ggdb -m32 -gdwarf-2 -fdiagnostics-color -fprofile-arcs -ftest-coverage -Wno-error=misleading-indentation")
  endif()
  set(ADDITIONAL_C_FLAGS_AZURE_SERVICES
      "-std=c99 -Werror -Wall -Wextra -pedantic -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -Wunused -Wuninitialized -Wmissing-declarations -Wconversion -Wpointer-arith -Wshadow -Wlogical-op -Wfloat-equal -fprofile-arcs -ftest-coverage -Wjump-misses-init -Wno-error=misleading-indentation"
  )
endif()

# Add definitions
add_definitions(
  ${ADDITIONAL_C_FLAGS}
  ${DRIVER_FLAG}
  -DNX_PCAP_SOURCE_NAME=\"${PCAP_NAME}\"
  -DNX_ENABLE_EXTENDED_NOTIFY_SUPPORT
  -DNX_SECURE_ENABLE
  -DNX_DNS_CLIENT_USER_CREATE_PACKET_POOL
  -DNX_DNS_CLIENT_CLEAR_QUEUE
  -DNXD_MQTT_CLOUD_ENABLE
  -DNX_SNTP_CLIENT_MAX_ROOT_DISPERSION=0
  -DNX_SNTP_CLIENT_MIN_SERVER_STRATUM=3
  -DNX_ENABLE_IP_PACKET_FILTER
  -DNX_SECURE_TLS_DISABLE_TLS_1_1
  -DNXD_MQTT_PING_TIMEOUT_DELAY=500
  -DNXD_MQTT_SOCKET_TIMEOUT=0
  -DNXD_MQTT_OVER_WEBSOCKET
  -DNX_AZURE_IOT_ADU_AGENT_PROXY_UPDATE_COUNT=1)

# Include azure rtos cmake
include(configs/azure_rtos_src.cmake)

if(NX_AZURE_DISABLE_IOT_SECURITY_MODULE)
  add_definitions(
      -DNX_AZURE_DISABLE_IOT_SECURITY_MODULE
  )
endif()

# Link libraries
if(THREADX_ARCH STREQUAL "linux")
  add_link_options(-m32 -fprofile-arcs -ftest-coverage)
endif()

if((NOT DISABLE_TEST) AND UNIX)
  # Include tests cmake
  include(configs/azure_rtos_tests.cmake)
endif()
