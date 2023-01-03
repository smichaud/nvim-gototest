local navigation = {}

local function get_adjusted_test_dir(test_dir)
    if test_dir == "" then return test_dir end
    if not require("gototest.utils").ends_with(test_dir, "/") then return test_dir .. "/" end
    return test_dir
end

local function decompose_test_file(config, filepath)
    local adjusted_test_dir = get_adjusted_test_dir(config.test_dir)
    local pattern = "(.*/)" .. adjusted_test_dir .. config.test_file_prefix .. "(.*)" .. config.test_file_suffix ..
        "(%." .. config.extension_pattern .. ")$"
    local root_path, bare_filename, extension = string.match(filepath, pattern)

    return root_path, bare_filename, extension
end

local function decompose_source_file(filepath)
    local extension = string.match(filepath, "%.[a-zA-Z0-9]+$")
    local base_path, filename = string.match(filepath, "(.*/)(.*%" .. extension .. ")$")
    return base_path, filename, extension
end

local function get_corresponding_filepath(config, filepath)
    local adjusted_test_dir = get_adjusted_test_dir(config.test_dir)
    local root_path, bare_filename, extension = decompose_test_file(config, filepath)

    local is_test_file = root_path and bare_filename and extension
    if is_test_file then
        local source_filepath = root_path .. bare_filename .. extension

        return source_filepath
    else
        local base_path, filename, extension = decompose_source_file(filepath)
        local is_valid_source_file = base_path and filename
        if is_valid_source_file then
            filename = config.test_file_prefix .. filename
            local test_filename = string.gsub(filename, extension, config.test_file_suffix .. extension)
            local test_filepath = base_path .. adjusted_test_dir .. test_filename

            return test_filepath
        end
    end
end

navigation.get_corresponding_filepath = get_corresponding_filepath
navigation.decompose_test_file = decompose_test_file

return navigation
