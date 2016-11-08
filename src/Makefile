######################################################################
# User configuration
######################################################################
# Path to nodemcu-uploader (https://github.com/kmpm/nodemcu-uploader)
NODEMCU-UPLOADER=nodemcu-uploader
# Serial port
PORT=/dev/ttyUSB0
SPEED=115200

######################################################################
# End of user config
######################################################################
HTTP_FILES := \
   index.html \
   app.js
   
LUA_FILES := $(wildcard *.lua)

# Print usage
usage:
	@echo "make upload FILE:=<file>  to upload a specific file (i.e make upload FILE:=init.lua)"
	@echo "make upload_http          to upload files to be served"
	@echo "make upload_server        to upload the server code and init.lua"
	@echo $(TEST)

# Upload one files only
upload:
	$(NODEMCU-UPLOADER) -b $(SPEED) -p $(PORT) upload $(FILE) --compile

# Upload HTTP files only
upload_http: $(HTTP_FILES)
	$(NODEMCU-UPLOADER) -b $(SPEED) -p $(PORT) upload $(foreach f, $^, $(f))

# Upload httpserver lua files (init and server module)
upload_server: $(LUA_FILES)
	$(NODEMCU-UPLOADER) -b $(SPEED) -p $(PORT) upload $(foreach f, $^, $(f)) --compile

terminal:
	$(NODEMCU-UPLOADER) -b $(SPEED) -p $(PORT) terminal

restart:
	$(NODEMCU-UPLOADER) -b $(SPEED) -p $(PORT) node restart