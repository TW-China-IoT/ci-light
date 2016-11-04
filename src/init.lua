print("\nCI Light Started\n\n")
print("\nbooting\n\n")

local indicator = require("indicator")

-- boot main.lc with 3 seconds delay
tmr.alarm(0, 3000, tmr.ALARM_SINGLE, function()
    tmr.unregister(1)
    dofile("main.lc")
end)

-- if GPIO0 is low, then stop booting
gpio.mode(3, gpio.INPUT)    -- D3 GPIO0
tmr.alarm(1, 300, tmr.ALARM_AUTO, function()
    if gpio.read(3) == 0 then
        tmr.unregister(0)
        print("stop booting")
        tmr.unregister(1)

        indicator.setstatus("maintenance")
    end
end)

-- clean
indicator = nil
collectgarbage()
