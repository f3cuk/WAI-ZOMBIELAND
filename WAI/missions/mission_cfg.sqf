wai_mission_timer 				= (300 + round(random 600)); 		// time between missions 5-15 minutes
wai_mission_timeout 			= (1800 + round(random 1800)); 		// time each missions take 30-60 minutes
wai_mission_fuel 					= ((1 + round(random 9)) / 10);		// fuel inside mission spawned vehicles (10 - 100%)
wai_crates_smoke 					= true;								// pop smoke on crate when mission is finished
wai_keep_vehicles					= true;								// save vehicles to database to keep them after restart
wai_players_online        = 1; // Number of players online before misson starts
wai_server_fps            = 5; // Missions only starts if server FPS is over wai_server_fps
// Missions
wai_missions 						  = ["black_hawk_crash","armed_vehicle","bandit_base","captured_mv22","ikea_convoy","destroyed_ural","disabled_milchopper","mayors_mansion","medi_camp","weapon_cache"];

// Vehicle arrays
armed_vehicle 						= ["ArmoredSUV_PMC_DZE","GAZ_Vodnik_DZE","HMMWV_M1151_M2_CZ_DES_EP1_DZE","HMMWV_M998A2_SOV_DES_EP1_DZE","LandRover_MG_TK_EP1_DZE","LandRover_Special_CZ_EP1_DZE","Offroad_DSHKM_Gue_DZE","Pickup_PK_GUE_DZE","Pickup_PK_INS_DZE","Pickup_PK_TK_GUE_EP1_DZE","UAZ_MG_TK_EP1_DZE"];
armed_chopper 						= ["CH_47F_EP1_DZE","Mi17_DZE","UH1H_DZE","UH1Y_DZE","UH60M_EP1_DZE"];
civil_aircraft 						= ["AH6X_DZ","AN2_DZ","MH6J_DZ","Mi17_Civilian_DZ"];
military_unarmed 					= ["GAZ_Vodnik_MedEvac","HMMWV_Ambulance","HMMWV_Ambulance_CZ_DES_EP1","HMMWV_DES_EP1","HMMWV_DZ","HMMWV_M1035_DES_EP1","LandRover_CZ_EP1","LandRover_TK_CIV_EP1","UAZ_CDF","UAZ_INS","UAZ_RU","UAZ_Unarmed_TK_CIV_EP1","UAZ_Unarmed_TK_EP1","UAZ_Unarmed_UN_EP1"];
cargo_trucks 						  = ["Kamaz","MTVR_DES_EP1","Ural_CDF","Ural_TK_CIV_EP1","Ural_UN_EP1","V3S_Open_TK_CIV_EP1","V3S_Open_TK_EP1"];
refuel_trucks						  = ["KamazRefuel_DZ","MtvrRefuel_DES_EP1_DZ","UralRefuel_TK_EP1_DZ","V3S_Refuel_TK_GUE_EP1_DZ"];
civil_vehicles 						= ["hilux1_civil_1_open","hilux1_civil_2_covered","hilux1_civil_3_open_EP1","SUV_Blue","SUV_Camo","SUV_Charcoal","SUV_Green","SUV_Orange","SUV_Pink","SUV_Red","SUV_Silver","SUV_TK_CIV_EP1","SUV_White","SUV_Yellow"];

// Dynamic box array
ammo_box_guns             = ["M240_DZ","M249_DZ","Mk_48_DZ","bizon_silenced","MP5A5","MP5SD","RPK_74","M240_DZ","M249_DZ","Mk_48_DZ","bizon_silenced","MP5A5","MP5SD","RPK_74","AK_47_M","AK_74","AKS_74_kobra","AKS_74_U","BAF_L85A2_RIS_Holo","bizon_silenced","FN_FAL_ANPVS4","FN_FAL","G36A_camo","G36C_camo","G36C","G36K_camo","M1014","M16A2","M16A2GL","M4A1_AIM_SD_camo","M4A1_Aim","M4A1_HWS_GL_camo","M4A1","M4A3_CCO_EP1","Remington870_lamp","Sa58P_EP1","Sa58V_CCO_EP1","Sa58V_EP1","Sa58V_RCO_EP1"];
ammo_box_tools 						= ["Binocular","Binocular_Vector","ItemCompass","ItemCrowbar","ItemEtool","ItemFishingPole","ItemFlashlightRed","ItemGPS","ItemHatchet_DZE","ItemKnife","ItemMachete","ItemMatchbox_DZE","ItemToolbox","NVGoggles"];
ammo_box_items 						= ["FoodNutmix","FoodPistachio","FoodMRE","ItemSodaOrangeSherbet","ItemSodaRbull","ItemSodaR4z0r","ItemSodaMdew","ItemSodaPepsi","ItemBandage","ItemSodaCoke","FoodbaconCooked","FoodCanBakedBeans","FoodCanFrankBeans","FoodCanPasta","FoodCanSardines","FoodchickenCooked","FoodmuttonCooked","FoodrabbitCooked","ItemTroutCooked","ItemTunaCooked","ItemSeaBassCooked","ItemAntibiotic","ItemBloodbag","ItemEpinephrin","ItemHeatPack","ItemMorphine","ItemGoldBar","ItemGoldBar10oz","CinderBlocks","ItemCanvas","ItemComboLock","ItemKeyKit","ItemLightBulb","ItemLockbox","ItemSandbag","ItemTankTrap","ItemWire","MortarBucket","PartEngine","PartFueltank","PartGeneric","PartGlass","PartPlankPack","PartVRotor","PartWheel","PartWoodPile"];

WAImissionconfig 					= true;
