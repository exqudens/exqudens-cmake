from conans import ConanFile, tools


class ConanConfiguration(ConanFile):
    requires = [
        "zlib/1.2.11",
        "libpng/1.6.37",
        "yaml-cpp/0.6.3"
    ]
    settings = "arch", "os", "compiler", "build_type"
    options = {"shared": [True, False]}

    def imports(self):
        self.copy(pattern="*", folder=True)
