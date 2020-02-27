import 'Turbine'
import 'Turbine.Gameplay'
import 'XpPercent.LevelXp'

Turbine.Shell.WriteLine('XpPercent is running and tracking your XP!')


-- helper to register event callback
function AddCallback(object, event, callback)
	if (object[event] == nil) then
		object[event] = callback;
	else
		if (type(object[event]) == 'table') then
			table.insert(object[event], callback);
		else
			object[event] = {object[event], callback};
		end
	end
end

AddCallback(Turbine.Chat, 'Received', function(sender, args)
	if (args.ChatType == Turbine.ChatType.Advancement) then
			local totalXp = CalculateXpPercentage(ParseTotalXp(args.Message))
			Turbine.Shell.WriteLine('Percent xp: ' ..string.format('%.4f', totalXp))
        end
    end
)

function ParseTotalXp(message)
	local xp = {}

	for matched in string.gmatch(message, '[%d,]+') do
		table.insert(xp, matched)
	end

	local xpNoCommas, replaces = string.gsub(xp[2], ',', '')

	return tonumber(xpNoCommas)
end

function CalculateXpPercentage(currentXp)
	local player = Turbine.Gameplay.LocalPlayer.GetInstance();

	currrentLevelXp = LevelXpNeeded[player:GetLevel()]
	nextLevelXp = LevelXpNeeded[player:GetLevel() + 1]

	Turbine.Shell.WriteLine('Current lvl xp: ' ..(currentXp - currrentLevelXp))
	Turbine.Shell.WriteLine('Next lvl  xp: ' ..(nextLevelXp - currrentLevelXp))

	return ((currentXp - currrentLevelXp) / (nextLevelXp - currrentLevelXp)) * 100;
end