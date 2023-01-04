-- TODO: Test trailing slashes handling
-- TODO: Test exentension pattern handling
local navigation = require("gototest.navigation")

local pattern_escape = require("gototest.utils").pattern_escape

local A_PROJECT_ROOT = "/a/project/root"
local A_FILE_EXTENSION_PATTERN = "tsx?"
local A_FILE_EXTENSION = ".ts"

describe("decompose test file,", function()
    local SOME_CONFIG = {
        project_root = A_PROJECT_ROOT,
        test_dir = "tests",
        test_file_prefix = "",
        test_file_suffix = ".suffix",
        extension_pattern = A_FILE_EXTENSION_PATTERN
    }

    describe("given test file,", function()
        it("should return base_path, bare_filename and extension", function()
            local A_ROOT_PATH = A_PROJECT_ROOT .. "/some/path/"
            local A_BARE_FILENAME = "filename"
            local A_TEST_FILE_PATH = A_ROOT_PATH .. SOME_CONFIG.test_dir .. "/" ..
                pattern_escape(SOME_CONFIG.test_file_prefix) .. A_BARE_FILENAME ..
                SOME_CONFIG.test_file_suffix .. A_FILE_EXTENSION
            local base_path, bare_filename, extension = navigation.decompose_test_file(SOME_CONFIG, A_TEST_FILE_PATH)

            assert.equals(A_ROOT_PATH, base_path)
            assert.equals(A_BARE_FILENAME, bare_filename)
            assert.equals(A_FILE_EXTENSION, extension)
        end)
    end)

    describe("given source file,", function()
        it("should return nil", function()
            local A_SOURCE_FILE_PATH = A_PROJECT_ROOT .. "/some/path/" .. "filename" .. A_FILE_EXTENSION
            local base_path, bare_filename, extension = navigation.decompose_test_file(SOME_CONFIG, A_SOURCE_FILE_PATH)

            assert.equals(nil, base_path)
            assert.equals(nil, bare_filename)
            assert.equals(nil, extension)
        end)
    end)
end)

describe("decompose source file,", function()
    it("should return ", function()
        local A_BASE_PATH = "/some/path/"
        local A_BARE_FILENAME = "filename"
        local AN_EXTENSION = ".txt"
        local A_FILE_PATH = A_BASE_PATH .. A_BARE_FILENAME .. AN_EXTENSION
        local base, filename, extension = navigation.decompose_source_file(A_FILE_PATH)

        assert.equals(A_BASE_PATH, base)
        assert.equals(A_BARE_FILENAME, filename)
        assert.equals(AN_EXTENSION, extension)
    end)
end)

describe("get_corresponding_filepath,", function()
    describe("given empty test dir config,", function()
        local SOME_CONFIG = {
            project_root = A_PROJECT_ROOT,
            test_dir = "",
            test_file_prefix = "prefix_",
            test_file_suffix = "",
            extension_pattern = A_FILE_EXTENSION_PATTERN
        }
        local A_FILEPATH = "/a/file/path/filename" .. A_FILE_EXTENSION
        local A_TEST_FILEPATH = "/a/file/path/" .. SOME_CONFIG.test_file_prefix .. "filename" .. A_FILE_EXTENSION

        describe("given source file,", function()
            it("should return corresponding test file", function()
                local corresponding_filepath = navigation.get_corresponding_filepath(SOME_CONFIG, A_FILEPATH)

                assert.equals(A_TEST_FILEPATH, corresponding_filepath)
            end)
        end)

        describe("given test file,", function()
            it("should return corresponding source file", function()
                local corresponding_filepath = navigation.get_corresponding_filepath(SOME_CONFIG, A_TEST_FILEPATH)

                assert.equals(A_FILEPATH, corresponding_filepath)
            end)
        end)

    end)

    describe("given pattern extension,", function()
        local SOME_CONFIG = {
            project_root = A_PROJECT_ROOT,
            test_dir = "tests/",
            test_file_prefix = "",
            test_file_suffix = ".test",
            extension_pattern = "tsx?"
        }
        local COMMON_ROOT_PATH = A_PROJECT_ROOT .. "/some/path/"
        local A_FILEPATH = COMMON_ROOT_PATH .. "reports.ts"
        local A_TEST_FILEPATH = COMMON_ROOT_PATH .. SOME_CONFIG.test_dir .. "reports.test.ts"

        -- I had a problem with this exact case... testing failure 😛
        describe("given source file,", function()
            it("should return corresponding test file", function()
                local corresponding_filepath = navigation.get_corresponding_filepath(SOME_CONFIG, A_FILEPATH)

                assert.equals(A_TEST_FILEPATH, corresponding_filepath)
            end)
        end)

        describe("given test file,", function()
            it("should return corresponding source file", function()
                local corresponding_filepath = navigation.get_corresponding_filepath(SOME_CONFIG, A_TEST_FILEPATH)

                assert.equals(A_FILEPATH, corresponding_filepath)
            end)
        end)
    end)
end)
