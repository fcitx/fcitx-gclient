find_package(PkgConfig)

pkg_check_modules(PKG_GTK2 QUIET gtk+-2.0)
pkg_check_variable(GTK2_BINARY_VERSION gtk+-2.0 gtk_binary_version)
mark_as_advanced(GTK2_BINARY_VERSION)

set(GTK2_DEFINITIONS ${PKG_GTK2_CFLAGS_OTHER})
set(GTK2_VERSION ${PKG_GTK2_VERSION})

find_path(GTK2_INCLUDE_DIR
    NAMES gtk/gtk.h
    HINTS ${PKG_GTK2_INCLUDE_DIRS}
)

find_library(GTK2_LIBRARY
    NAMES gtk-x11-2.0
    HINTS ${PKG_GTK2_LIBRARY_DIRS}
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GTK2
    FOUND_VAR
        GTK2_FOUND
    REQUIRED_VARS
        GTK2_LIBRARY
        GTK2_INCLUDE_DIR
        GTK2_BINARY_VERSION
    VERSION_VAR
        GTK2_VERSION
)

if(GTK2_FOUND AND NOT TARGET GTK2::gtk)
    add_library(GTK2::gtk UNKNOWN IMPORTED)
    set_target_properties(GTK2::gtk PROPERTIES
        IMPORTED_LOCATION "${GTK2_LIBRARY}"
        INTERFACE_COMPILE_OPTIONS "${GTK2_DEFINITIONS}"
        INTERFACE_INCLUDE_DIRECTORIES "${GTK2_INCLUDE_DIR}"
    )
    set_property(TARGET GTK2::gtk APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${PKG_GTK2_INCLUDE_DIRS})
    set_property(TARGET GTK2::gtk APPEND PROPERTY INTERFACE_LINK_LIBRARIES ${PKG_GTK2_LIBRARIES})
endif()

mark_as_advanced(GTK2_INCLUDE_DIR GTK2_LIBRARY)

include(FeatureSummary)
set_package_properties(GTK2 PROPERTIES
    URL "http://www.gtk.org/"
    DESCRIPTION "The GTK+ Toolkit (v2)"
)
