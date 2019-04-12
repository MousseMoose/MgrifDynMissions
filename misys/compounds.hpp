//Templates. Necessary to have standardised compound classes that can be extended with default values for new fields without modifying every entry
class Mgrif_CompoundConfig { //
		class Mgrif_CompoundSize { // Size Template
			class Mgrif_Compound { // Compound Template
					file = "";
					components[] = {};
			};
	};
};

class Mgrif_CompoundComponentConfig {
		class Mgrif_CompoundComponentType { //Type Template
			class Mgrif_CompoundComponentSize { //Component Size Template
				class Mgrif_CompoundComponent { // Compound Component Template
					file = "";
				};
			};
		};
		
};

class RB {
	class RBA {
	};
};

class CfgMisysCompounds:Mgrif_CompoundConfig {
	
	class S33:Mgrif_CompoundSize {
		class CampAudacity:Mgrif_Compound  {
			file = "misys\compounds\S33Audacity.sqf";
			components[] ={"S5","S10","S5","S10"};
		};
		
		
		class CampBravery:Mgrif_Compound  {
			file = "misys\compounds\S33Bravery.sqf";
			components[] ={"S7p5","S10","S7p5","S7p5","S10","S7p5"};
		};
		
		class MBase:Mgrif_Compound  {
			file = "misys\compounds\S33MBase.sqf";
			components[] ={"S10","S10","S10","S10","S5"};
		};
		
		class Camp:Mgrif_Compound  {
			file = "misys\compounds\S33Camp.sqf";
			components[] ={"S5","S5","S7p5"};
		};
		
	};
	
};

class CfgMisysCompoundComponents: Mgrif_CompoundComponentConfig {
	
	//Todo: statically generate availables in init
	availableS5[] = {"Garage","Props","Garrison"};
	availableS7p5[] = {"Garage","Props","Garrison"};
	availableS10[] = {"Garage","Props","Garrison","Helipad","Medical"};
	
	
	class Garage:Mgrif_CompoundComponentType {
		function = "mgrif_fnc_misys_componentGarage";
		class S5:Mgrif_CompoundComponentSize {
			class Car:Mgrif_CompoundComponent {
				file = "misys\components\s5GarageCar.sqf";
			};
		};
		
		class S7p5:Mgrif_CompoundComponentSize {
			class NetBarrels:Mgrif_CompoundComponent {
				file = "misys\components\s7p5GarageNetBarrels.sqf";
			};
		};
		
		class S10:Mgrif_CompoundComponentSize {
			class Net:Mgrif_CompoundComponent {
				file = "misys\components\s10GarageNet.sqf";
			};
		};
	};
	
	
	
	
	class Props:Mgrif_CompoundComponentType {
		function = "mgrif_fnc_misys_componentProps";
		class S5:Mgrif_CompoundComponentSize {
			class Portapotties:Mgrif_CompoundComponent {
				file = "misys\components\s5portapotties.sqf";
			};	
		};
		
		class S7p5:Mgrif_CompoundComponentSize {
			class Storage:Mgrif_CompoundComponent {
				file = "misys\components\s7p5PropsStorage.sqf";
			};	
		};
		
		class S10:Mgrif_CompoundComponentSize {
			class HelipadProps:Mgrif_CompoundComponent {
				file = "misys\components\s10helipad.sqf";
			};
		};
		
		
	};
	
	class Garrison:Mgrif_CompoundComponentType {
		function = "mgrif_fnc_misys_componentGarrison";
		class S5:Mgrif_CompoundComponentSize {
			class Tents:Mgrif_CompoundComponent {
				file = "misys\components\s5tents.sqf";
			};
		};
		
		class S7p5:Mgrif_CompoundComponentSize {
			class Cargo2:Mgrif_CompoundComponent {
				file = "misys\components\s7p5Cargo2.sqf";
			};
		};
		
		class S10:Mgrif_CompoundComponentSize {
			
			class HQ:Mgrif_CompoundComponent {
				file = "misys\components\s10hq.sqf";
			};
		};
		
	};
	
	class Medical:Mgrif_CompoundComponentType {
		function = "mgrif_fnc_misys_componentMedical";
		class S10:Mgrif_CompoundComponentSize {
			class Damaged:Mgrif_CompoundComponent {
				file = "misys\components\s10MedicalDamaged.sqf";
			};
		};
	};
	
	class Helipad:Mgrif_CompoundComponentType {
		function = "mgrif_fnc_misys_componentHelipad";
		class S10:Mgrif_CompoundComponentSize {
			class Helipad:Mgrif_CompoundComponent {
				file = "misys\components\s10helipad.sqf";
			};
		};
	};
};

class CfgMisysCompoundAuxillaries: Mgrif_CompoundComponentConfig {
	class Motorpool:Mgrif_CompoundComponentType {
		function = "mgrif_fnc_misys_componentGarage";
		class S20:Mgrif_CompoundComponentSize {
			class Car:Mgrif_CompoundComponent {
				file = "misys\components\s20Motorpool.sqf";
			};
		};		
	};
	
	class Garrison:Mgrif_CompoundComponentType {
		function = "mgrif_fnc_misys_componentGarrison";
		class S15:Mgrif_CompoundComponentSize {
			class Houses:Mgrif_CompoundComponent {
				file = "misys\components\s15GarrisonCargo.sqf";
			};
		};
	};
};



class CfgMisysRoadblocks {
	class JunkBarricade {
		file = "misys\roadblocks\rbJunkBarricade.sqf";
	};
};