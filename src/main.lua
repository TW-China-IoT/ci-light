local ciwifi = require("ciwifi")
local indicator = require("indicator")
local buzz = require("buzz")
local shake = require("shake")

buzz.init()
buzz.stopbuzz()
indicator.init()
indicator.setstatus("success")
ciwifi.setup()
shake.init()

dofile("server.lc")(80)

