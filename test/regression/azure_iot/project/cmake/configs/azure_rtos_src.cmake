# Set folder
set(TX_FOLDER "${PROJECT_SOURCE_DIR}/../../threadx")
set(NXD_FOLDER "${PROJECT_SOURCE_DIR}/../../../../..")

# Add tx
add_subdirectory(${TX_FOLDER} threadx)

# Add nxd
set(NXD_ENABLE_FILE_SERVERS OFF CACHE BOOL "Disable fileX dependency by netxduo")
set(NXD_ENABLE_AZURE_IOT ON CACHE BOOL "Enable Azure IoT from netxduo")
add_subdirectory(${NXD_FOLDER} netxduo)

# Replace addon files from netxduo
get_target_property(SOURCES_LIST netxduo SOURCES)
set(NEW_SOURCES_LIST "")
foreach(SOURCE ${SOURCES_LIST})
  if(SOURCE MATCHES ".*azure_iot.*")
    list(APPEND NEW_SOURCES_LIST ${SOURCE})
  else()
    string(REPLACE "netxduo/addons" "addons" NEW_SOURCE ${SOURCE})
    list(APPEND NEW_SOURCES_LIST ${NEW_SOURCE})
  endif()
endforeach()
set_target_properties(netxduo PROPERTIES SOURCES "${NEW_SOURCES_LIST}")
get_target_property(INCLUDE_LIST netxduo INCLUDE_DIRECTORIES)
set(NEW_INCLUDE_LIST "")
foreach(INCLUDE ${INCLUDE_LIST})
  if(INCLUDE MATCHES ".*azure_iot.*")
    list(APPEND NEW_INCLUDE_LIST ${INCLUDE})
  else()
    string(REPLACE "netxduo/addons" "addons" NEW_INCLUDE ${INCLUDE})
    list(APPEND NEW_INCLUDE_LIST ${NEW_INCLUDE})
  endif()
endforeach()
set_target_properties(netxduo PROPERTIES INCLUDE_DIRECTORIES "${NEW_INCLUDE_LIST}")
set_target_properties(netxduo PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${NEW_INCLUDE_LIST}")

set_target_properties(threadx PROPERTIES FOLDER "azure_rtos")
set_target_properties(netxduo PROPERTIES FOLDER "azure_rtos")

set_target_properties(az_core PROPERTIES FOLDER "azure_iot_embedded_sdk")
set_target_properties(az_iot_common PROPERTIES FOLDER "azure_iot_embedded_sdk")
set_target_properties(az_iot_hub PROPERTIES FOLDER "azure_iot_embedded_sdk")
set_target_properties(az_iot_provisioning PROPERTIES FOLDER "azure_iot_embedded_sdk")
set_target_properties(az_nohttp PROPERTIES FOLDER "azure_iot_embedded_sdk")
set_target_properties(az_noplatform PROPERTIES FOLDER "azure_iot_embedded_sdk")

# Enable strict build flags for netxduo
if(THREADX_TOOLCHAIN STREQUAL "gnu")
  target_compile_options(
    netxduo
    PRIVATE -std=c99
            -Werror
            -Wall
            -Wextra
            -pedantic
            -fmessage-length=0
            -fsigned-char
            -ffunction-sections
            -fdata-sections
            -Wunused
            -Wuninitialized
            -Wmissing-declarations
            -Wconversion
            -Wpointer-arith
            -Wshadow
            -Wlogical-op
            -Wfloat-equal
            -fprofile-arcs
            -Wjump-misses-init
            -Wno-error=misleading-indentation)
endif()