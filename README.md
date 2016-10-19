# CI-Light

### Burning Firmware
1. pip install esptool
2. press "flash" button on board
3. esptool.py --port [tty_port] write_flash -fm dio -fs 32m 0x00000 firmware/nodemcu-master-8-modules-2016-10-12-09-42-54-integer.bin

### Config

update line in file "src/main.lua" with your AP SSID and password:
	
	wifi.sta.config("your_ssid","your_password")

### Upload
1. pip install nodemcu-uploader
2. nodemcu-uploader --port [tty_port] upload src/*.lua
3. nodemcu-uploader --port [tty_port] node restart
