if (NOT TARGET XKBCommon::XKBCommon AND
    NOT TARGET GTK2::gtk)
return()
endif()

if (NOT DEFINED GTK2_IM_MODULEDIR)
    set(GTK2_IM_MODULEDIR "${CMAKE_INSTALL_LIBDIR}/gtk-2.0/${GTK2_BINARY_VERSION}/immodules" CACHE PATH "Gtk2 im module directory")
endif()

set(FCITX_GTK2_IM_MODULE_SOURCES
  fcitxim.c
  fcitximcontext.c
)

add_library(im-fcitx MODULE ${FCITX_GTK2_IM_MODULE_SOURCES})
set_target_properties( im-fcitx PROPERTIES PREFIX ""
  COMPILE_FLAGS "-fvisibility=hidden" LINK_FLAGS "-Wl,--no-undefined")
target_link_libraries(im-fcitx XKBCommon::XKBCommon GTK2::gtk Fcitx::GClient Fcitx::Core)
install(TARGETS im-fcitx DESTINATION "${GTK2_IM_MODULEDIR}")
