# Description:
# Tools for building a Catalog by Convention.

licenses(["notice"])  # Apache 2.0

objc_library(
    name = "CatalogByConvention",
    srcs = glob([
      "src/*.m",
      "src/private/*.h",
      "src/private/*.m",
    ]),
    includes = ["src/"],
    hdrs = glob(["src/*.h"]),
    visibility = ["//visibility:public"],
    copts = [
        "-Wall",  # Standard known-to-be-bugs warnings.
        "-Wcast-align",  # Casting a pointer such that alignment is broken.
        "-Wconversion",  # Numeric conversion warnings.
        "-Wdocumentation",  # Documentation checks.
        "-Werror",  # All warnings as errors.
        "-Wextra",  # Many useful extra warnings.
        "-Wimplicit-atomic-properties",  # Dynamic properties should be non-atomic.
        "-Wmissing-prototypes",  # Global function is defined without a previous prototype.
        "-Wno-error=deprecated",  # Deprecation warnings are never errors.
        "-Wno-error=deprecated-implementations",  # Deprecation warnings are never errors.
        "-Wno-sign-conversion",  # Do not warn on sign conversions.
        "-Wno-unused-parameter",  # Do not warn on unused parameters.
        "-Woverlength-strings",  # Strings longer than the C maximum.
        "-Wshadow",  # Local variable shadows another variable, parameter, etc.
        "-Wstrict-selector-match",  # Compiler can't figure out the right selector.
        "-Wundeclared-selector",  # Compiler doesn't see a selector.
        "-Wunreachable-code",  # Code will never be reached.
    ]
)
