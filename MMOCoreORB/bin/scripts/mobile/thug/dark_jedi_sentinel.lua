dark_jedi_sentinel = Creature:new {
	objectName = "@mob/creature_names:dark_jedi_sentinel",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "self",
	faction = "",
	level = 291,
	chanceHit = 27.25,
	damageMin = 1800,
	damageMax = 3310,
	baseXp = 27849,
	baseHAM = 321000,
	baseHAMmax = 392000,
	armor = 3,
	resists = {95,95,95,95,95,95,95,95,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + HERD + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = { "dark_jedi" },
	lootGroups = {
		{
			groups = {
				{group = "melee_saber", chance = 10000000},
			},
						lootChance = 10000000
		},
		{
			groups = {
				{group = "jrobe", chance = 10000000},
			},
						lootChance = 10000000
		},
	},
	weapons = {"dark_jedi_weapons_gen2"},
	conversationTemplate = "",
	attacks = merge(lightsabermaster,forcepowermaster)
}

CreatureTemplates:addCreatureTemplate(dark_jedi_sentinel, "dark_jedi_sentinel")
