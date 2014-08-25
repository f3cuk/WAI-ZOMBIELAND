if(isServer) then {

	private ["_max_ai","_timeout_time","_currenttime","_starttime","_msglose","_msgwin","_msgstart","_objectives","_crate","_marker","_in_range","_objectivetarget","_position","_type","_complete","_timeout","_mission","_killpercent","_delete_mines","_cleanunits","_clearmission","_baseclean"];

	_mission	= (_this select 0) select 0;
	_crate		= (_this select 0) select 1;
	_type		= (_this select 1) select 0;
	_baseclean	= _this select 2;
	_msgstart	= _this select 3;
	_msgwin		= _this select 4;
	_msglose	= _this select 5;

	_position				= position _crate;
	_timeout 				= false;
	_complete				= false;
	_starttime 				= time;
	_timeout_time			= ((wai_mission_timeout select 0) + random((wai_mission_timeout select 1) - (wai_mission_timeout select 0)));
	_max_ai					= (wai_mission_data select _mission) select 0;

	[nil,nil,rTitleText,_msgstart,"PLAIN",10] call RE;

	while {!_timeout && !_complete} do {

		sleep 1;
		_currenttime = time;
		{
			if((isPlayer _x) && (_x distance _position <= wai_timeout_distance)) then {
				_starttime = time;
			};
			
		} forEach playableUnits;

		if (_currenttime - _starttime >= _timeout_time) then {
			_timeout = true;
		};
		
		call {

			if (_type == "crate") exitWith {

				if(wai_kill_percent == 0) then {

					{
						if((isPlayer _x) && (_x distance _position <= 20)) then {
							_complete = true
						};
					} forEach playableUnits;

				} else {

					_killpercent = _max_ai - (_max_ai * (wai_kill_percent / 100));

					if(((wai_mission_data select _mission) select 0) >= _killpercent) then {
						{
							if((isPlayer _x) && (_x distance _position <= 20)) then {
								_complete = true
							};
						} forEach playableUnits;
					};

				};

			};

			if (_type == "kill") exitWith {
				if(((wai_mission_data select _mission) select 0) == _max_ai) then {
					_complete = true
				};
			};

			if (_type == "assassinate") exitWith {
				_objectivetarget = (_this select 1) select 1;
				{
					_complete = true;
					if (alive _x) exitWith {_complete = false;};
				} count units _objectivetarget;
			};

		};
	};

	if (_complete) then {

		if(wai_crates_smoke) then {
			_marker = "smokeShellPurple" createVehicle getPosATL _crate;
			_marker setPosATL (getPosATL _crate);
			_marker attachTo [_crate,[0,0,0]];
		};

		if (wai_crates_flares && sunOrMoon != 1) then {
			_marker = "RoadFlare" createVehicle getPosATL _crate;
			_marker setPosATL (getPosATL _crate);
			_marker attachTo [_crate, [0,0,0]];
			
			_in_range = _crate nearEntities ["CAManBase",1250];
			
			{
				if(isPlayer _x && _x != player) then {
					PVDZE_send = [_x,"RoadFlare",[_marker,0]];
					publicVariableServer "PVDZE_send";
				};
			} count _in_range;

		};

		_delete_mines = ((wai_mission_data select _mission) select 2);

		if(count _delete_mines > 0) then {
			{
				if(typeName _x == "ARRAY") then {
				
					{
						deleteVehicle _x;
					} forEach _x;
				
				} else {
				
					deleteVehicle _x;
				};
				
			} forEach _delete_mines;
		};
		
		wai_mission_data set [_mission, -1];
		[nil,nil,rTitleText,_msgwin,"PLAIN",10] call RE;
	};

	if (_timeout) then {

		{
			_cleanunits = _x getVariable ["missionclean",nil];
		
			if (!isNil "_cleanunits") then {

				switch (_cleanunits) do {
					case "ground" : {ai_ground_units = (ai_ground_units -1);};
					case "air" : {ai_air_units = (ai_air_units -1);};
					case "vehicle" : {ai_vehicle_units = (ai_vehicle_units -1);};
					case "static" : {ai_emplacement_units = (ai_emplacement_units -1);};
				};
				sleep .1;
			};

			if (_x getVariable ["mission", nil] == _mission) then {
				deleteVehicle _x;
			};

		} forEach allUnits + vehicles;
		
		{
			if(typeName _x == "ARRAY") then {
			
				{
					deleteVehicle _x;
				} forEach _x;
			
			} else {
			
				deleteVehicle _x;
			};
			
		} forEach _baseclean + ((wai_mission_data select _mission) select 2) + [_crate];
			
		wai_mission_data set [_mission, -1];
		[nil,nil,rTitleText,_msglose,"PLAIN",10] call RE;
	};

};