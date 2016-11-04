indicator = {}

local buzz = require("buzz")
local light_pin = 0     -- D0 led on board

function indicator.init()
    gpio.mode(light_pin, gpio.OUTPUT)
    ws2812.init()   -- D4
end

function indicator.setstatus(status)
    if status=="fail" then
        buffer=ws2812.newBuffer(16, 3)
        buffer:fill(30, 255, 0)
        ws2812.write(buffer)
        gpio.write(light_pin, gpio.LOW)
        buzz.startbuzz()
    elseif status=="success" then
        buffer=ws2812.newBuffer(16, 3)
        buffer:fill(255, 255, 255)
        ws2812.write(buffer)
        gpio.write(light_pin, gpio.HIGH)
        buzz.stopbuzz()
    elseif status=="booting" then
        buffer=ws2812.newBuffer(16, 3)
        buffer:fill(0, 0, 255)
        ws2812.write(buffer)
        gpio.write(light_pin, gpio.LOW)
    else
        print("unknow status:", status)
    end
    collectgarbage()
end

return indicator

