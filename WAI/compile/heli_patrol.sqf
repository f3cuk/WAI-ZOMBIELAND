if (isServer) then {

	private ["_wpnum","_radius","_gunner2","_gunner","_skillarray","_startingpos","_heli_class","_startPos","_helicopter","_unitGroup","_pilot","_skill","_position","_wp"];

	_position 			= _this select 0;
	_startingpos 		= _this select 1;
	_radius 			= _this select 2;
	_wpnum 				= _this select 3;
	_heli_class 		= _this select 4;
	_skill 				= _this select 5;
	_aitype				= _this select 6;

	_skillarray			= ["aimingAccuracy","aimingShake","aimingSpeed","endurance","spotDistance","spotTime","courage","reloadSpeed","commanding","general"];

	_unitGroup 			= createGroup east;
	_pilot 				= _unitGroup createUnit ["Bandit1_DZ", [0,0,0], [], 1, "NONE"];

	switch (_skill) do {
		case "easy"		: { _aicskill = ai_skill_easy; };
		case "medium" 	: { _aicskill = ai_skill_medium; };
		case "hard" 	: { _aicskill = ai_skill_hard; };
		case "extreme" 	: { _aicskill = ai_skill_extreme; };
		case "Random" 	: { _aicskill = ai_skill_random call BIS_fnc_selectRandom; };
		default	{ _aicskill = ai_skill_random call BIS_fnc_selectRandom; };
	};

	[_pilot] joinSilent _unitGroup;
	switch (_aitype) do {
		case "Bandit":	{ _pilot setVariable ["humanity", ai_add_humanity, true]; };
		case "Hero":	{ _pilot setVariable ["humanity", -ai_remove_humanity, true]; };
	};
	ai_air_units 		= (ai_air_units +1);

	_helicopter 		= createVehicle [_heli_class, [(_startingpos select 0),(_startingpos select 1), 200], [], 0, "FLY"];
	_helicopter 		setFuel 1;
	_helicopter 		engineOn true;
	_helicopter 		setVehicleAmmo 1;
	_helicopter 		flyInHeight 150;
	_helicopter 		lock true;
	_helicopter 		addEventHandler ["GetOut",{(_this select 0) setFuel 0;(_this select 0) setDamage 1;}];

	_pilot 				assignAsDriver _helicopter;
	_pilot 				moveInDriver _helicopter;

	_gunner 			= _unitGroup createUnit ["Bandit1_DZ", [0,0,0], [], 1, "NONE"];
	_gunner 			assignAsGunner _helicopter;
	_gunner 			moveInTurret [_helicopter,[0]];

	[_gunner] 			joinSilent _unitGroup;
	switch (_aitype) do {
		case "Bandit":	{ _gunner setVariable ["humanity", ai_add_humanity, true]; };
		case "Hero":	{ _gunner setVariable ["humanity", -ai_remove_humanity, true]; };
	};
	ai_air_units 		= (ai_air_units + 1);

	_gunner2 			= _unitGroup createUnit ["Bandit1_DZ", [0,0,0], [], 1, "NONE"];
	_gunner2			assignAsGunner _helicopter;
	_gunner2 			moveInTurret [_helicopter,[1]];
	[_gunner2] 			joinSilent _unitGroup;
	switch (_aitype) do {
		case "Bandit":	{ _gunner2 setVariable ["humanity", ai_add_humanity, true]; };
		case "Hero":	{ _gunner2 setVariable ["humanity", -ai_remove_humanity, true]; };
	};
	ai_air_units 		= (ai_air_units + 1);

	{
		_pilot setSkill [_x,1]
	} forEach _skillarray;

	{
		_gunner 	setSkill [(_x select 0),(_x select 1)];
		_gunner2 	setSkill [(_x select 0),(_x select 1)];
	} forEach _aicskill;

	{
		_x addweapon "Makarov";
		_x addmagazine "8Rnd_9x18_Makarov";
		_x addmagazine "8Rnd_9x18_Makarov";
	} forEach (units _unitgroup);

	{
		_x addEventHandler ["Killed",{[_this select 0, _this select 1, "air"] call on_kill;}];
	} forEach (units _unitgroup);

	PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_helicopter];
	[_helicopter] spawn veh_monitor;

	_unitGroup allowFleeing 0;
	_unitGroup setBehaviour "AWARE";
	_unitGroup setSpeedMode "FULL";
	_unitGroup setCombatMode "RED";

	if(_wpnum > 0) then {

		for "_i" from 1 to _wpnum do {
			_wp = _unitGroup addWaypoint [[(_position select 0),(_position select 1),0],_radius];
			_wp setWaypointType "MOVE";
			_wp setWaypointCompletionRadius 200;
		};

	};

	_wp = _unitGroup addWaypoint [[(_position select 0),(_position select 1),0],100];
	_wp setWaypointType "CYCLE";
	_wp setWaypointCompletionRadius 200;

};