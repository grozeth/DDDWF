local TOTAL_DAMAGE = 0
local HIT_COUNT = 0
local CRITICAL_COUNTER
local EXTRA_ATTACKS = 0
local SOUND_ON_KILL = 1

local WFDamageFrame = CreateFrame("Frame")
WFDamageFrame:RegisterEvent("COMBAT_TEXT_UPDATE")

WFDamageFrame:SetScript("OnEvent", function(self, event, ...)

	if(event == "COMBAT_TEXT_UPDATE") then
		local combatTextType = ...
		
		if (combatTextType == "EXTRA_ATTACKS") then
			WFDamageFrame:RegisterEvent("UNIT_COMBAT")
			EXTRA_ATTACKS = 4
			CRITICAL_COUNTER = 0
			TOTAL_DAMAGE = 0
		end
	elseif (event == "UNIT_COMBAT") then
		local unitTarget, event, flagText, amount, schoolMask = ...
		if(unitTarget == "target") then
			if (EXTRA_ATTACKS < 4) then
				calculateWindfury(amount, flagText == "CRITICAL")
			else
				EXTRA_ATTACKS = EXTRA_ATTACKS - 1
			end
		end
	end
end)

function calculateWindfury(HIT_DAMAGE, IS_CRITICAL)
	EXTRA_ATTACKS = EXTRA_ATTACKS - 1
	TOTAL_DAMAGE = TOTAL_DAMAGE + HIT_DAMAGE
	if (IS_CRITICAL) then 
		CRITICAL_COUNTER = CRITICAL_COUNTER + 1
	end
	if (EXTRA_ATTACKS == 0) then
	
		local damage_string = "Windfury total damage: " .. TOTAL_DAMAGE
		if(CRITICAL_COUNTER >= 1) then
			PlaySoundFile("Interface\\AddOns\\DDDWF\\SoundFiles\\ding-ding-ding.mp3", "Master")
			
			damage_string = damage_string .. " ( " .. CRITICAL_COUNTER .. "x Critical ) "
		end
		print(damage_string)
		WFDamageFrame:UnregisterEvent("UNIT_COMBAT")
	end
end


