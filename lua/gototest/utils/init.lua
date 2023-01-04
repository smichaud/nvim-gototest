local utils = {}

local function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

local function pattern_escape(text)
    return string.gsub(text, "%.", "%%.")
end

local function ends_with(str, ending)
    return ending == "" or str:sub(- #ending) == ending
end

local function ensure_trailing_slash(text)
    if not ends_with(text, "/") then return text .. "/" end
    return text
end

local function shallow_copy(original)
    local original_type = type(original)
    local copy
    if original_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(original) do copy[orig_key] = orig_value end
    else
        copy = original
    end

    return copy
end

utils.file_exists = file_exists
utils.pattern_escape = pattern_escape
utils.ends_with = ends_with
utils.shallow_copy = shallow_copy
utils.ensure_trailing_slash = ensure_trailing_slash

return utils
