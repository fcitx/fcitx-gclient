find_package(PkgConfig)

include(Utils)
pkg_check_modules(PKG_GObjectIntrospection QUIET gobject-introspection-1.0)
pkg_check_variable(GObjectIntrospection_GIRDIR gobject-introspection-1.0 girdir)
mark_as_advanced(GObjectIntrospection_GIRDIR)
pkg_check_variable(GObjectIntrospection_TYPELIBDIR gobject-introspection-1.0 typelibdir)
mark_as_advanced(GObjectIntrospection_TYPELIBDIR)

set(GObjectIntrospection_VERSION ${PKG_GObjectIntrospection_VERSION})

find_program(GObjectIntrospection_SCANNER NAMES g-ir-scanner DOC "g-ir-scanner executable")
mark_as_advanced(GObjectIntrospection_SCANNER)
find_program(GObjectIntrospection_COMPILER NAMES g-ir-compiler DOC "g-ir-compiler executable")
mark_as_advanced(GObjectIntrospection_COMPILER)
find_program(GObjectIntrospection_GENERATE NAMES g-ir-generate DOC "g-ir-generate executable")
mark_as_advanced(GObjectIntrospection_GENERATE)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GObjectIntrospection
    FOUND_VAR
        GObjectIntrospection_FOUND
    REQUIRED_VARS
        GObjectIntrospection_GIRDIR
        GObjectIntrospection_TYPELIBDIR
        GObjectIntrospection_SCANNER
        GObjectIntrospection_COMPILER
        GObjectIntrospection_GENERATE
    VERSION_VAR
        GObjectIntrospection_VERSION
)

if(GObjectIntrospection_FOUND AND
    (NOT TARGET GObjectIntrospection::Scanner AND
     NOT TARGET GObjectIntrospection::Compiler AND
     NOT TARGET GObjectIntrospection::Generate))
    add_executable(GObjectIntrospection::Scanner IMPORTED)
    set_target_properties(GObjectIntrospection::Scanner PROPERTIES IMPORTED_LOCATION "${GObjectIntrospection_SCANNER}")
    add_executable(GObjectIntrospection::Compiler IMPORTED)
    set_target_properties(GObjectIntrospection::Compiler PROPERTIES IMPORTED_LOCATION "${GObjectIntrospection_COMPILER}")
    add_executable(GObjectIntrospection::Generate IMPORTED)
    set_target_properties(GObjectIntrospection::Generate PROPERTIES IMPORTED_LOCATION "${GObjectIntrospection_GENERATE}")

    include(${CMAKE_CURRENT_LIST_DIR}/GObjectIntrospectionMacros.cmake)
endif()

include(FeatureSummary)
set_package_properties(GObjectIntrospection PROPERTIES
    URL "https://live.gnome.org/GObjectIntrospection"
    DESCRIPTION "Introspection system for GObject-based libraries"
)
