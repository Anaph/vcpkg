vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

string(REPLACE "-" "." format_version ${VERSION})
vcpkg_download_distfile(ARCHIVE
    URLS "http://live555.com/liveMedia/public/live-latest.tar.gz"
    FILENAME "live.${format_version}.tar.gz"
    SHA512 78cedf67931b0227b7afed7a64c59db1e1dc7bc4ba5a2b7b4cc638bdf3a03c3bc04499bb4d7f5bdd692f53faca6f5a2a33295daf5bba1c153f66977465b61b8e
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
