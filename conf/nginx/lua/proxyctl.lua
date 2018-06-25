-- Debug pring helper
function dpr(message)
    if (tonumber(os.getenv("DEBUG_LOG")) > 0) then
        ngx.log(ngx.STDERR, "DEBUG: " .. message)
    end
end

-- Helper function to read a file from disk
function read_file(path)
    local open = io.open
    local file = open(path, "rb") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

-- Returns loading.html for HTTP_OK and not-found.html otherwise
function response(status)
    -- Load response body from disk
    -- This used to be done with ngx.location.capture, which does not support HTTP/2 and fails with https requests:
    -- See https://github.com/openresty/lua-nginx-module/issues/1285#issuecomment-376418678
    -- While direct file operations may be inefficient, they won't happen often, so this should be fine.
    -- An alternative option would be to use lua-resty-http to replace ngx.location.capture for subrequests.
    local response_body
    if (status == ngx.HTTP_OK) then
        response_body = read_file('/var/www/proxy/loading.html')
    else
        response_body = read_file('/var/www/proxy/not-found.html')
    end

    ngx.header["Content-Type"] = 'text/html'
    ngx.status = status -- Set the status before printing anything
    ngx.print(response_body)

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

    -- If all went well, reload the page
    if (exit_code == 0) then
        dpr("Container start succeeded")
        response(ngx.HTTP_OK)
    -- If proxyctl start failed (non-existing environment or something went wrong), return 404
    else
        dpr("Container start failed")
        response(ngx.HTTP_NOT_FOUND)
    end
-- There is an active lock, so skip for now
else
    dpr(ngx.var.host .. " is locked. Skipping.")
end
