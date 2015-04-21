find_package(PkgConfig)

pkg_check_modules(PKG_GTK3 QUIET gtk+-3.0)
pkg_check_variable(GTK3_BINARY_VERSION gtk+-3.0 gtk_binary_version)
mark_as_advanced(GTK3_BINARY_VERSION)

set(GTK3_DEFINITIONS ${PKG_GTK3_CFLAGS_OTHER})
set(GTK3_VERSION ${PKG_GTK3_VERSION})

find_path(GTK3_INCLUDE_DIR
    NAMES gtk/gtk.h
    HINTS ${PKG_GTK3_INCLUDE_DIRS}
)

find_library(GTK3_LIBRARY
    NAMES gtk-3
    HINTS ${PKG_GTK3_LIBRARY_DIRS}
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GTK3
    FOUND_VAR
        GTK3_FOUND
    REQUIRED_VARS
        GTK3_LIBRARY
        GTK3_INCLUDE_DIR
        GTK3_BINARY_VERSION
    VERSION_VAR
        GTK3_VERSION
)

if(GTK3_FOUND AND NOT TARGET GTK3::gtk)
    add_library(GTK3::gtk UNKNOWN IMPORTED)
    set_target_properties(GTK3::gtk PROPERTIES
        IMPORTED_LOCATION "${GTK3_LIBRARY}"
        INTERFACE_COMPILE_OPTIONS "${GTK3_DEFINITIONS}"
        INTERFACE_INCLUDE_DIRECTORIES "${GTK3_INCLUDE_DIR}"
    )
    set_property(TARGET GTK3::gtk APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${PKG_GTK3_INCLUDE_DIRS})
    set_property(TARGET GTK3::gtk APPEND PROPERTY INTERFACE_LINK_LIBRARIES ${PKG_GTK3_LIBRARIES})
endif()

mark_as_advanced(GTK3_INCLUDE_DIR GTK3_LIBRARY)

include(FeatureSummary)
set_package_properties(GTK3 PROPERTIES
    URL "http://www.gtk.org/"
    DESCRIPTION "The GTK+ Toolkit (v3)"
)
