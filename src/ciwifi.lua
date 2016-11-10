-- network
ciwifi = {}

local config = require("config")
local parameter = config.read()

local wifiConfig = {}
local aplist = {}
local connected = false
local ip = nil

function ciwifi.setup()
    -- wifi.STATION         -- station: join a WiFi network
    -- wifi.SOFTAP          -- access point: create a WiFi network
    -- wifi.wifi.STATIONAP  -- both station and access point
    wifiConfig.mode = wifi.STATIONAP  -- both station and access point

    -- AP
    wifiConfig.accessPointConfig = {}
    wifiConfig.accessPointConfig.ssid = "CILIGHT-"..node.chipid()   -- Name of the SSID you want to create
    --wifiConfig.accessPointConfig.pwd = "CILIGHT-"..node.chipid()    -- WiFi password - at least 9 characters
    wifiConfig.accessPointConfig.auth = wifi.OPEN

    wifiConfig.accessPointIpConfig = {}
    wifiConfig.accessPointIpConfig.ip = "192.168.100.1"
    wifiConfig.accessPointIpConfig.netmask = "255.255.255.0"
    wifiConfig.accessPointIpConfig.gateway = "192.168.100.1"

    wifi.setmode(wifiConfig.mode)
    print('set (mode='..wifi.getmode()..')')
    print('AP MAC: ',wifi.ap.getmac())

    wifi.ap.config(wifiConfig.accessPointConfig)
    wifi.ap.setip(wifiConfig.accessPointIpConfig)

    wifiConfig = nil
    collectgarbage()

    refresh_ap_list()
    --tmr.alarm(1, 5000, tmr.ALARM_AUTO, refresh_ap_list) 

    if config.check() then
        -- STATION
        wifi.sta.config(parameter[config.SSID], parameter[config.PWD])
        wifi.sta.connect()
        wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T) 
            print("\n\tSTA - CONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..T.BSSID.."\n\tChannel: "..T.channel)
            collectgarbage()
            connected = true
        end)
        wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T) 
            print("\n\tSTA - DISCONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..T.BSSID.."\n\treason: "..T.reason)
            collectgarbage()
            connected = false
        end)
        wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T) 
            print("\n\tSTA - GOT IP".."\n\tStation IP: "..T.IP.."\n\tSubnet mask: "..T.netmask.."\n\tGateway IP: "..T.gateway)
            collectgarbage()
            ip = T.IP
        end)
    end
end

function listap(t)
    for k in pairs(aplist) do
        aplist[k] = nil
    end
    collectgarbage()
    --print("\n"..string.format("%32s","SSID").."\tBSSID\t\t\t\t  RSSI\t\tAUTHMODE\tCHANNEL")
    for ssid,v in pairs(t) do
        local authmode, rssi, bssid, channel = string.match(v, "([^,]+),([^,]+),([^,]+),([^,]+)")
        --print(string.format("%32s",ssid).."\t"..bssid.."\t  "..rssi.."\t\t"..authmode.."\t\t\t"..channel)
        aplist[ssid] = authmode 
    end
    collectgarbage()
end

function refresh_ap_list()
    wifi.sta.getap(listap)
end

function ciwifi.get_ap_list()
    ok, json = pcall(cjson.encode, aplist)
    refresh_ap_list()
    if ok then
        collectgarbage()
        return json
    else
        collectgarbage()
        return "{}"
    end
end

function ciwifi.is_connected()
    if connected then
        return '{"connected": "true"}'
    else
        return '{"connected: "false"}'
    end
end

function ciwifi.get_ip()
    if ip then
        return '{"ip": "'..ip..'"}'
    else
        return '{}'
    end
end

return ciwifi
