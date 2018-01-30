#define MGRIF_CONFIGROOT missionConfigFile

params [
	["_faction","fia"],
	["_generalClass",""],
	["_specificClass","rand"],
	["_pos",[]]
];	

private ["_veh","_name"];

if(_specificClass == "rand") then {
	_specificClass =  configName ([MGRIF_CONFIGROOT >> "CfgMgrifFactions" >> _faction  >> _generalClass] call mgrif_fnc_misys_selectRandomConfig);
};
_veh =  _specificClass createVehicle _pos;
_veh setVariable ["BIS_enableRandomization", false];

//textures
{ 
	if(_x != "none") then {
		_veh setObjectTextureGlobal [_forEachIndex,_x];
	};
} foreach getArray(MGRIF_CONFIGROOT >> "CfgMgrifFactions" >> _faction  >> _generalClass >> _specificClass >> "textures");

_veh
	


