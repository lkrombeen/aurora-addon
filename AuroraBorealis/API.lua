 mapping = {
	["Crimson Shocker"] = "MS>OS",
	["Flamewaker Legplates"] = "MS>OS",
	["Heavy Dark Iron Ring"] = "Druid (Tank) > MS>OS",
	["Manastorm Leggings"] = "MS>OS",
	["Ring of Spell Power"] = "Caster > Healers",
	["Robes of Volatile Power"] = "Paladin = Warlock > Other Casters",
	["Salamander Scale Pants"] = "Paladin = Druid (Resto) > Healers",
	["Sorcerous Dagger"] = "Caster DPS = Druid (Resto) > Priest",
	["Wristguards of Stability"] = "Druid (Feral) = Warrior (DPS)",
	["Aged Core Leather Gloves"] = "Rogue = Warrior (Dag.) > Warrior (Tank) = Warrior (Non-human)",
	["Fire Runed Grimoire"] = "MS>OS",
	["Flameguard Gauntlets"] = "MS>OS",
	["Magma Tempered Boots"] = "MS>OS",
	["Mana Igniting Cord"] = "Caster > Paladin",
	["Obsidian Edged Blade"] = "MS>OS",
	["Quick Strike Ring"] = "Druid (Feral) = Warrior (DPS) > Rogue > Hunter",
	["Sabatons of the Flamewalker"] = "Paladin",
	["Talisman of Ephemeral Power"] = "Caster > Healers",
	["Choker of Enlightenent"] = "Caster > Healers",
	["Earthshaker"] = "MS>OS",
	["Eskhandar's Right Claw"] = "MS>OS",
	["Medallion of Steadfast Might"] = "MS>OS",
	["Striker's Mark"] = "Rogue = Warrior > Hunter",
	["Aurastone Hammer"] = "Druid (Resto) = Paladin > Priest",
	["Brutality Blade"] = "Rogue = Warrior (DPS) > Hunter",
	["Drillborer Disk"] = "MS>OS",
	["Gutgore Ripper"] = "Rogue = Warrior (Non-human)",
	["Seal of the Archmagus"] = "MS>OS",
	["Shadowstrike"] = "MS>OS",
	["Azuresong Mageblade"] = "Caster > Paladin",
	["Blastershot Launcher"] = "Rogue = Warrior  > Hunter",
	["Staff of Dominance"] = "Caster > Healers",
	["Ancient Petrified Leaf"] = "Hunter",
	["Cauterizing Band"] = "MS>OS",
	["Core Forged Greaves"] = "MS>OS",
	["Core Hound Tooth"] = "Rogue = Warrior (Dag.) = Warrior (Tank) > Warrior (Non-Human) > Warrior (Human) > Hunter",
	["Finkle's Lava Dredger"] = "MS>OS",
	["Fireguard Shoulders"] = "Druid (Feral) > Warrior (Tank)",
	["Fireproof Cloak"] = "Warrior (Tank) = Druid (Feral)",
	["Gloves of the Hypnotic Flame"] = "Caster",
	["Sash of Whispered Secrets"] = "S. Priest > Warlock",
	["The Eye of Divinity"] = "Priest",
	["Wild Growth Spaulders"] = "MS>OS",
	["Wristguards of True Flight"] = "Warrior (Tank) > Hunter = Warrior (DPS) > Paladin (Ret)",
	["Band of Accuria"] = "Rogue = Warrior (Tank) > Warrior (DPS) = Druid (Feral) > Hunter",
	["Band of Sulfuras"] = "MS>OS",
	["Bonereaver's Edge"] = "MS>OS",
	["Choker of the Fire Lord"] = "Caster > Healers",
	["Cloak of the Shrouded Mists"] = "Hunter > Rogue > Warrior (Tank)",
	["Crown of Destruction"] = "Hunter = Warrior",
	["Dragon's Blood Cape"] = "Tank > MS>OS",
	["Essence of the Pure Flame"] = "MS>OS",
	["Malistar's Defender"] = "MS>OS",
	["Onslaught Girdle"] = "Warrior (Tank) = Warrior (DPS)",
	["Perdition's Blade"] = "Rogue (Dag.) > Warrior (Nonhuman) > Warrior (Tank)",
	["Shard of the Flame"] = "MS>OS",
	["Spinal Reaper"] = "MS>OS",
	["Ancient Cornerstone Grimoire"] = "MS>OS",
	["Eskhandar's Collar"] = "Druid (Feral) > MS>OS",
	["Deathbringer"] = "Warrior (Edge) > Warrior (DPS)",
	["Head of Onyxia"] = "Warrior (Tank) = Druid (Tank) = Warrior (DPS) = Rogue = Hunter",
	["Sapphiron Drape"] = "MS>OS",
	["Shard of the Scale"] = "MS>OS",
	["Ring of Binding"] = "MS>OS",
	["Vis'kag the Bloodletter"] = "Rogue (Human) = Warrior (DPS) (Human) > Rogue  = Warrior (DPS)"
}

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
	local prio = mapping[itemName]
	if prio ~= nil then
		local msg = format("%s: %s", itemLink, mapping[itemName])
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
	prio = mapping[name]
	if prio ~= nil then
		GameTooltip:AddDoubleLine("Priority:", prio)
	end
end

-- Slash commands you can execute
SLASH_ABP1 = "/abp"
SLASH_ABL1 = "/abl"
SlashCmdList["ABP"] = handlePrio
SlashCmdList["ABL"] = handleLoot

GameTooltip:SetScript("OnTooltipSetItem", updateTooltip)