local navigation = {}

local pattern_escape = require("gototest.utils").pattern_escape

local function get_adjusted_test_dir(test_dir)
    if test_dir == "" then return test_dir end
    return require("gototest.utils").ensure_trailing_slash(test_dir)
end

local function decompose_test_file(config, filepath)
    local adjusted_test_dir = get_adjusted_test_dir(config.test_dir)
    local pattern = "(.*/)" .. adjusted_test_dir .. pattern_escape(config.test_file_prefix) .. "(.+)" ..
        pattern_escape(config.test_file_suffix) .. "(%." .. config.extension_pattern .. ")$"
    local base_path, bare_filename, extension = string.match(filepath, pattern)

    return base_path, bare_filename, extension
end

local function decompose_source_file(filepath)
    local base_path, bare_filename, extension = string.match(filepath, "(.-)([^\\/]-)(%.?[^%.\\/]*)$")

    return base_path, bare_filename, extension
end

local function get_corresponding_filepath(config, filepath)
    local adjusted_test_dir = get_adjusted_test_dir(config.test_dir)

    local test_base_path, bare_filename, test_ext = decompose_test_file(config, filepath)
    local is_test_file = test_base_path and bare_filename and test_ext
    if is_test_file then
        local source_filepath = test_base_path .. bare_filename .. test_ext

        return source_filepath
    else
        local source_base_path, source_bare_filename, source_ext = decompose_source_file(filepath)
        local is_valid_source_file = source_base_path and source_bare_filename and
            string.match(source_ext, "%." .. config.extension_pattern)
        if is_valid_source_file then
            local test_filepath = source_base_path .. adjusted_test_dir .. config.test_file_prefix ..
                source_bare_filename .. config.test_file_suffix .. source_ext

            return test_filepath
        end
    end
end

navigation.get_corresponding_filepath = get_corresponding_filepath
navigation.decompose_test_file = decompose_test_file
navigation.decompose_source_file = decompose_source_file

return navigation
