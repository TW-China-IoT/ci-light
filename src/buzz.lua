buzz = {}

local buzz_pin = 1   -- D1 buzz

function buzz.init()
    gpio.mode(buzz_pin, gpio.OUTPUT)
end

function buzz.startbuzz()
    gpio.write(buzz_pin,gpio.HIGH)
end

function buzz.stopbuzz()
    gpio.write(buzz_pin,gpio.LOW)
end

return buzz

