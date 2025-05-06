include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO           nyanmisaka/rk-mirrors
    REF            jellyfin-rga-next
    SHA512         d611cdd9557fc07bb3786a4cbaeb91263e70172eb764c9349b101707018517a976b2db8c96dbe41825c33b79841b1c8d0fcac44fb8ef20b4bc76f8e42a361f72
    HEAD_REF       jellyfin-rga-next
)

# ────────────────────────────────────────────────────────────────
# Patch NormalRga.cpp & im2d_impl.cpp for uintptr_t casts
file(READ   ${SOURCE_PATH}/core/NormalRga.cpp _nr)
string(REPLACE
    "#include \"NormalRga.h\""
    "#include <cstdint>\n#include \"NormalRga.h\""
    _nr "${_nr}"
)
string(REGEX REPLACE
    "\\(unsigned int\\)*([A-Za-z_][A-Za-z0-9_]*)"
    "(unsigned int)(uintptr_t)\\1"
    _nr "${_nr}"
)
file(WRITE  ${SOURCE_PATH}/core/NormalRga.cpp "${_nr}")

file(READ   ${SOURCE_PATH}/im2d_api/src/im2d_impl.cpp _im2)
string(REPLACE
    "#include \"NormalRga.h\""
    "#include <cstdint>\n#include \"NormalRga.h\""
    _im2 "${_im2}"
)
string(REGEX REPLACE
    "\\(unsigned int\\)*([A-Za-z_][A-Za-z0-9_]*)"
    "(unsigned int)(uintptr_t)\\1"
    _im2 "${_im2}"
)
file(WRITE  ${SOURCE_PATH}/im2d_api/src/im2d_impl.cpp "${_im2}")
# ────────────────────────────────────────────────────────────────

# ────────────────────────────────────────────────────────────────
# Patch meson.build: inject -fpermissive and disable werror
file(READ   ${SOURCE_PATH}/meson.build _meson)
string(REPLACE
    "cpp_args : ['-w']"
    "cpp_args : ['-w', '-fpermissive']"
    _meson "${_meson}"
)
file(WRITE  ${SOURCE_PATH}/meson.build "${_meson}")
# ────────────────────────────────────────────────────────────────

vcpkg_check_features(
    OUT_FEATURE_OPTIONS _FEATURE_OPTIONS
    FEATURES shared static
)

if(FEATURE_SHARED)
    set(_DEFAULT_LIB "shared")
else()
    set(_DEFAULT_LIB "static")
endif()

vcpkg_configure_meson(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
      --prefix=${CURRENT_PACKAGES_DIR}
      --libdir=lib
      -Ddefault_library=${_DEFAULT_LIB}
      -Dlibdrm=false
      -Dlibrga_demo=false
      -Dwerror=false
      -Dwarning_level=2
)

vcpkg_install_meson()

# ────────────────────────────────────────────────────────────────────
# Generate pkg-config so 'pkg-config --libs librga' works
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/lib/pkgconfig)
set(_PC ${CURRENT_PACKAGES_DIR}/lib/pkgconfig/librga.pc)
file(WRITE ${_PC}
    "prefix=${CURRENT_PACKAGES_DIR}\n"
    "exec_prefix=\${prefix}\n"
    "libdir=\${prefix}/lib\n"
    "includedir=\${prefix}/include\n\n"
    "Name: librga\n"
    "Description: Rockchip Raster Graphic Acceleration (RGA)\n"
    "Version: 2.1.0\n"
    "Libs: -lrga\n"
    "Libs.private: -lstdc++ -lm\n"
    "Cflags: -I\${includedir}\n"
)

set(_PC_ALSO ${CURRENT_PACKAGES_DIR}/lib/pkgconfig/rockchip_rga.pc)
file(WRITE ${_PC_ALSO}
    "prefix=${CURRENT_PACKAGES_DIR}\n"
    "exec_prefix=\${prefix}\n"
    "libdir=\${prefix}/lib\n"
    "includedir=\${prefix}/include\n\n"
    "Name: librga\n"
    "Description: Rockchip Raster Graphic Acceleration (RGA)\n"
    "Version: 2.1.0\n"
    "Libs: -lrga\n"
    "Libs.private: -lstdc++ -lm\n"
    "Cflags: -I\${includedir}\n"
)

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig)
set(_PC_debug ${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/librga.pc)
file(WRITE ${_PC_debug}
    "prefix=${CURRENT_PACKAGES_DIR}\n"
    "exec_prefix=\${prefix}\n"
    "libdir=\${prefix}/lib\n"
    "includedir=\${prefix}/include\n\n"
    "Name: librga\n"
    "Description: Rockchip Raster Graphic Acceleration (RGA)\n"
    "Version: 2.1.0\n"
    "Libs: -lrga\n"
    "Libs.private: -lstdc++ -lm\n"
    "Cflags: -I\${includedir}\n"
)

set(_PC_debug_ALSO ${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/rockchip_rga.pc)
file(WRITE ${_PC_debug_ALSO}
    "prefix=${CURRENT_PACKAGES_DIR}\n"
    "exec_prefix=\${prefix}\n"
    "libdir=\${prefix}/lib\n"
    "includedir=\${prefix}/include\n\n"
    "Name: librga\n"
    "Description: Rockchip Raster Graphic Acceleration (RGA)\n"
    "Version: 2.1.0\n"
    "Libs: -lrga\n"
    "Libs.private: -lstdc++ -lm\n"
    "Cflags: -I\${includedir}\n"
)

vcpkg_fixup_pkgconfig()
# ────────────────────────────────────────────────────────────────────

# ────────────────────────────────────────────────────────────────────
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/lib)
file(GLOB RGA_LIBS "${CURRENT_PACKAGES_DIR}/lib/librga.*")
file(COPY ${RGA_LIBS} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
# ────────────────────────────────────────────────────────────────────

# Install license
file(INSTALL ${SOURCE_PATH}/COPYING
     DESTINATION ${CURRENT_PACKAGES_DIR}/licenses)

if(VCPKG_TARGET_IS_WINDOWS)
    vcpkg_fixup_cmake_targets()
    vcpkg_copy_pdbs()
endif()
