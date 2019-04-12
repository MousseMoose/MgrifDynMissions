#define MGRIF_CONFIGROOT missionConfigFile


/*_class = _this select 0;
_group = _this select 1;
_pos = _this select 2;
_faction = _this select 3;*/
params [["_class","rifleman"],
		["_group",grpNull],
		["_pos",[]],
		["_faction","Fia"]
		];




_unit = _group createUnit [getText ( MGRIF_CONFIGROOT >> 'CfgMgrifFactions' >> _faction >> 'unit') ,_pos,[],0,"CAN_COLLIDE"];
_unit setUnitLoadout getArray (MGRIF_CONFIGROOT >> 'CfgMgrifFactions' >> _faction >> _class);
[_unit] join _group; 
_unit



