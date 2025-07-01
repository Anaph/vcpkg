vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

string(REPLACE "-" "." format_version ${VERSION})
vcpkg_download_distfile(ARCHIVE
    URLS "http://live555.com/liveMedia/public/live555-latest.tar.gz"
    FILENAME "live.${format_version}.tar.gz"
    SHA512 4b2053ac83cceedf05dd778d56ee63b77e41a8a3dac086365bf8b91a7c9758c2eedc6d6ee5468fac3cec8e33b7b070cfa7401a4ec37f87346c940f56d4af63ac
)

vcpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    PATCHES
        fix-RTSPClient.patch
        fix_operator_overload.patch
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
