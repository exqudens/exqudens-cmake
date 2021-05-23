from conans import ConanFile, tools


class ConanConfiguration(ConanFile):
    requires = [
        "fmt/7.1.3"
    ]
    settings = "arch", "os", "compiler", "build_type"
    options = {"shared": [True, False]}

    def imports(self):
        self.copy(pattern="*", folder=True)
