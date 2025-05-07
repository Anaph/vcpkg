# triplets/community/arm-linux-gnueabihf.cmake

# Target architecture
set(VCPKG_TARGET_ARCHITECTURE arm)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)
# Use Linux as the target OS
set(VCPKG_CMAKE_SYSTEM_NAME Linux)
# set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
# set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Optional: if you need a minimum kernel version
# set(VCPKG_CMAKE_SYSTEM_VERSION 1)

set(CMAKE_SYSROOT "/home/anaph/workspace/build_rv1126_brownai-main-prebuilts-gcc-linux-x86-arm/prebuilts/gcc/linux-x86/arm/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/libc")
# Point at your cross-compiler binaries:
# (make sure these names are on your PATH, or give full paths)
set(VCPKG_CMAKE_C_COMPILER   "/home/anaph/workspace/build_rv1126_brownai-main-prebuilts-gcc-linux-x86-arm/prebuilts/gcc/linux-x86/arm/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc")
set(VCPKG_CMAKE_CXX_COMPILER "/home/anaph/workspace/build_rv1126_brownai-main-prebuilts-gcc-linux-x86-arm/prebuilts/gcc/linux-x86/arm/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf-g++")
set(VCPKG_CMAKE_AR           "/home/anaph/workspace/build_rv1126_brownai-main-prebuilts-gcc-linux-x86-arm/prebuilts/gcc/linux-x86/arm/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc-ar")
set(VCPKG_CMAKE_RANLIB       "/home/anaph/workspace/build_rv1126_brownai-main-prebuilts-gcc-linux-x86-arm/prebuilts/gcc/linux-x86/arm/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc-ranlib")
set(VCPKG_CMAKE_NM           "/home/anaph/workspace/build_rv1126_brownai-main-prebuilts-gcc-linux-x86-arm/prebuilts/gcc/linux-x86/arm/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc-nm")
# If you have an Obj-copy or Windres:
# set(VCPKG_CMAKE_OBJCOPY      arm-linux-gnueabihf-objcopy)
# set(VCPKG_CMAKE_RC_COMPILER  arm-linux-gnueabihf-windres)

# Disable any built-in MSVC/Clang-CL logic
set(VCPKG_CMAKE_SYSTEM_PROCESSOR arm)

# Tell vcpkg not to chain-load another toolchain file:
set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "" CACHE STRING "")
