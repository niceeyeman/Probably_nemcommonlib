-- Common Function NEM
-- Created on Dec 21st 2013 1:30 pm
-- github https://github.com/niceeyeman/Probably_nemcommonlib

local nemcommon = { }
--[[ ToC
	Buff checks
	Debuff checks
	Mechanics checks
	Item checks
	]]
	
-- **** Buff checks **** @
function nemcommon.targNotfocus()
		if (UnitIsUnit("target", "focus")) then
		return false end
	return true
end
-- Checks player for Arcane/Dalaran Brilliance,Burning Wrath, Still Water
-- True if duration > 3
function nemcommon.tenSpellpower(thresholdtsp)
	local temp_buffstsp = {1459,61316,77747,109773,126309}
	local timertsp = thresholdtsp or 3
	for i=1,#temp_buffstsp do
		if UnitBuff("player",GetSpellInfo(temp_buffstsp[i])) then
			if select(7,UnitBuff("player",GetSpellInfo(temp_buffstsp[i]))) - GetTime() <= timertsp then return true end
		end
	end
	return false
end

-- Hysteria functions added a couple from chunky's list
-- checks for short duration buffs
function nemcommon.tempBuffs(threshold)
	local temp_buffs = {104509,104510,128985,33702,126577,126478,125487,136082,126605,126734,126476,138898,139133,138786,138703,104993,105702,148897,148906,146184,146046,137590,113858,114207,146218,138963,}
	local timerTB = threshold or 3
	for i=1,#temp_buffs do
		if UnitBuff("player",GetSpellInfo(temp_buffs[i])) then
			if select(7,UnitBuff("player",GetSpellInfo(temp_buffs[i]))) - GetTime() <= timerTB then return true end
		end
	end
	return false
end

-- Debuff checks

--Checks target for Magic Vulnerabilty
function nemcommon.fiveMagicdam(threshold)
	local temp_fmd = {1490,34889,24844,93068}
	local timerfmd = threshold or 3
	for i=1,#temp_fmd do
		if UnitDebuff("target",GetSpellInfo(temp_fmd[i])) then
			if select(7,UnitDebuff("target",GetSpellInfo(temp_fmd[i]))) - GetTime() <= timerfmd then return true end
		end
	end
	return false
end

-- **** Mechanics checks **** usually fight specific

-- Don't DoT mind controlled players 
-- Source boomkin function
function nemcommon.garroshMC(unit)
        if UnitExists(unit) then
                if UnitDebuff(unit,GetSpellInfo(145832))
                        or UnitDebuff(unit,GetSpellInfo(145171))
                        or UnitDebuff(unit,GetSpellInfo(145065))
                        or UnitDebuff(unit,GetSpellInfo(145071))
                then return false else return true end
        else return false end
end

-- Source boomkin function
function nemcommon.interruptEvents(unit)
  if UnitBuff("player", 31821) then return true end -- Devo
  if not unit then unit = "boss1" end
  local spell = UnitCastingInfo(unit)
  local stop = false
  if spell == GetSpellInfo(138763) then stop = true end
  if spell == GetSpellInfo(137457) then stop = true end
  if spell == GetSpellInfo(143343) then stop = true end -- Thok
  if stop then
    if UnitCastingInfo("player") or UnitChannelInfo("player") then
      RunMacroText("/stopcasting")
      return false
    end
  end
  return true
end

-- Chunky destro function
function nemcommon.Boss(target)
  if UnitLevel("target") == -1 then 
    return true 
    end
  return false
end

-- Source Chunky destro function
function nemcommon.Doomguard(unit)
  if not (UnitBuff("player", 2825) or
			UnitBuff("player", 32182) or 
			UnitBuff("player", 80353) or
			UnitBuff("player", 90355)) then
		return false
	end
	if not ProbablyEngine.condition["modifier.cooldowns"] then return false end
	if UnitLevel(target) ~= -1 then return false end
	return true 
end

-- **** Item Checks ***

-- Source Chunky destro function @
function nemcommon.Healthstone(target)
  if GetItemCount(5512, nil, true) == 3 then return false end
  return true
end

-- Some example item sub-classes are:
--      "One-Handed Axes",
--      "Two-Handed Axes",
--      "Bows",
--      "Guns",
--      "One-Handed Maces",
--      "Two-Handed Maces",
--      "Polearms",
--      "One-Handed Swords",
--      "Two-Handed Swords",
--      "Staves",
--      "Fist Weapons",
--      "Miscellaneous",
--      "Daggers",
--      "Thrown",
--      "Crossbows",
--      "Wands",
--      "Fishing Poles"
-- use @nemcommon.dagCheck("Two-Handed Swords") untested
function nemcommon.dagCheck(weaptype)
local sName, sLink, iRarity, iLevel, iMinLevel, sType, sSubType, iStackCount = GetItemInfo(GetInventoryItemID("player", GetInventorySlotInfo("MainHandSlot")))
	local dCwt = weaptype or "Daggers"
 if sSubType == dCwt then return true else return false end
end



ProbablyEngine.library.register("nemcommon", nemcommon)