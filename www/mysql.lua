local mysql = require "resty.mysql"
local db, err = mysql:new()
if not db then
    ngx.say("failed to instantiate mysql:", err)
    return 
end

db:set_timeout(1000);

local ok, err, errno, sqlstate = db:connect{
    host = "127.0.0.1",
    port = 3306,
    database = "test",
    user = "root",
    password = "123456",
    max_packet_size = 1024 * 1024
}

if not ok then
    ngx.say("fail to connect:", err, ": ", errno, ": ", sqlstate, ".");
    return 
end

ngx.say("connected to mysql.")

local res, err, error, sqlstate = 
    db:query("select * from test")

if not res then
    ngx.say("error happen: ", err, ": ", errno, ": ", sqlstate, ".")
    return 
end

local cjson = require "cjson"
ngx.say("result: ", cjson.encode(res))

local ok, err = db:close()

if not ok then
    ngx.say("failed to close: ", err)
    return 
else
    ngx.say("close ok");
end



