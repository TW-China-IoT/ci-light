-- shake
local buzz = require("buzz")

function init()
    shake_sensor_pin = 2   -- D2 shake sensor
    gpio.mode(shake_sensor_pin, gpio.INT)
    shake_smooth_width = 300000
    shake_count = 0
    shake_start_ticks = {}
    shake_window_width = 5
    shake_minimum_duration = 800000
    shake_maximum_duration = 1300000
    gpio.trig(shake_sensor_pin, "both", function(level)
        now_tick = tmr.now()
        if shake_count>1 and (now_tick-shake_start_ticks[shake_count])<shake_smooth_width then
            return
        end

        shake_count = shake_count + 1
        -- print("shake!", shake_count)
        shake_start_ticks[shake_count] = now_tick

        if shake_count>=shake_window_width then
            -- for i=1,shake_window_width do print(shake_start_ticks[i]) end
            span = shake_start_ticks[shake_window_width] - shake_start_ticks[1]
            print("span ", span)
            if span>shake_maximum_duration or span<shake_minimum_duration then
                for i=1,(shake_window_width-1) do shake_start_ticks[i]=shake_start_ticks[i+1] end
                shake_count = shake_count - 1
            else
                shake_count = 0
                print("shake detected with level: ", level)
                buzz.stopbuzz()
            end
        end
    end)
end

