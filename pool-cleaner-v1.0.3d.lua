-- GMA2 Pool Cleaner v1.0.3d
-- Last Updated: 11.07.2021
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
local deleteUnlabeled = false -- set to true to delete items you never labeled ex. 'macro 35'

-- define GMA2 API functions
local maPrint = gma.echo
local maCmd = gma.cmd
local getHandle = gma.show.getobj.handle
local getName = gma.show.getobj.label

-- shortcut functions
function match(a, b) -- matches strings, returns false if they are not strings
    if type(a) == "string" and type(b) == "string" then
        if string.find(string.lower(a), string.lower(b)) ~= nil and string.len(a) == string.len(b) then
            return true
        else
            return false
        end -- if match
    else
        return false
    end -- if strings
end -- function match

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
                if pool[x] ~= nil and getHandle(poolType .. " " .. x) ~= nil and match(pool[x], object_name) == true then -- existence, then check for match
                        maPrint("FOUND MATCH: {" .. pool[compId] .. ": #"..compId.." & #"..x.."}")
                        maPrint("DELETING: " .. pool[x].." #"..x)
                        maCmd("Delete " .. poolType .. " " .. x)
                        killcount = killcount + 1
                end -- existence 2 and match
            end -- inner for
        end -- existence 1
    end -- Outer for

    -- if desired, can also check for pool items you created but never labeled
    -- i.e. 'macro 254' or 'effect 87'
    -- deleteUnlabeled must be set 'true' at the top of the script
    if deleteUnlabeled == true then -- if it was set, delete unlabeled items
        local doofcount = 0
        maPrint("LET'S SEE HOW MANY TIMES YOU FORGOT TO LABEL SOMETHING...")
        for i = startId, finishId do
            if getHandle(poolType.." "..i) ~= nil and pool[i] == nil then -- if there's something there but no label...
                maPrint("FOUND SOMETHING YOU NEVER LABELED YOU GOOBER")
                maPrint("DELETING "..string.upper(poolType).." "..i.."...HOPE IT WASN'T IMPORTANT")
                maCmd("Delete "..poolType.." "..i)
                doofcount = doofcount + 1
            end -- existence and match
        end -- for loop
        killcount = killcount + doofcount
        maPrint("THAT'S "..doofcount.." TIMES YOU MADE SOMETHING YOU DIDN'T LABEL")
        if doofcount > 20 then
            maPrint("YOU'RE A MEGA DOOF")
        end -- if megadoof
    end -- if deleteUnlabeled

    maPrint("DELETED " .. killcount .. " " .. string.upper(poolType) .. "S")

    if killcount > 1000 then
        maPrint("YIKES")
    end -- if showfile was gross

    maPrint("POOL CLEANER FINISHED")
    maPrint("Remember: No matter where you go, there you are. - BB")
end
return Start
