local ciwifi = require("ciwifi")
local indicator = require("indicator")
local buzz = require("buzz")
local shake = require("shake")

print("\nstart app\n\n")

buzz.init()
buzz.stopbuzz()
indicator.init()
indicator.setstatus("success")
ciwifi.setup()
shake.init()

dofile("server.lc")(80)

