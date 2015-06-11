-- Limit chat by distance [shout]
-- by Muhammad Rifqi Priyo Susanto (srifqi)
-- License: CC0 1.0 Universal
-- Dependencies: default

-- Parameter
local DISTANCE = 50	-- Distance (nodes)

--------------------
-- Internal Stuff --
--------------------

-- Limit chat by distance given in DISTANCE parameter
minetest.register_on_chat_message(function(name, message)
	local shouter = minetest.get_player_by_name(name)
	local spos = shouter:getpos()
	local heard = 0
	
	-- Minetest library
	local function vdistance(a,b) local x,y,z = a.x-b.x,a.y-b.y,a.z-b.z return math.hypot(x,math.hypot(y,z)) end
	
	for _,player in ipairs(minetest.get_connected_players()) do
		if player:get_player_name() ~= shouter:get_player_name() then
			local pos = player:getpos()
			if vdistance(spos,pos) <= DISTANCE then
				minetest.chat_send_player(player:get_player_name(), "<"..name.."> "..message)
				heard = heard +1
			end
		end
	end
	minetest.chat_send_player(name, "("..heard.." hearing)")
	return true
end)

-- Broadcast your message to all player (pay 1 stick)
minetest.register_chatcommand("sh", {
	params = "<messsage>",
	description = "Broadcast your message to all player (pay 1 stick)",
	privs = {shout=true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local inv = player:get_inventory()
		if inv:contains_item("main",ItemStack("default:stick 1")) then
			-- Pay 1 stick
			inv:remove_item("main",ItemStack("default:stick 1"))
			minetest.chat_send_all("<"..name.."> "..param)
			return true
		else
			return false, "You don't have any stick to pay."
		end
	end,
})
