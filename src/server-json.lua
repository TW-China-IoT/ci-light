-- httpserver-json.lua
-- Part of nodemcu-httpserver, handles sending static files to client.
-- Author: Marcos Kirsch

return function (connection, req, args)
    dofile("server-header.lc")(connection, req, args)
    connection:send(args.data)
    args.data = nil
    collectgarbage()
end
