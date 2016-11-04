# CI-Light

### Burning Firmware
1. pip install esptool
2. press "flash" button on board
3. esptool.py --port [tty_port] write_flash -fm dio -fs 32m 0x00000 firmware/nodemcu-integer.bin

### Firmware build modules
Build on https://nodemcu-build.com/

You do not need to upgrade firmware unless you need other modules
 
With modules: adc cjson crypto encoder file gpio http net node ow pcm pwm spi struct tmr websocket wifi ws2812

### Config in Code

update line in file "src/main.lua" with your AP SSID and password:
	
	wifi.sta.config("your_ssid","your_password")

### Upload to Board
1. pip install nodemcu-uploader
2. cd src
3. nodemcu-uploader --port [tty_port] upload index.html dingdong_8k.u8
3. nodemcu-uploader --port [tty_port] upload *.lua --compile
4. nodemcu-uploader --port [tty_port] node restart

### Test
	$ curl http://[ip]/cilight?status=fail
    # red light + buzzing
    
    # shake device，buzzing will be stopped
	
	$ curl http://[ip]/cilight?status=success
	# green light

    $ curl http://[ip]/getap
	
Note: IP address will show on [tty_port] when board starting; or, use "print(wifi.sta.getip())" to get it on a running board.
