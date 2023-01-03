local configuration = {}

-- TODO: Create default based on filetype
local function get_default()
    return {
        project_root = vim.fn.getcwd(),
        test_dir = "",
        test_file_prefix = "",
        test_file_suffix = "",
        extension_pattern = ""
    }
end

local function get_filepath(working_dir)
    local escaped_working_dir = string.gsub(working_dir, "/", "%%")
    -- TODO: Add a setting to customize config directory
    local user_home_dir = vim.fn.expand("$HOME")
    local vim_home_dir = user_home_dir .. "/.config/nvim"
    local config_filepath = vim_home_dir .. "/gototest/" .. escaped_working_dir

    return config_filepath
end

local function prompt_user(config)
    local user_project_root = vim.fn.input("project root: ", config.project_root)
    local user_test_dir = vim.fn.input("test dir: ", config.test_dir)
    local user_test_file_prefix = vim.fn.input("test file prefix: ", config.test_file_prefix)
    local user_test_file_suffix = vim.fn.input("test file suffix: ", config.test_file_suffix)
    local user_extension_pattern = vim.fn.input("test file extension pattern: ", config.extension_pattern)

    local escaped_config = {
        project_root = user_project_root,
        test_dir = string.gsub(user_test_dir, "%.", "%%."),
        test_file_prefix = string.gsub(user_test_file_prefix, "%.", "%%."),
        test_file_suffix = string.gsub(user_test_file_suffix, "%.", "%%."),
        extension_pattern = user_extension_pattern
    }

    return escaped_config
end

local function write(filepath, config_table)
    local file_handle = io.open(filepath, "w")
    if file_handle then
        for key, value in pairs(config_table) do file_handle:write(key .. " = " .. tostring(value) .. "\n") end
        file_handle:close()
    else
        error("Crap... Can't write the config file...", 1)
    end
end

local function read(filepath)
    local config = {}
    for line in io.lines(filepath) do
        local key, value = string.match(line, "^(.*) = (.*)$")
        config[key] = value
    end

    return config
end

local function delete(filepath)
    os.remove(filepath)
end

configuration.get_default = get_default
configuration.get_filepath = get_filepath
configuration.prompt_user = prompt_user
configuration.write = write
configuration.read = read
configuration.delete = delete

return configuration
