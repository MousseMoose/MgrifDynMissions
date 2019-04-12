#define MGRIF_CONFIGROOT missionConfigFile
params [
		["_pos",[]],
		["_minObjDist",0],
		["_compoundSize",33],
		["_in",false],
		["_default",[]]
	];	

private ["_min","_max"];
_min = 0;
_max = 0;

if(_in) then {
	_max = _compoundSize;
} else {
	_min = _compoundSize;
	_max = _compoundSize * 1.5;
};


_safePos = [_pos, _min, _max, _minObjDist, 0, 0.5, 0,[],_default] call mgrif_fnc_misys_findSafePosReal;
_safePos