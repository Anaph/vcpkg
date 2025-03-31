vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)
#https://github.com/microsoft/onnxruntime/releases/download/v1.16.3/onnxruntime-linux-x64-1.16.3.tgz
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/microsoft/onnxruntime/releases/download/v${VERSION}/onnxruntime-linux-x64-${VERSION}.tgz"
    FILENAME "onnxruntime-linux-x64-${VERSION}.tgz"
    SHA512 66eaebcf3db5c0e38224f1aa8bd50ae0158f42d3ee9a317621e1e9dba6ab921e9aafa26c02718facb810bacae68522851a4ce2b1821a224920dae98f18a89e74
)

vcpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    NO_REMOVE_ONE_LEVEL
)

# Download repo for experimental features
vcpkg_from_github(
    OUT_SOURCE_PATH REPO_PATH
    REPO microsoft/onnxruntime
    REF v${VERSION}
    SHA512 f2fec4ded88da6bf67ae7d0aa3082736cb3b8ba29e723b5a516d7632b68ce02aed461f24d3e82cbab20757729e0ab45d736bd986c9b7395f2879b16a091c12a1
)

file(COPY
        ${REPO_PATH}/include/onnxruntime/core/session/experimental_onnxruntime_cxx_api.h 
        ${REPO_PATH}/include/onnxruntime/core/session/experimental_onnxruntime_cxx_inline.h
        DESTINATION ${CURRENT_PACKAGES_DIR}/include
    )

file(MAKE_DIRECTORY
        ${CURRENT_PACKAGES_DIR}/include
        ${CURRENT_PACKAGES_DIR}/lib
        ${CURRENT_PACKAGES_DIR}/bin
        ${CURRENT_PACKAGES_DIR}/debug/lib
        ${CURRENT_PACKAGES_DIR}/debug/bin
    )

file(COPY
        ${SOURCE_PATH}/onnxruntime-linux-x64-${VERSION}/include
        DESTINATION ${CURRENT_PACKAGES_DIR}
    )

file(COPY
        ${SOURCE_PATH}/onnxruntime-linux-x64-${VERSION}/lib/libonnxruntime.so
        DESTINATION ${CURRENT_PACKAGES_DIR}/lib
    )
file(COPY
        ${SOURCE_PATH}/onnxruntime-linux-x64-${VERSION}/lib/libonnxruntime.so.1.16.3
        DESTINATION ${CURRENT_PACKAGES_DIR}/lib
    )

file(COPY
        ${SOURCE_PATH}/onnxruntime-linux-x64-${VERSION}/lib/libonnxruntime.so
        DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib
    )
file(COPY
        ${SOURCE_PATH}/onnxruntime-linux-x64-${VERSION}/lib/libonnxruntime.so.1.16.3
        DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib
    )

file(COPY
        ${SOURCE_PATH}/onnxruntime-linux-x64-${VERSION}/lib/libonnxruntime.so
        DESTINATION ${CURRENT_PACKAGES_DIR}/bin
    )
file(COPY
        ${SOURCE_PATH}/onnxruntime-linux-x64-${VERSION}/lib/libonnxruntime.so.1.16.3
        DESTINATION ${CURRENT_PACKAGES_DIR}/bin
    )

file(COPY
        ${SOURCE_PATH}/onnxruntime-linux-x64-${VERSION}/lib/libonnxruntime.so
        DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin
    )
file(COPY
        ${SOURCE_PATH}/onnxruntime-linux-x64-${VERSION}/lib/libonnxruntime.so.1.16.3
        DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin
    )

# # Handle copyright
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/onnxruntime-linux-x64-${VERSION}/LICENSE")
