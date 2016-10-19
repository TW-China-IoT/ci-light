
-- network
wifi.setmode(wifi.STATIONAP)

wifi.ap.config({ssid="NODE-" .. node.chipid(), auth=wifi.OPEN})

wifi.sta.config("your_ssid","your_password")
wifi.sta.connect()

wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T) 
 print("\n\tSTA - CONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..T.BSSID.."\n\tChannel: "..T.channel)
end)
wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T) 
 print("\n\tSTA - DISCONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..T.BSSID.."\n\treason: "..T.reason)
end)
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T) 
 print("\n\tSTA - GOT IP".."\n\tStation IP: "..T.IP.."\n\tSubnet mask: "..T.netmask.."\n\tGateway IP: "..T.gateway)
end)

-- light & buzz
buzz_pin = 1   -- D1 buzz
gpio.mode(buzz_pin, gpio.OUTPUT)
light_pin = 0   -- D0 led on board
gpio.mode(light_pin, gpio.OUTPUT)
ws2812.init()   -- D4
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
setstatus("success")
function stopbuzz()
	gpio.write(buzz_pin,gpio.LOW)
end

-- shake
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
			stopbuzz()
		end
	end
end)

-- rest api
srv = net.createServer(net.TCP)
srv:listen(80, function(conn)
    conn:on("receive", function(sck, payload)
        print("payload:\n", payload)
        -- if nil~=string.find(payload, "POST.+/cilight.+application/json.+status.*:.*success.+") then
        if nil~=string.find(payload, "GET.+/cilight.+status=success.*") then
        	sck:send("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n")
        	setstatus("success")
    	-- elseif nil~=string.find(payload, "POST.+/cilight.+application/json.+status.*:.*fail.+") then
    	elseif nil~=string.find(payload, "GET.+/cilight.+status=fail.*") then
    		sck:send("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n")
    		setstatus("fail")
    	else
    		sck:send("HTTP/1.0 400 OK\r\nContent-Type: text/html\r\n\r\n<h1> Invalid Request </h1>")
    	end
    end)
    conn:on("sent", function(sck)
    	sck:close()
    end)
end)

