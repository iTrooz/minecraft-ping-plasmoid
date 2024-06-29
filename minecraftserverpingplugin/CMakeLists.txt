add_definitions(-DTRANSLATION_DOMAIN=\"plasma_applet_nl.netsoj.minecraftserverping\")
set(minecraftserverping_SRCS
    minecraftserverping.cpp
    minecraftserver.cpp
    serverlistmodel.cpp
	formatcodeconverter.cpp
)
set(minecraftserverping_HEADERS
    minecraftserverping.h
    minecraftserver.h
    serverlistmodel.h
	formatcodeconverter.h
)

add_library(minecraftserverpingplugin SHARED ${minecraftserverping_SRCS})

target_precompile_headers(minecraftserverpingplugin PRIVATE ${minecraftserverping_HEADERS})
target_link_libraries(minecraftserverpingplugin
                      KF6::I18n
                      Qt6::Core
                      Qt6::Qml
                      Qt6::Gui)

install(TARGETS minecraftserverpingplugin DESTINATION ${KDE_INSTALL_QMLDIR}/nl/netsoj/minecraftserverping)
install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/nl/netsoj/minecraftserverping)
