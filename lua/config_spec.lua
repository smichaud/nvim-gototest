local config = require("config")

describe("get_default_config", function()
    it("should return empty strings config", function()
        local default_config = config.get_default_config()

        assert.equals(default_config.test_dir, "test")
        assert.equals(default_config.test_file_prefix, "")
        assert.equals(default_config.test_file_suffix, "")
        assert.equals(default_config.extension_pattern, "")
    end)
end)

describe("write_config --> read_config", function()
    local some_config = {
        project_root = "/project_root",
        test_dir = "test_dir",
        test_file_prefix = "prefix",
        test_file_suffix = ".suffix",
        extension_pattern = "txt"
    }

    it("should result in same config", function()
        local a_temp_file_path = os.tmpname()

        config.write_config(a_temp_file_path, some_config)
        local result_config = config.read_config(a_temp_file_path)

        assert.equals(result_config, some_config)
        for k, _ in pairs(some_config) do assert.equals(result_config[k], some_config[k]) end
    end)
end)
