if(isServer) then {

	private["_box","_name","_marker_add"];

	_box 			= _this select 0;
	_statement		= _this select 1;

	_current_time	= floor(time);

	if(wai_crates_smoke) then {

		if (_current_time > 18.5 && _current_time < 6) then {
			_marker_add = "ARTY_Flare_Medium" createVehicle getPosATL _box;
			_marker_add setPosATL (getPosATL _box);
			_marker_add attachTo [_box, [0,0,0]];
		} else {
			_marker_add = "smokeShellPurple" createVehicle getPosATL _box;
			_marker_add setPosATL (getPosATL _box);
			_marker_add attachTo [_box,[0,0,0]];
		};
		
	};

	[nil,nil,rTitleText,format["%1", _statement], "PLAIN",10] call RE;

};