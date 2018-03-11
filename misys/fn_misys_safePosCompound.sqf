#define MUCONFIGROOT missionConfigFile
params [
		["_pos",[]],
		["_minObjDist",0],
		["_compoundSize",33],
		["_in",false]
	];	

private ["_min","_max"];
_min = 0;
_max = 0;

if(_in) then {
	_max = _compoundSize;
} else {
	_min = _compoundSize;
	_max = 50;
};


_safePos = [_pos, _min, _max, _minObjDist, 0, 0.5, 0,[]] call BIS_fnc_findSafePos;
_safePos;