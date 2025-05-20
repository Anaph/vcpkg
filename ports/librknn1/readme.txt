airockchip/rknpu1 
Supports
    RK1808/RK1806
    RV1109/RV1126


Some commands

find_library(RKNNRT_LIB librknnrt PATHS "${CMAKE_CURRENT_LIST_DIR}/lib")
target_link_libraries(my_target PRIVATE ${RKNNRT_LIB})


vcpkg_download_distfile(
    ARCHIVE
    URLS "https://example.com/rknnrt-1.0.0.tar.gz"
    FILENAME "rknnrt-1.0.0.tar.gz"
    SHA512 1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef
)



vcpkg install librknnrt --triplet arm64-linux