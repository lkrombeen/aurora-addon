local function sendMessage(message, chatType, channel)
	if tonumber(channel) == nil then
		SendChatMessage(message, chatType, nil, nil)
	else
		SendChatMessage(message, "CHANNEL", nil, tonumber(channel))
	end
end

local function handlePrioLoot(printNoMatch, args)
	local item, tail = strsplit("]", args, 2)
	if tail == nil then
		print("Invalid syntax: /ab prio [Linen Cloth]. No item was linked")
		return
	end

	local itemName, itemLink = GetItemInfo(item)

	-- First 4 are random empty and cannot be stripped for some reason
	local tail = string.gsub(tail, "%s+", ""):sub(5,string.len(tail))
	local prio = priorities[itemName]
	if prio ~= nil then
		local msg = format("%s: %s", itemLink, priorities[itemName])
		if string.len(tail) == 0 then
			print(msg)
		else
			sendMessage(msg, tail, tail)
		end
		return
	end

	-- Do not print
	if not printNoMatch then
		return
	end

	if itemLink ~= nil then
		print(format("No priority entry for item: %s", itemLink))
	else
		print(format("No priority entry for item: %s", item))
	end
end

local function handlePrio(args)
	handlePrioLoot(true, args)
end

-- Print the current loot
local function handleLoot(args)
 	for i = 1, GetNumLootItems() do 
 		local link = GetLootSlotLink(i)
 		if link ~= nil then
 			handlePrioLoot(true, link .. " " .. args)
 		end
 	end
end

local function updateTooltip(tooltip)
	name, _ = tooltip:GetItem()
	prio = priorities[name]
	if prio ~= nil then
		tooltip:AddDoubleLine("Priority:", prio)
	end
end

-- Slash commands you can execute
SLASH_ABP1 = "/abp"
SLASH_ABL1 = "/abl"
SlashCmdList["ABP"] = handlePrio
SlashCmdList["ABL"] = handleLoot

GameTooltip:SetScript("OnTooltipSetItem", updateTooltip)
ItemRefTooltip:SetScript("OnTooltipSetItem", updateTooltip)