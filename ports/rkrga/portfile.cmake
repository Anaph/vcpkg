include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO           nyanmisaka/rk-mirrors
    REF            jellyfin-rga-next
    SHA512         d611cdd9557fc07bb3786a4cbaeb91263e70172eb764c9349b101707018517a976b2db8c96dbe41825c33b79841b1c8d0fcac44fb8ef20b4bc76f8e42a361f72
    HEAD_REF       jellyfin-rga-next
)

# ────────────────────────────────────────────────────────────────
# 1) Patch NormalRga.cpp: include <cstdint> and funnel all (unsigned int)ptr
#    casts through uintptr_t so they no longer lose bits.
file(READ   ${SOURCE_PATH}/core/NormalRga.cpp _nr)
string(REPLACE
    "#include \"NormalRga.h\""
    "#include <cstdint>\n#include \"NormalRga.h\""
    _nr
    "${_nr}"
)
# replace every “(unsigned int)foo” with “(unsigned int)(uintptr_t)foo”
string(REGEX REPLACE
    "\\(unsigned int\\)*([A-Za-z_][A-Za-z0-9_]*)"
    "(unsigned int)(size_t)\\1"
    _nr
    "${_nr}"
)
file(WRITE  ${SOURCE_PATH}/core/NormalRga.cpp "${_nr}")
# ────────────────────────────────────────────────────────────────

# ────────────────────────────────────────────────────────────────
# 1) Patch NormalRga.cpp: include <cstdint> and funnel all (unsigned int)ptr
#    casts through uintptr_t so they no longer lose bits.
file(READ   ${SOURCE_PATH}/im2d_api/src/im2d_impl.cpp _im2)
string(REPLACE
    "#include \"NormalRga.h\""
    "#include <cstdint>\n#include \"NormalRga.h\""
    _im2
    "${_im2}"
)
# replace every “(unsigned int)foo” with “(unsigned int)(uintptr_t)foo”
string(REGEX REPLACE
    "\\(unsigned int\\)*([A-Za-z_][A-Za-z0-9_]*)"
    "(unsigned int)(size_t)\\1"
    _im2
    "${_im2}"
)
file(WRITE  ${SOURCE_PATH}/im2d_api/src/im2d_impl.cpp "${_im2}")
# ────────────────────────────────────────────────────────────────



# Determine whether we want shared or static only
if(FEATURE_SHARED)
    set(_DEFAULT_LIB "shared")
else()
    set(_DEFAULT_LIB "static")


# ────────────────────────────────────────────────────────────────
# Patch RGA’s own meson.build so that all cpp_args = ['-w','-fpermissive']
file(READ   ${SOURCE_PATH}/meson.build _rga_meson2)
string(REPLACE
    "
librga = shared_library(
    'rga',
    librga_srcs,
    dependencies : [libthreads_dep],
	include_directories : incdir,
    version : meson.project_version(),
    cpp_args : ['-w'],
    install : true,
)"
    "librga = static_library(
    'rga',
    librga_srcs,
    dependencies : [libthreads_dep],
        include_directories : incdir,
    cpp_args : ['-w'],
    install : true,
)"
    _rga_meson2
    "${_rga_meson2}"
)
file(WRITE  ${SOURCE_PATH}/meson.build "${_rga_meson2}")
# ────────────────────────────────────────────────────────────────

endif()


# ────────────────────────────────────────────────────────────────
# Patch RGA’s own meson.build so that all cpp_args = ['-w','-fpermissive']
file(READ   ${SOURCE_PATH}/meson.build _rga_meson)
string(REPLACE
    "cpp_args : ['-w']"
    "cpp_args : ['-w', '-fpermissive']"
    _rga_meson
    "${_rga_meson}"
)
file(WRITE  ${SOURCE_PATH}/meson.build "${_rga_meson}")
# ────────────────────────────────────────────────────────────────



vcpkg_check_features(
    OUT_FEATURE_OPTIONS _FEATURE_OPTIONS
    FEATURES shared static
)


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


# Generate rockchip_rga.pc for pkg-config
file(WRITE "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/rockchip_rga.pc" 
"prefix=${CURRENT_PACKAGES_DIR}
exec_prefix=\${prefix}
libdir=\${prefix}/lib
includedir=\${prefix}/include

Name: rockchip_rga
Description: Rockchip 2D Raster Graphic Acceleration
Version: 1.10.1
Libs: -L\${libdir} -lrga
Cflags: -I\${includedir}
")

# Install license
file(INSTALL ${SOURCE_PATH}/COPYING
     DESTINATION ${CURRENT_PACKAGES_DIR}/licenses)

if(VCPKG_TARGET_IS_WINDOWS)
    vcpkg_fixup_cmake_targets()
    vcpkg_copy_pdbs()
endif()
