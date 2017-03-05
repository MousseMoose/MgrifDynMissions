#define MUCONFIGROOT missionConfigFile
params ["_faction","_rarity","_entry"];
getArray (MUCONFIGROOT >> 'cfgMuFactions' >> _faction >> 'gear' >> _rarity >> _entry)