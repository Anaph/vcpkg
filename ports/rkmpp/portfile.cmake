include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Anaph/mpp
    REF jellyfin-mpp-next
    SHA512 f40768167f3ba0b960ef07a847309f9fab999b326cbb41b314d29770b7ed371831083cfe1bfc7992b49eb892767124f08a02fdc6f8b4610b646824d02e4ca8c9
    HEAD_REF jellyfin-mpp-next
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    DETERMINE_BUILD_TRIPLET

    OPTIONS
      -DCMAKE_INSTALL_PREFIX:PATH=${CURRENT_PACKAGES_DIR}
      -DBUILD_SHARED_LIBS:BOOL=OFF
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
    "Version: 1.3.9\n"              # satisfy `>= 1.3.8`
    "Libs: -L${libdir} -lrockchip_mpp\n"
    "Libs.private: \n"  # pull in guard helpers & math
    "Cflags: -I\${includedir}\n"
)

file(WRITE ${_PC_debug}
    "prefix=${CURRENT_PACKAGES_DIR}\n"
    "exec_prefix=\${prefix}\n"
    "libdir=\${prefix}/lib\n"
    "includedir=\${prefix}/include\n\n"
    "Name: rockchip_mpp\n"
    "Description: Rockchip Media Process Platform (MPP)\n"
    "Version: 1.3.9\n"              # satisfy `>= 1.3.8`
    "Libs: -L${libdir} -lrockchip_mpp\n"
    "Libs.private: \n"  # pull in guard helpers & math
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
    "Version: 0.3.1\n"              # satisfy `>= 1.3.8`
    "Libs: -L${libdir} -lrockchip_vpu\n"
    "Libs.private: \n"  # pull in guard helpers & math
    "Cflags: -I\${includedir}\n"
)

file(WRITE ${_PC_vpu_debug}
    "prefix=${CURRENT_PACKAGES_DIR}\n"
    "exec_prefix=\${prefix}\n"
    "libdir=\${prefix}/lib\n"
    "includedir=\${prefix}/include\n\n"
    "Name: rockchip_vpu\n"
    "Description: Rockchip VPU\n"
    "Version: 0.3.1\n"              # satisfy `>= 1.3.8`
    "Libs: -L${libdir} -lrockchip_vpu\n"
    "Libs.private: \n"  # pull in guard helpers & math
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