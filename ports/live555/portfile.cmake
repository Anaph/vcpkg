vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

string(REPLACE "-" "." format_version ${VERSION})
vcpkg_download_distfile(ARCHIVE
    URLS "http://live555.com/liveMedia/public/live555-latest.tar.gz"
    FILENAME "live.${format_version}.tar.gz"
    SHA512 5e904ef1ae4ed9bb79b0a0c3704e718ae720d6d03a84f6b1ab9ea25e905ab2ed134719cf605e9d3672f04a3b0007cd8bca515817502b226148a8b3fd1a7ec048
)

vcpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    PATCHES
        fix-RTSPClient.patch
        fix_operator_overload.patch
        fix-atomic-flag-test.patch
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    PREFER_NINJA

    OPTIONS
        # point FindOpenSSL at the vcpkg-installed ARMhf openssl
        -DOPENSSL_ROOT_DIR=${CURRENT_INSTALLED_DIR}
        -DOPENSSL_INCLUDE_DIR=${CURRENT_INSTALLED_DIR}/include
        -DOPENSSL_CRYPTO_LIBRARY=${CURRENT_INSTALLED_DIR}/lib/libcrypto.a
        -DOPENSSL_SSL_LIBRARY=${CURRENT_INSTALLED_DIR}/lib/libssl.a
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

vcpkg_cmake_config_fixup(PACKAGE_NAME unofficial-live555)

file(GLOB HEADERS
    "${SOURCE_PATH}/BasicUsageEnvironment/include/*.h*"
    "${SOURCE_PATH}/groupsock/include/*.h*"
    "${SOURCE_PATH}/liveMedia/include/*.h*"
    "${SOURCE_PATH}/UsageEnvironment/include/*.h*"
)

file(COPY ${HEADERS} DESTINATION "${CURRENT_PACKAGES_DIR}/include")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
