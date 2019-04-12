#define MGRIF_CONFIGROOT missionconfigFile
#include "MacrosCompounds.hpp"
#include "MacrosGarrison.hpp"

params [
	["_compPos",[]],
	["_compDir",[]],
	["_compType",""],
	["_compSize",""],
	["_compName", ""],
	["_faction","FIA"],
	["_strength", 1],
	["_isAux", false]
];




_configType = "CfgMisysCompoundComponents";

if(_isAux) then {
	_configType = "CfgMisysCompoundAuxillaries";
};


if(_compName == "rand") then {
	_comp = (MGRIF_CONFIGROOT >> _configType >> _compType >> _compSize);
	_compName = configName ([_comp] call mgrif_fnc_misys_selectRandomConfig);
};


_compFile = "";
_compConfig = (MGRIF_CONFIGROOT >> _configType >> _compType >> _compSize >> _compName);
_compFile = getText (_compConfig >> "file");

//if(_isAux) then {
//	hint str [_compFile,_compPos,_compDir];
//};

_compObjs = [
				_compFile,
				_compPos,
				_compDir
			] call mgrif_fnc_misys_createComposition;
			
//_compCustom = [_compoundPos, _dir, _compPos, _compDir, _faction, _strength, _compObjs,_compTypes,_compSizes] call call compile getText (MGRIF_CONFIGROOT >> _configType >> (_compTypes select _forEachIndex) >> "function");

[_compName,_compObjs]



