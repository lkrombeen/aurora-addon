local function formatClasses(message)
	formattedMessage = message
	for k, v in pairs(classColours) do
		formattedMessage = formattedMessage:gsub(k, "|cff" .. v .. k .. "|r")
	end
	return formattedMessage
end

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

local function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

local function handleRoll(args)
	local command, item = strsplit(" ", args)
	local n = tonumber(command)
	local prio = "MS + 1"
	if string.lower(command) == "os" then
		prio = "OS"
	elseif n == nil then
		item = args
	end

	if item == "" or item == nil or item == " " then
		print("|cffC41F3BNo item linked|r")
		return
	end

	local itemName, itemLink = GetItemInfo(item)
	local priority = priorities[itemName]

	if itemLink == nil then
		print("|cffC41F3BWrong input abr: /abr [(optional) os or 1-n] [item] |r")
		return
	end

	if priority ~= nil and n ~= nil and n >= 1 then
		local splitted = split(priority, ">")
		if splitted[n] ~= nil then
			prio = "MS + 1 (" .. splitted[n] .. ")"
		else
			print("|cffC41F3BPriority number exceeded item priorities...|r")
		end
	end

	sendMessage(format("%s: roll %s", itemLink, prio), "RAID_WARNING")
end

local function updateTooltip(tooltip)
	name, _ = tooltip:GetItem()
	prio = priorities[name]
	if prio ~= nil then
		tooltip:AddDoubleLine("Priority:", formatClasses(prio))
	end
end

-- Slash commands you can execute
SLASH_ABP1 = "/abp"
SLASH_ABL1 = "/abl"
SLASH_ABR1 = "/abr"
SlashCmdList["ABP"] = handlePrio
SlashCmdList["ABL"] = handleLoot
SlashCmdList["ABR"] = handleRoll

GameTooltip:HookScript("OnTooltipSetItem", updateTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", updateTooltip)