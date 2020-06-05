import 'Turbine'
import 'Turbine.Gameplay'
import 'XPercent.LevelXp'
import 'Turbine.UI'
import 'Turbine.UI.Lotro'

Turbine.Shell.WriteLine('XPercent is running and tracking your XP!')

window = Turbine.UI.Window()
window:SetSize(100, 44)
window:SetBackColor(Turbine.UI.Color(0, 0, 0, 0))
window:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend)
-- window:SetText('Level Percentage')
window:SetVisible(true)
window:SetPosition(Turbine.UI.Display:GetWidth() - 320, 20)

totalXpLabel = Turbine.UI.Label()
totalXpLabel:SetParent(window)
totalXpLabel:SetVisible(true)
totalXpLabel:SetSize(100, 22)
totalXpLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16)
totalXpLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
totalXpLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);
totalXpLabel:SetForeColor(Turbine.UI.Color(0.84, 1, 1, 1))
totalXpLabel:SetOutlineColor(Turbine.UI.Color(0, 0, 0))
totalXpLabel:SetText('0')

diffXpLabel = Turbine.UI.Label()
diffXpLabel:SetParent(window)
diffXpLabel:SetVisible(true)
diffXpLabel:SetSize(100, 22)
diffXpLabel:SetPosition(0, 16)
diffXpLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16)
diffXpLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
diffXpLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);
diffXpLabel:SetForeColor(Turbine.UI.Color(0.64, 1, 0, 1))
diffXpLabel:SetOutlineColor(Turbine.UI.Color(0, 0, 0))
diffXpLabel:SetText('0')

lastXp = 0


-- helper to register event callbackaaa
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
			-- elminiate any other messages that don't have to do with XP
			if not string.match(args.Message, "You've earned [%d,]+ XP for a total of [%d,]+ XP.") then return end
			
			local totalXp = CalculateXpPercentage(ParseTotalXp(args.Message))
			local diffXp = totalXp - lastXp
			
			lastXp = totalXp

			local decimalPlacesTotalXp = string.format('%.4f', totalXp) ..' %'
			local decimalPlacesDiffXp = '+ '.. string.format('%.4f', diffXp) ..' %'

			totalXpLabel:SetText(decimalPlacesTotalXp)
			diffXpLabel:SetText(decimalPlacesDiffXp)
			-- Turbine.Shell.WriteLine('Percent xp: ' ..decimalPlacesXp)
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

	return ((currentXp - currrentLevelXp) / (nextLevelXp - currrentLevelXp)) * 100;
end