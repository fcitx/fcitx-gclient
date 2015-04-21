cmake_minimum_required(VERSION 3.0)

set(FCITX_VERSION "4.99")
project(fcitx-gclient VERSION ${FCITX_VERSION})

find_package(ECM 0.0.11 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})
set(CMAKE_AUTOMOC_RELAXED_MODE TRUE)

include(CMakeFindDependencyMacro)
include(FeatureSummary)
include(ECMSetupVersion)
include(ECMGenerateHeaders)
include(ECMOptionalAddSubdirectory)
include(ECMCoverageOption)
include(GenerateExportHeader)

option(WITH_GIR "Build GIR" On)

if(NOT NO_SNOOPER_APPS)
  set(NO_SNOOPER_APPS ".*chrome.*,.*chromium.*,firefox.*,Do.*"
    CACHE STRING "Disable Key Snooper for following app")
endif()

include(CheckCCompilerFlag)

check_c_compiler_flag("-std=c99" C99_SUPPORTED)
if (NOT C99_SUPPORTED)
    message(FATAL_ERROR "C99 is required to compile Fcitx.")
endif()

include(GNUInstallDirs)
include(Utils)

# directory needed by bsd
if(NOT CMAKE_INSTALL_LIBDATADIR)
  set(CMAKE_INSTALL_LIBDATADIR "${CMAKE_INSTALL_LIBDIR}" CACHE PATH "libdata root (LIBDIR)")
  set(CMAKE_INSTALL_LIBDATADIR "${CMAKE_INSTALL_LIBDIR}")
  mark_as_advanced(CMAKE_INSTALL_LIBDATADIR)
endif()
if (NOT IS_ABSOLUTE ${CMAKE_INSTALL_LIBDATADIR})
set(CMAKE_INSTALL_FULL_LIBDATADIR "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDATADIR}")
else()
set(CMAKE_INSTALL_FULL_LIBDATADIR "${CMAKE_INSTALL_LIBDATADIR}")
endif()

# TODO mac/win
set(FCITX_LIBRARY_SUFFIX ".so")

# process rpath
list(FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${CMAKE_INSTALL_FULL_LIBDIR}" _isSystemPlatformLibDir)
list(FIND CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES "${CMAKE_INSTALL_FULL_LIBDIR}" _isSystemCxxLibDir)
if("${_isSystemPlatformLibDir}" STREQUAL "-1" AND "${_isSystemCxxLibDir}" STREQUAL "-1")
    set(CMAKE_SKIP_BUILD_RPATH  FALSE)
    set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
    set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_LIBDIR}")
    set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
endif("${_isSystemPlatformLibDir}" STREQUAL "-1" AND "${_isSystemCxxLibDir}" STREQUAL "-1")

find_package(PkgConfig REQUIRED)
find_package(X11)
find_package(GTK2)
find_package(GTK3)
find_package(XKBCommon COMPONENTS XKBCommon)
find_package(GLib2 REQUIRED)
find_package(Gio2 REQUIRED)
find_package(GObject2 REQUIRED)
find_package(Fcitx 4.99 REQUIRED COMPONENTS Core)
if (ENABLE_GIR)
find_package(GObjectIntrospection)
endif()

set(CMAKE_C_FLAGS "-fPIC -std=c99 -Wall -Wextra -fvisibility=hidden ${CMAKE_C_FLAGS}")
set(CMAKE_SHARED_LINKER_FLAGS "-Wl,--as-needed -Wl,--no-undefined ${CMAKE_SHARED_LINKER_FLAGS}")
set(CMAKE_MODULE_LINKER_FLAGS "-Wl,--as-needed -Wl,--no-undefined ${CMAKE_MODULE_LINKER_FLAGS}")

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/config.h.in ${CMAKE_CURRENT_BINARY_DIR}/config.h)
include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_subdirectory(src)

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
