vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO JeffyCN/rockchip_mirrors
    REF gstreamer-rockchip
    SHA512 e1cbfb9b02132dbc7a22ee88606a85ca76e30058da97c41bb493363cbbea4eafb77295bdbc73bec6e60b483124ad64d4059bf79fb54191b897b89ad29f2cd55d
)

# set(OUT_FEATURE_OPTIONS "")
# vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURES)

# Set up environment variables for building
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -I${SOURCE_PATH}/include")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -L${SOURCE_PATH}/lib")


# Configure, build, and install using Meson
vcpkg_configure_meson(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        --prefix=${CURRENT_PACKAGES_DIR}
)

vcpkg_install_meson()

# Remove unnecessary files (if necessary)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share)