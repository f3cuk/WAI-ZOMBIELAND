//Weapon Cache

private ["_dropPosition","_effectSmoke","_numSpawned","_numKillReq","_position","_box","_missiontimeout","_cleanmission","_playerPresent","_starttime","_currenttime","_cleanunits","_rndnum","_rndgro","_num_guns","_num_tools","_num_items"];

_position 		= safepos call BIS_fnc_findSafePos;
diag_log 		format["WAI: Mission Weapon cache started at %1",_position];

_num_guns		= (3 + round(random 12));
_num_tools		= 2;
_num_items		= 2;
_numSpawned = "";

_box 			= createVehicle ["BAF_VehicleBox",[(_position select 0),(_position select 1),0], [], 0, "CAN_COLLIDE"];

_rndnum 	= (1 + round (random 7));
_rndgro 	= (1 + round (random 3));

for "_i" from 0 to _rndgro do {
	[[_position select 0, _position select 1, 0],_rndnum,"easy","Random",3,"Random","Random","Random",true] call spawn_group;
};

[[[(_position select 0) + 10, (_position select 1) + 10, 0],[(_position select 0) + 10, (_position select 1) - 10, 0]],"M2StaticMG","easy","Random",0,2,"Random","Random",true] call spawn_static;

[_position,"[Medium] Weapon cache"] execVM "\z\addons\dayz_server\WAI\missions\compile\markers.sqf";

[nil,nil,rTitleText,"Bandits have obtained a weapon crate! Check your map for the location!", "PLAIN",10] call RE;

_missiontimeout 		= true;
_cleanmission 			= false;
_playerPresent 			= false;
_starttime 				= floor(time);
if(_numSpawned == "") then {
	_numSpawned = ai_ground_units;
};

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
	
	_numKillReq = ceil(wai_RequiredKillPercent * _numSpawned);
	//diag_log format["WAI: player must kill %1 AI",_numKillReq];
	waitUntil
	{
		sleep 5;
		_playerPresent = false;

		{
			if((isPlayer _x) && (_x distance _position <= 30) && (ai_ground_units <= (_numSpawned - _numKillReq))) then {
				_playerPresent = true
			};
		} forEach playableUnits;

		(_playerPresent)
	};
	
	[_box,_num_guns,_num_tools,_num_items] call spawn_ammo_box;
	
	if(wai_crates_smoke) then {

		_dropPosition = getpos _box;
		_effectSmoke = "smokeShellPurple" createVehicle _dropPosition;
		_effectSmoke attachto [_box, [0,0,-0.2]];
		
	};

	[nil,nil,rTitleText,"Survivors have secured the Weapon Cache!", "PLAIN",10] call RE;

} else {

	clean_running_mission 	= true;
	deleteVehicle 			_box;

	{
		_cleanunits = _x getVariable "missionclean";
		
		if (!isNil "_cleanunits") then {

			switch (_cleanunits) do {
				case "ground" :  {ai_ground_units = (ai_ground_units -1);};
				case "air" :     {ai_air_units = (ai_air_units -1);};
				case "vehicle" : {ai_vehicle_units = (ai_vehicle_units -1);};
				case "static" :  {ai_emplacement_units = (ai_emplacement_units -1);};
			};
			
			deleteVehicle _x;
			sleep 0.05;
		};

	} forEach allUnits;
	
	[nil,nil,rTitleText,"Survivors did not secure the Weapon Cache in time", "PLAIN",10] call RE;
};

diag_log format["WAI: Mission Weapon cache ended at %1",_position];
missionrunning = false;
