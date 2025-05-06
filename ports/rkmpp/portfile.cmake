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

# Install the license
#file(INSTALL ${SOURCE_PATH}/LICENSE
#     DESTINATION ${CURRENT_PACKAGES_DIR}/licenses)

# Only on Windows do we need to fix up .targets/.props & copy PDBs
if(VCPKG_TARGET_IS_WINDOWS)
    vcpkg_fixup_cmake_targets()
    vcpkg_copy_pdbs()
endif()

# ────────────────────────────────────────────────────────────────────
# Generate rockchip_mpp.pc for pkg-config
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/lib/pkgconfig)
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig)
set(_PC ${CURRENT_PACKAGES_DIR}/lib/pkgconfig/rockchip_mpp.pc)
set(_PC_debug ${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/rockchip_mpp.pc)
file(WRITE ${_PC}
    "prefix=${CURRENT_PACKAGES_DIR}\n"
    "exec_prefix=\${prefix}\n"
    "libdir=\${prefix}/lib\n"
    "includedir=\${prefix}/include\n\n"
    "Name: rockchip_mpp\n"
    "Description: Rockchip Media Process Platform (MPP)\n"
    "Version: 1.3.8\n"              # satisfy `>= 1.3.8`
    "Libs: -lrockchip_mpp\n"
    "Libs.private: -lstdc++ -lm\n"  # pull in guard helpers & math
    "Cflags: -I\${includedir}\n"
)

file(WRITE ${_PC_debug}
    "prefix=${CURRENT_PACKAGES_DIR}\n"
    "exec_prefix=\${prefix}\n"
    "libdir=\${prefix}/lib\n"
    "includedir=\${prefix}/include\n\n"
    "Name: rockchip_mpp\n"
    "Description: Rockchip Media Process Platform (MPP)\n"
    "Version: 1.3.8\n"              # satisfy `>= 1.3.8`
    "Libs: -lrockchip_mpp\n"
    "Libs.private: -lstdc++ -lm\n"  # pull in guard helpers & math
    "Cflags: -I\${includedir}\n"
)

set(_PC_vpu ${CURRENT_PACKAGES_DIR}/lib/pkgconfig/rockchip_vpu.pc)
set(_PC_vpu_debug ${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/rockchip_vpu.pc)
file(WRITE ${_PC_vpu}
    "prefix=${CURRENT_PACKAGES_DIR}\n"
    "exec_prefix=\${prefix}\n"
    "libdir=\${prefix}/lib\n"
    "includedir=\${prefix}/include\n\n"
    "Name: rockchip_vpu\n"
    "Description: Rockchip VPU\n"
    "Version: 1.3.8\n"              # satisfy `>= 1.3.8`
    "Libs: -lrockchip_vpu\n"
    "Libs.private: -lstdc++ -lm\n"  # pull in guard helpers & math
    "Cflags: -I\${includedir}\n"
)

file(WRITE ${_PC_vpu_debug}
    "prefix=${CURRENT_PACKAGES_DIR}\n"
    "exec_prefix=\${prefix}\n"
    "libdir=\${prefix}/lib\n"
    "includedir=\${prefix}/include\n\n"
    "Name: rockchip_vpu\n"
    "Description: Rockchip VPU\n"
    "Version: 1.3.8\n"              # satisfy `>= 1.3.8`
    "Libs: -lrockchip_vpu\n"
    "Libs.private: -lstdc++ -lm\n"  # pull in guard helpers & math
    "Cflags: -I\${includedir}\n"
)
# Normalize paths in .pc and hook in vcpkg’s pkgconfig handling
vcpkg_fixup_pkgconfig()

# ────────────────────────────────────────────────────────────────────
# Copy the built MPP library into the debug folder too, so -lrockchip_mpp
# actually resolves when FFmpeg’s debug configure/link runs.
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/lib)
file(GLOB MPP_LIBS "${CURRENT_PACKAGES_DIR}/lib/librockchip_mpp.*")
file(COPY ${MPP_LIBS} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
file(GLOB VPU_LIBS "${CURRENT_PACKAGES_DIR}/lib/librockchip_vpu.*")
file(COPY ${VPU_LIBS} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
# ────────────────────────────────────────────────────────────────────


# ────────────────────────────────────────────────────────────────────