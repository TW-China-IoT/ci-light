local ciwifi = require("ciwifi")
local indicator = require("indicator")
local buzz = require("buzz")

buzz.init()
buzz.stopbuzz()
indicator.init()
indicator.setstatus("success")
ciwifi.setup()

dofile("server.lc")(80)

