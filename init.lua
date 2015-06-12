-- Limit chat by distance [shout]
-- by Muhammad Rifqi Priyo Susanto (srifqi)
-- License: CC0 1.0 Universal
-- Dependencies: (none)

shout = {}

-- Parameter
shout.DISTANCE	= 50	-- Distance (nodes)
shout.PAYMENT	= {		-- Payment
	string	= "default:stick",	-- Payment ItemString
	amount	= 1,
	name	= "stick",	-- "You don't have any %s to pay."
} 

--------------------
-- Internal Stuff --
--------------------

-- Limit chat by distance given in shout.DISTANCE parameter
minetest.register_on_chat_message(function(name, message)
	local shouter = minetest.get_player_by_name(name)
	local spos = shouter:getpos()
	local heard = 0
	
	-- Minetest library (modified)
	local function vdistance(a,b) local x,y,z = a.x-b.x,a.y-b.y,a.z-b.z return math.sqrt(x*x+y*y+z*z) end
	
	for _,player in ipairs(minetest.get_connected_players()) do
		if player:get_player_name() ~= shouter:get_player_name() then
			local pos = player:getpos()
			if vdistance(spos,pos) <= shout.DISTANCE then
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
	description = "Broadcast your message to all player (pay "..shout.PAYMENT.amount.." "..shout.PAYMENT.name..")",
	privs = {shout=true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local inv = player:get_inventory()
		local stackname = shout.PAYMENT.string.." "..shout.PAYMENT.amount
		if inv:contains_item("main",ItemStack(stackname)) then
			-- Pay 1 stick
			inv:remove_item("main",ItemStack(stackname))
			minetest.chat_send_all("<"..name.."> "..param)
			return true
		else
			return false, "You don't have any "..shout.PAYMENT.name.." to pay."
		end
	end,
})
