function init()
    buzz_pin = 1   -- D1 buzz
    gpio.mode(buzz_pin, gpio.OUTPUT)
end

function stopbuzz()
    gpio.write(buzz_pin,gpio.LOW)
end

