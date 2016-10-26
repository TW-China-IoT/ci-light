indicator = {}

local buzz = require("buzz")
local light_pin = 0     -- D0 led on board

function indicator.init()
    gpio.mode(light_pin, gpio.OUTPUT)
    ws2812.init()   -- D4
end

function indicator.setstatus(status)
    if status=="fail" then
        ws2812.write(string.char(255, 0, 0, 0, 255, 0, 0, 0))
        gpio.write(light_pin, gpio.LOW)
        buzz.startbuzz()
    elseif status=="success" then
        ws2812.write(string.char(0, 255, 0, 0, 0, 255, 0, 0))
        gpio.write(light_pin, gpio.HIGH)
        buzz.stopbuzz()
    else
        print("unknow status:", status)
    end
    collectgarbage()
end

return indicator

