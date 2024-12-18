cmake_minimum_required(VERSION 3.14)

project(Server LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
# 搜索所有源文件
file(GLOB_RECURSE Server_src "./*.cpp" "./*.h")
# 添加静态库
add_library(Server STATIC ${Server_src})

# 确保找到所需的 Qt 模块，包括 Concurrent
find_package(Qt6 REQUIRED COMPONENTS Core Gui Quick Concurrent)

# 链接库的依赖项
target_link_libraries(Server
    PRIVATE Qt6::Core
    PRIVATE Qt6::Gui
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Concurrent
)

# 将 Server 库链接到 MainApp
target_link_libraries(DataConversionTools PRIVATE Server)
