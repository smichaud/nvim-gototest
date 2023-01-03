local configuration = require("gototest.configuration")

describe("get_default", function()
    it("should return empty strings config", function()
        local default_config = configuration.get_default()

        assert.equals(default_config.test_dir, "")
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

        configuration.write(a_temp_file_path, some_config)
        local result_config = configuration.read(a_temp_file_path)

        for k, _ in pairs(some_config) do assert.equals(result_config[k], some_config[k]) end
    end)
end)
