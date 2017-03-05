class cfgMuFactions {
    class fia {
        
        unit = "B_G_Soldier_F";
        vehicles[] =  {};
        patrolMaxCount = 2; //TODO: rethink, limits scaling!
        patrolMaxStrength = 5;
        
        class gear {

            class common {
            	uniforms[] = {"U_BG_Guerilla2_3","U_BG_Guerilla2_2"};
            	vests[]		= {"V_Chestrig_blk","V_BandollierB_oli"};
            	backpacks[] = {"B_AssaultPack_rgr"};
            	goggles[] = {"G_Aviator"};
            	head[] = {"H_Bandanna_gry","H_Booniehat_oli"};
            	
            	
            	
                weaponsPrim[]	= {"SMG_01_F","arifle_TRG20_F"};
                weaponsSec[]	= {};
                weaponsSide[]	= {"hgun_Rook40_F"};
                
                attachmentsPrim[] = {{},{},{},{"optic_ACO_grn_smg"}}; // muzzle, bipod, side,sights
                attachmentsSec[] = {{},{},{},{}}; 
                attachmentsSide[] = {{},{},{},{}};
                
                
                sidearms[]	= {"hgun_Rook40_F"};
                items[]		= {"FirstAidKit","Chemlight_red","Chemlight_green"};
                itemCount[]	= {0,3};	//min, max
                gear[]		= {"itemCompass"}; // "bonus" gear APART FROM map and radio
                gearCount[] 	= {1,0};
                
            };
            
            
            class uncommon:common {
				itemCount[] 	= {3,1};
            };
            
            class rare:uncommon {
                vests[]		= {"V_TacVest_oli"};
            };
            
		};
	};
    
};