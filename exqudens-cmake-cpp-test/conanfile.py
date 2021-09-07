from conans import ConanFile, tools
from conans.model import Generator


class ConanPackagesCmake(Generator):

    @property
    def content(self):
        content = ''

        content += 'set(CONAN_PACKAGE_NAMES \n'
        for dep_name, dep_cpp_info in self.deps_build_info.dependencies:
            content += '    "' + dep_name + '" \n'
        content += ')\n'

        for dep_name, dep_cpp_info in self.deps_build_info.dependencies:
            build_paths = []
            for build_path in dep_cpp_info.build_paths:
                cmake_build_path = build_path.replace('\\', '/')
                if cmake_build_path.endswith('/'):
                    cmake_build_path = cmake_build_path[:-1]
                build_paths.append(cmake_build_path)
            content += 'set(CONAN_PACKAGE_' + dep_name + '_BUILD_PATHS '
            content += '"' + ';'.join(build_paths) + '"'
            content += ')\n'
            content += 'set(CONAN_PACKAGE_' + dep_name + '_CMAKE_FIND_PACKAGE_NAME '
            content += '"' + dep_cpp_info.get_name('cmake_find_package') + '"'
            content += ')\n'

        content += 'set(CONAN_CMAKE_PACKAGE_NAMES \n'
        for dep_name, dep_cpp_info in self.deps_build_info.dependencies:
            content += '    "' + dep_cpp_info.get_name('cmake_find_package') + '" \n'
        content += ')\n'

        return content

    @property
    def filename(self):
        return "conan-packages.cmake"


class ConanConfiguration(ConanFile):
    requires = [
        "exqudens-cpp-test-lib/1.0.0",
        "gtest/cci.20210126"
    ]
    settings = "arch", "os", "compiler", "build_type"
    options = {"shared": [True, False]}
    generators = "ConanPackagesCmake", "cmake_find_package"


if __name__ == "__main__":
    pass
