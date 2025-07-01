set(VCPKG_TARGET_ARCHITECTURE    arm)
set(VCPKG_CRT_LINKAGE            dynamic)
set(VCPKG_LIBRARY_LINKAGE        static)

set(VCPKG_CMAKE_SYSTEM_NAME      Linux)
set(VCPKG_CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_TOOLCHAIN_PATH your_path)

# <-- chain-load the pure CMake toolchain file you just made:
set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE
    ${CMAKE_TOOLCHAIN_PATH}/toolchain.cmake)

# <--- ADD THESE TWO LINES: real cross‐compiler prefix -------->
set(VCPKG_CROSS_COMPILER_TARGET arm-linux-gnueabihf)
set(VCPKG_CROSS_COMPILER_PREFIX ${CMAKE_TOOLCHAIN_PATH}/rv1126_gcc_linux_x86_arm/prebuilts/gcc/linux-x86/arm/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/arm-linux-gnueabihf-)
# -------------------------------------------------------------

# set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE
#     "/home/anaph/workspace/build_rv1126_brownai-main-prebuilts-gcc-linux-x86-arm/prebuilts/gcc/linux-x86/arm/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/armv7-cross.ini"
#     CACHE STRING "")