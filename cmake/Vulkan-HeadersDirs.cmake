include(GNUInstallDirs)

set(vulkan_headers_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/include")
set(vulkan_headers_PUBLIC_HEADER_DIR "${vulkan_headers_INCLUDE_DIR}/vulkan")
set(vulkan_headers_REGISTRY_DIR "${CMAKE_CURRENT_SOURCE_DIR}/registry")

set(vulkan_headers_BINARY_CONFIG_DIR "${PROJECT_BINARY_DIR}/cmake")
set(vulkan_headers_BINARY_INCLUDE_DIR "${PROJECT_BINARY_DIR}/include")
set(vulkan_headers_BINARY_PUBLIC_HEADER_DIR "${vulkan_headers_BINARY_INCLUDE_DIR}/vulkan")

set(vulkan_headers_INSTALL_BIN_DIR "${CMAKE_INSTALL_BINDIR}")
set(vulkan_headers_INSTALL_CONFIG_DIR "${CMAKE_INSTALL_LIBDIR}/cmake/vulkan")
set(vulkan_headers_INSTALL_INCLUDE_DIR "${CMAKE_INSTALL_INCLUDEDIR}")
set(vulkan_headers_INSTALL_PUBLIC_HEADER_DIR "${vulkan_headers_INSTALL_INCLUDE_DIR}/vulkan")
set(vulkan_headers_INSTALL_LIB_DIR "${CMAKE_INSTALL_LIBDIR}")

set(CMAKE_INSTALL_DOCDIR "${CMAKE_INSTALL_DATAROOTDIR}/doc/vulkan")
