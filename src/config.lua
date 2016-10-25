config = {}

config.SSID = "ssid"
config.PWD = "pwd"

local NETWORK_SSID_CONF = "network_ssid.conf"
local NETWORK_PWD_CONF = "network_pwd.conf"

local config_files = {
    [config.SSID] = NETWORK_SSID_CONF,
    [config.PWD] = NETWORK_PWD_CONF
}

function config_trim(s) 
    return (string.gsub(s, "^%s*(.-)%s*$", "%1")) 
end

function config_trimrn(s)
    s = string.gsub(s, "\r", "")
    s = string.gsub(s, "\n", "")
    return s
end

function config_iscontain(set, key)
    return set[key] ~= nil
end

function config_check_exists()
    for k, f in pairs(config_files) do
        if file.open(f) then
            file.close()
        else
            return false
        end
    end
    return true
end

function config_write_content(filename, content)
    print(config_files[filename])
    if file.open(config_files[filename], "w+") then
        file.writeline(content)
        file.flush()
        file.close()
    end
end

function config_read_content(filename)
    local content = nil
    print("config_read_content: " ..filename)
    if file.open(filename) then
        content = file.readline()
        file.close()
    end
    if content then
        content = config_trim(content)
        content = config_trimrn(content)
    end
    return content
end

function config_check_content()
    local content = nil
    for k, f in pairs(config_files) do
        content = config_read_content(f)
        print(content)
        if content then
            if string.len(content) == 0 then
                return false
            end
        else
            return false
        end
    end
    return true
end

function config.check()
    local ret = config_check_exists()
    if ret then
        ret = config_check_content()
    end
    return ret
end

function config.write(conf)
    local config_fields = {config.SSID, config.PWD}
    for _, field in ipairs(config_fields) do
        if config_iscontain(conf, field) then
            print("write config to file: " .. field .. "-" .. conf[field])
            config_write_content(field, conf[field])
        end
    end
end

function config.read()
    local conf = {}
    local config_fields = {config.SSID, config.PWD}
    for _, field in ipairs(config_fields) do
        conf[field] = config_read_content(config_files[field])
    end
    return conf
end

return config

