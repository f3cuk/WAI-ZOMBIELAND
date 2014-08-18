if(isServer) then {

	private["_tanktraps","_mines","_playerPresent","_cleanmission","_currenttime","_starttime","_missiontimeout","_vehname","_veh","_position","_vehclass","_vehdir","_objPosition"];

	_position 		= safepos call BIS_fnc_findSafePos;
	_tanktraps		= [];
	_mines			= [];	

	diag_log 		format["WAI: Mission MV22 started at %1",_position];

	_vehclass 		= "MV22_DZ";
	_vehname		= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");

	//Medical Supply Box
	_box 			= createVehicle ["LocalBasicWeaponsBox",[(_position select 0) - 20,(_position select 1) - 20,0], [], 0, "CAN_COLLIDE"];
	[_box] 			call Medical_Supply_Box;

	//Medical Tent
	_tent 			= createVehicle ["USMC_WarfareBFieldhHospital",[(_position select 0) - 40, (_position select 1),-0.2],[], 0, "CAN_COLLIDE"];
	_tent 			setVectorUp surfaceNormal position _tent;

	//MV22
	_veh 			= createVehicle [_vehclass,_position, [], 0, "CAN_COLLIDE"];
	_vehdir			= round(random 360);
	_veh 			setDir _vehdir;

	clearWeaponCargoGlobal _veh;
	clearMagazineCargoGlobal _veh;

	_veh 			setVariable ["ObjectID","1",true];
	PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];
	_objPosition 	= getPosATL _veh;
	
	diag_log format["WAI: Mission MV22 spawned a %1",_vehname];

	// deploy roadkill defense (or not)
	if(wai_enable_tank_traps) then {
		_tanktraps = [_position] call tank_traps;
	};
	
	if(wai_enable_minefield) then {
		_mines = [_position,50,100,50] call minefield;
	};
	
	//Troops
	_rndnum = round (random 3) + 4;
	[[_position select 0, _position select 1, 0],_rndnum,"hard","Random",4,"Random","Random","Random","Bandit",true] call spawn_group;
	[[_position select 0, _position select 1, 0],_rndnum,"hard","Random",4,"Random","Random","Random","Bandit",true] call spawn_group;
	[[_position select 0, _position select 1, 0],_rndnum,"Random","Random",4,"Random","Random","Random","Bandit",true] call spawn_group;
	[[_position select 0, _position select 1, 0],_rndnum,"Random","Random",4,"Random","Random","Random","Bandit",true] call spawn_group;
	 
	//Turrets
	[[[(_position select 0) + 10, (_position select 1) + 10, 0],[(_position select 0) + 10, (_position select 1) - 10, 0]],"M2StaticMG","easy","Random",0,2,"Random","Random","Bandit",true] call spawn_static;

	if(wai_enable_tank_traps) then {
		[_position] call tank_traps;
	};

	[_position,"[Medium] Captured MV 22","Bandit"] execVM wai_marker;
	
	[nil,nil,rTitleText,"Bandits have captured a Red Cross MV-22! An informant has advised there is medical supplies, he has updated the map for the location!", "PLAIN",10] call RE;

	_missiontimeout 	= true;
	_cleanmission 		= false;
	_playerPresent 		= false;
	_starttime 			= floor(time);

	while {_missiontimeout} do {
		sleep 5;
		_currenttime = floor(time);

		{
			if((isPlayer _x) && (_x distance _position <= 150)) then {
				_playerPresent = true
			};
		} forEach playableUnits;

		if (_currenttime - _starttime >= wai_mission_timeout) then {
			_cleanmission = true;
		};

		if ((_playerPresent) || (_cleanmission)) then {
			_missiontimeout = false;
		};
	};

	if (_playerPresent) then {

		[0] call mission_type;

		[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;

		[_box,"Survivors have secured the MV-22!",[_tanktraps,_mines]] call mission_succes;

	} else {

		[[_box,_veh,_tanktraps,_mines],"Survivors did not secure the MV-22 in time!"] call mission_failure;
		
	};

	diag_log format["WAI: Mission captured MV-22 ended at %1",_position];

	missionrunning = false;

};