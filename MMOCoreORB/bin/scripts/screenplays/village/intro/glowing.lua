local ObjectManager = require("managers.object.object_manager")
local Logger = require("utils.logger")

Glowing = ScreenPlay:new {
	requiredBadges = {
		{ type = "exploration_jedi", amount = 3 },
		{ type = "exploration_dangerous", amount = 0 },
		{ type = "exploration_easy", amount = 0 },
		{ type = "master", amount = 0 },
		{ type = "content", amount = 0 },
	}
}

function Glowing:getCompletedBadgeTypeCount(pPlayer)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return 0
	end

	local typesCompleted = 0

	for i = 1, #self.requiredBadges, 1 do
		local type = self.requiredBadges[i].type
		local requiredAmount = self.requiredBadges[i].amount

		local badgeListByType = getBadgeListByType(type)
		local badgeCount = 0

		for j = 1, #badgeListByType, 1 do
			if PlayerObject(pGhost):hasBadge(badgeListByType[j]) then
				badgeCount = badgeCount + 1
			end
		end

		if badgeCount >= requiredAmount then
			typesCompleted = typesCompleted + 1
		end
	end

	return typesCompleted
end

function Glowing:hasRequiredBadgeCount(pPlayer)
	return self:getCompletedBadgeTypeCount(pPlayer) == #self.requiredBadges
end

-- Check if the player is glowing or not.
-- @param pPlayer pointer to the creature object of the player.
function Glowing:isGlowing(pPlayer)
	return VillageJediManagerCommon.hasJediProgressionScreenPlayState(pPlayer, VILLAGE_JEDI_PROGRESSION_GLOWING)
end

-- Event handler for the BADGEAWARDED event.
-- @param pPlayer pointer to the creature object of the player who was awarded with a badge.
-- @param pPlayer2 pointer to the creature object of the player who was awarded with a badge.
-- @param badgeNumber the badge number that was awarded.
-- @return 0 to keep the observer active.
function Glowing:badgeAwardedEventHandler(pPlayer, pPlayer2, badgeNumber)
	if (pPlayer == nil) then
		return 0
	end

	if self:hasRequiredBadgeCount(pPlayer) and not CreatureObject(pPlayer):hasSkill("force_title_jedi_novice") then
		FsIntro:completeVillageIntroFrog(pPlayer)
		FsOutro:completeVillageOutroFrog(pPlayer)
		JediTrials:completePadawanForTesting(pPlayer)
		local sui = SuiMessageBox.new("JediTrials", "emptyCallback") -- No callback
		sui.setTitle("Jedi Unlock")
		sui.setPrompt("Welcome Padawan. To begin your journey you must first craft a lightsaber. There is no reason to visit a shrine. use /findmytrainer to locate your jedi skill trainer. May the force be with you. \n(read the welcome/login email for some helpful tips!)")
		sui.sendTo(pPlayer)
	end

	return 0
end

-- Register observer on the player for observing badge awards.
-- @param pPlayer pointer to the creature object of the player to register observers on.
function Glowing:registerObservers(pPlayer)
	dropObserver(BADGEAWARDED, "Glowing", "badgeAwardedEventHandler", pPlayer)
	createObserver(BADGEAWARDED, "Glowing", "badgeAwardedEventHandler", pPlayer)
end

-- Handling of the onPlayerLoggedIn event. The progression of the player will be checked and observers will be registered.
-- @param pPlayer pointer to the creature object of the player who logged in.
function Glowing:onPlayerLoggedIn(pPlayer)
		sendMail("mySWG", "Welcome/Login Mail", "Welcome to mySWG.\n\n"
		.."NEW PLAYER INFO:"
		.."\n**WARNING** UNLOCKING JEDI will surrender all of your skills and make your character permanently a jedi and unable to learn non jedi skills."
		.."\n-Unlock jedi by visiting 3 jedi POI then type /checkforce (ben kenobis home on tatooine, jedi temple on dantooine, exar kun temple on yavin4)."
		.."\n-Use the /findmytrainer to locate your jedi skill trainer."
		.."\n\nTHE KNIGHTLY KNEWS:"
		.."\n-Jedi Sentinels at the enclaves drop perfect stat 4th gen lightsabers (they are the same strength as Dark Jedi Masters)."
		.."\n\nTHE CHANGES:"
		.."\n5char, 2char online per account, multi accounts will get you banned"
		.."\ninfinite skill points, jedi cant learn non jedi skills"
		.."\nXP is 20x"
		.."\ncrafting xp is 200x"
		.."\nspin groups enabled here, 1hit gives full xp"
		.."\nNO XP LOSS"
		.."\nno exceptional/legendary items"
		.."\ncrafting times removed"
		.."\nfactory times reduced"
		.."\ncities and building on ANY planet"
		.."\nn poli can place all city bldgs"
		.."\nreduced maintenance costs"
		.."\nBoba fett at dwb entrance"
		.."\nDWB droids drop SEA"
		.."\nLightsaber accuracy CA added"
		.."\nclothing/armor 10 sockets each"
		.."\nall wearables can be color changed"
		.."\narmor has no encumbrance"
		.."\nbazaar 1000 items @ 999m max"
		.."\nspeeder and house can be bought with faction points"
		.."\nno adk"
		.."\nsitting regens ham 3x, force 2x"
		.."\nmed centers / cantinas heal wounds"
		.."\nplayer can have 5 faction pets, no atst"
		.."\n\nJEDI:"		
		.."\nAny saber type can use any saber special."
		.."\n1h,2h,dbl lightsabers have same stats (based off vanilla dbl bladed)."
		.."\ncrystals only add damage, all other stats added to lightsaber base stats."
		.."\ninstant knight trial completion, instant rank 11"
		.."\nFRS light and dark side balanced"
		.."\n\n Welcome to mySWG,\n-Veaseomat\n\n *This mail will be received every login, check here for changes!", CreatureObject(pPlayer):getFirstName())

	if self:hasRequiredBadgeCount(pPlayer) and not CreatureObject(pPlayer):hasSkill("force_title_jedi_novice") then
		FsIntro:completeVillageIntroFrog(pPlayer)
		FsOutro:completeVillageOutroFrog(pPlayer)
		JediTrials:completePadawanForTesting(pPlayer)
		local sui = SuiMessageBox.new("JediTrials", "emptyCallback") -- No callback
		sui.setTitle("Jedi Unlock")
		sui.setPrompt("Welcome Padawan. To begin your journey you must first craft a lightsaber. There is no reason to visit a shrine. use /findmytrainer to locate your jedi skill trainer. May the force be with you. \n(read the welcome/login email for some helpful tips!)")
		sui.sendTo(pPlayer)
	end
end

-- Handling of the checkForceStatus command.
-- @param pPlayer pointer to the creature object of the player who performed the command
function Glowing:checkForceStatusCommand(pPlayer)
	local progress = "@jedi_spam:fs_progress_" .. self:getCompletedBadgeTypeCount(pPlayer)

	if self:hasRequiredBadgeCount(pPlayer) and not CreatureObject(pPlayer):hasSkill("force_title_jedi_novice") then
		FsIntro:completeVillageIntroFrog(pPlayer)
		FsOutro:completeVillageOutroFrog(pPlayer)
		JediTrials:completePadawanForTesting(pPlayer)
		local sui = SuiMessageBox.new("JediTrials", "emptyCallback") -- No callback
		sui.setTitle("Jedi Unlock")
		sui.setPrompt("Welcome Padawan. To begin your journey you must first craft a lightsaber. There is no reason to visit a shrine. use /findmytrainer to locate your jedi skill trainer. May the force be with you. \n(read the welcome/login email for some helpful tips!)")
		sui.sendTo(pPlayer)
	end
end

return Glowing
