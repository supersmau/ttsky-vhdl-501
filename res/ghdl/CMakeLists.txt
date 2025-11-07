# Setup cmake minimum version
cmake_minimum_required(VERSION 3.1...3.15)

if(${CMAKE_VERSION} VERSION_LESS 3.15)
    cmake_policy(VERSION ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION})
endif()

project(sampler)
include(cmake/macros.cmake)
include(cmake/test_macros.cmake)
enable_testing()

add_custom_target(check COMMAND ${CMAKE_CTEST_COMMAND})
set(SRC "src")

add_sources(
    ${SRC}/top.vhd
    ${SRC}/sampler.vhd
)

add_subdirectory(test)
add_custom_target(index COMMAND ghdl -i --workdir=${CMAKE_BINARY_DIR} ${VHDL_SOURCES})
