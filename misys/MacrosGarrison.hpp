#define MGRIF_MISYS_INFANTRY(arr) (arr select 0)
	#define MGRIF_MISYS_PATROLS(arr) (( arr select 0) select 0)
	#define MGRIF_MISYS_WATCHS(arr) ((arr select 0) select 1)
	#define MGRIF_MISYS_BUILDINGGUARDS(arr) ((arr select 0) select 2)
	#define MGRIF_MISYS_SQUADS(arr) ((arr select 0) select 3)
#define MGRIF_MISYS_MOTORISED(arr) (arr select 1)
	#define MGRIF_MISYS_MOTORISEDUNARMED(arr) ((arr select 1) select 0)
	#define MGRIF_MISYS_MOTORISEDARMED(arr) ((arr select 1) select 1)
#define MGRIF_MISYS_MECHANISED(arr) (arr select 2)
	#define MGRIF_MISYS_MECHANISEDUNARMED(arr) ((arr select 2) select 0)
	#define MGRIF_MISYS_MECHANISEDUNARMED(arr) ((arr select 2) select 1)
#define MGRIF_MISYS_ARMOR(arr) (arr select 3)
	#define MGRIF_MISYS_TANKS(arr) ((arr select 3) select 0)
#define MGRIF_MISYS_HELICOPTERS(arr) (arr select 4)
	#define MGRIF_MISYS_HELICOPTERSTRANSPORT(arr) ((arr select 4) select 0)
	#define MGRIF_MISYS_HELICOPTERSLIGHT(arr) ((arr select 4) select 1)
	#define MGRIF_MISYS_HELICOPTERSATTACK(arr) ((arr select 4) select 2)
#define MGRIF_MISYS_PLANES(arr) (arr select 5)
	#define MGRIF_MISYS_PLANESAA(arr) ((arr select 5) select 0)
	#define MGRIF_MISYS_PLANESCAS(arr) ((arr select 5) select 1)
	#define MGRIF_MISYS_PLANESTRANSPORT(arr) ((arr select 5) select 2)
#define MGRIF_MISYS_GARRISONTEMPLATE [[[],[],[],[]],[[],[]],[[],[]],[[]],[[],[],[]],[[],[],[]]]

#define MGRIF_MISYS_TASK_READY 0
#define MGRIF_MISYS_TASK_CPATROL 1
#define MGRIF_MISYS_TASK_LRPATROL 2
#define MGRIF_MISYS_TASK_SWEEP 3

/*
infantry
	local patrol groups
	Local Watch tower groups
	Local Building groups
	AO Squads
motorised
	motorised unarmed
	motorised armed
mechanised
	mechanised unarmed
	mechanised armed
tank
	tank
helicopter
	helicopter unarmed transport
	helicopter armed transport
	helicopter attack/gunship
plane
	plane AA
	plane CAS
	plane para
*/