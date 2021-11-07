-- GMA2 Pool Cleaner v1.0.3c
-- Last Updated: 10.16.2021
-- Creator: Calea Designs
-- Contact: CaleaDesigns@gmail.com
--
-- Project Repository: https://github.com/Calea-Designs/gma2-pool-cleaner
--
-- GMA2 Pool Cleaner is designed to comb through a desired object pool to find
-- and delete objects with duplicate names
-- This is a brute force method and will not check if the data contained within
-- the objects is actually duplicated.
--
-- IT IS URGED TO MAKE A BACKUP SHOWFILE BEFORE RUNNING THIS PLUGIN.
--
-- FEEDBACK WILL BE DISPLAYED IN THE SYSTEM MONITOR AS EACH TARGET IS FOUND
-- AND DELETED. CHECK THIS IF SOMETHING IS MISSING
--
-- You've been warned ( ツ )_/¯
--
-- These are your user settings, edit these as needed for each run
local poolType = "macro" -- enter which pool to clean, MUST LEAVE ''
local startId = 1 -- which pool object to start at
local finishId = 30 -- which pool object to end at

-- define GMA2 API functions
local maPrint = gma.echo
local maCmd = gma.cmd
local getHandle = gma.show.getobj.handle
local getName = gma.show.getobj.name

-- shortcut functions
function match(a, b) -- matches strings, returns false if they are not strings
    if type(a) == "string" and type(b) == "string" then
        if string.find(string.lower(a), string.lower(b)) ~= nil and string.len(a) == string.len(b) then
            return true
        else
            return false
        end
    else
        return false
    end
end

function strip(text, n) -- removes GMA2 pool ID numbers from object names
    if type(text) == "string" then
        text = string.gsub(text, tostring(n), "")
    end
    return text
end

--plugin start
function Start()
    maPrint("POOL CLEANER v1.0.3 ACTIVATED")
    local pool = {} -- where we will load pool information
    -- loading phase
    maPrint("LOADING OBJECTS FROM "..string.upper(poolType).." POOL")
    for i = startId, finishId do -- loads required pool into a table
        local handle = getHandle(poolType .. " " .. i)
        if handle ~= nil then
            local a = getName(handle)
            pool[i] = a
        end
    end
    -- comparison and deletion phase
    maPrint("LOAD SUCCESSFUL, BEGINNING DELETION")
    local killcount = 0 -- counter for deleted objects
    for compId = startId, finishId do
        local v = compId + 1
        local object_name = pool[compId]
        if object_name ~= nil and getHandle(poolType .. " " .. compId) ~= nil then -- existence?
            for x = v, finishId do
                if pool[x] ~= nil and getHandle(poolType .. " " .. x) ~= nil then -- existence?
                    if match(strip(pool[x], x), strip(object_name, compId)) == true then -- checks for match disregarding pool ID number
                        maPrint("FOUND MATCH: {" .. pool[compId] .. ", " .. pool[x] .. "}")
                        maPrint("DELETING: " .. pool[x])
                        maCmd("Delete " .. poolType .. " " .. x)
                        killcount = killcount + 1
                    end -- duplicate check
                end -- existence 2
            end -- inner for
        end -- existence 1
    end -- Outer for
    maPrint("DELETED " .. killcount .. " " .. string.upper(poolType) .. "S")
    maPrint("POOL CLEANER FINISHED")
end
return Start
