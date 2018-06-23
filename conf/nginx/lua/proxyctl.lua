-- Debug pring helper
function dpr(message)
    if (tonumber(os.getenv("DEBUG_LOG")) > 0) then
        ngx.log(ngx.STDERR, "DEBUG: " .. message)
    end
end

-- Respond with a specific page (location) and status code
function response(location, status)
    local res = ngx.location.capture(location)
    ngx.header.content_type = 'text/html';
    ngx.status = status -- Set the status before printing anything
    ngx.print(res.body)

    -- Unlock host before exiting
    dpr("Unlocking " .. ngx.var.host)
    ngx.shared.hosts:delete(ngx.var.host)

    ngx.exit(status)
end

-- Get the host lock timestamp
local timestamp = os.time(os.date("!*t"))
local lock_timestamp = ngx.shared.hosts:get(ngx.var.host)

if (lock_timestamp == nil) then lock_timestamp = 0 end
local lock_age = timestamp - lock_timestamp

-- Break the lock if it is older than 30s
if (lock_age > 30) then
    dpr("Unlocking a stale lock (" .. lock_age .. "s) for " .. ngx.var.host)
    ngx.shared.hosts:delete(ngx.var.host)
end

-- No lock timestamp = can proceed with project wake up
if (lock_timestamp == 0) then

    dpr("Locking " .. ngx.var.host)
    lock_timestamp = os.time(os.date("!*t"))
    ngx.shared.hosts:set(ngx.var.host, lock_timestamp)

    -- Lanch project start script
    -- os.execute returs multiple values starting with Lua 5.2
    local status, exit, exit_code = os.execute("PATH=/usr/local/bin:$PATH sudo proxyctl start \"" .. ngx.var.host .. "\"")

    -- If all went well, reload the page using /loading.html
    if (exit_code == 0) then
        dpr("Container start succeeded")
        response("/loading.html", ngx.HTTP_OK)
    -- If proxyctl start failed (non-existing environment or something went wrong), return /not-found.html
    else
        dpr("Container start failed")
        response("/loading.html", ngx.HTTP_NOT_FOUND)
    end
-- There is an active lock, so skip for now
else
    dpr(ngx.var.host .. " is locked. Skipping.")
end
