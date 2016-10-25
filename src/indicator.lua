function init()
    light_pin = 0   -- D0 led on board
    gpio.mode(light_pin, gpio.OUTPUT)
    ws2812.init()   -- D4
end

function setstatus(status)
    if status=="fail" then
        ws2812.write(string.char(255, 0, 0, 0, 255, 0, 0, 0))
        gpio.write(light_pin,gpio.LOW)
        gpio.write(buzz_pin,gpio.HIGH)
    elseif status=="success" then
        ws2812.write(string.char(0, 255, 0, 0, 0, 255, 0, 0))
        gpio.write(light_pin,gpio.HIGH)
        gpio.write(buzz_pin,gpio.LOW)
    else
        print("unknow status:", status)
    end
end

