include(vcpkg_common_functions)

# 1) Download the libdrm-2.4.124 tarball
vcpkg_download_distfile(ARCHIVE
    URLS "https://dri.freedesktop.org/libdrm/libdrm-2.4.100.tar.gz"
    FILENAME "libdrm-2.4.100.tar.gz"
    SHA512 b61835473c77691c4a8e67b32b9df420661e8bf8700507334b58bde5e6a402dee4aea2bec1e5b83343dd28fcb6cf9fd084064d437332f178df81c4780552595b
    PATCHES
        disable-tests.patch
    )

# 2) Extract it
vcpkg_extract_source_archive(SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
)

# 2) Wipe the entire tests/ tree so no leftover Makefile.in ever lingers
# file(REMOVE_RECURSE "${SOURCE_PATH}/tests")

# 2a) Remove the upstream tests directory completely
file(REMOVE_RECURSE "${SOURCE_PATH}/tests")

# 2b) Recreate it with a no-op Makefile.in so Autoconf won't complain
file(REMOVE_RECURSE "${SOURCE_PATH}/tests")
file(MAKE_DIRECTORY   "${SOURCE_PATH}/tests")
file(WRITE           "${SOURCE_PATH}/tests/Makefile.in" 
"all:\n"
"\t@echo \"== libdrm tests disabled by vcpkg ==\"\n\n"
"install:\n"
"\t@echo \"== libdrm tests: nothing to install ==\"\n\n"
"uninstall:\n"
"\t@echo \"== libdrm tests: nothing to uninstall ==\"\n"
)

file(MAKE_DIRECTORY   "${SOURCE_PATH}/tests/modeprint")
file(WRITE           "${SOURCE_PATH}/tests/modeprint/Makefile.in" 
"all:\n\t@echo \"== libdrm tests disabled by vcpkg ==\"\n")

file(MAKE_DIRECTORY   "${SOURCE_PATH}/tests/modetest")
file(WRITE           "${SOURCE_PATH}/tests/modetest/Makefile.in" 
"all:\n\t@echo \"== libdrm tests disabled by vcpkg ==\"\n")

file(MAKE_DIRECTORY   "${SOURCE_PATH}/tests/kms")
file(WRITE           "${SOURCE_PATH}/tests/kms/Makefile.in" 
"all:\n\t@echo \"== libdrm tests disabled by vcpkg ==\"\n")

file(MAKE_DIRECTORY   "${SOURCE_PATH}/tests/kmstest")
file(WRITE           "${SOURCE_PATH}/tests/kmstest/Makefile.in" 
"all:\n\t@echo \"== libdrm tests disabled by vcpkg ==\"\n")

file(MAKE_DIRECTORY   "${SOURCE_PATH}/tests/proptest")
file(WRITE           "${SOURCE_PATH}/tests/proptest/Makefile.in" 
"all:\n\t@echo \"== libdrm tests disabled by vcpkg ==\"\n")

file(MAKE_DIRECTORY   "${SOURCE_PATH}/tests/radeon")
file(WRITE           "${SOURCE_PATH}/tests/radeon/Makefile.in" 
"all:\n\t@echo \"== libdrm tests disabled by vcpkg ==\"\n")

file(MAKE_DIRECTORY   "${SOURCE_PATH}/tests/amdgpu")
file(WRITE           "${SOURCE_PATH}/tests/amdgpu/Makefile.in" 
"all:\n\t@echo \"== libdrm tests disabled by vcpkg ==\"\n")


file(MAKE_DIRECTORY   "${SOURCE_PATH}/tests/vbltest")
file(WRITE           "${SOURCE_PATH}/tests/vbltest/Makefile.in" 
"all:\n\t@echo \"== libdrm tests disabled by vcpkg ==\"\n")

file(MAKE_DIRECTORY   "${SOURCE_PATH}/tests/exynos")
file(WRITE           "${SOURCE_PATH}/tests/exynos/Makefile.in" 
"all:\n\t@echo \"== libdrm tests disabled by vcpkg ==\"\n")

file(MAKE_DIRECTORY   "${SOURCE_PATH}/tests/tegra")
file(WRITE           "${SOURCE_PATH}/tests/tegra/Makefile.in" 
"all:\n\t@echo \"== libdrm tests disabled by vcpkg ==\"\n")


file(MAKE_DIRECTORY   "${SOURCE_PATH}/tests/nouveau")
file(WRITE           "${SOURCE_PATH}/tests/nouveau/Makefile.in" 
"all:\n\t@echo \"== libdrm tests disabled by vcpkg ==\"\n")

file(MAKE_DIRECTORY   "${SOURCE_PATH}/tests/intel")
file(WRITE           "${SOURCE_PATH}/tests/intel/Makefile.in" 
"all:\n\t@echo \"== libdrm tests disabled by vcpkg ==\"\n")


file(MAKE_DIRECTORY   "${SOURCE_PATH}/tests/omap")
file(WRITE           "${SOURCE_PATH}/tests/omap/Makefile.in" 
"all:\n\t@echo \"== libdrm tests disabled by vcpkg ==\"\n")

file(MAKE_DIRECTORY   "${SOURCE_PATH}/tests/freedreno")
file(WRITE           "${SOURCE_PATH}/tests/freedreno/Makefile.in" 
"all:\n\t@echo \"== libdrm tests disabled by vcpkg ==\"\n")

file(MAKE_DIRECTORY   "${SOURCE_PATH}/tests/vc4")
file(WRITE           "${SOURCE_PATH}/tests/vc4/Makefile.in" 
"all:\n\t@echo \"== libdrm tests disabled by vcpkg ==\"\n")

file(MAKE_DIRECTORY   "${SOURCE_PATH}/tests/etnaviv")
file(WRITE           "${SOURCE_PATH}/tests/etnaviv/Makefile.in" 
"all:\n\t@echo \"== libdrm tests disabled by vcpkg ==\"\n")

file(MAKE_DIRECTORY   "${SOURCE_PATH}/tests/util")
file(WRITE           "${SOURCE_PATH}/tests/util/Makefile.in" 
"all:\n\t@echo \"== libdrm tests disabled by vcpkg ==\"\n")

set(CFLAGS   "-O2 -fPIC ${CFLAGS}")
set(CXXFLAGS "-O2 -fPIC ${CXXFLAGS}")

# 3) Actually configure & build
vcpkg_configure_make(
    SOURCE_PATH             ${SOURCE_PATH}
    DETERMINE_BUILD_TRIPLET
    NO_ADDITIONAL_PATHS

    OPTIONS
    --disable-silent-rules
    --verbose
    --disable-shared
    --with-pic
    --enable-static
    --disable-dependency-tracking
    --disable-install-test-programs
)

vcpkg_install_make()



file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/lib/pkgconfig)
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig)
set(_PC ${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libdrm.pc)
set(_PC_debug ${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libdrm.pc)


file(WRITE ${_PC}
    "prefix=${CURRENT_PACKAGES_DIR}\n"
    "exec_prefix=\${prefix}\n"
    "libdir=\${exec_prefix}/lib\n"
    "includedir=\${prefix}/include\n"
    "Name: libdrm\n"
    "Description: Userspace interface to kernel DRM services\n"
    "Version: 2.4.124\n"
    "Libs: -L\${libdir} -ldrm -lm\n"
    "Cflags: -I\${includedir} -I\${includedir}/libdrm\n"

)

file(WRITE ${_PC_debug}
    "prefix=${CURRENT_PACKAGES_DIR}\n"
    "exec_prefix=\${prefix}\n"
    "libdir=\${exec_prefix}/lib\n"
    "includedir=\${prefix}/include\n"
    "Name: libdrm\n"
    "Description: Userspace interface to kernel DRM services\n"
    "Version: 2.4.124\n"
    "Libs: -L\${libdir} -ldrm -lm\n"
    "Cflags: -I\${includedir} -I\${includedir}/libdrm\n"

)

set(_PC ${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libkms.pc)
set(_PC_debug ${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libkms.pc)


file(WRITE ${_PC}
    "prefix=${CURRENT_PACKAGES_DIR}\n"
    "exec_prefix=\${prefix}\n"
    "libdir=\${exec_prefix}/lib\n"
    "includedir=\${prefix}/include\n"
    "Name: libdrm\n"
    "Description: Library that abstract aways the different mm interface for kernel drivers\n"
    "Version: 1.0.0\n"
    "Libs: -L\${libdir} -lkms\n"
    "Cflags: -I\${includedir}/libkms\n"

)

file(WRITE ${_PC_debug}
    "prefix=${CURRENT_PACKAGES_DIR}\n"
    "exec_prefix=\${prefix}\n"
    "libdir=\${exec_prefix}/lib\n"
    "includedir=\${prefix}/include\n"
    "Name: libdrm\n"
    "Description: Library that abstract aways the different mm interface for kernel drivers\n"
    "Version: 1.0.0\n"
    "Libs: -L\${libdir} -lkms\n"
    "Cflags:  -I\${includedir}/libkms\n"

)


# Normalize paths in .pc and hook in vcpkg’s pkgconfig handling
vcpkg_fixup_pkgconfig()

# ────────────────────────────────────────────────────────────────────
# Copy the built MPP library into the debug folder too, so -lrockchip_mpp
# actually resolves when FFmpeg’s debug configure/link runs.
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/lib)
file(GLOB MPP_LIBS "${CURRENT_PACKAGES_DIR}/lib/libdrm.*")
file(COPY ${MPP_LIBS} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
file(GLOB VPU_LIBS "${CURRENT_PACKAGES_DIR}/lib/libkms.*")
file(COPY ${VPU_LIBS} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
# ────────────────────────────────────────────────────────────────────

vcpkg_copy_pdbs()
