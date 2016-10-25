local conf = require("wifi")
local indicator = require("indicator")
local buzz = require("buzz")

buzz.init()
buzz.stopbuzz()
indicator.init()
indicator.setstatus("success")

dofile("server.lc")(80)

