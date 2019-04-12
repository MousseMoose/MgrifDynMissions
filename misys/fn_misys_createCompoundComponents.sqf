#define MGRIF_CONFIGROOT missionconfigFile
#include "MacrosCompounds.hpp"
#include "MacrosGarrison.hpp"

params [
	["_compoundPos",0],
	["_dir",0],
	["_faction","FIA"],
	["_compTypes",[]],
	["_compSizes",[]],
	["_compNames", []],
	["_compPositions", []],
	["_strength", 1],
	["_radius", 33],
	["_isAux", false]
];

_configType = "CfgMisysCompoundComponents";

if(_isAux) then {
	_configType = "CfgMisysCompoundAuxillaries";
};


if(count (_compSizes) > 0) then {
	
	{
		if(_x == "rand") then {
			_comp = (MGRIF_CONFIGROOT >> _configType >> (_compTypes select _forEachIndex) >> (_compSizes select _forEachIndex)) ;
			_compNames set [_forEachIndex,configName ([_comp] call mgrif_fnc_misys_selectRandomConfig)];
		};
	} forEach _compNames;
	
	

	{
		_comp = (MGRIF_CONFIGROOT >> _configType >> (_compTypes select _forEachIndex) >> _x);
		_compPos = _compPositions select _forEachIndex;
		
		_compDir = getDir ((_compound select MISYS_COMPS) select _forEachIndex);
		if(_isAux) then {
			_compDir = 0;
		};
		
		_compName = _compNames select _forEachIndex;
		_compFile = "";
		_compConfig = "";
		
		_compConfig = (_comp >> _compName);
		
		
		
		_compFile = getText (_compConfig >> "file");
		_compObjs = [
						_compFile,
						_compPos,
						_compDir
					] call mgrif_fnc_misys_createComposition;
		_compCustom = [_compoundPos, _dir, _compPos, _compDir, _faction, _strength, _compObjs,_compTypes,_compSizes] call call compile getText (MGRIF_CONFIGROOT >> _configType >> (_compTypes select _forEachIndex) >> "function");

		{
			private _current = _x;
			private _currentIndex = _forEachIndex;
			{(((_garrisonForces)#_currentIndex)#_forEachIndex) append _x} forEach _current;
		} forEach (_compCustom#0);
		//_vehicles append (_compCustom#1);
		//_props append (_compCustom#2);
		
		if(_isAux) then {
			p2 pushback [_compFile,_compPos,_compDir];
			hint str [_compFile,_compPos,_compDir];
		};
		
		{
			//TODO: edge case index 0 (should remain in array, instead of just being appended)
			(_compound select _forEachIndex) append _x;
		} foreach _compObjs;
	} foreach _compSizes;
	
	//{deleteVehicle _x} foreach (_compound select MISYS_COMPS);
};
[_garrisonForces]