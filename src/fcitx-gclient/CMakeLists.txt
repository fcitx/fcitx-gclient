set(FCITX_GCLIENT_SOURCES
  fcitxclient.c
  fcitxinputmethod.c
  fcitxkbd.c
  fcitxconnection.c
  )

set(FCITX_GCLIENT_BUILT_SOURCES
  ${CMAKE_CURRENT_BINARY_DIR}/marshall.c
  )

set(FCITX_GCLIENT_HEADERS
  fcitxclient.h
  fcitxinputmethod.h
  fcitxkbd.h
  fcitxconnection.h
  )

set(FCITX_GCLIENT_BUILT_HEADERS
  ${CMAKE_CURRENT_BINARY_DIR}/marshall.h
  )

pkg_check_variable(GLIB2_GLIB_GENMARSHAL "glib-2.0" "glib_genmarshal")
find_program(GLIB_GENMARSHAL ${GLIB2_GLIB_GENMARSHAL})

add_custom_command(OUTPUT marshall.c
  COMMAND ${GLIB_GENMARSHAL} --body --prefix=fcitx_marshall
  ${CMAKE_CURRENT_SOURCE_DIR}/marshall.list > marshall.c
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/marshall.list)
add_custom_command(OUTPUT marshall.h
  COMMAND ${GLIB_GENMARSHAL} --header --prefix=fcitx_marshall
  ${CMAKE_CURRENT_SOURCE_DIR}/marshall.list > marshall.h
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/marshall.list)

add_library(fcitx-gclient SHARED ${FCITX_GCLIENT_SOURCES}
  ${FCITX_GCLIENT_BUILT_SOURCES} ${FCITX_GCLIENT_BUILT_HEADERS})
add_library(Fcitx5::GClient ALIAS fcitx-gclient)
set_target_properties(fcitx-gclient
  PROPERTIES VERSION ${FCITX_VERSION}
  SOVERSION 2
  COMPILE_FLAGS "-fvisibility=hidden"
  LINK_FLAGS "-Wl,--no-undefined"
  EXPORT_NAME GClient)
target_link_libraries(fcitx-gclient
    PRIVATE
        GLib2::GLib GObject2::GObject Gio2::Gio Fcitx5::Core)
target_include_directories(fcitx-gclient PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/..> $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}> $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}> "$<INSTALL_INTERFACE:${CMAKE_INSTALL_FULL_INCLUDEDIR}>/Fcitx5/FcitxGClient")
configure_file(fcitx-gclient.pc.in ${CMAKE_CURRENT_BINARY_DIR}/fcitx-gclient.pc @ONLY)
generate_export_header(fcitx-gclient BASE_NAME FcitxGClient)

install(TARGETS fcitx-gclient EXPORT FcitxGClientTargets LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}")
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/fcitx-gclient.pc
  DESTINATION "${CMAKE_INSTALL_LIBDATADIR}/pkgconfig")
install(FILES ${FCITX_GCLIENT_HEADERS}
  DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/Fcitx5/FcitxGClient/fcitx-gclient")

ecm_setup_version(PROJECT
                  PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/FcitxGClientConfigVersion.cmake"
                  SOVERSION 2)

configure_package_config_file("${CMAKE_CURRENT_SOURCE_DIR}/FcitxGClientConfig.cmake.in"
                              "${CMAKE_CURRENT_BINARY_DIR}/FcitxGClientConfig.cmake"
                              INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/FcitxGClient
)

install(EXPORT FcitxGClientTargets DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/FcitxGClient FILE FcitxGClientTargets.cmake NAMESPACE Fcitx5::)

install(FILES  "${CMAKE_CURRENT_BINARY_DIR}/FcitxGClientConfig.cmake"
               "${CMAKE_CURRENT_BINARY_DIR}/FcitxGClientConfigVersion.cmake"
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/FcitxGClient
        COMPONENT Devel )

if (WITH_GIR AND GObjectIntrospection_FOUND)
gobject_introspection(
    FILENAME Fcitx-2.0.gir
    NSVERSION 2.0
    INCLUDE Gio-2.0 GObject-2.0 GLib-2.0
    PACKAGE_EXPORT fcitx-gclient
    LIBRARY fcitx-gclient
    SCANNER_ARGS --warn-all --add-include-path="${CMAKE_CURRENT_SOURCE_DIR}"
    COMPILER_ARGS "--includedir=${CMAKE_CURRENT_SOURCE_DIR}"
    SYMBOL_PREFIXES fcitx
    SOURCES ${FCITX_GCLIENT_SOURCES} ${FCITX_GCLIENT_HEADERS}
    QUIET
  )
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/Fcitx-2.0.gir"
    DESTINATION "${GObjectIntrospection_GIRDIR}")
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/Fcitx-2.0.typelib"
    DESTINATION "${GObjectIntrospection_TYPELIBDIR}")
endif()
