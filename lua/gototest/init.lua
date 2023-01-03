-- TODO:
-- Set extension automatically instead of hardcoded .tsx?
-- Create a "edit config" feature
-- Enable config dir settings (instead of forcing ~/.local/share/nvim)
-- Try to find pattern based on files (local sys_output = vim.fn.systemlist('find .'))
-- Handle corresponding directory (e.g. java convention: src ~ test)
local gototest = {}

local function get_config()
    local configuration = require("gototest.configuration")

    local config = configuration.get_default()
    local working_dir = vim.fn.getcwd()
    local config_filepath = configuration.get_filepath(working_dir)

    if not require("utils").file_exists(config_filepath) then
        print("GoToTest configuration file not found, create one? y/n")
        local answer = vim.fn.getchar()
        local y_char_value = 121
        if answer == y_char_value then
            os.execute("mkdir -p " .. "$HOME/.config/nvim/gototest/")
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
    local config_filepath = configuration.get_filepath(working_dir)
    configuration.delete(config_filepath)
end

local function toggle_source_test()
    local navigation = require("gototest.navigation")
    local loaded_config = get_config()
    local current_filepath = vim.fn.expand("%")
    local corresponding_filepath = navigation.get_corresponding_filepath(loaded_config, current_filepath)
    if corresponding_filepath ~= nil then vim.api.nvim_command('edit ' .. corresponding_filepath) end
end

local function setup()
    vim.api.nvim_create_user_command("GoToTestToggle", toggle_source_test, {})
    vim.api.nvim_create_user_command("GoToTestDeleteConfig", delete_config, {})
end

gototest.setup = setup

return gototest
