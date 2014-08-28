if (isServer) then {

	private ["_type","_skin","_gain","_mission","_ainum","_unit","_player","_humanity","_banditkills","_humankills","_humanitygain"];
	
	_unit 		= _this select 0;
	_player 	= _this select 1;
	_type 		= _this select 2;

	switch (_type) do {
		case "ground" : {ai_ground_units = (ai_ground_units -1);};
		case "air" : {ai_air_units = (ai_air_units -1);};
		case "vehicle" : {ai_vehicle_units = (ai_vehicle_units -1);};
		case "static" : {ai_emplacement_units = (ai_emplacement_units -1);};
	};
	
	_unit setVariable["missionclean", nil];
	
	_mission = _unit getVariable ["mission", nil];
		
	if (!isNil "_mission") then {
		if (typeName(wai_mission_data select _mission) == "ARRAY") then {
			wai_mission_data select _mission set [0, ((wai_mission_data select _mission) select 0) - 1];
		};
	};
	_unit setVariable ["killedat", time];

	if(ai_add_skin) then {

		_skin = (typeOf _unit);
		_skin = "Skin_" + _skin;

		if (isClass (configFile >> "CfgMagazines" >> _skin)) then {
			[_unit,_skin] call BIS_fnc_invAdd;
		};

	};

	if (isPlayer _player) then {

		private ["_banditkills","_humanity","_humankills"];

		_humanity 		= _player getVariable["humanity",0];
		_banditkills 	= _player getVariable["banditKills",0];
		_humankills 	= _player getVariable["humanKills",0];

		if (ai_humanity_gain) then {
			_gain = _unit getVariable ["humanity", 0];
			call {
				if (_unit getVariable ["Hero", false]) exitWith { _player setVariable ["humanity",(_humanity - _gain),true]; };
				if (_unit getVariable ["Bandit", false]) exitWith { _player setVariable ["humanity",(_humanity + _gain),true]; };					
				if (_unit getVariable ["Special", false]) exitWith { if (_humanity < 0) then { _player setVariable ["humanity",(_humanity - _gain),true]; } else { _player setVariable ["humanity",(_humanity + _gain),true]; }; };
			};
		};

		if (ai_kills_gain) then {
			if (_unit getVariable ["Hero", false]) then {
				_player setVariable ["humanKills",(_humankills + 1),true];
			} else {
				_player setVariable ["banditKills",(_banditkills + 1),true];
			};
		};

		if (ai_clear_body) then {
			{_unit removeMagazine _x;} forEach (magazines _unit);
			{_unit removeWeapon _x;} forEach (weapons _unit);
		};

		if (ai_share_info) then {
			{if (((position _x) distance (position _unit)) <= ai_share_distance) then {_x reveal [_player, 4.0];}} forEach allUnits;
		};

	} else {

		if (ai_clean_roadkill) then {

			removeBackpack _unit;
			removeAllWeapons _unit;

			{
				_unit removeMagazine _x
			} forEach magazines _unit;

		} else {

			if ((random 100) <= ai_roadkill_damageweapon) then {

				removeAllWeapons _unit;
				
			};

		};

	};

	if(wai_use_rpg && wai_remove_rpg) then {

		if(_unit hasWeapon "RPG7V") then {
			_unit removeWeapon "RPG7V";
			{
				if(_x == "PG7V") then {
					_unit removeMagazine _x
				};
			} forEach magazines _unit;
		};
		
	};

	if(_unit hasWeapon "NVGoggles" && floor(random 100) < 20) then {
		_unit removeWeapon "NVGoggles";
	};

};