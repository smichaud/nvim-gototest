local M = {}

-- TODO:
-- Set extension automatically instead of hardcoded .tsx?
-- Reset, edit and/or delete config
-- Unit test in lua?
-- Try to find pattern based on files (local sys_output = vim.fn.systemlist('find .'))
-- Handle corresponding directory (e.g. java convention: src ~ test)
local function get_config()
    local working_dir = vim.fn.getcwd()

    local config = {
        project_root = working_dir,
        test_dir = "test",
        test_file_prefix = "",
        test_file_suffix = ".test",
        extension_pattern = "tsx?"
    }

    local escaped_working_dir = string.gsub(working_dir, "/", "%%")
    local user_home_dir = vim.fn.expand("$HOME")
    local vim_home_dir = user_home_dir .. "/.config/nvim"
    local config_filepath = vim_home_dir .. "/gototest/" .. escaped_working_dir

    if not require("utils").file_exists(config_filepath) then
        print("GoToTest configuration file not found, create one? y/n")
        local answer = vim.fn.getchar()

        local y_char_value = 121
        if answer == y_char_value then
            os.execute("mkdir -p " .. "$HOME/.config/nvim/gototest/")

            local user_project_root = vim.fn.input("project root: ", config.project_root)
            local user_test_dir = vim.fn.input("test dir: ", config.test_dir)
            local user_test_file_prefix = vim.fn.input("test file prefix: ", config.test_file_prefix)
            local user_test_file_suffix = vim.fn.input("test file suffix: ", config.test_file_suffix)
            local user_extension_pattern = vim.fn.input("test file extension pattern: ", config.extension_pattern)

            config = {
                project_root = user_project_root,
                test_dir = string.gsub(user_test_dir, "%.", "%%."),
                test_file_prefix = string.gsub(user_test_file_prefix, "%.", "%%."),
                test_file_suffix = string.gsub(user_test_file_suffix, "%.", "%%."),
                extension_pattern = user_extension_pattern
            }

            local file_handle = io.open(config_filepath, "w")
            if file_handle then
                for key, value in pairs(config) do
                    file_handle:write(key .. " = " .. tostring(value) .. "\n")
                end
                file_handle:close()
            else
                print("Crap... Can't write the config file...")
            end
        end
    else
        config = {}
        for line in io.lines(config_filepath) do
            local key, value = string.match(line, "^(.*) = (.*)$")
            config[key] = value
        end
    end

    return config
end

local function _gototest(config, filepath)
    print("TODO")
end

local function gototest()
    local config = get_config()

    local current_filepath = vim.fn.expand("%")

    local escaped_test_file_prefix = config.test_file_prefix
    local escaped_test_file_suffix = config.test_file_suffix
    local test_file_pattern = "(.*/)" .. config.test_dir .. "/" .. escaped_test_file_prefix .. "(.*)" ..
        escaped_test_file_suffix .. "(%." .. config.extension_pattern .. ")$"
    local root_path, filename, extension = string.match(current_filepath, test_file_pattern)
    local is_test_file = root_path and filename and extension

    if is_test_file then
        local src_filepath = root_path .. filename .. extension
        vim.api.nvim_command('edit ' .. src_filepath)
    else
        local ext = string.match(current_filepath, "%.[a-zA-Z0-9]+$")
        local basepath, src_filename = string.match(current_filepath, "(.*/)(.*%" .. ext .. ")$")
        local is_valid_src_file = basepath and src_filename
        if is_valid_src_file then
            src_filename = config.test_file_prefix .. src_filename
            local test_filename = string.gsub(src_filename, ext, config.test_file_suffix .. ext)
            local test_filepath = basepath .. config.test_dir .. "/" .. test_filename
            vim.api.nvim_command('edit ' .. test_filepath)
        end
    end
end

local function setup()
    vim.api.nvim_create_user_command("GoToTest", gototest, {})
end

M.setup = setup
M.get_config = get_config
M.gototest = gototest

return M
