vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/anaph/onnxruntime/releases/download/v${VERSION}/onnxruntime-linux-${VCPKG_TARGET_ARCHITECTURE}${VCPKG_TARGET_FEATURE}-${VERSION}.tar.gz"
    FILENAME "onnxruntime-linux-${VCPKG_TARGET_ARCHITECTURE}${VCPKG_TARGET_FEATURE}-${VERSION}.tar.gz"
    SKIP_SHA512 TRUE
)

vcpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    NO_REMOVE_ONE_LEVEL
)

set(ONNX_LIB_PATH "onnxruntime-linux-${VCPKG_TARGET_ARCHITECTURE}${VCPKG_TARGET_FEATURE}/onnxruntime-linux-${VCPKG_TARGET_ARCHITECTURE}${VCPKG_TARGET_FEATURE}")

file(MAKE_DIRECTORY
        ${CURRENT_PACKAGES_DIR}/include
        ${CURRENT_PACKAGES_DIR}/lib
        ${CURRENT_PACKAGES_DIR}/bin
        ${CURRENT_PACKAGES_DIR}/debug/lib
        ${CURRENT_PACKAGES_DIR}/debug/bin
    )

file(COPY
        ${SOURCE_PATH}/${ONNX_LIB_PATH}/include/onnxruntime
        DESTINATION ${CURRENT_PACKAGES_DIR}
    )

file(COPY ${SOURCE_PATH}/${ONNX_LIB_PATH}/lib/libonnxruntime.so
    DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(COPY ${SOURCE_PATH}/${ONNX_LIB_PATH}/lib/libonnxruntime.so
    DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)

file(COPY ${SOURCE_PATH}/${ONNX_LIB_PATH}/lib/libonnxruntime.so.${VERSION}
    DESTINATION ${CURRENT_PACKAGES_DIR}/bin)
file(COPY ${SOURCE_PATH}/${ONNX_LIB_PATH}/lib/libonnxruntime.so.${VERSION}
    DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)


file(COPY ${SOURCE_PATH}/${ONNX_LIB_PATH}/lib/onnxruntime_providers_shared.so
    DESTINATION ${CURRENT_PACKAGES_DIR}/bin)
file(COPY ${SOURCE_PATH}/${ONNX_LIB_PATH}/lib/onnxruntime_providers_shared.so
    DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)

