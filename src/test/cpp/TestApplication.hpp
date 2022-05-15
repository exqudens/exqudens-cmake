#pragma once

#include <gmock/gmock.h>
#include <gtest/gtest.h>

#include "TestConfiguration.hpp"
#include "exqudens/OtherTests.hpp"

class TestApplication {

  public:

    static int run(int* argc, char** argv) {
      TestConfiguration::setExecutableFile(argv[0]);
      testing::InitGoogleMock(argc, argv);
      testing::InitGoogleTest(argc, argv);
      return RUN_ALL_TESTS();
    }

};
