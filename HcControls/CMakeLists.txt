cmake_minimum_required(VERSION 3.20)

if (HCCONTROLS_BUILD_STATIC_LIB AND (QT_VERSION VERSION_GREATER_EQUAL "6.2"))
    project(hccontrols VERSION 1.0)
else()
    project(hccontrolsplugin VERSION 1.0)
endif()

#配置通用编译
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if (HCCONTROLS_BUILD_STATIC_LIB)
    add_definitions(-DHCCONTROLS_BUILD_STATIC_LIB)
endif()

#导入Qt相关依赖包
find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick Qml Svg)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick Qml Svg)

if(QT_VERSION VERSION_GREATER_EQUAL "6.3")
    qt_standard_project_setup()
else()
    set(CMAKE_AUTOMOC ON)
    set(CMAKE_AUTORCC ON)
    set(CMAKE_AUTOUIC ON)
endif()

set(HcControls_QML_PLUGIN_DIRECTORY "" CACHE PATH "Path to HcControls plugin")
if (NOT HcControls_QML_PLUGIN_DIRECTORY)
    set(HcControls_QML_PLUGIN_DIRECTORY ${QT_SDK_DIR}/qml/HcControls)
endif ()

#国际化
# find_program(QT_LUPDATE NAMES lupdate)
# find_program(QT_LRELEASE NAMES lrelease)
find_program(LUPDATE_EXECUTABLE lupdate)
find_program(LRELEASE_EXECUTABLE lrelease)

if (NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/hc_en_US.qm)
    execute_process(COMMAND ${QT_LUPDATE} ${CMAKE_CURRENT_LIST_DIR} -ts hc_en_US.ts WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})
    execute_process(COMMAND ${QT_LRELEASE} hc_en_US.ts WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})
endif ()
if (NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/hc_zh_CN.qm)
    execute_process(COMMAND ${QT_LUPDATE} ${CMAKE_CURRENT_LIST_DIR} -ts hc_zh_CN.ts WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})
    execute_process(COMMAND ${QT_LRELEASE} hc_zh_CN.ts WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})
endif ()
file(GLOB QM_FILE_PATHS ${CMAKE_CURRENT_LIST_DIR}/ *.qm)
file(COPY ${QM_FILE_PATHS} DESTINATION "${CMAKE_CURRENT_SOURCE_DIR}/Qt${QT_VERSION_MAJOR}/imports/HcControls/i18n")

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/cpp)

#遍历所有Cpp文件
file(GLOB_RECURSE CPP_FILES *.cpp *.h)
foreach(filepath ${CPP_FILES})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
    list(APPEND sources_files ${filename})
endforeach(filepath)

if(QT_VERSION VERSION_GREATER_EQUAL "6.2")
    #HcControlsplugin.HcControlsplugin.h，这些只要Qt5使用，Qt6不需要
    list(REMOVE_ITEM sources_files HcControlsplugin.h HcControlsplugin.cpp)
    if (NOT HCCONTROLS_BUILD_STATIC_LIB)
        list(REMOVE_ITEM sources_files HcControls.h HcControls.cpp)
    endif()

    #遍历所有qml文件
    file(GLOB_RECURSE QML_PATHS *.qml)
    foreach(filepath ${QML_PATHS})
        #if(${filepath} MATCHES "Qt${QT_VERSION_MAJOR}/")
            string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
            list(APPEND qml_files ${filename})
        #endif()
    endforeach(filepath)

    #遍历所有资源文件
    file(GLOB_RECURSE RES_PATHS *.png *.jpg *.svg *.ico *.ttf *.webp *.js *.qm)
    foreach(filepath ${RES_PATHS})
        #if(${filepath} MATCHES "Qt${QT_VERSION_MAJOR}/")
            string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
            list(APPEND resource_files ${filename})
        #endif()
    endforeach(filepath)

    #修改资源文件导出路径
    foreach(filepath IN LISTS qml_files resource_files)
        string(REPLACE "Qt${QT_VERSION_MAJOR}/imports/HcControls/" "" filename ${filepath})
        string(REPLACE "qml/" "" filename ${filepath})
        set_source_files_properties(${filepath} PROPERTIES QT_RESOURCE_ALIAS ${filename})

        string(REGEX MATCH "HcPcrHelper|Constants" RESULT ${filepath})
        if (RESULT)
            set_source_files_properties(${filepath} PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
        endif()
    endforeach()
endif()

if (HCCONTROLS_BUILD_STATIC_LIB)
    set(LIB_TYPE "STATIC")
else()
    set(LIB_TYPE "SHARED")
endif()

if (HCCONTROLS_BUILD_STATIC_LIB)
    set(PLUGIN_TARGET_NAME "")
else()
    #如果是动态库，则使用插件目标作为其自己的支持目标来定义 QML 模块，在这种情况下，模块必须在运行时动态加载，并且不能由其他目标直接链接到
    set(PLUGIN_TARGET_NAME ${PROJECT_NAME})
endif()

#如果是Windows平台，则生成rc文件
# set(HCCONTROLS_VERSION_RC_PATH "")
# if(WIN32)
#     set(HCCONTROLS_VERSION_RC_PATH ${CMAKE_BINARY_DIR}/version_${PROJECT_NAME}.rc)
#     configure_file(
#         ${HCCONTROLS_DIRECTORY}/.cmake/version_dll.rc.in
#         ${HCCONTROLS_VERSION_RC_PATH}
#     )
# endif()

if(QT_VERSION VERSION_GREATER_EQUAL "6.2")
    #如果是Qt6.2版本以上，则使用qt_add_library，qt_add_qml_module函数添加资源文件
    if(HCCONTROLS_BUILD_STATIC_LIB)
        set(HCCONTROLS_QML_PLUGIN_DIRECTORY ${CMAKE_BINARY_DIR}/HcControls)
    endif()
    qt_add_library(${PROJECT_NAME} ${LIB_TYPE})
    qt_add_qml_module(${PROJECT_NAME}
        PLUGIN_TARGET ${PLUGIN_TARGET_NAME}
        OUTPUT_DIRECTORY ${HCCONTROLS_QML_PLUGIN_DIRECTORY}
        VERSION 1.0
        URI "HcControls"
        #修改qmltypes文件名称。默认HcControlsplugin.qmltypes，使用默认名称有时候import HcControls 1.0会爆红，所以修改成plugins.qmltypes
        TYPEINFO "plugins.qmltypes"
        SOURCES ${sources_files} ${HCCONTROLS_VERSION_RC_PATH}
        QML_FILES ${qml_files}
        RESOURCES ${resource_files}
        RESOURCE_PREFIX "/qt/qml"
    )
else()
    qt_add_resources(QRC_RESOURCES Qt5/imports/hccontrols.qrc)
    #如果是Qt6.2版本以下，则使用add_qmlplugin函数添加资源文件，这是个自定义的函数，详情见.cmake/QmlPlugin.cmake
    include(QmlPlugin)
    add_qmlplugin(${PROJECT_NAME}
        URI "HcControls"
        VERSION 1.0
        SOURCES ${sources_files} ${HCCONTROLS_VERSION_RC_PATH} Qt5/imports/hccontrols.qrc
        QMLFILES ${qml_files}
        QMLDIR imports/HcControls
        BINARY_DIR ${HCCONTROLS_QML_PLUGIN_DIRECTORY}
        LIBTYPE ${LIB_TYPE}
    )
endif()

target_compile_definitions(${PROJECT_NAME}
    PRIVATE
    #导入qrcode配置文件
    HAVE_CONFIG_H
)

#去掉mingw生成的动态库libxxx前缀lib，不去掉前缀会导致 module "HcControls" plugin "HCCONTROLSplugin" not found
if(MINGW)
    set_target_properties(${PROJECT_NAME} PROPERTIES PREFIX "")
    #解决编译器报 too many sections的问题
    target_compile_options(${PROJECT_NAME} PRIVATE -Wa,-mbig-obj)
endif()

#MSVC Debug 添加后缀d，与Qt插件风格保持一致
if(MSVC)
    set_target_properties(${PROJECT_NAME} PROPERTIES DEBUG_POSTFIX "d")
endif()


#链接库
target_link_libraries(${PROJECT_NAME} PUBLIC
    Qt${QT_VERSION_MAJOR}::CorePrivate
    Qt${QT_VERSION_MAJOR}::QuickPrivate
    Qt${QT_VERSION_MAJOR}::QmlPrivate
    Qt${QT_VERSION_MAJOR}::Svg
)

if(APPLE)
    find_library(CARBON_LIBRARY Carbon)
    target_link_libraries(${PROJECT_NAME} PRIVATE ${CARBON_LIBRARY})
elseif(WIN32)
    target_link_libraries(${PROJECT_NAME} PRIVATE user32)
elseif(UNIX)
    if(QT_VERSION_MAJOR STREQUAL "6")
        if(QT_VERSION VERSION_LESS "6.2.0")
            message(FATAL_ERROR "Qt 6.2.0 or greater is required when using Qt6")
        endif()
    else()
        if(QT_VERSION_MAJOR LESS "6")
            find_package(Qt5 REQUIRED COMPONENTS X11Extras)
            target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::X11Extras)
        endif()
    endif()
    target_link_libraries(${PROJECT_NAME} PRIVATE X11)
endif()

target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/qmlcustomplot
)

if ((${QT_VERSION_MAJOR} LESS_EQUAL 6) AND (CMAKE_BUILD_TYPE MATCHES "Release"))
    find_program(QML_PLUGIN_DUMP NAMES qmlplugindump)
    add_custom_target(Script-Generate-QmlTypes
            COMMAND ${QML_PLUGIN_DUMP} -nonrelocatable -noinstantiate HcControls 1.0 ${CMAKE_CURRENT_BINARY_DIR} > ${CMAKE_CURRENT_SOURCE_DIR}/Qt5/imports/HcControls/plugins.qmltypes
            COMMENT "Generate qmltypes........."
            SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/Qt5/imports/HcControls/plugins.qmltypes
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
endif()

#安装
install(DIRECTORY ${HCCONTROLS_QML_PLUGIN_DIRECTORY} DESTINATION ${CMAKE_INSTALL_PREFIX}/imports)
