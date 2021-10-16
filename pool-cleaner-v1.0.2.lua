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
local pool_type = 'macro' -- enter which pool to clean, MUST LEAVE ''
local start_id = 1 -- which pool object to start at
local finish_id = 30 -- which pool object to end at

-- shortcut functions
local ma_print = gma.echo
local ma_cmd = gma.cmd
local get_handle = gma.show.getobj.handle
local get_name = gma.show.getobj.name

-- functions
function match(a, b) -- matches strings, returns false if they are not strings
  if type(a) == 'string' and type(b) == 'string' then
    if string.find(string.lower(a), string.lower(b)) ~= nil and
       string.len(a) == string.len(b) then
      return true
    else return false
    end
  else return false;
  end
end

function strip(text, n) -- strips id numbers from pool object names
    if type(text) == 'string' then
      n = tostring(n)
      text = string.gsub(text, n, '')
    end
  return text
end

--plugin start
function Start ()
  ma_print('POOL CLEANER ACTIVATED')
  local pool = {} -- our "scratch paper"
  local load_id = start_id; -- isolate start_id for safety

  -- loading phase

  ma_print("LOADING POOL OBJECTS")
  while load_id <= finish_id do -- loads required pool into a table
  	local handle = get_handle(pool_type..' '..load_id);
  	if handle ~= nil then
       local a = get_name(handle)
  	   pool[load_id] = a; -- assigns name to working pool with og pool position as id
  	end
  	load_id = load_id + 1;
  end
  ma_print('LOAD SUCCESSFUL, BEGINNING DELETION')

  -- comparison and deletion phase

  local comp_id = start_id; -- isolate start_id for safety
  local killcount = 0 -- counter for deleted objects
  while comp_id <= finish_id do -- main while loop
  	local x = comp_id + 1;
  	local object_name = pool[comp_id];
    if object_name ~= nil and get_handle(pool_type..' '..comp_id) ~= nil then
  	   while x <= finish_id do -- steps thru each subsequent object to see if there is a match
  			if pool[x] ~= nil and get_handle(pool_type..' '..x) ~= nil then
  				if match(strip(pool[x], x), strip(object_name, comp_id)) == true then
              ma_print('FOUND MATCH: {'..pool[comp_id]..', '..pool[x]..'}')
              ma_print('DELETING: '..pool[x])
              ma_cmd('Delete '..pool_type..' '..x)
              killcount = killcount + 1
  				end
  			end
  		 x = x + 1
  	   end
    end
  	comp_id = comp_id + 1
  end
  ma_print('DELETED '..killcount..' '..string.upper(pool_type)..'S')
  ma_print('END OF PLUGIN')
end
return Start
