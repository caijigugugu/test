cmake_minimum_required(VERSION 3.16)

project(DataConversionTools VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Core Quick Sql Widgets Network Gui)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(DataConversionTools
    main.cpp
)

qt_add_qml_module(DataConversionTools
    URI DataConversionTools
    VERSION 1.0
    QML_FILES
        Main.qml
    RESOURCES
        "Icons/logo_hcsci.png"
        SOURCES hc_trans.h
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(DataConversionTools PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.DataConversionTools
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

add_subdirectory(HcControls)
add_subdirectory(server)

target_link_libraries(DataConversionTools
    PRIVATE Qt6::Core
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Sql
    PRIVATE Qt6::Widgets
    PRIVATE Qt6::Network
    PRIVATE Qt6::Gui
    ${CMAKE_SOURCE_DIR}/hc_trans.dll
)

include(GNUInstallDirs)
install(TARGETS DataConversionTools
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
