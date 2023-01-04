-- TODO:
-- Set extension automatically instead of hardcoded .tsx?
-- Create a "edit config" feature
-- Try to find pattern based on files (local sys_output = vim.fn.systemlist('find .'))
-- Handle corresponding directory (e.g. java convention: src ~ test)
local gototest = { storage_dir_path = vim.fn.expand("$HOME") .. "/" .. "/.local/share/nvim/gototest/" }

local function get_config()
    local configuration = require("gototest.configuration")

    local config = configuration.get_default()
    local working_dir = vim.fn.getcwd()
    local config_filepath = configuration.get_filepath(gototest.storage_dir_path, working_dir)

    if not require("utils").file_exists(config_filepath) then
        print("Gototest configuration file not found, create one? y/n")
        local answer = vim.fn.getchar()
        local y_char_value = 121
        if answer == y_char_value then
            os.execute("mkdir -p " .. gototest.storage_dir_path)
            config = configuration.prompt_user(config)
            configuration.write(config_filepath, config)
        end
    else
        config = configuration.read(config_filepath)
    end

    return config
end

local function delete_config()
    local configuration = require("gototest.configuration")
    local working_dir = vim.fn.getcwd()
    local config_filepath = configuration.get_filepath(gototest.storage_dir_path, working_dir)
    configuration.delete(config_filepath)
end

local function toggle_source_test()
    local navigation = require("gototest.navigation")
    local loaded_config = get_config()
    local current_filepath = vim.fn.expand("%")
    local corresponding_filepath = navigation.get_corresponding_filepath(loaded_config, current_filepath)
    if corresponding_filepath ~= nil then vim.api.nvim_command('edit ' .. corresponding_filepath) end
end

local function setup(settings)
    if settings ~= nil and settings.storage_dir_path ~= nil then
        gototest.storage_dir_path = require("gototest.utils").ensure_trailing_slash(settings.storage_dir_path)
    end

    vim.api.nvim_create_user_command("GoToTestToggle", toggle_source_test, {})
    vim.api.nvim_create_user_command("GoToTestDeleteConfig", delete_config, {})
end

gototest.setup = setup

return gototest
