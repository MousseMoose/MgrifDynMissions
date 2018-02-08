#define MGRIF_CONFIGROOT missionConfigFile
#define MGRIF_MISYS_CU(CLASS,GROUP,POS,FACTION) [CLASS,GROUP,POS,FACTION] call mgrif_fnc_misys_createUnit

params [
	["_faction","fia"],
	["_generalClass",""],
	["_pos",[]],
	["_crewed",false],
	["_specificClass","rand"]
	
	
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


if(_crewed) then {
	private ["_group","_unit"];
	_group = createGroup OPFOR;
	_crewType = "crew";
	if(_specificClass isKindOf "Air") then {
		_crewType = "pilot";
	};
	
	if(getNumber(configFile >> "CfgVehicles" >> _specificClass >> "hasDriver") == 1 ) then {
		_unit = MGRIF_MISYS_CU(_crewType,_group,_pos,_faction);
		_unit moveInDriver _veh;
	};
	
	//Backwards compatibility? Is this needed?
	if(getNumber(configFile >> "CfgVehicles" >> _specificClass >> "hasGunner") == 1 ) then {
		_unit = MGRIF_MISYS_CU(_crewType,_group,_pos,_faction);
		_unit moveInGunner _veh;
	};
	
	if(getNumber(configFile >> "CfgVehicles" >> _specificClass >> "hasCommander") == 1 ) then {
		_unit = MGRIF_MISYS_CU(_crewType,_group,_pos,_faction);
		_unit moveInCommander _veh;
	};
	
	{
		_unit = MGRIF_MISYS_CU(_crewType,_group,_pos,_faction);
		_unit moveInTurret [_veh,_x];
	} forEach (allTurrets _veh);
	
	
};	

_veh