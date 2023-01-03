local M = {}

local function get_default_config()
    return {
        project_root = vim.fn.getcwd(),
        test_dir = "test",
        test_file_prefix = "",
        test_file_suffix = ".test",
        extension_pattern = "tsx?"
    }
end

local function write_config(config_filepath, config)
    local file_handle = io.open(config_filepath, "w")
    if file_handle then
        for key, value in pairs(config) do file_handle:write(key .. " = " .. tostring(value) .. "\n") end
        file_handle:close()
    else
        error("Crap... Can't write the config file...", 1)
    end
end

local function read_config(config_filepath)
    local config = {}
    for line in io.lines(config_filepath) do
        local key, value = string.match(line, "^(.*) = (.*)$")
        config[key] = value
    end

    return config
end

M.get_default_config = get_default_config
M.write_config = write_config
M.read_config = read_config

return M
