#define MUCONFIGROOT missionConfigFile
params ["_faction","_rarity","_entry"];
getText (MUCONFIGROOT >> 'cfgMuFactions' >> _faction >> 'gear' >> _rarity >> _entry)