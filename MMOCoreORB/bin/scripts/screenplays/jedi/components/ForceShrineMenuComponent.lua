ForceShrineMenuComponent = {}

function ForceShrineMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	local menuResponse = LuaObjectMenuResponse(pMenuResponse)

	if (CreatureObject(pPlayer):hasSkill("force_title_jedi_novice")) then
		menuResponse:addRadialMenuItem(120, 3, "@jedi_trials:meditate") -- Meditate
	end

	if (CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_02")) then
		menuResponse:addRadialMenuItem(121, 3, "@force_rank:recover_jedi_items") -- Recover Jedi Items
	end

end

function ForceShrineMenuComponent:handleObjectMenuSelect(pObject, pPlayer, selectedID)
	if (pPlayer == nil or pObject == nil) then
		return 0
	end

	if (selectedID == 120 and CreatureObject(pPlayer):hasSkill("force_title_jedi_novice")) then
		if (CreatureObject(pPlayer):getPosture() ~= CROUCHED) then
			self:doMeditate(pObject, pPlayer)
		else
			self:doMeditate(pObject, pPlayer)
		end
	elseif (selectedID == 121 and CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_02")) then
		self:recoverRobe(pPlayer)
	end

	return 0
end

function ForceShrineMenuComponent:doMeditate(pObject, pPlayer)
	if (tonumber(readScreenPlayData(pPlayer, "KnightTrials", "completedTrials")) == 1 and not CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_03")) then
		KnightTrials:resetCompletedTrialsToStart(pPlayer)
	end

	if (not CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_02") and CreatureObject(pPlayer):hasScreenPlayState(32, "VillageJediProgression")) then
		local currentTrial = JediTrials:getCurrentTrial(pPlayer)

		if (not JediTrials:isOnPadawanTrials(pPlayer)) then
			PadawanTrials:startPadawanTrials(pObject, pPlayer)
		elseif (currentTrial == 0) then
			PadawanTrials:startNextPadawanTrial(pObject, pPlayer)
		else
			PadawanTrials:showCurrentTrial(pObject, pPlayer)
		end
	elseif (JediTrials:isOnKnightTrials(pPlayer)) then
		local pPlayerShrine = KnightTrials:getTrialShrine(pPlayer)

		if (pPlayerShrine ~= nil and pObject ~= pPlayerShrine) then
			local correctShrineZone = SceneObject(pPlayerShrine):getZoneName()
			if (correctShrineZone ~= SceneObject(pObject):getZoneName()) then
				local messageString = LuaStringIdChatParameter("@jedi_trials:knight_shrine_reminder")
				messageString:setTO(getStringId("@jedi_trials:" .. correctShrineZone))
				CreatureObject(pPlayer):sendSystemMessage(messageString:_getObject())
			else
				CreatureObject(pPlayer):sendSystemMessage("@jedi_trials:knight_shrine_wrong")
			end
			return
		end

		local currentTrial = JediTrials:getCurrentTrial(pPlayer)
		local trialsCompleted = JediTrials:getTrialsCompleted(pPlayer)

		if (currentTrial == 0 and trialsCompleted == 0) then
			local sui = SuiMessageBox.new("KnightTrials", "startNextKnightTrial")
			sui.setTitle("@jedi_trials:knight_trials_title")
			sui.setPrompt("Are you ready to become a Jedi Knight and enter the OVERPOWERED Force Ranking System?")
			sui.setOkButtonText("@jedi_trials:button_yes")
			sui.setCancelButtonText("@jedi_trials:button_no")
			sui.sendTo(pPlayer)
		else
			KnightTrials:showCurrentTrial(pPlayer)
		end
	else
		CreatureObject(pPlayer):sendSystemMessage("@jedi_trials:force_shrine_wisdom_" .. getRandomNumber(1, 15))
	end
end

function ForceShrineMenuComponent:recoverRobe(pPlayer)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		return
	end

	if (SceneObject(pInventory):isContainerFullRecursive()) then
		CreatureObject(pPlayer):sendSystemMessage("@jedi_spam:inventory_full_jedi_robe")
		return
	end

	local robeTemplate
	if (CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_03")) then
		local councilType = JediTrials:getJediCouncil(pPlayer)

		if (CreatureObject(pPlayer):hasSkill("force_rank_light_novice")) then
			robeTemplate = "object/tangible/wearables/robe/robe_jedi_light_s01.iff"
		end
		if (CreatureObject(pPlayer):hasSkill("force_rank_light_rank_01")) then
			robeTemplate = "object/tangible/wearables/robe/robe_jedi_light_s02.iff"
		end
		if (CreatureObject(pPlayer):hasSkill("force_rank_light_rank_05")) then
			robeTemplate = "object/tangible/wearables/robe/robe_jedi_light_s03.iff"
		end
		if (CreatureObject(pPlayer):hasSkill("force_rank_light_rank_08")) then
			robeTemplate = "object/tangible/wearables/robe/robe_jedi_light_s04.iff"
		end
		if (CreatureObject(pPlayer):hasSkill("force_rank_light_rank_10")) then
			robeTemplate = "object/tangible/wearables/robe/robe_jedi_light_s05.iff"
		end
		if (CreatureObject(pPlayer):hasSkill("force_rank_dark_novice")) then
			robeTemplate = "object/tangible/wearables/robe/robe_jedi_dark_s01.iff"
		end
		if (CreatureObject(pPlayer):hasSkill("force_rank_dark_rank_01")) then
			robeTemplate = "object/tangible/wearables/robe/robe_jedi_dark_s02.iff"
		end
		if (CreatureObject(pPlayer):hasSkill("force_rank_dark_rank_05")) then
			robeTemplate = "object/tangible/wearables/robe/robe_jedi_dark_s03.iff"
		end
		if (CreatureObject(pPlayer):hasSkill("force_rank_dark_rank_08")) then
			robeTemplate = "object/tangible/wearables/robe/robe_jedi_dark_s04.iff"
		end
		if (CreatureObject(pPlayer):hasSkill("force_rank_dark_rank_10")) then
			robeTemplate = "object/tangible/wearables/robe/robe_jedi_dark_s05.iff"
		end
	else
		robeTemplate = "object/tangible/wearables/robe/robe_jedi_padawan.iff"
	end

	giveItem(pInventory, robeTemplate, -1)
	CreatureObject(pPlayer):sendSystemMessage("@force_rank:items_recovered")
end
