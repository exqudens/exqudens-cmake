from conans import ConanFile, tools


class ConanConfiguration(ConanFile):
    requires = [
        "zlib/1.2.11",
        "libpng/1.6.37",
        "json-c/0.15"
    ]
    settings = "arch", "os", "compiler", "build_type"
    options = {"shared": [True, False]}
    generators = "cmake_paths", "cmake_find_package"


if __name__ == "__main__":
    pass
