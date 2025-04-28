cmake_minimum_required(VERSION 3.16)

project(TransparentClock VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 14)

# Try Qt 6 first, then fall back to Qt 5
find_package(Qt6 COMPONENTS Quick Widgets QUIET)
if (NOT Qt6_FOUND)
    find_package(Qt5 5.15 COMPONENTS Quick Widgets REQUIRED)
endif()

set(app_icon_resource_windows "${CMAKE_CURRENT_SOURCE_DIR}/Resources/clock.rc")

set(PROJECT_SOURCES
    main.cpp
    systemtraymanager.cpp
    systemtraymanager.h
    main.qml
    ${app_icon_resource_windows}
    resources.qrc
)

if (Qt6_FOUND)
    qt_add_executable(transparent_clock
        ${PROJECT_SOURCES}
    )
else()
    add_executable(transparent_clock
        ${PROJECT_SOURCES}
    )
endif()

set_target_properties(transparent_clock PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

if (Qt6_FOUND)
    target_compile_definitions(transparent_clock PRIVATE
        QT_VERSION_MAJOR=6
        $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
    )
    target_link_libraries(transparent_clock PRIVATE
        Qt6::Quick 
        Qt6::Widgets
    )
else()
    target_compile_definitions(transparent_clock PRIVATE
        QT_VERSION_MAJOR=5
        $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
    )
    target_link_libraries(transparent_clock PRIVATE
        Qt5::Quick 
        Qt5::Widgets
    )
endif()
