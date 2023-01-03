local navigation = require("gototest.navigation")
local shallow_copy = require("gototest.utils").shallow_copy

local A_PROJECT_ROOT = "/a/project/root"
local A_FILE_EXTENSION_PATTERN = "py"
local A_FILE_EXTENSION = "." .. A_FILE_EXTENSION_PATTERN
local SOME_CONFIG = {
    project_root = A_PROJECT_ROOT,
    test_dir = "test_dir/",
    test_file_prefix = "prefix_",
    test_file_suffix = "_suffix",
    extension_pattern = A_FILE_EXTENSION_PATTERN
}

describe("decompose test file", function()
    describe("given test file", function()
        it("return root_path, bare_filename and extension", function()
            local A_ROOT_PATH = A_PROJECT_ROOT .. "/some/path/"
            local A_BARE_FILENAME = "filename"
            local root_path, bare_filename, extension = navigation.decompose_test_file(SOME_CONFIG,
                A_ROOT_PATH ..
                SOME_CONFIG.test_dir ..
                SOME_CONFIG.test_file_prefix ..
                "filename" ..
                SOME_CONFIG.test_file_suffix ..
                A_FILE_EXTENSION)

            assert.equals(A_ROOT_PATH, root_path)
            assert.equals(A_BARE_FILENAME, bare_filename)
            assert.equals(A_FILE_EXTENSION, extension)
        end)
    end)

    describe("given source file", function()
        it("return nil", function()
            local A_SOURCE_FILE_PATH = A_PROJECT_ROOT .. "/some/path/" .. "filename" .. A_FILE_EXTENSION
            local root_path, bare_filename, extension = navigation.decompose_test_file(SOME_CONFIG, A_SOURCE_FILE_PATH)

            assert.equals(nil, root_path)
            assert.equals(nil, bare_filename)
            assert.equals(nil, extension)
        end)
    end)
end)

-- describe("get_corresponding_filepath", function()
--     describe("given empty test dir config", function()
--         local SOME_CONFIG_WITHOUT_TEST_DIR = shallow_copy(SOME_CONFIG)
--         SOME_CONFIG_WITHOUT_TEST_DIR.test_file_prefix = "test_"
--         local A_FILEPATH = "/a/file/path/filename.py"
--         local A_TEST_FILEPATH = "/a/file/path/test_filename.py"

--         describe("given source file", function()
--             it("should return corresponding test file", function()
--                 local corresponding_filepath = navigation.get_corresponding_filepath(SOME_CONFIG_WITHOUT_TEST_DIR,
--                     A_FILEPATH)

--                 assert.equals(A_TEST_FILEPATH, corresponding_filepath)
--             end)
--         end)

--         describe("given test file", function()
--             it("should return corresponding source file", function()
--                 local corresponding_filepath = navigation.get_corresponding_filepath(SOME_CONFIG_WITHOUT_TEST_DIR,
--                     A_TEST_FILEPATH)

--                 assert.equals(A_FILEPATH, corresponding_filepath)
--             end)
--         end)
--     end)
-- end)
