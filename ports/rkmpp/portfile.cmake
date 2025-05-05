include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO nyanmisaka/mpp
    REF jellyfin-mpp
    SHA512 8ed6f8a6b7f28055ed22f548e7b92f2a807d74c3b0dc3c61c53fdd4d44f1014c79368a470b59430c0d6bc5b2486097f63423fe13aec431ba46f14a9b151adc94
    HEAD_REF jellyfin-mpp
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
      -DCMAKE_INSTALL_PREFIX:PATH=${CURRENT_PACKAGES_DIR}
      -DBUILD_SHARED_LIBS:BOOL=${FEATURE_SHARED}
      -DBUILD_TEST:BOOL=OFF
)

vcpkg_install_cmake()

# (Optional) Copy debugging symbols on Windows 
vcpkg_copy_pdbs()

file(INSTALL
    "${SOURCE_PATH}/pkgconfig/rockchip_mpp.pc.cmake"
    DESTINATION "${CURRENT_PACKAGES_DIR}/lib/pkgconfig"
    RENAME rockchip_mpp.pc)

file(INSTALL
    "${SOURCE_PATH}/pkgconfig/rockchip_vpu.pc.cmake"
    DESTINATION "${CURRENT_PACKAGES_DIR}/lib/pkgconfig"
    RENAME rockchip_vpu.pc)


# Install LICENSE
# file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/licenses)
