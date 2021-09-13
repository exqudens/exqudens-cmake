from os import path
from conans.model import Generator
from conans import ConanFile, tools


def convert_to_cmake_build_paths(dep_cpp_info_build_paths):
    build_paths = []
    for build_path in dep_cpp_info_build_paths:
        cmake_build_path = build_path.replace('\\', '/')
        if cmake_build_path.endswith('/'):
            cmake_build_path = cmake_build_path[:-1]
        build_paths.append(cmake_build_path)
    return '<sep>'.join(build_paths)


class ConanPackagesCmake(Generator):

    @property
    def content(self):
        ignore_version_package_names = ['gtest']
        cmake_find_by_module_package_names = ['gtest']
        content = ''

        content += 'set(' + self.conanfile.name + '_CONAN_PACKAGE_NAMES\n'
        for dep_name, dep_cpp_info in self.deps_build_info.dependencies:
            content += '    "' + dep_name + '" \n'
        content += ')\n'

        content += 'set(' + self.conanfile.name + '_CMAKE_PACKAGE_NAMES\n'
        for dep_name, dep_cpp_info in self.deps_build_info.dependencies:
            content += '    "' + dep_cpp_info.get_name('cmake_find_package') + '" \n'
        content += ')\n'

        content += 'set(' + self.conanfile.name + '_CMAKE_PACKAGE_VERSIONS\n'
        for dep_name, dep_cpp_info in self.deps_build_info.dependencies:
            if dep_name in ignore_version_package_names:
                content += '    "' + '<ignore>' + '" \n'
            else:
                content += '    "' + dep_cpp_info.version + '" \n'
        content += ')\n'

        content += 'set(' + self.conanfile.name + '_CMAKE_PACKAGE_FIND_TYPES\n'
        for dep_name, dep_cpp_info in self.deps_build_info.dependencies:
            if dep_name in cmake_find_by_module_package_names:
                content += '    "' + 'MODULE' + '" \n'
            else:
                content += '    "' + 'CONFIG' + '" \n'
        content += ')\n'

        content += 'set(' + self.conanfile.name + '_CMAKE_PACKAGE_PATHS\n'
        for dep_name, dep_cpp_info in self.deps_build_info.dependencies:
            content += '    "' + convert_to_cmake_build_paths(dep_cpp_info.build_paths) + '" \n'
        content += ')\n'

        return content

    @property
    def filename(self):
        return "conan-packages.cmake"


class ConanConfiguration(ConanFile):
    requires = [
        ("exqudens-cpp-test-lib/1.0.0"),
        ("gtest/cci.20210126", "private")
    ]
    settings = "arch", "os", "compiler", "build_type"
    options = {"shared": [True, False]}
    generators = "ConanPackagesCmake", "cmake_find_package"

    def set_name(self):
        self.name = path.basename(path.dirname(path.abspath(__file__)))

    def set_version(self):
        self.version = tools.load(path.join(path.dirname(path.dirname(path.abspath(__file__))), "version.txt")).strip()

    def imports(self):
        self.copy(pattern="*.dll", dst="bin", src="bin")
        self.copy(pattern="*.dylib", dst="lib", src="lib")

    def package_info(self):
        self.cpp_info.libs = tools.collect_libs(self)


if __name__ == "__main__":
    pass
