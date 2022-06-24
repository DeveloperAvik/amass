-- Copyright 2021 Jeff Foley. All rights reserved.
-- Use of this source code is governed by Apache 2 LICENSE that can be found in the LICENSE file.

local url = require("url")

name = "Searx"
type = "scrape"

function start()
    set_rate_limit(2)
    math.randomseed(os.time())
end

function vertical(ctx, domain)
    -- Qualified best SearX/SearXNG instances
    local instances = {
        "https://anon.sx",
        "https://etsi.me",
        "https://northboot.xyz",
        "https://procurx.pt",
        "https://searx.be",
        "https://searx.info",
        "https://searx.ninja",
        "https://searx.ru",
        "https://swag.pw",
    }
    -- Randomly choose one instance for scraping
    local host = instances[math.random(1, 9)] .. "/search"

    for i=1,10 do
        local query = "site:" .. domain .. " -www"
        local params = {
            ['q']=query,
            ['pageno']=i,
            ['category_general']="1",
            ['time_range']="None",
            ['language']="en-US",
        }

        local ok = scrape(ctx, {
            ['url']=host,
            method="POST",
            data=url.build_query_string(params),
            headers={['Content-Type']="application/x-www-form-urlencoded"},
        })
        if not ok then
            break
        end
    end
end
