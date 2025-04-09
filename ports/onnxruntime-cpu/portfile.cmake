vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

# Detect URL and SHA512 for archs
# https://github.com/microsoft/onnxruntime/releases/download/v1.16.3/onnxruntime-linux-x64-1.16.3.tgz
# https://github.com/microsoft/onnxruntime/releases/download/v1.16.3/onnxruntime-linux-aarch64-1.16.3.tgz
# https://github.com/microsoft/onnxruntime/releases/download/v1.16.3/onnxruntime-win-x64-1.16.3.zip
if(VCPKG_TARGET_IS_WINDOWS)
    message(FATAL_ERROR "OS Windows is not supported yet")
elseif(VCPKG_TARGET_IS_LINUX)
    if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
        set(FILE_ARCH "x64")
        set(FILE_FULLNAME "onnxruntime-linux-${FILE_ARCH}-${VERSION}.tgz")
        set(FILE_SHA512 "66eaebcf3db5c0e38224f1aa8bd50ae0158f42d3ee9a317621e1e9dba6ab921e9aafa26c02718facb810bacae68522851a4ce2b1821a224920dae98f18a89e74")
    elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
        set(FILE_ARCH "aarch64")
        set(FILE_FULLNAME "onnxruntime-linux-${FILE_ARCH}-${VERSION}.tgz")
        set(FILE_SHA512 "73140375fbdb60482a9959c1e5facc88b92500cae9206d6e2a017eb858109f8e3d1a9903e69da1bc7a05162f83c97f8a30d9ae0dc3b0bfca1146a849b3ad404f")
    else()
        message(FATAL_ERROR "Linux ${VCPKG_TARGET_ARCHITECTURE} is not supported")
    endif()
else()
    message(FATAL_ERROR "Target OS is not supported")
endif()

vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/microsoft/onnxruntime/releases/download/v${VERSION}/${FILE_FULLNAME}"
    FILENAME "${FILE_FULLNAME}"
    SHA512 "${FILE_SHA512}"
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
        ${SOURCE_PATH}/onnxruntime-linux-${FILE_ARCH}-${VERSION}/include
        DESTINATION ${CURRENT_PACKAGES_DIR}
    )

file(COPY
        ${SOURCE_PATH}/onnxruntime-linux-${FILE_ARCH}-${VERSION}/lib/libonnxruntime.so
        DESTINATION ${CURRENT_PACKAGES_DIR}/lib
    )
file(COPY
        ${SOURCE_PATH}/onnxruntime-linux-${FILE_ARCH}-${VERSION}/lib/libonnxruntime.so.${VERSION}
        DESTINATION ${CURRENT_PACKAGES_DIR}/lib
    )

file(COPY
        ${SOURCE_PATH}/onnxruntime-linux-${FILE_ARCH}-${VERSION}/lib/libonnxruntime.so
        DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib
    )
file(COPY
        ${SOURCE_PATH}/onnxruntime-linux-${FILE_ARCH}-${VERSION}/lib/libonnxruntime.so.${VERSION}
        DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib
    )

file(COPY
        ${SOURCE_PATH}/onnxruntime-linux-${FILE_ARCH}-${VERSION}/lib/libonnxruntime.so
        DESTINATION ${CURRENT_PACKAGES_DIR}/bin
    )
file(COPY
        ${SOURCE_PATH}/onnxruntime-linux-${FILE_ARCH}-${VERSION}/lib/libonnxruntime.so.${VERSION}
        DESTINATION ${CURRENT_PACKAGES_DIR}/bin
    )

file(COPY
        ${SOURCE_PATH}/onnxruntime-linux-${FILE_ARCH}-${VERSION}/lib/libonnxruntime.so
        DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin
    )
file(COPY
        ${SOURCE_PATH}/onnxruntime-linux-${FILE_ARCH}-${VERSION}/lib/libonnxruntime.so.${VERSION}
        DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin
    )

# # Handle copyright
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/onnxruntime-linux-${FILE_ARCH}-${VERSION}/LICENSE")
