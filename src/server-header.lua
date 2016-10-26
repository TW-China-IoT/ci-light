-- server-header.lua
-- Part of nodemcu-httpserver, knows how to send an HTTP header.
-- Author: Marcos Kirsch

return function (connection, req, args)

    local function getHTTPStatusString(code)
        local codez = {[200]="OK", [400]="Bad Request", [404]="Not Found",}
        local myResult = codez[code]
        -- enforce returning valid http codes all the way throughout?
        if myResult then return myResult else return "Not Implemented" end
    end

    local function getMimeType(ext)
        -- A few MIME types. Keep list short. If you need something that is missing, let's add it.
        local mt = {css = "text/css", gif = "image/gif", html = "text/html", ico = "image/x-icon", jpeg = "image/jpeg", jpg = "image/jpeg", js = "application/javascript", json = "application/json", png = "image/png", xml = "text/xml"}
        if mt[ext] then return mt[ext] else return "text/plain" end
    end

    local mimeType = getMimeType(args.extension)

    connection:send("HTTP/1.0 " .. args.code .. " " .. getHTTPStatusString(args.code) .. "\r\nServer: ci-light-server\r\nContent-Type: " .. mimeType .. "\r\nnCache-Control: private, no-store\r\n")
    if args.isGzipped then
        connection:send("Cache-Control: max-age=2592000\r\nContent-Encoding: gzip\r\n")
    end
    connection:send("Connection: close\r\n\r\n")

end


