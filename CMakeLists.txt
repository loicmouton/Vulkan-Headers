# ~~~
# Copyright (c) 2018 Valve Corporation
# Copyright (c) 2018 LunarG, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ~~~

# CMake project initialization ---------------------------------------------------------------------------------------------------
# This section contains pre-project() initialization, and ends with the project() command.

cmake_minimum_required(VERSION 3.10.2)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# NONE = this project has no language toolchain requirement.
project(Vulkan-Headers NONE)

# Project-wide includes ----------------------------------------------------------------------------------------------------------
# This section includes files usefull across the whole project.

include(Vulkan-HeadersDirs)

# --------------------------------------------------------------------------------------------------------------------------------

# User-interface declarations ----------------------------------------------------------------------------------------------------
# This section contains variables that affect development GUIs (e.g. CMake GUI and IDEs), such as option(), folders, and variables
# with the CACHE property.


if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
  set(vulkan-headers_IS_MAIN_PROJECT TRUE)
else()
  set(vulkan-headers_IS_MAIN_PROJECT FALSE)
endif()

option(VULKAN_HEADERS_INSTALL "Enable install rule for Vulkan-Headers targets" "${vulkan-headers_IS_MAIN_PROJECT}")

if(vulkan-headers_IS_MAIN_PROJECT AND VULKAN_HEADERS_INSTALL AND WIN32 AND CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    # Windows: if install locations not set by user, set install prefix to "<build_dir>\install".
    set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install" CACHE PATH "default install path" FORCE)
endif()

# --------------------------------------------------------------------------------------------------------------------------------

# define exported targets for nested project builds to consume
set(vulkan-headers_PUBLIC_HEADER_FILES
    "vk_icd.h"
    "vk_layer.h"
    "vk_platform.h"
    "vk_sdk_platform.h"
    "vulkan.h"
    "vulkan.hpp"
    "vulkan_android.h"
    "vulkan_beta.h"
    "vulkan_core.h"
    "vulkan_directfb.h"
    "vulkan_fuchsia.h"
    "vulkan_ggp.h"
    "vulkan_ios.h"
    "vulkan_macos.h"
    "vulkan_metal.h"
    "vulkan_vi.h"
    "vulkan_wayland.h"
    "vulkan_win32.h"
    "vulkan_xcb.h"
    "vulkan_xlib.h"
    "vulkan_xlib_xrandr.h")
set(vulkan-headers_BUILD_PUBLIC_HEADER_FILES "${vulkan-headers_PUBLIC_HEADER_FILES}")
list(TRANSFORM vulkan-headers_BUILD_PUBLIC_HEADER_FILES PREPEND "${vulkan-headers_PUBLIC_HEADER_DIR}/")
set(vulkan-headers_INSTALL_PUBLIC_HEADER_FILES "${vulkan-headers_PUBLIC_HEADER_FILES}")
list(TRANSFORM vulkan-headers_INSTALL_PUBLIC_HEADER_FILES PREPEND "${vulkan-headers_INSTALL_PUBLIC_HEADER_DIR}/")

add_library(Vulkan-Headers INTERFACE)
add_library(Vulkan::Headers ALIAS Vulkan-Headers)
target_include_directories(Vulkan-Headers
    INTERFACE
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>"
        "$<INSTALL_INTERFACE:${vulkan-headers_INSTALL_PUBLIC_HEADER_DIR}>")
set_target_properties(Vulkan-Headers
    PROPERTIES
        PUBLIC_HEADER "${vulkan-headers_BUILD_PUBLIC_HEADER_FILES}")

set(vulkan_registry_PYTHON_SCRIPTS
    "spec_tools/util.py"
    "cgenerator.py"
    "conventions.py"
    "genvk.py"
    "reg.py"
    "validusage.py"
    "vk.xml"
    "vkconventions.py")
set(vulkan_registry_BUILD_PYTHON_SCRIPTS "${vulkan-headers_PUBLIC_HEADER_FILES}")
list(TRANSFORM vulkan_registry_BUILD_PYTHON_SCRIPTS PREPEND "${vulkan-headers_REGISTRY_DIR}/")
set(vulkan_registry_INSTALL_PYTHON_SCRIPTS "${vulkan-headers_PUBLIC_HEADER_FILES}")
list(TRANSFORM vulkan_registry_INSTALL_PYTHON_SCRIPTS PREPEND "${vulkan-headers_INSTALL_REGISTRY_DIR}/")
list(APPEND vulkan-headers_INSTALL_TARGETS Vulkan-Headers)

add_library(Vulkan-Registry INTERFACE)
add_library(Vulkan::Registry ALIAS Vulkan-Registry)
target_include_directories(Vulkan-Registry
    INTERFACE
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/registry>"
        "$<INSTALL_INTERFACE:${vulkan-headers_INSTALL_REGISTRY_DIR}>")
target_sources(Vulkan-Registry
    INTERFACE
        "$<BUILD_INTERFACE:${vulkan_registry_BUILD_PYTHON_SCRIPTS}>"
        "$<INSTALL_INTERFACE:${vulkan_registry_INSTALL_PYTHON_SCRIPTS}>"
)
list(APPEND vulkan-headers_INSTALL_TARGETS Vulkan-Registry)

if(VULKAN_HEADERS_INSTALL)
    include(CMakePackageConfigHelpers)

    install(EXPORT Vulkan-HeadersTargets
            DESTINATION ${vulkan-headers_INSTALL_CONFIG_DIR}
            NAMESPACE Vulkan::)

    set(cmakeModulesDir "cmake")
    configure_package_config_file("cmake/Vulkan-HeadersConfig.cmake.in"
                                  "${vulkan-headers_BINARY_CONFIG_DIR}/Vulkan-HeadersConfig.cmake"
                                  INSTALL_DESTINATION "${vulkan-headers_INSTALL_CONFIG_DIR}")
    install(FILES "${vulkan-headers_BINARY_CONFIG_DIR}/Vulkan-HeadersConfig.cmake"
            DESTINATION ${vulkan-headers_INSTALL_CONFIG_DIR})

    install(TARGETS ${vulkan-headers_INSTALL_TARGETS}
            EXPORT Vulkan-HeadersTargets
            RUNTIME DESTINATION ${vulkan-headers_INSTALL_BIN_DIR}
            LIBRARY DESTINATION ${vulkan-headers_INSTALL_LIB_DIR}
            ARCHIVE DESTINATION ${vulkan-headers_INSTALL_LIB_DIR}
            PUBLIC_HEADER DESTINATION ${vulkan-headers_INSTALL_PUBLIC_HEADER_DIR})
endif()

# uninstall target
if(vulkan-headers_IS_MAIN_PROJECT AND NOT TARGET uninstall)
    configure_file("${CMAKE_CURRENT_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in"
                   "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
                   IMMEDIATE
                   @ONLY)
    add_custom_target(uninstall COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)
endif()
