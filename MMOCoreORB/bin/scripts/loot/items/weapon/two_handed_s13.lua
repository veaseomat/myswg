--Automatically generated by SWGEmu Spawn Tool v0.12 loot editor. 

two_handed_s13 = {
	minimumLevel = 1,
	maximumLevel = 1,
	customObjectName = "a Perfect Lightsaber",
	directObjectTemplate = "object/weapon/melee/2h_sword/crafted_saber/sword_lightsaber_two_handed_s13_gen4.iff",
	craftingValues = {
		{"mindamage",235,235,0},
		{"maxdamage",325,325,0},
		{"attackspeed",2.4,2.4,0},
		{"woundchance",66,66,0},
		{"hitpoints",1000,1000,0},
		{"forcecost",8,8,0},
		{"attackhealthcost",0,0,0},
		{"attackactioncost",0,0,0},
		{"attackmindcost",0,0,0},
	},
	customizationStringNames = {},
	customizationValues = {},

	-- randomDotChance: The chance of this weapon object dropping with a random dot on it. Higher number means less chance. Set to 0 to always have a random dot.
	randomDotChance = -1,
	junkDealerTypeNeeded = JUNKNOTSELLABLE,

}

addLootItemTemplate("two_handed_s13", two_handed_s13)
