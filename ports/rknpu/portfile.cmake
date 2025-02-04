vcpkg_download_distfile(
    RKNPU
    URLS "https://github.com/rockchip-linux/rknpu/archive/refs/tags/v1.7.3.zip"
    FILENAME "rknpu-1.7.3.zip"
    SHA512 SHA512 d72f3616a05166368e3642cb2a3a42227c7d9e0eba994ce58691d9711fef51172783b8439a1d88187f5cbb4889de1210341890db72bc97ef5ee67e39659e88f5
)

# Extract the downloaded archive
vcpkg_extract_source_archive(
    OUT_SOURCE_PATH 
    ARCHIVE ${DOWNLOADS}/rknpu-1.7.3.zip
)

# Install the necessary headers, libraries, and executables
file(GLOB HEADER_FILES "${OUT_SOURCE_PATH}/rknn/include/*.h")
file(COPY ${HEADER_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/include/rknn)
file(GLOB BINARY_FILES "${OUT_SOURCE_PATH}/drivers/linux-armhf-puma/usr/bin/*")
file(COPY ${BINARY_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/bin/rknn)
file(GLOB LIBRARY_FILES "${OUT_SOURCE_PATH}/drivers/linux-armhf-puma/usr/lib/*")
file(COPY ${LIBRARY_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/lib/rknn)
# Install documentation
file(INSTALL "${OUT_SOURCE_PATH}/rknn/doc" DESTINATION ${CURRENT_PACKAGES_DIR}/share/rknn)

# Clean up unnecessary files
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/rknpu/.git)
