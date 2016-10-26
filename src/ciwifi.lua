-- network
ciwifi = {}

local config = require("config")
local parameter = config.read()

local wifiConfig = {}

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

    if config.check() then
        -- STATION
        wifi.sta.config(parameter[config.SSID], parameter[config.PWD])
        wifi.sta.connect()
        wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T) 
            print("\n\tSTA - CONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..T.BSSID.."\n\tChannel: "..T.channel)
            collectgarbage()
        end)
        wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T) 
            print("\n\tSTA - DISCONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..T.BSSID.."\n\treason: "..T.reason)
            collectgarbage()
        end)
        wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T) 
            print("\n\tSTA - GOT IP".."\n\tStation IP: "..T.IP.."\n\tSubnet mask: "..T.netmask.."\n\tGateway IP: "..T.gateway)
            collectgarbage()
        end)
    end
end

return ciwifi
