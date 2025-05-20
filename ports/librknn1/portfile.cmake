#set(VCPKG_POLICY_MISMATCHED_NUMBER_OF_BINARIES enabled)
set(SOURCE_PATH "${CMAKE_CURRENT_LIST_DIR}/rknn_api")

if(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
    set(ARCH_DIR "lib64")
elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm")
    set(ARCH_DIR "lib")
else()
    message(FATAL_ERROR "Unsupported architecture: ${VCPKG_TARGET_ARCHITECTURE}")
endif()

file(INSTALL "${SOURCE_PATH}/librknn_api/include/"
    DESTINATION "${CURRENT_PACKAGES_DIR}/include"
)

file(INSTALL "${SOURCE_PATH}/librknn_api/${ARCH_DIR}/librknn_api.so"
    DESTINATION "${CURRENT_PACKAGES_DIR}/lib"
)

file(COPY "${SOURCE_PATH}/librknn_api/${ARCH_DIR}/librknn_api.so"
    DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib"
)

# License if any
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/LICENSE"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
    RENAME copyright
)