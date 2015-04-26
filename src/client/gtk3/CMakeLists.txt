if (NOT TARGET XKBCommon::XKBCommon OR
    NOT TARGET GTK3::gtk)
return()
endif()

if (NOT DEFINED GTK3_IM_MODULEDIR)
    set(GTK3_IM_MODULEDIR "${CMAKE_INSTALL_LIBDIR}/gtk-3.0/${GTK3_BINARY_VERSION}/immodules" CACHE PATH "Gtk3 im module directory")
endif()

set(FCITX_GTK3_IM_MODULE_SOURCES
    fcitxim.c
    fcitximcontext.c
)

add_library(im-fcitx-gtk3 MODULE ${FCITX_GTK3_IM_MODULE_SOURCES})
set_target_properties( im-fcitx-gtk3 PROPERTIES PREFIX ""
  COMPILE_FLAGS "-fvisibility=hidden" OUTPUT_NAME "im-fcitx"
  LINK_FLAGS "-Wl,--no-undefined")

target_link_libraries(im-fcitx-gtk3 XKBCommon::XKBCommon GTK3::gtk Fcitx5::GClient Fcitx5::Core)
if(X11_FOUND)
target_include_directories(im-fcitx-gtk3 PRIVATE ${X11_INCLUDE_DIR})
target_link_libraries(im-fcitx-gtk3 ${X11_X11_LIB})
endif()
install(TARGETS im-fcitx-gtk3 DESTINATION "${GTK3_IM_MODULEDIR}")
