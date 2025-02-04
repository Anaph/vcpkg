vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/microsoft/onnxruntime/releases/download/v${VERSION}/onnxruntime-linux-${VCPKG_TARGET_ARCHITECTURE}-${VERSION}.tgz"
    FILENAME "onnxruntime-linux-${VCPKG_TARGET_ARCHITECTURE}-${VERSION}.tgz"
    SKIP_SHA512 TRUE
)

vcpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    NO_REMOVE_ONE_LEVEL
)

set(onnxruntime_DIR ${CURRENT_PACKAGES_DIR}/share/onnxruntime)
set(ONNX_LIB_PATH onnxruntime-linux-${VCPKG_TARGET_ARCHITECTURE}${VCPKG_TARGET_FEATURE}-${VERSION})


file(MAKE_DIRECTORY
        ${CURRENT_PACKAGES_DIR}/include
        ${CURRENT_PACKAGES_DIR}/lib
        ${CURRENT_PACKAGES_DIR}/bin
        ${CURRENT_PACKAGES_DIR}/debug/lib
        ${CURRENT_PACKAGES_DIR}/debug/bin
        ${CURRENT_PACKAGES_DIR}/share/onnxruntime
    )

file(COPY
    ${SOURCE_PATH}/${ONNX_LIB_PATH}/include
    DESTINATION ${CURRENT_PACKAGES_DIR}
)


get_filename_component(CMAKE_CURRENT_LIST_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
file(COPY
    ${CMAKE_CURRENT_LIST_DIR}/onnxruntimeVersion.cmake
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/onnxruntime
)

file(COPY
    ${CMAKE_CURRENT_LIST_DIR}/onnxruntimeConfig.cmake
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/onnxruntime
)

file(COPY ${SOURCE_PATH}/${ONNX_LIB_PATH}/lib/libonnxruntime.so
    DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(COPY ${SOURCE_PATH}/${ONNX_LIB_PATH}/lib/libonnxruntime.so
    DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)

file(COPY ${SOURCE_PATH}/${ONNX_LIB_PATH}/lib/libonnxruntime.so.${VERSION}
    DESTINATION ${CURRENT_PACKAGES_DIR}/bin)
file(COPY ${SOURCE_PATH}/${ONNX_LIB_PATH}/lib/libonnxruntime.so.${VERSION}
    DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)



# # Handle copyright
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/${ONNX_LIB_PATH}/LICENSE")
