cmake_minimum_required(VERSION 3.5)
project(live555 C CXX)

add_compile_definitions(NO_STD_LIB)
set(CMAKE_CXX_STANDARD 17)
include_directories(
    BasicUsageEnvironment/include
    groupsock/include
    liveMedia/include
    UsageEnvironment/include
)


# set(CMAKE_THREAD_LIBS_INIT -pthread CACHE STRING "Thread libraries" FORCE)
# Force CMake to consider threads found
# set(CMAKE_HAVE_THREADS_LIBRARY 1 CACHE INTERNAL "Have threads library" FORCE)
# set(Threads_FOUND TRUE CACHE BOOL "Threads found" FORCE)
# find_package(Threads REQUIRED)

if (WIN32)
    add_definitions(-DNO_GETIFADDRS)
endif(WIN32)

if (NOT MSVC)
    add_compile_options(-DSOCKLEN_T=socklen_t)
endif()

if (CMAKE_SYSTEM_NAME MATCHES "Darwin")
   add_compile_options(-DBSD=1)
   add_compile_options(-DHAVE_SOCKADDR_LEN=1)
   add_compile_options(-DTIME_BASE=int)
   add_compile_options(-DNEED_XLOCALE_H=1)
endif()

add_compile_options(-fPIC)


# add_compile_options(-DSOCKLEN_T=socklen_t) 
# add_compile_options(-DNO_SSTREAM=1) 
# add_compile_options(-D_LARGEFILE_SOURCE=1) 
# add_compile_options(-D_FILE_OFFSET_BITS=64)
# add_compile_options(-O )

file(GLOB BASIC_USAGE_ENVIRONMENT_SRCS BasicUsageEnvironment/*.c BasicUsageEnvironment/*.cpp)
add_library(BasicUsageEnvironment ${BASIC_USAGE_ENVIRONMENT_SRCS})
target_include_directories(BasicUsageEnvironment PUBLIC $<INSTALL_INTERFACE:include>)

file(GLOB GROUPSOCK_SRCS groupsock/*.c groupsock/*.cpp)
add_library(groupsock ${GROUPSOCK_SRCS})
target_include_directories(groupsock PUBLIC $<INSTALL_INTERFACE:include>)

file(GLOB LIVEMEDIA_SRCS liveMedia/*.c liveMedia/*.cpp)
add_library(liveMedia ${LIVEMEDIA_SRCS})
find_package(OpenSSL REQUIRED)
target_include_directories(liveMedia PRIVATE "${OPENSSL_INCLUDE_DIR}" PUBLIC $<INSTALL_INTERFACE:include>)
target_link_libraries(liveMedia  OpenSSL::SSL OpenSSL::Crypto)

file(GLOB USAGE_ENVIRONMENT_SRCS UsageEnvironment/*.c UsageEnvironment/*.cpp)
add_library(UsageEnvironment ${USAGE_ENVIRONMENT_SRCS})
target_include_directories(UsageEnvironment PUBLIC $<INSTALL_INTERFACE:include>)

file(WRITE "${CMAKE_BINARY_DIR}/unofficial-live555-config.cmake"
[[
include(CMakeFindDependencyMacro)

find_dependency(OpenSSL)

include("${CMAKE_CURRENT_LIST_DIR}/unofficial-live555-targets.cmake")
]]
)

install(FILES "${CMAKE_BINARY_DIR}/unofficial-live555-config.cmake" DESTINATION share/unofficial-live555)

install(TARGETS groupsock BasicUsageEnvironment liveMedia UsageEnvironment
    EXPORT unofficial-live555-targets
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

install(
    EXPORT unofficial-live555-targets
    FILE unofficial-live555-targets.cmake
    NAMESPACE unofficial::
    DESTINATION share/unofficial-live555
)
