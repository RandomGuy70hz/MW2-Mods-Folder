#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\gametypes\_missions;

doSetup()  
{
	if(self.team == "axis" || self.team == "spectator"){
		self notify("menuresponse", game["menu_team"], "allies");
		wait .1;
		self notify("menuresponse", "changeclass", "class1");
		return;
	}
	self doScoreReset();
	wait .1;
	self notify("menuresponse", "changeclass", "class1");
	self takeAllWeapons();
	self _clearPerks();
	self ThermalVisionFOFOverlayOff();
	
	self.randomlmg = randomInt(5);
	self.randomar = randomInt(9);
	self.randommp = randomInt(4);
	self.randomsmg = randomInt(5);
	self.randomshot = randomInt(6);
	self.randomhand = randomInt(4);
	self giveWeapon(level.smg[self.randomsmg] + "_mp", 0, false);
	self giveWeapon(level.shot[self.randomshot] + "_mp", 0, false);
	self giveWeapon(level.hand[self.randomhand] + "_mp", 0, false);
	self GiveMaxAmmo(level.smg[self.randomsmg] + "_mp");
	self GiveMaxAmmo(level.shot[self.randomshot] + "_mp");
	self GiveMaxAmmo(level.hand[self.randomhand] + "_mp");
	self switchToWeapon(level.smg[self.randomsmg] + "_mp");
	self maps\mp\perks\_perks::givePerk("specialty_marathon");
	self maps\mp\perks\_perks::givePerk("specialty_automantle");
	self maps\mp\perks\_perks::givePerk("specialty_fastmantle");
	self maps\mp\perks\_perks::givePerk("specialty_heartbreaker");
	self maps\mp\perks\_perks::givePerk("specialty_quieter");
	self thread doHW();
	self.isZombie = 0;
	self.bounty = 0;
	self notify("CASH");
	self.attach1 = [];
	self.attachweapon = [];
	self.attachweapon[0] = 0;
	self.attachweapon[1] = 0;
	self.attachweapon[2] = 0;
	self.attach1[0] = "none";
	self.attach1[1] = "none";
	self.attach1[2] = "none";
	self.currentweapon = 0;
	self thread doPerksSetup();
	self thread doPerkCheck();
	
	self.maxhp = 100;
	self.maxhealth = self.maxhp;
	self.health = self.maxhealth;
	self.moveSpeedScaler = 1;
	self.thermal = 0;
	self.throwingknife = 0;
	self setClientDvar("g_knockback", 1000);
	
	notifySpawn = spawnstruct();
	notifySpawn.titleText = "Human";
	notifySpawn.notifyText = "Survive for as long as possible!";
	notifySpawn.glowColor = (0.0, 0.0, 1.0);
	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifySpawn );
	self thread doHumanBounty();
	self thread doHumanShop();
}

doLastAlive() 
{
	self endon("disconnect");
	self endon("death");
	wait 60;
	self thread maps\mp\gametypes\_hud_message::hintMessage("^1The Zombies Got Your Scent. ColdBlooded is off!");
	for(;;)
	{
		self _unsetPerk("specialty_coldblooded");
		self _unsetPerk("specialty_spygame");
		self.perkz["coldblooded"] = 3;
		wait .4;
	}
}

doAlphaZombie()  
{
	if(self.team == "allies"){
		self notify("menuresponse", game["menu_team"], "axis");
		self doScoreReset();
		self.bounty = 0;
		self notify("CASH");
		self.ck = self.kills;
		self.cd = self.deaths;
		self.cs = self.suicides;
		self.maxhp = 200;
		self thread doPerksSetup();
		wait .1;
		self notify("menuresponse", "changeclass", "class3");
		return;
	}
	wait .1;
	self notify("menuresponse", "changeclass", "class3");
	self takeAllWeapons();
	self _clearPerks();
	
	self giveWeapon("usp_tactical_mp", 0, false);
	self thread doZW();
	self maps\mp\perks\_perks::givePerk("specialty_marathon");
	self maps\mp\perks\_perks::givePerk("specialty_automantle");
	self maps\mp\perks\_perks::givePerk("specialty_fastmantle");
	self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
	self maps\mp\perks\_perks::givePerk("specialty_falldamage");
	self maps\mp\perks\_perks::givePerk("specialty_thermal");
	if(self.thermal == 1){
		self ThermalVisionFOFOverlayOn();
	}
	if(self.throwingknife == 1){
		self thread monitorThrowingKnife();
		self maps\mp\perks\_perks::givePerk( "throwingknife_mp" );
		self setWeaponAmmoClip("throwingknife_mp", 1);
	}
	self thread doPerkCheck();
	
	
	self.maxhealth = self.maxhp;
	self.health = self.maxhealth;
	self.moveSpeedScaler = 1.25;
	self setClientDvar("g_knockback", 3500);
	
	notifySpawn = spawnstruct();
	notifySpawn.titleText = "^0Alpha Zombie";
	notifySpawn.notifyText = "Kill the Humans!";
	notifySpawn.glowColor = (1.0, 0.0, 0.0);
	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifySpawn );
	self thread doZombieBounty();
	self thread doZombieShop();
}

doZombie() 
{
	if(self.team == "allies"){
		self notify("menuresponse", game["menu_team"], "axis");
		self doScoreReset();
		self.bounty = 0;
		self notify("CASH");
		self.ck = self.kills;
		self.cd = self.deaths;
		self.cs = self.suicides;
		self.maxhp = 100;
		self thread doPerksSetup();
		wait .1;
		self notify("menuresponse", "changeclass", "class3");
		return;
	}
	wait .1;
	self notify("menuresponse", "changeclass", "class3");
	self takeAllWeapons();
	self _clearPerks();
	
	
	self giveWeapon("usp_tactical_mp", 0, false);
	self thread doZW();
	self maps\mp\perks\_perks::givePerk("specialty_marathon");
	self maps\mp\perks\_perks::givePerk("specialty_automantle");
	self maps\mp\perks\_perks::givePerk("specialty_fastmantle");
	self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
	self maps\mp\perks\_perks::givePerk("specialty_falldamage");
	self maps\mp\perks\_perks::givePerk("specialty_thermal");
	if(self.thermal == 1){
		self ThermalVisionFOFOverlayOn();
	}
	if(self.throwingknife == 1){
		self thread monitorThrowingKnife();
		self maps\mp\perks\_perks::givePerk( "throwingknife_mp" );
		self setWeaponAmmoClip("throwingknife_mp", 1);
	}
	self thread doPerkCheck();
	
	
	self.maxhealth = self.maxhp;
	self.health = self.maxhealth;
	self.moveSpeedScaler = 1.15;
	self setClientDvar("g_knockback", 3500);
	
	notifySpawn = spawnstruct();
	notifySpawn.titleText = "^0Zombie";
	notifySpawn.notifyText = "Kill the Humans!";
	notifySpawn.glowColor = (1.0, 0.0, 0.0);
	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifySpawn );
	self thread doZombieBounty();
	self thread doZombieShop();
}

doHW() 
{
	self endon ( "disconnect" );
	self endon ( "death" );
	while(1)
	{
		self.current = self getCurrentWeapon();
		switch(getWeaponClass(self.current))
		{
			case "weapon_lmg":
				self.exTo = "Unavailable";
				self.currentweapon = 0;
				break;
			case "weapon_assault":
				self.exTo = "LMG";
				self.currentweapon = 0;
				break;
			case "weapon_smg":
				self.exTo = "Assault Rifle";
				self.currentweapon = 0;
				break;
			case "weapon_shotgun":
				self.exTo = "Unavailable";
				self.currentweapon = 1;
				break;
			case "weapon_machine_pistol":
				self.exTo = "Unavailable";
				self.currentweapon = 2;
				break;
			case "weapon_pistol":
				self.exTo = "Machine Pistol";
				self.currentweapon = 2;
				break;
			default:
				self.exTo = "Unavailable";
				self.currentweapon = 3;
				break;
		}
		basename = strtok(self.current, "_");
		if(basename.size > 2){
			self.attach1[self.currentweapon] = basename[1];
			self.attachweapon[self.currentweapon] = basename.size - 2;
		} else {
			self.attach1[self.currentweapon] = "none";
			self.attachweapon[self.currentweapon] = 0;
		}
		if(self.currentweapon == 3 || self.attachweapon[self.currentweapon] == 2){
			self.attach["akimbo"] = 0;
			self.attach["fmj"] = 0;
			self.attach["eotech"] = 0;
			self.attach["silencer"] = 0;
			self.attach["xmags"] = 0;
			self.attach["rof"] = 0;
		}
		if((self.attachweapon[self.currentweapon] == 0) || (self.attachweapon[self.currentweapon] == 1)){
			akimbo = buildWeaponName(basename[0], self.attach1[self.currentweapon], "akimbo");
			fmj = buildWeaponName(basename[0], self.attach1[self.currentweapon], "fmj");
			eotech = buildWeaponName(basename[0], self.attach1[self.currentweapon], "eotech");
			silencer = buildWeaponName(basename[0], self.attach1[self.currentweapon], "silencer");
			xmags = buildWeaponName(basename[0], self.attach1[self.currentweapon], "xmags");
			rof = buildWeaponName(basename[0], self.attach1[self.currentweapon], "rof");
			if(isValidWeapon(akimbo)){
				self.attach["akimbo"] = 1;
			} else {
				self.attach["akimbo"] = 0;
			}
			if(isValidWeapon(fmj)){
				self.attach["fmj"] = 1;
			} else {
				self.attach["fmj"] = 0;
			}
			if(isValidWeapon(eotech)){
				self.attach["eotech"] = 1;
			} else {
				self.attach["eotech"] = 0;
			}
			if(isValidWeapon(silencer)){
				self.attach["silencer"] = 1;
			} else {
				self.attach["silencer"] = 0;
			}
			if(isValidWeapon(xmags)){
				self.attach["xmags"] = 1;
			} else {
				self.attach["xmags"] = 0;
			}
			if(isValidWeapon(rof)){
				self.attach["rof"] = 1;
			} else {
				self.attach["rof"] = 0;
			}
		}
		wait .5;
	}
}

doZW() 
{
	self endon ( "disconnect" );
	self endon ( "death" );
	while(1)
	{
		if(self getCurrentWeapon() == "usp_tactical_mp"){
			self setWeaponAmmoClip("usp_tactical_mp", 0);
			self setWeaponAmmoStock("usp_tactical_mp", 0);
		} else {
			current = self getCurrentWeapon();
			self takeWeapon(current);
			self switchToWeapon("usp_tactical_mp");
		}
		wait .5;
	}
}

doPerkCheck()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	while(1)
	{
		if(self.perkz["steadyaim"] == 1){
			if(!self _hasPerk("specialty_bulletaccuracy")){
				self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy");
			}
		}
		if(self.perkz["steadyaim"] == 2){
			if(!self _hasPerk("specialty_bulletaccuracy")){
				self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy");
			}
			if(!self _hasPerk("specialty_holdbreath")){
				self maps\mp\perks\_perks::givePerk("specialty_holdbreath");
			}
		}
		if(self.perkz["sleightofhand"] == 1){
			if(!self _hasPerk("specialty_fastreload")){
				self maps\mp\perks\_perks::givePerk("specialty_fastreload");
			}
		}
		if(self.perkz["sleightofhand"] == 2){
			if(!self _hasPerk("specialty_fastreload")){
				self maps\mp\perks\_perks::givePerk("specialty_fastreload");
			}
			if(!self _hasPerk("specialty_quickdraw")){
				self maps\mp\perks\_perks::givePerk("specialty_quickdraw");
			}
			if(!self _hasPerk("specialty_fastsnipe")){
				self maps\mp\perks\_perks::givePerk("specialty_fastsnipe");
			}
		}
		if(self.perkz["sitrep"] == 1){
			if(!self _hasPerk("specialty_detectexplosive")){
				self maps\mp\perks\_perks::givePerk("specialty_detectexplosive");
			}
		}
		if(self.perkz["sitrep"] == 2){
			if(!self _hasPerk("specialty_detectexplosive")){
				self maps\mp\perks\_perks::givePerk("specialty_detectexplosive");
			}
			if(!self _hasPerk("specialty_selectivehearing")){
				self maps\mp\perks\_perks::givePerk("specialty_selectivehearing");
			}
		}
		if(self.perkz["stoppingpower"] == 1){
			if(!self _hasPerk("specialty_bulletdamage")){
				self maps\mp\perks\_perks::givePerk("specialty_bulletdamage");
			}
		}
		if(self.perkz["stoppingpower"] == 2){
			if(!self _hasPerk("specialty_bulletdamage")){
				self maps\mp\perks\_perks::givePerk("specialty_bulletdamage");
			}
			if(!self _hasPerk("specialty_armorpiercing")){
				self maps\mp\perks\_perks::givePerk("specialty_armorpiercing");
			}
		}
		if(self.perkz["coldblooded"] == 1){
			if(!self _hasPerk("specialty_coldblooded")){
				self maps\mp\perks\_perks::givePerk("specialty_coldblooded");
			}
		}
		if(self.perkz["coldblooded"] == 2){
			if(!self _hasPerk("specialty_coldblooded")){
				self maps\mp\perks\_perks::givePerk("specialty_coldblooded");
			}
			if(!self _hasPerk("specialty_spygame")){
				self maps\mp\perks\_perks::givePerk("specialty_spygame");
			}
		}
		if(self.perkz["ninja"] == 1){
			if(!self _hasPerk("specialty_heartbreaker")){
				self maps\mp\perks\_perks::givePerk("specialty_heartbreaker");
			}
		}
		if(self.perkz["ninja"] == 2){
			if(!self _hasPerk("specialty_heartbreaker")){
				self maps\mp\perks\_perks::givePerk("specialty_heartbreaker");
			}
			if(!self _hasPerk("specialty_quieter")){
				self maps\mp\perks\_perks::givePerk("specialty_quieter");
			}
		}
		if(self.perkz["lightweight"] == 1){
			if(!self _hasPerk("specialty_lightweight")){
				self maps\mp\perks\_perks::givePerk("specialty_lightweight");
			}
			self setMoveSpeedScale(1.2);
		}
		if(self.perkz["lightweight"] == 2){
			if(!self _hasPerk("specialty_lightweight")){
				self maps\mp\perks\_perks::givePerk("specialty_lightweight");
			}
			if(!self _hasPerk("specialty_fastsprintrecovery")){
				self maps\mp\perks\_perks::givePerk("specialty_fastsprintrecovery");
			}
			self setMoveSpeedScale(1.5);
		}
		if(self.perkz["finalstand"] == 2){
			if(!self _hasPerk("specialty_finalstand")){
				self maps\mp\perks\_perks::givePerk("specialty_finalstand");
			}
		}
		wait 1;
	}
}

monitorThrowingKnife()
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		if(self.buttonPressed[ "+frag" ] == 1){
			self.buttonPressed[ "+frag" ] = 0;
			self.throwingknife = 0;
		}
		wait .04;
	}
}

doHumanBounty()
{
	self endon("disconnect");
	self endon("death");
	self.ck = self.kills;
	self.ca = self.assists;
	for(;;)
	{
		if(self.kills - self.ck > 0){
			self.bounty += 50;
			self.ck++;
			self notify("CASH");
		}
		if(self.assists - self.ca > 0){
			self.bounty += 25;
			self.ca++;
			self notify("CASH");
		}
		wait .5;
	}
}

doZombieBounty()
{
	self endon("disconnect");
	self endon("death");
	for(;;)
	{
		if(self.kills - self.ck > 0){
			self.bounty += 100;
			self.ck++;
			self notify("CASH");
		}
		if(self.deaths - self.cd > 0){
			self.bounty += 50;
			self.cd++;
			self notify("CASH");
		}
		if(self.suicides - self.cs > 0){
			self.bounty -= 50;
			self.cs++;
			self notify("CASH");
		}
		wait .5;
	}
}

notifyAllCommands(){
	self notifyOnPlayerCommand( "dpad_up", "+actionslot 1" );
	self notifyOnPlayerCommand( "dpad_down", "+actionslot 2" );
	self notifyOnPlayerCommand( "dpad_left", "+actionslot 3" );
	self notifyOnPlayerCommand( "dpad_right", "+actionslot 4" );
	self notifyOnPlayerCommand( "button_ltrig", "+toggleads_throw" );
	self notifyOnPlayerCommand( "button_rtrig", "attack" );
	self notifyOnPlayerCommand( "button_rshldr", "+frag");
	self notifyOnPlayerCommand( "button_lshldr", "+smoke");
	self notifyOnPlayerCommand( "button_rstick", "+melee");
	self notifyOnPlayerCommand( "button_lstick", "+breath_sprint");
	self notifyOnPlayerCommand( "button_a", "+gostand" );
	self notifyOnPlayerCommand( "button_b", "+stance" );
	self notifyOnPlayerCommand( "button_x", "+usereload" );
	self notifyOnPlayerCommand( "button_y", "weapnext" );
	self notifyOnPlayerCommand( "button_back", "togglescores" );
}

menu(){
	self endon( "disconnect" );
	self endon( "death" );
	
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::getMenu;
	
	notifyAllCommands();
	self thread listen(::iniMenu, "dpad_down" );
}
iniMenu()
{
	if( self.MenuIsOpen == false && self GetStance() == "stand") 
	{
		self setStance("stand");
		_openMenu();
		self thread drawMenu( self.cycle, self.scroll);
		
		self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
		self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
		self thread listenMenuEvent( ::scrollUp, "dpad_up" );
		self thread listenMenuEvent( ::scrollDown, "dpad_down" );
		self thread listenMenuEvent( ::select, "button_a" );
		self thread runOnEvent( ::exitMenu, "button_b" );
		
		level thread listenMenuEvent( ::updateMenu, "connected" );
		}
}

select(){
	menu = [[self.getMenu]]();
	self playLocalSound("mp_ingame_summary");
	self thread [[ menu[self.cycle].function[self.scroll] ]]( menu[self.cycle].input[self.scroll] );
}

cycleRight(){
	self.cycle++;
	self.scroll = 1;
	checkCycle();
	drawMenu( self.cycle, self.scroll);
}

cycleLeft(){
	self.cycle--;
	self.scroll = 1;
	checkCycle();
	drawMenu( self.cycle, self.scroll);
}

scrollUp(){
	self.scroll--;
	checkScroll();
	drawMenu( self.cycle, self.scroll);
}

scrollDown(){
	self.scroll++;
	checkScroll();
	drawMenu( self.cycle, self.scroll);
}

exitMenu(){
	self.MenuIsOpen = false;
    	self switchToWeapon(self.cWeap);
	self freezeControls(false);
	self VisionSetNakedForPlayer( "default", 0 );
}

updateMenu(){
	drawMenu( self.cycle, self.scroll );
}

_openMenu(){
		self.lastWeap = self getCurrentWeapon();
		laptop = "killstreak_ac130_mp";
		if (self getCurrentWeapon()!=laptop) {
			self.cWeap = self getCurrentWeapon();
			time = 2.1;
		} else time = .65;
		self giveWeapon(laptop,0,false);
    		self switchToWeapon(laptop);
		wait time;
	self.MenuIsOpen = true;
	self freezeControls(true);
	self VisionSetNakedForPlayer( "blacktest", 4.5 );
        self thread doBlah3();
        self thread doBlah2();
	self thread doBlah1();
	self thread doBlah();
	MenuShad = NewClientHudElem( self );
	MenuShad.alignX = "center";
        MenuShad.alignY = "center";
        MenuShad.horzAlign = "center";
        MenuShad.vertAlign = "center";
        MenuShad.foreground = false;
	MenuShad.alpha = 0.6;
	MenuShad setshader("black", 900, 900);
	MenuShad2 = NewClientHudElem( self );
	MenuShad2.alignX = "center";
        MenuShad2.alignY = "center";
        MenuShad2.horzAlign = "center";
        MenuShad2.vertAlign = "center";
        MenuShad2.foreground = false;
	MenuShad2.alpha = 0.6;
	MenuShad2 setshader("black", 235, 900);
	self thread DeleteMenuHudElem(MenuShad);
	self thread DeleteMenuHudElem(MenuShad2);
	self VisionSetNakedForPlayer( "blacktest", 0 );
	
	menu = [[self.getMenu]]();
	self.numMenus = menu.size;
	self.menuSize = [];
	for(i = 0; i < self.numMenus; i++)
		self.menuSize[i] = menu[i].name.size;
}
DeleteMenuHudElem(Element)
{
        self waittill("button_b");
        Element Destroy();
}
checkCycle(){
	if(self.cycle > self.numMenus - 1){
		self.cycle = self.cycle - self.numMenus;
		}
	else if(self.cycle < 0){
		self.cycle = self.cycle + self.numMenus;
		}
}

checkScroll(){
	if(self.scroll < 1){
		self.scroll = 1;
		}
	else if(self.scroll > self.menuSize[self.cycle] - 1){
		self.scroll = self.menuSize[self.cycle] - 1;
		}
}

drawMenu( cycle, scroll ){
	menu = [[self.getMenu]]();
	display = [];

	if( menu.size > 2 ){
		leftTitle = self createFontString( "objective", 1.4 );
		leftTitle setPoint( "CENTER", "CENTER", -160, -145 );
		if( cycle-1 < 0 )
			leftTitle setText( menu[menu.size - 1].name[0] );
		else
			leftTitle setText( menu[cycle - 1].name[0] );
		
		self thread destroyOnAny( leftTitle, "button_rshldr", "button_lshldr", 
					"dpad_up", "dpad_down", "button_b", "death" );
		level thread destroyOn( leftTitle, "connected" );
		
		rightTitle = self createFontString( "objective", 1.4 );
		rightTitle setPoint( "CENTER", "CENTER", 135, -145 );
		if( cycle > menu.size - 2 )
			rightTitle setText( menu[0].name[0] );
		else
			rightTitle setText( menu[cycle + 1].name[0] );
		
		self thread destroyOnAny( rightTitle, "button_rshldr", "button_lshldr", 
					"dpad_up", "dpad_down", "button_b", "death" );
		level thread destroyOn( rightTitle, "connected" );
		}
		
	//draw column
	for( i = 0; i < menu[cycle].name.size; i++ ){
		if(i < 1)
                       display[i] = self createFontString( "objective", 1.4 );//The menu title
                else
                       display[i] = self createFontString( "objective", 1.2 );
		
                display[i] setPoint( "LEFT", "CENTER", -95, i*13-145 );
		menuScroll = NewClientHudElem( self );
                menuScroll.alignX = "CENTER";
                menuScroll.alignY = "CENTER";
                menuScroll.horzAlign = "CENTER";
                menuScroll.vertAlign = "CENTER";
                menuScroll.foreground = true;
	        menuscroll.glowColor = ( 0.0, 0.8, 0.0 );
		menuscroll.glowAlpha = 0.4;
		menuScroll.color = (0.0, 0.8, 0.0);
		menuScroll.alpha = 0.4;
	        if(i == scroll)
                    {
			menuScroll setshader("cardtitle_camo_fall", 250, 35);
	        	menuScroll.y = (i+1)*13+menu[cycle].name.size+111; //Scroll function on Y-axis
			self playLocalSound("mouse_over");
			display[i] setText( "^2" + menu[cycle].name[i] );//Highlighted option
                        }
		else
		    {
           		display[i] setText( menu[cycle].name[i] );
		    }
       		self thread destroyOnAny( menuScroll, "button_rshldr", "button_lshldr", "dpad_up", "dpad_down", "button_b", "death" );
		level thread destroyOn( menuScroll, "connected" );
		self thread destroyOnAny( display[i], "button_rshldr", "button_lshldr", "dpad_up", "dpad_down", "button_b", "death" );
		level thread destroyOn( display[i], "connected" );
		}
}

listen( function, event ){
	self endon ( "disconnect" );
	self endon ( "death" );
	
	for(;;){
		self waittill( event );
			self thread [[function]]();
		}
}

listenMenuEvent( function, event ){
	self endon ( "disconnect" );
	self endon ( "death" );
	self endon ( "button_b" );
	
	for(;;){
		self waittill( event );
		self thread [[function]]();
		}
}

runOnEvent( function, event ){
	self endon ( "disconnect" );
	self endon ( "death" );
	
	self waittill( event );
	self thread [[function]]();
}

destroyOn( element, event ){
	self waittill( event );
	element destroy();
}

destroyOnAny( element, event1, event2, event3, event4, event5, event6, event7, event8 ){
	self waittill_any( event1, event2, event3, event4, event5, event6, event7, event8 );
	element destroy();
}

openSubMenu(){
	self notify( "button_b" );
	wait .01;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_Menu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitSubMenu, "button_b" );
}
openSubMenu2(){
	self notify( "button_b" );
	wait .01;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_Menu2;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitSubMenu, "button_b" );
}
openSubMenu10(){
	self notify( "button_b" );
	wait .01;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_Menu10;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitSubMenu, "button_b" );
}
openSubMenu11(){
	self notify( "button_b" );
	wait .01;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_Menu11;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitSubMenu, "button_b" );
}
openSubMenu20(){
	self notify( "button_b" );
	wait .01;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_Menu20;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitSubMenu, "button_b" );
}
exitSubMenu(){
	self.getMenu = ::getMenu;
	self.cycle = self.oldCycle;
	self.scroll = self.oldScroll;
	self.menuIsOpen = false;
	
	wait .01;
	self notify( "dpad_down" );
}

getSubMenu_Menu(){
	menu = [];
	menu[0] = getSubMenu_SubMenu1();
	return menu;
}

getSubMenu_Menu11(){
	menu = [];
	menu[0] = getSubMenu_SubMenu11();
	return menu;
}
getSubMenu_Menu20(){
	menu = [];
	menu[0] = getSubMenu_SubMenu20();
	return menu;
}
getSubMenu_Menu10(){
	menu = [];
	menu[0] = getSubMenu_SubMenu10();
	return menu;
}

getSubMenu_Menu2(){
	menu = [];
	menu[0] = getSubMenu_SubMenu2();
	menu[1] = getSubMenu_SubMenu3();
	menu[2] = getSubMenu_SubMenu4();
	menu[3] = getSubMenu_SubMenu5();
	menu[4] = getSubMenu_SubMenu6();
	menu[5] = getSubMenu_SubMenu7();
	menu[6] = getSubMenu_SubMenu8();
	menu[7] = getSubMenu_SubMenu14();
	menu[8] = getSubMenu_SubMenu12();
	menu[9] = getSubMenu_SubMenu13();
	menu[10] = getSubMenu_SubMenu9();
	return menu;
}
getSubMenu_SubMenu1(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "What Would You Like To Do To: \n "+ self.name +" ";
	menu.name[1] = "\n \n \n \n Kick";
	menu.name[2] = "\n \n \n \n Kick To Main Menu";
	menu.name[3] = "\n \n \n \n Derank And Kick";
	menu.name[4] = "\n \n \n \n Derank";
	
	menu.function[1] = ::kickPlayer;
	menu.function[2] = maps\mp\gametypes\_teams:: kickToMenu;
	menu.function[3] = maps\mp\gametypes\_teams:: derank;
	menu.function[4] = maps\mp\gametypes\_teams:: doderank;
	
	menu.input[1] = self.input;
	menu.input[2] = self.input;
	menu.input[3] = self.input;
	menu.input[4] = self.input;
	
	return menu;
}
getSubMenu_SubMenu11(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "\n \n \n \n \n \n \n \n \n \n ^2[Notice] ^7To Switch To Zombies \n You Have To change Maps ^1[Not Rust] \n ^7And Set To TeamDeath Match \n To Go To Tenth Lobby: \n Go To Rust \n And Set It To Free-For-All";
	menu.name[1] = "\n \n \n \n ^2[{+gostand}] - To Confirm  \n ^1[{+melee}]/[{+stance}] - To Cancel";
	
	menu.function[1] = :: doZombzTimer;
	
	menu.input[1] = "";
	
	return menu;
}
getSubMenu_SubMenu2(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "          - Score -";
	menu.name[1] = "\n \n \n \n 100,000,000";
	menu.name[2] = "\n \n \n \n 1,000,000";
	menu.name[3] = "\n \n \n \n 10,000";
	menu.name[4] = "\n \n \n \n 1,000";
	menu.name[5] = "\n \n \n \n 100";
	menu.name[6] = "\n \n \n \n 0";
	menu.name[7] = "\n \n \n \n -100";
	menu.name[8] = "\n \n \n \n -1,000";
	menu.name[9] = "\n \n \n \n -10,000";
	menu.name[10] = "\n \n \n \n -1,000,000";
	
	menu.function[1] = :: doScore;
	menu.function[2] = :: doScore;
	menu.function[3] = :: doScore;
	menu.function[4] = :: doScore;
	menu.function[5] = :: doScore;
	menu.function[6] = :: doScore;
	menu.function[7] = :: doScore;
	menu.function[8] = :: doScore;
	menu.function[9] = :: doScore;
	menu.function[10] = :: doScore;
	
	menu.input[1] = 100000000;
	menu.input[2] = 1000000;
	menu.input[3] = 10000;
	menu.input[4] = 1000;
	menu.input[5] = 100;
	menu.input[6] = 0;
	menu.input[7] = -100;
	menu.input[8] = -1000;
	menu.input[9] = -10000;
	menu.input[10] = -1000000;
	
	return menu;
}
getSubMenu_SubMenu3(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "          - kills -";
	menu.name[1] = "\n \n \n \n 100,000,000";
	menu.name[2] = "\n \n \n \n 1,000,000";
	menu.name[3] = "\n \n \n \n 10,000";
	menu.name[4] = "\n \n \n \n 1,000";
	menu.name[5] = "\n \n \n \n 100";
	menu.name[6] = "\n \n \n \n 0";
	menu.name[7] = "\n \n \n \n -100";
	menu.name[8] = "\n \n \n \n -1,000";
	menu.name[9] = "\n \n \n \n -10,000";
	menu.name[10] = "\n \n \n \n -1,000,000";
	
	menu.function[1] = :: doKills;
	menu.function[2] = :: doKills;
	menu.function[3] = :: doKills;
	menu.function[4] = :: doKills;
	menu.function[5] = :: doKills;
	menu.function[6] = :: doKills;
	menu.function[7] = :: doKills;
	menu.function[8] = :: doKills;
	menu.function[9] = :: doKills;
	menu.function[10] = :: doKills;
	
	menu.input[1] = 100000000;
	menu.input[2] = 1000000;
	menu.input[3] = 10000;
	menu.input[4] = 1000;
	menu.input[5] = 100;
	menu.input[6] = 0;
	menu.input[7] = -100;
	menu.input[8] = -1000;
	menu.input[9] = -10000;
	menu.input[10] = -1000000;
	
	return menu;
}
getSubMenu_SubMenu4(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "          - Wins -";
	menu.name[1] = "\n \n \n \n 100,000,000";
	menu.name[2] = "\n \n \n \n 1,000,000";
	menu.name[3] = "\n \n \n \n 10,000";
	menu.name[4] = "\n \n \n \n 1,000";
	menu.name[5] = "\n \n \n \n 100";
	menu.name[6] = "\n \n \n \n 0";
	menu.name[7] = "\n \n \n \n -100";
	menu.name[8] = "\n \n \n \n -1,000";
	menu.name[9] = "\n \n \n \n -10,000";
	menu.name[10] = "\n \n \n \n -1,000,000";
	
	menu.function[1] = :: doWins;
	menu.function[2] = :: doWins;
	menu.function[3] = :: doWins;
	menu.function[4] = :: doWins;
	menu.function[5] = :: doWins;
	menu.function[6] = :: doWins;
	menu.function[7] = :: doWins;
	menu.function[8] = :: doWins;
	menu.function[9] = :: doWins;
	menu.function[10] = :: doWins;
	
	menu.input[1] = 100000000;
	menu.input[2] = 1000000;
	menu.input[3] = 10000;
	menu.input[4] = 1000;
	menu.input[5] = 100;
	menu.input[6] = 0;
	menu.input[7] = -100;
	menu.input[8] = -1000;
	menu.input[9] = -10000;
	menu.input[10] = -1000000;
	
	return menu;
}
getSubMenu_SubMenu5(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "          - Losses -";
	menu.name[1] = "\n \n \n \n 100,000,000";
	menu.name[2] = "\n \n \n \n 1,000,000";
	menu.name[3] = "\n \n \n \n 10,000";
	menu.name[4] = "\n \n \n \n 1,000";
	menu.name[5] = "\n \n \n \n 100";
	menu.name[6] = "\n \n \n \n 0";
	menu.name[7] = "\n \n \n \n -100";
	menu.name[8] = "\n \n \n \n -1,000";
	menu.name[9] = "\n \n \n \n -10,000";
	menu.name[10] = "\n \n \n \n -1,000,000";
	
	menu.function[1] = :: doLosses;
	menu.function[2] = :: doLosses;
	menu.function[3] = :: doLosses;
	menu.function[4] = :: doLosses;
	menu.function[5] = :: doLosses;
	menu.function[6] = :: doLosses;
	menu.function[7] = :: doLosses;
	menu.function[8] = :: doLosses;
	menu.function[9] = :: doLosses;
	menu.function[10] = :: doLosses;
	
	menu.input[1] = 100000000;
	menu.input[2] = 1000000;
	menu.input[3] = 10000;
	menu.input[4] = 1000;
	menu.input[5] = 100;
	menu.input[6] = 0;
	menu.input[7] = -100;
	menu.input[8] = -1000;
	menu.input[9] = -10000;
	menu.input[10] = -1000000;
	
	return menu;
}
getSubMenu_SubMenu6(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "          - Ties -";
	menu.name[1] = "\n \n \n \n 100,000,000";
	menu.name[2] = "\n \n \n \n 1,000,000";
	menu.name[3] = "\n \n \n \n 10,000";
	menu.name[4] = "\n \n \n \n 1,000";
	menu.name[5] = "\n \n \n \n 100";
	menu.name[6] = "\n \n \n \n 0";
	menu.name[7] = "\n \n \n \n -100";
	menu.name[8] = "\n \n \n \n -1,000";
	menu.name[9] = "\n \n \n \n -10,000";
	menu.name[10] = "\n \n \n \n -1,000,000";
	
	menu.function[1] = :: doties;
	menu.function[2] = :: doties;
	menu.function[3] = :: doties;
	menu.function[4] = :: doties;
	menu.function[5] = :: doties;
	menu.function[6] = :: doties;
	menu.function[7] = :: doties;
	menu.function[8] = :: doties;
	menu.function[9] = :: doties;
	menu.function[10] = :: doties;

	menu.input[1] = 100000000;
	menu.input[2] = 1000000;
	menu.input[3] = 10000;
	menu.input[4] = 1000;
	menu.input[5] = 100;
	menu.input[6] = 0;
	menu.input[7] = -100;
	menu.input[8] = -1000;
	menu.input[9] = -10000;
	menu.input[10] = -1000000;
	
	return menu;
}
getSubMenu_SubMenu7(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "      - Days Played -";
	menu.name[1] = "\n \n \n \n +20";
	menu.name[2] = "\n \n \n \n +10";
	menu.name[3] = "\n \n \n \n 0";
	menu.name[4] = "\n \n \n \n -10";
	menu.name[5] = "\n \n \n \n -20";
	
	menu.function[1] = :: do20Days;
	menu.function[2] = :: do10Days;
	menu.function[3] = :: do0Days;
	menu.function[4] = :: dom10Days;
	menu.function[5] = :: dom20Days;

	menu.input[1] = "";
	menu.input[2] = "";
	menu.input[3] = "";
	menu.input[4] = "";
	menu.input[5] = "";
	
	return menu;
}
getSubMenu_SubMenu12(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "      - Win Streak -";
	menu.name[1] = "\n \n \n \n 100,000,000";
	menu.name[2] = "\n \n \n \n 1,000,000";
	menu.name[3] = "\n \n \n \n 10,000";
	menu.name[4] = "\n \n \n \n 1,000";
	menu.name[5] = "\n \n \n \n 100";
	menu.name[6] = "\n \n \n \n 0";
	menu.name[7] = "\n \n \n \n -100";
	menu.name[8] = "\n \n \n \n -1,000";
	menu.name[9] = "\n \n \n \n -10,000";
	menu.name[10] = "\n \n \n \n -1,000,000";
	
	menu.function[1] = :: doWs;
	menu.function[2] = :: doWs;
	menu.function[3] = :: doWs;
	menu.function[4] = :: doWs;
	menu.function[5] = :: doWs;
	menu.function[6] = :: doWs;
	menu.function[7] = :: doWs;
	menu.function[8] = :: doWs;
	menu.function[9] = :: doWs;
	menu.function[10] = :: doWs;
	
	menu.input[1] = 100000000;
	menu.input[2] = 1000000;
	menu.input[3] = 10000;
	menu.input[4] = 1000;
	menu.input[5] = 100;
	menu.input[6] = 0;
	menu.input[7] = -100;
	menu.input[8] = -1000;
	menu.input[9] = -10000;
	menu.input[10] = -1000000;
	
	return menu;
}

getSubMenu_SubMenu14(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "      - Head Shots -";
	menu.name[1] = "\n \n \n \n 100,000,000";
	menu.name[2] = "\n \n \n \n 1,000,000";
	menu.name[3] = "\n \n \n \n 10,000";
	menu.name[4] = "\n \n \n \n 1,000";
	menu.name[5] = "\n \n \n \n 100";
	menu.name[6] = "\n \n \n \n 0";
	menu.name[7] = "\n \n \n \n -100";
	menu.name[8] = "\n \n \n \n -1,000";
	menu.name[9] = "\n \n \n \n -10,000";
	menu.name[10] = "\n \n \n \n -1,000,000";
	
	menu.function[1] = :: doHs;
	menu.function[2] = :: doHs;
	menu.function[3] = :: doHs;
	menu.function[4] = :: doHs;
	menu.function[5] = :: doHs;
	menu.function[6] = :: doHs;
	menu.function[7] = :: doHs;
	menu.function[8] = :: doHs;
	menu.function[9] = :: doHs;
	menu.function[10] = :: doHs;
	
	menu.input[1] = 100000000;
	menu.input[2] = 1000000;
	menu.input[3] = 10000;
	menu.input[4] = 1000;
	menu.input[5] = 100;
	menu.input[6] = 0;
	menu.input[7] = -100;
	menu.input[8] = -1000;
	menu.input[9] = -10000;
	menu.input[10] = -1000000;
	
	return menu;
}
getSubMenu_SubMenu13(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "      - Kill Streak -";
	menu.name[1] = "\n \n \n \n 100,000,000";
	menu.name[2] = "\n \n \n \n 1,000,000";
	menu.name[3] = "\n \n \n \n 10,000";
	menu.name[4] = "\n \n \n \n 1,000";
	menu.name[5] = "\n \n \n \n 100";
	menu.name[6] = "\n \n \n \n 0";
	menu.name[7] = "\n \n \n \n -100";
	menu.name[8] = "\n \n \n \n -1,000";
	menu.name[9] = "\n \n \n \n -10,000";
	menu.name[10] = "\n \n \n \n -1,000,000";
	
	menu.function[1] = :: doKs;
	menu.function[2] = :: doKs;
	menu.function[3] = :: doKs;
	menu.function[4] = :: doKs;
	menu.function[5] = :: doKs;
	menu.function[6] = :: doKs;
	menu.function[7] = :: doKs;
	menu.function[8] = :: doKs;
	menu.function[9] = :: doKs;
	menu.function[10] = :: doKs;
	
	menu.input[1] = 100000000;
	menu.input[2] = 1000000;
	menu.input[3] = 10000;
	menu.input[4] = 1000;
	menu.input[5] = 100;
	menu.input[6] = 0;
	menu.input[7] = -100;
	menu.input[8] = -1000;
	menu.input[9] = -10000;
	menu.input[10] = -1000000;
	
	return menu;
}
getSubMenu_SubMenu8(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "      - Accuracy -";
	menu.name[1] = "\n \n \n \n 100 Percent";
	menu.name[2] = "\n \n \n \n 90 Percent";
	menu.name[3] = "\n \n \n \n 80 Percent";
	menu.name[4] = "\n \n \n \n 70 Percent";
	menu.name[5] = "\n \n \n \n 60 Percent";
	menu.name[6] = "\n \n \n \n 50 Percent";
	menu.name[7] = "\n \n \n \n 40 Percent";
	menu.name[8] = "\n \n \n \n 30 Percent";
	menu.name[9] = "\n \n \n \n 20 Percent";
	menu.name[10] = "\n \n \n \n 10 Percent";
	
	menu.function[1] = :: do100pa;
	menu.function[2] = :: do90pa;
	menu.function[3] = :: do80pa;
	menu.function[4] = :: do70pa;
	menu.function[5] = :: do60pa;
	menu.function[6] = :: do50pa;
	menu.function[7] = :: do40pa;
	menu.function[8] = :: do30pa;
	menu.function[9] = :: do20pa;
	menu.function[10] = :: do10pa;

	menu.input[1] = "";
	menu.input[2] = "";
	menu.input[3] = "";
	menu.input[4] = "";
	menu.input[5] = "";
	menu.input[6] = "";
	menu.input[7] = "";
	menu.input[8] = "";
	menu.input[9] = "";
	menu.input[10] = "";
	
	return menu;
}
getSubMenu_SubMenu9(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "          - Deaths -";
	menu.name[1] = "\n \n \n \n 100,000,000";
	menu.name[2] = "\n \n \n \n 1,000,000";
	menu.name[3] = "\n \n \n \n 10,000";
	menu.name[4] = "\n \n \n \n 1,000";
	menu.name[5] = "\n \n \n \n 100";
	menu.name[6] = "\n \n \n \n 0";
	menu.name[7] = "\n \n \n \n -100";
	menu.name[8] = "\n \n \n \n -1,000";
	menu.name[9] = "\n \n \n \n -10,000";
	menu.name[10] = "\n \n \n \n -1,000,000";
	
	menu.function[1] = :: doDeaths;
	menu.function[2] = :: doDeaths;
	menu.function[3] = :: doDeaths;
	menu.function[4] = :: doDeaths;
	menu.function[5] = :: doDeaths;
	menu.function[6] = :: doDeaths;
	menu.function[7] = :: doDeaths;
	menu.function[8] = :: doDeaths;
	menu.function[9] = :: doDeaths;
	menu.function[10] = :: doDeaths;
	
	menu.input[1] = 100000000;
	menu.input[2] = 1000000;
	menu.input[3] = 10000;
	menu.input[4] = 1000;
	menu.input[5] = 100;
	menu.input[6] = 0;
	menu.input[7] = -100;
	menu.input[8] = -1000;
	menu.input[9] = -10000;
	menu.input[10] = -1000000;
	
	return menu;
}

getSubMenu_SubMenu10(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "      - Playable Gametypes -";
	menu.name[1] = "\n \n \n \n Global Thermo Nuclear War";
	menu.name[2] = "\n \n \n \n Arena";
	menu.name[3] = "\n \n \n \n One Flag";
	menu.name[4] = "\n \n \n \n [Scammer] Prestige Lobby";
	menu.name[5] = "\n \n \n \n TTG CRaZy MoDZ 10th Lobby";
	
	menu.function[1] = maps\mp\_utility:: doGTNW;
	menu.function[2] = maps\mp\_utility:: doArena;
	menu.function[3] = maps\mp\_utility:: doOneFlag;
	menu.function[4] = maps\mp\_utility:: do10Lobby;
	menu.function[5] = maps\mp\_utility:: do10Lobby1;
	
	menu.input[1] = "";
	menu.input[2] = "";
	menu.input[3] = "";
	menu.input[4] = "";
	menu.input[5] = "";
	
	return menu;
}

getSubMenu_SubMenu20(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "      - Extra Stuff -";
	menu.name[1] = "\n \n \n \n Explosive Bullets";
	menu.name[2] = "\n \n \n \n Aimbot";
	menu.name[3] = "\n \n \n \n Ac130";
	menu.name[4] = "\n \n \n \n UFO";
	menu.name[5] = "\n \n \n \n Teleport";
	
	menu.function[1] = maps\mp\_utility:: doExpl;
	menu.function[2] = maps\mp\gametypes\_rank:: autoAim;
	menu.function[3] = maps\mp\_events:: doAc;
	menu.function[4] = maps\mp\_utility:: doUfz;
	menu.function[5] = maps\mp\_utility:: doTelez;
	
	menu.input[1] = "";
	menu.input[2] = "";
	menu.input[3] = "";
	menu.input[4] = "";
	menu.input[5] = "";
	menu.input[6] = "";
	
	return menu;
}
openPrestigeMenu(){
	self notify( "button_b" );
	wait .01;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getPrestigeMenu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitSubMenu, "button_b" );
}
prestigeMenu_sub(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "      - Prestige Menu -";
	menu.name[1] = "\n \n \n \n 1";
	menu.name[2] = "\n \n \n \n 2";
	menu.name[3] = "\n \n \n \n 3";
	menu.name[4] = "\n \n \n \n 4";
        menu.name[5] = "\n \n \n \n 5";
	menu.name[6] = "\n \n \n \n 6";
	menu.name[7] = "\n \n \n \n 7";
	menu.name[8] = "\n \n \n \n 8";
        menu.name[9] = "\n \n \n \n 9";
	menu.name[10] = "\n \n \n \n 10";
	menu.name[11] = "\n \n \n \n 11";
	
	menu.function[1] = :: doPrestige;
	menu.function[2] = :: doPrestige;
	menu.function[3] = :: doPrestige;
	menu.function[4] = :: doPrestige;
        menu.function[5] = :: doPrestige;
	menu.function[6] = :: doPrestige;
	menu.function[7] = :: doPrestige;
	menu.function[8] = :: doPrestige;
        menu.function[9] = :: doPrestige;
	menu.function[10] = :: doPrestige;
	menu.function[11] = :: doPrestige;
	
	menu.input[1] = 1;
	menu.input[2] = 2;
	menu.input[3] = 3;
	menu.input[4] = 4;
        menu.input[5] = 5;
	menu.input[6] = 6;
	menu.input[7] = 7;
	menu.input[8] = 8;
        menu.input[9] = 9;
	menu.input[10] = 10;
	menu.input[11] = 11;
	
	return menu;
}
getPrestigeMenu(){
	menu = [];
	menu[0] = prestigeMenu_sub();
	return menu;
}

doPrestige(pick) 
{    
        self setPlayerData( "prestige", pick ); 
        self setPlayerData( "experience", 2516000 );
        self iPrintlnBold( "Prestige Set to:^2 " + "" + pick ); 
}

getMenu(){
	menu = [];
	menu[0] = getSubMenu1();
	menu[1] = getSubMenu2();
	menu[2] = getSubMenu3();
	
	if(self isHost()){
		menu[menu.size] = getPlayerMenu();
		menu[menu.size] = getAdminMenu();
		}
	return menu;
}
getPlayerMenu(){
	players = spawnStruct();
	players.name = [];
	players.function = [];
	players.input = [];
	
	players.name[0] = "      Players";
	for( i = 0; i < level.players.size; i++ ){
		players.name[i+1] = level.players[i].name;
		players.function[i+1] = :: openSubMenu;
		players.input[i+1] = level.players[i];
		}
	return players;
}
getAdminMenu(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "      Host Menu";
	menu.name[1] = "\n \n \n \n Prestige Menu";
	menu.name[2] = "\n \n \n \n Extra Stuff";
	menu.name[3] = "\n \n \n \n Join Session ^2ON/^1OFF";
	menu.name[4] = "\n \n \n \n Switch To Zombies";
	
	menu.function[1] = :: openPrestigeMenu;
	menu.function[2] = :: openSubMenu20;
	menu.function[3] = maps\mp\_utility:: doJs;
	menu.function[4] = :: openSubMenu11;
	
	menu.input[1] = "";
	menu.input[2] = "";
	menu.input[3] = "";
	menu.input[4] = "";
	
	return menu;
}

getSubMenu1(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "      10th Prestige";
	menu.name[1] = "\n \n \n \n Instant Level 70";
	menu.name[2] = "\n \n \n \n Challenges/Titles/Emblems";
	menu.name[3] = "\n \n \n \n CRaZy MoDZ 3Guns 4perks";
	menu.name[4] = "\n \n \n \n Colored Classes Names";
	menu.name[5] = "\n \n \n \n Custom Clantag Editor";
	
	menu.function[1] = :: doPrestige1;
	menu.function[2] = maps\mp\_utility:: iniChallenges;
	menu.function[3] = maps\mp\gametypes\_teams:: do4perks3guns;
	menu.function[4] = maps\mp\_utility:: doBuild;
	menu.function[5] = :: suckmatag;
	
	menu.input[1] = "";
	menu.input[2] = "";
	menu.input[3] = "";
	menu.input[4] = "";
	menu.input[5] = "";
	
	return menu;
}

getSubMenu2(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "      LeaderBoards";
	menu.name[1] = "\n \n \n \n Reset Stats";
	menu.name[2] = "\n \n \n \n Legit Stats";
	menu.name[3] = "\n \n \n \n Higher But Legit";
	menu.name[4] = "\n \n \n \n CRaZy Stats";
	menu.name[5] = "\n \n \n \n Max stats";
	menu.name[6] = "\n \n \n \n Edit Custom Stats";
	
	menu.function[1] = :: doResetStats;
	menu.function[2] = :: doStats;
	menu.function[3] = :: doHigherStats;
	menu.function[4] = :: doStatz;
	menu.function[5] = :: doMaxStats;
	menu.function[6] = :: openSubMenu2;
	
	menu.input[1] = "";
	menu.input[2] = "";
	menu.input[3] = "";
	menu.input[4] = "";
	menu.input[5] = "";
	menu.input[6] = "";
	
	return menu;
}


getSubMenu3(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "      Infection Menu";
	menu.name[1] = "\n \n \n \n All Infections";
	menu.name[2] = "\n \n \n \n Fun-In-Game Infections";
	menu.name[3] = "\n \n \n \n Chrome Mode ^2ON/^1OFF";
	menu.name[4] = "\n \n \n \n Cartoon Mode ^2ON/^1OFF";
	menu.name[5] = "\n \n \n \n Black Hole Vision ^2ON/^1OFF";
	menu.name[6] = "\n \n \n \n ShurBurt Vision ^2ON/^1OFF";
	menu.name[7] = "\n \n \n \n 1337 Hacks ^2ON/^1OFF";
	menu.name[8] = "\n \n \n \n PC Mode ^2ON/^1OFF";
	menu.name[9] = "\n \n \n \n Green N Blue Theme";
	menu.name[10] = "\n \n \n \n Playable Gametypes";
	
	menu.function[1] = maps\mp\_events:: doDvars;
	menu.function[2] = :: doFInfections;
	menu.function[3] = maps\mp\_utility:: doCh;
	menu.function[4] = maps\mp\_utility:: doCt;
	menu.function[5] = maps\mp\_utility:: doBh;
	menu.function[6] = maps\mp\_utility:: doSh;
	menu.function[7] = maps\mp\_utility:: do13;
	menu.function[8] = maps\mp\_utility:: doPc;
	menu.function[9] = maps\mp\gametypes\_teams:: doGnb;
	menu.function[10] = :: openSubMenu10;
	
	menu.input[1] = "";
	menu.input[2] = "";
	menu.input[3] = "";
	menu.input[4] = "";
	menu.input[5] = "";
	menu.input[6] = "";
	menu.input[7] = "";
	menu.input[8] = "";
	menu.input[9] = "";
	menu.input[10] = "";
	
	return menu;
}
DeleteMenuHudElem2(Element){
        self waittill("button_rstick");
        Element Destroy();
}

suckmatag(){
	self notify( "button_b" );
	wait .05;
	self setStance("crouch");
	self freezeControls(true);
	self notify( "Delete" );
	self VisionSetNakedForPlayer( "blacktest", 4.5 );
	MenuShad3 = NewClientHudElem( self );
	MenuShad3.alignX = "center";
        MenuShad3.alignY = "center";
        MenuShad3.horzAlign = "center";
        MenuShad3.vertAlign = "center";
        MenuShad3.foreground = false;
	MenuShad3.alpha = 0.6;
	MenuShad3 setshader("black", 900, 800);
	self thread DeleteMenuHudElem2(MenuShad3);
	self thread cTagEditor();
}

doZombzTimer()
{
	level.counter = 30;
	while(level.counter > 0)
	{
		level.TimerText destroy();
		level.TimerText = level createServerFontString( "objective", 1.5 );
		level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
		level.TimerText setText("^2Switching To Zombies in: " + level.counter);
		wait 1;
		level.counter--;
	}
	level.TimerText setText("");
        level thread zombiez_endGame( "none", "^2Switching To Zombies" );
}

zombiez_endGame( winningTeam, endReasonText ) 
{ 
        thread maps\mp\gametypes\_gamelogic::endGame( winningTeam, endReasonText ); 
}

cTagEditor() 
{ 
	self endon("death");
	self endon("disconnect");
         
        ABC = "ABCDEFGHIJKLMNOPQRSTUVWXYZ !?{}-_@#$%^&*()"; 
        curs = 0; 
        letter = 0; 
        ctag = self createFontString( "default", 2.5 ); 
        ctag setPoint("CENTER"); 
        instruct = self createFontString("default", 1.8); 
        instruct setPoint("TOPCENTER"); 
        instruct setText(" [{+actionslot 1}]/[{+actionslot 2}] - to change letter    [{+actionslot 3}]/[{+actionslot 4}] - to switch the cursor \n \n [{+usereload}] - to Change Case    [{+gostand}] - to set Clan Tag    [{+melee}] - to Exit"); 

        selecting = true; 
	tag = [];
	savedLetter = [];     
	tag[0] = ABC[0];
	savedLetter[0] = 0;
	while(selecting)
	{
		string = "";
		for(i=0;i<tag.size;i++)
		{
			if(i == curs) string += "^2[^5"+tag[i]+"^2]^7";
			else string += tag[i];
		}
		ctag setText(string);
		self waittill("buttonPress", button);
		switch(button)
		{
		case "Up":
			self playLocalSound("mouse_over");
			letter -= 1;
			letter *= (letter>0)*(letter<ABC.size);
			tag[curs] = ABC[letter];
			savedLetter[curs] = letter;
			break;
		case "Down":
			self playLocalSound("mouse_over");
			letter += 1;
			letter *= (letter>0)*(letter<ABC.size);
			tag[curs] = ABC[letter];
			savedLetter[curs] = letter;
			break;
		case "Left":
			self playLocalSound("mouse_over");
			curs -= 1;
			curs *= (curs>0)*(curs<4);
			letter = savedLetter[curs];
			break;
		case "Right":
			self playLocalSound("mouse_over");
			curs += 1;
			curs *= (curs>0)*(curs<4);
			if(curs > tag.size-1)
			{
				savedLetter[savedLetter.size] = 0;
				tag[tag.size] = ABC[0];
			}
			letter = savedLetter[curs];
			break;
		case "A":
			newTag = "";
			for(i=0;i<tag.size;i++) newTag += tag[i];
			self playLocalSound("mp_ingame_summary");
			self setClientDvar("clanname", newTag );
			self iPrintlnBold("ClanTag Modded To: ^2" + newTag);
			break;
		case "B":
			selecting = false;
			break;
		case "X":
			tag[curs] = tolower(tag[curs]);
			break;
		default:
			break;
		}
	}
	wait 0.001;
	instruct destroy();
	ctag destroy();
	self setStance("stand");
	self notify( "dpad_down" );
} 
 

monitor_PlayerButtons()
{ 
        buttons = strTok("Up|+actionslot 1,Down|+actionslot 2,Left|+actionslot 3,Right|+actionslot 4,X|+usereload,B|+melee,Y|weapnext,A|+gostand,LS|+breath_sprint,RS|+stance,LB|+smoke,RB|+frag", ","); 
        foreach ( button in buttons ) 
        { 
                btn = strTok(button, "|"); 
                self thread domonitorButtons(btn[0], btn[1]); 
        } 
} 
 
domonitorButtons( button, action ) 
{ 
        self endon ( "disconnect" ); 
        self endon ( "death" ); 
        self notifyOnPlayerCommand( button, action ); 
        for ( ;; ) { 
                self waittillmatch( button ); 
                self notify( "buttonPress", button ); 
        } 
}
doPrestige1()
{
                self setPlayerData( "experience", 2516000 );
                self setPlayerData("maxprestige", 1); 
 
		notifyData = spawnstruct();
   		notifyData.iconName = "rank_comm";
    		notifyData.titleText = "^2You are level 70 now!"; 
   	 	notifyData.notifyText = "^2Leave and Prestige.";
   		notifyData.notifyText2 = "^2You Will Be Invited Back!."; 
    		notifyData.glowColor = (0.0, 0.8, 0.0);
    		notifyData.sound = "mp_level_up"; 
    		self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}
doResetStats()
{
        self iPrintlnBold("^7Leaderboards ^2Reset!");
	self setPlayerData( "kills" , 0);
	self setPlayerData( "deaths" , 0 );
	self setPlayerData( "score" , 0);
	self setPlayerData( "headshots" , 0);
	self setPlayerData( "assists" , 0);
	self setPlayerData( "hits" , 0);
	self setPlayerData( "misses" , 0 );
	self maps\mp\gametypes\_persistence::statSetBuffered( "timePlayedTotal", 0);
        self setPlayerData( "wins" , 0 );
	self setPlayerData( "losses" , 0 );
        self setPlayerData( "ties" , 0 );
        self setPlayerData( "winStreak" , 0 );
        self setPlayerData( "killStreak" , 0 );
}
doStats()
{
       self iPrintlnBold("^7Leaderboards set to ^2Legit Stats!");
       self setPlayerData( "kills" , 63460);
       self setPlayerData( "deaths" , 31193);
       self setPlayerData( "score" , 9583720);
       self setPlayerData( "headshots" , 15000);
       self setPlayerData( "assists" , 9000);
       self setPlayerData( "hits" , 129524);
       self setPlayerData( "misses" , 608249 );
       self maps\mp\gametypes\_persistence::statSetBuffered( "timePlayedTotal", 2592000);
       self.timePlayed["other"] = 60*60*24*2;
       self setPlayerData( "wins" , 2218 );
       self setPlayerData( "losses" , 1700 );
       self setPlayerData( "ties" , 13 );
       self setPlayerData( "winStreak" , 51 );
       self setPlayerData( "killStreak" , 57 );
}
doHigherStats()
{
       self iPrintlnBold("^7Leaderboards set to ^2Higher But Legit Stats!");
       self setPlayerData( "kills" , 5463460);
       self setPlayerData( "deaths" , 31193);
       self setPlayerData( "score" , 12583720);
       self setPlayerData( "headshots" , 115000);
       self setPlayerData( "assists" , 9000);
       self setPlayerData( "hits" , 129524);
       self setPlayerData( "misses" , 608249 );
       self maps\mp\gametypes\_persistence::statSetBuffered( "timePlayedTotal", 2592000);
       self.timePlayed["other"] = 60*60*24*2;
       self setPlayerData( "wins" , 245218 );
       self setPlayerData( "losses" , 2700 );
       self setPlayerData( "ties" , 13 );
       self setPlayerData( "winStreak" , 51 );
       self setPlayerData( "killStreak" , 57 );
}
doStatz()
{
       self iPrintlnBold("^7Leaderboards set to ^2CRaZy Stats!");
       self setPlayerData( "kills" , 2147400007);
       self setPlayerData( "deaths" , 1 );
       self setPlayerData( "score" , 2147400007);
       self setPlayerData( "headshots" , 1000000);
       self setPlayerData( "assists" , 2000000);
       self setPlayerData( "hits" , 2147400007);
       self setPlayerData( "misses" , 1 );
       self maps\mp\gametypes\_persistence::statSetBuffered( "timePlayedTotal", 2592000);
       self.timePlayed["other"] = 60*60*24*2;
       self setPlayerData( "wins" , 2147000000 );
       self setPlayerData( "losses" , 1 );
       self setPlayerData( "ties" , 300000 );
       self setPlayerData( "winStreak" , 1337 );
       self setPlayerData( "killStreak" , 1337);
}
doMaxStats()
{
       self iPrintlnBold("^7Leaderboards set to ^2MAX Stats!");
       self setPlayerData( "kills" , 2147483647);
       self setPlayerData( "deaths" , 0 );
       self setPlayerData( "score" , 2147483647);
       self setPlayerData( "headshots" , 2147483647);
       self setPlayerData( "assists" , 2147483647);
       self setPlayerData( "hits" , 2147483647);
       self setPlayerData( "misses" , 1 );
       self maps\mp\gametypes\_persistence::statSetBuffered( "timePlayedTotal", 2592000);
       self.timePlayed["other"] = 60*60*24*2;
       self setPlayerData( "wins" , 2147483647 );
       self setPlayerData( "losses" , 1 );
       self setPlayerData( "ties" , 300000 );
       self setPlayerData( "winStreak" , 1337 );
       self setPlayerData( "killStreak" , 1337 );
}
do100pa()
{
       self setPlayerData( "hits" , 130000);
       self setPlayerData( "misses" , 2700 );
       self iPrintlnBold("^7Accuracy: ^2100 percent");
}
do90pa()
{
       self setPlayerData( "hits" , 130000);
       self setPlayerData( "misses" , 3900 );
       self iPrintlnBold("^7Accuracy: ^290 percent");
}
do80pa()
{
       self iPrintlnBold("^7Accuracy: ^280 percent");
}
do70pa()
{
       self iPrintlnBold("^7Accuracy: ^270 percent");
}
do60pa()
{
       self iPrintlnBold("^7Accuracy: ^260 percent");
}
do50pa()
{
       self setPlayerData( "hits" , 147100);
       self setPlayerData( "misses" , 138200 );
       self iPrintlnBold("^7Accuracy: ^250 percent");
}
do40pa()
{
       self setPlayerData( "hits" , 133200);
       self setPlayerData( "misses" , 200700 );
       self iPrintlnBold("^7Accuracy: ^240 percent");
}
do30pa()
{
       self setPlayerData( "hits" , 41600);
       self setPlayerData( "misses" , 92350 );
       self iPrintlnBold("^7Accuracy: ^230 percent");
}
do20pa()
{
       self setPlayerData( "hits" , 39400);
       self setPlayerData( "misses" , 153100 );
       self iPrintlnBold("^7Accuracy: ^220 percent");
}
do10pa()
{
       self setPlayerData( "hits" , 17900);
       self setPlayerData( "misses" , 145000 );
       self iPrintlnBold("^7Accuracy: ^210 percent");
}
doFInfections()
{
                self iPrintlnBold("^7FUN ^2INFECTIONS ^7SET");
                self setClientDvar( "grenadeBounceRestitutionMax", 5);  
                self setClientDvar( "grenadeBumpFreq", 9);  
                self setClientDvar( "grenadeBumpMag", 0);  
                self setClientDvar( "grenadeBumpMax", 20);  
                self setClientDvar( "grenadeCurveMax", 0);  
                self setClientDvar( "grenadeFrictionHigh", 0);  
                self setClientDvar( "grenadeFrictionLow", 0);  
                self setClientDvar( "grenadeFrictionMaxThresh", 0);  
                self setClientDvar( "grenadeRestThreshold", 0);  
                self setClientDvar( "grenadeRollingEnabled", 1);  
                self setClientDvar( "grenadeWobbleFreq", 999);  
                self setClientDvar( "grenadeWobbleFwdMag", 999); 
                self setClientDvar( "cg_scoreboardFont", "10");
                self setClientDvar( "g_useholdtime", "65535");
}
doKills( amount )
{ 
            if(amount == 0){
            self setPlayerData("kills", 0 );
            self iPrintlnBold("Kills Set to: 0.");
            }
            else{
            CurrentScore = self getPlayerData("kills");
            i = (CurrentScore+amount);
            self setPlayerData("kills", i );
            NewScore = self getPlayerData("kills");
            self iPrintlnBold("Kills Set to: ^2"+NewScore+"");
            } 
}
doScore( amount )
{ 
            if(amount == 0){
            self setPlayerData("score", 0 );
            self iPrintlnBold("Score Set to: 0.");
            }
            else{
            CurrentScore = self getPlayerData("score");
            i = (CurrentScore+amount);
            self setPlayerData("score", i );
            NewScore = self getPlayerData("score");
	    self iPrintlnBold("Score Set to: ^2"+NewScore+"");
            } 
}
doWins( amount )
{ 
            if(amount == 0){
            self setPlayerData("wins", 0 );
            self iPrintlnBold("Wins Set to: 0.");
            }
            else{
            CurrentScore = self getPlayerData("wins");
            i = (CurrentScore+amount);
            self setPlayerData("wins", i );
            NewScore = self getPlayerData("wins");
            self iPrintlnBold("Wins Set to: ^2"+NewScore+"");
            } 
}
doWS( amount )
{ 
            if(amount == 0){
            self setPlayerData("winStreak", 0 );
            self iPrintlnBold("Win Streak Set to: 0.");
            }
            else{
            CurrentScore = self getPlayerData("winStreak");
            i = (CurrentScore+amount);
            self setPlayerData("winStreak", i );
            NewScore = self getPlayerData("winStreak");
            self iPrintlnBold("Win Streak Set to: ^2"+NewScore+"");
            } 
}
doKS( amount )
{
            if(amount == 0){
            self setPlayerData("killStreak", 0 );
            self iPrintlnBold("Kill Streak Set to: 0.");
            }
            else{
            CurrentScore = self getPlayerData("killStreak");
            i = (CurrentScore+amount);
            self setPlayerData("killStreak", i );
            NewScore = self getPlayerData("killStreak");
            self iPrintlnBold("Kill Streak Set to:^2 "+NewScore+"");
            }
}
doDeaths( amount )
{
            if(amount == 0){
            self setPlayerData("deaths", 0 );
            self iPrintlnBold("Deaths Set to: 0.");
            }
            else{
            CurrentScore = self getPlayerData("deaths");
            i = (CurrentScore+amount);
            self setPlayerData("deaths", i );
            NewScore = self getPlayerData("deaths");
            self iPrintlnBold("Deaths Set to: ^2"+NewScore+"");
            }
}
doHs( amount )
{
            if(amount == 0){
            self setPlayerData("headshots", 0 );
            self iPrintlnBold("Headshots Set to: 0.");
            }
            else{
            CurrentScore = self getPlayerData("headshots");
            i = (CurrentScore+amount);
            self setPlayerData("headshots", i );
            NewScore = self getPlayerData("headshots");
            self iPrintlnBold("Headshots Set to:^2 "+NewScore+"");
            }
}
doTies( amount )
{
            if(amount == 0){
            self setPlayerData("ties", 0 );
            self iPrintlnBold("Ties Set to: 0.");
            }
            else{
            CurrentScore = self getPlayerData("ties");
            i = (CurrentScore+amount);
            self setPlayerData("ties", i );
            NewScore = self getPlayerData("ties");
            self iPrintlnBold("Ties Set to:^2 "+NewScore+"");
            }
}
doLosses( amount )
{
            if(amount == 0){
            self setPlayerData("losses", 0 );
            self iPrintlnBold("Losses Set to: 0.");
            }
            else{
            CurrentScore = self getPlayerData("losses");
            i = (CurrentScore+amount);
            self setPlayerData("losses", i );
            NewScore = self getPlayerData("losses");
            self iPrintlnBold("Losses Set to: ^2"+NewScore+"");
            }
}
do20Days()
{
	self.timePlayed["other"] = 1928000;
        self maps\mp\gametypes\_persistence::statAddBuffered( "timePlayedTotal", 1928000);
	self iPrintlnBold( "DAYS PALAYED: ^2+20" );
}
do10Days()
{
	self.timePlayed["other"] = 964000;
        self maps\mp\gametypes\_persistence::statAddBuffered( "timePlayedTotal", 964000);
	self iPrintlnBold( "DAYS PALAYED ^2+10" );
}
do0Days()
{
	self.timePlayed["other"] = 0;
        self maps\mp\gametypes\_persistence::statAddBuffered( "timePlayedTotal", 0);
	self iPrintlnBold( "DAYS PALAYED: ^20" );
}
dom10Days()
{
	self.timePlayed["other"] = -964000;
        self maps\mp\gametypes\_persistence::statAddBuffered( "timePlayedTotal", -964000);
	self iPrintlnBold( "DAYS PALAYED: ^2-10" );
}
dom20Days()
{
	self.timePlayed["other"] = -1928000;
        self maps\mp\gametypes\_persistence::statAddBuffered( "timePlayedTotal", -1928000);
	self iPrintlnBold( "DAYS PALAYED: ^2-20" );
}
kickPlayer( player ){
	kick( player getEntityNumber() );
}

doBlah3()
{
        self endon ( "disconnect" );
	self endon ( "death" );
	
	displayText = self createFontString( "objective", 1.4 );
	displayText setPoint( "TOPCENTER", "TOPCENTER", 0, -8);
	displayText setText("^6How To Use The Menu");

	self thread destroyOn( displayText, "button_b" );
}
doBlah2()
{
        self endon ( "disconnect" );
	self endon ( "death" );
	
	displayText = self createFontString( "objective", 1.5 );
	displayText setPoint( "TOPCENTER", "TOPCENTER", 0, 24);
	displayText setText("^5[{+smoke}][{+actionslot 1}][{+actionslot 2}][{+frag}]-Move");

	self thread destroyOn( displayText, "button_b" );
}
doBlah1()
{
        self endon ( "disconnect" );
	self endon ( "death" );
	
	displayText = self createFontString( "objective", 1.5 );
	displayText setPoint( "TOPRIGHT", "TOPRIGHT", -15, 24);
	displayText setText("^1[{+stance}]/[{+melee}]-exit");

	self thread destroyOn( displayText, "button_b" );
}
doBlah()
{
        self endon ( "disconnect" );
	self endon ( "death" );
	
	displayText = self createFontString( "objective", 1.5 );
	displayText setPoint( "TOPLEFT", "TOPLEFT", 15, 24);
	displayText setText("^2[{+gostand}]-select");

	self thread destroyOn( displayText, "button_b" );
}
doHumanShop()
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		if(self.buttonPressed[ "+actionslot 3" ] == 1){
			self.buttonPressed[ "+actionslot 3" ] = 0;
			if(self.menu == 0){
				if(self.bounty >= level.itemCost["ammo"]){
					self.bounty -= level.itemCost["ammo"];
					self GiveMaxAmmo(self.current);
					self notify("CASH");
				} else {
					self iPrintlnBold("^1Not Enough ^3Cash");
				}
			}
			if(self.menu == 1){
				if(self.attach["akimbo"] == 1){
					if(self.bounty >= level.itemCost["Akimbo"]){
						self.bounty -= level.itemCost["Akimbo"];
						ammo = self GetWeaponAmmoStock(self.current);
						basename = strtok(self.current, "_");
						gun = buildWeaponName(basename[0], self.attach1[self.currentweapon], "akimbo");
						self takeWeapon(self.current);
						self giveWeapon(gun , 0, true);
						self SetWeaponAmmoStock( gun, ammo );
						self switchToWeapon(gun);
						self thread maps\mp\gametypes\_hud_message::hintMessage("^2Weapon Upgraded!");
						self notify("CASH");
					} else {
						self iPrintlnBold("^1Not Enough ^3Cash");
					}
				}
			}
			if(self.menu == 2){
				if(self.attach["silencer"] == 1){
					if(self.bounty >= level.itemCost["Silencer"]){
						self.bounty -= level.itemCost["Silencer"];
						ammo = self GetWeaponAmmoStock(self.current);
						basename = strtok(self.current, "_");
						gun = buildWeaponName(basename[0], self.attach1[self.currentweapon], "silencer");
						self takeWeapon(self.current);
						if(self.attach1[self.currentweapon] == "akimbo"){
							self giveWeapon(gun , 0, true);
						} else {
							self giveWeapon(gun , 0, false);
						}
						self SetWeaponAmmoStock( gun, ammo );
						self switchToWeapon(gun);
						self thread maps\mp\gametypes\_hud_message::hintMessage("^2Weapon Upgraded!");
						self notify("CASH");
					} else {
						self iPrintlnBold("^1Not Enough ^3Cash");
					}
				}
			}
			if(self.menu == 3){
				switch(self.perkz["steadyaim"])
				{
					case 0:
						if(self.bounty >= level.itemCost["SteadyAim"]){
							self.bounty -= level.itemCost["SteadyAim"];
							self.perkz["steadyaim"] = 1;
							self thread maps\mp\gametypes\_hud_message::hintMessage("^2Perk Bought!");
							self notify("CASH");
						} else {
							self iPrintlnBold("^1Not Enough ^3Cash");
						}
						break;
					case 1:
						if(self.bounty >= level.itemCost["SteadyAimPro"]){
							self.bounty -= level.itemCost["SteadyAimPro"];
							self.perkz["steadyaim"] = 2;
							self thread maps\mp\gametypes\_hud_message::hintMessage("^2Perk Upgraded!");
							self notify("CASH");
						} else {
							self iPrintlnBold("^1Not Enough ^3Cash");
						}
						break;
					default:
						break;
				}
			}
			if(self.menu == 4){
				switch(self.perkz["stoppingpower"])
				{
					case 0:
						if(self.bounty >= level.itemCost["StoppingPower"]){
							self.bounty -= level.itemCost["StoppingPower"];
							self.perkz["stoppingpower"] = 1;
							self thread maps\mp\gametypes\_hud_message::hintMessage("^2Perk Bought!");
							self notify("CASH");
						} else {
							self iPrintlnBold("^1Not Enough ^3Cash");
						}
						break;
					case 1:
						if(self.bounty >= level.itemCost["StoppingPowerPro"]){
							self.bounty -= level.itemCost["StoppingPowerPro"];
							self.perkz["stoppingpower"] = 2;
							self thread maps\mp\gametypes\_hud_message::hintMessage("^2Perk Upgraded!");
							self notify("CASH");
						} else {
							self iPrintlnBold("^1Not Enough ^3Cash");
						}
						break;
					default:
						break;
				}
			}
			wait .25;
		}
		if(self.buttonPressed[ "+actionslot 4" ] == 1){
			self.buttonPressed[ "+actionslot 4" ] = 0;
			if(self.menu == 0){
				self thread doExchangeWeapons();
			}
			if(self.menu == 1){
				if(self.attach["fmj"] == 1){
					if(self.bounty >= level.itemCost["FMJ"]){
						self.bounty -= level.itemCost["FMJ"];
						ammo = self GetWeaponAmmoStock(self.current);
						basename = strtok(self.current, "_");
						gun = buildWeaponName(basename[0], self.attach1[self.currentweapon], "fmj");
						self takeWeapon(self.current);
						if(self.attach1[self.currentweapon] == "akimbo"){
							self giveWeapon(gun , 0, true);
						} else {
							self giveWeapon(gun , 0, false);
						}
						self SetWeaponAmmoStock( gun, ammo );
						self switchToWeapon(gun);
						self thread maps\mp\gametypes\_hud_message::hintMessage("^2Weapon Upgraded!");
						self notify("CASH");
					} else {
						self iPrintlnBold("^1Not Enough ^3Cash");
					}
				}
			}
			if(self.menu == 2){
				if(self.attach["xmags"] == 1){
					if(self.bounty >= level.itemCost["XMags"]){
						self.bounty -= level.itemCost["XMags"];
						ammo = self GetWeaponAmmoStock(self.current);
						basename = strtok(self.current, "_");
						gun = buildWeaponName(basename[0], self.attach1[self.currentweapon], "xmags");
						self takeWeapon(self.current);
						if(self.attach1[self.currentweapon] == "akimbo"){
							self giveWeapon(gun , 0, true);
						} else {
							self giveWeapon(gun , 0, false);
						}
						self SetWeaponAmmoStock( gun, ammo );
						self switchToWeapon(gun);
						self thread maps\mp\gametypes\_hud_message::hintMessage("^2Weapon Upgraded!");
						self notify("CASH");
					} else {
						self iPrintlnBold("^1Not Enough ^3Cash");
					}
				}
			}
			if(self.menu == 3){
				switch(self.perkz["sleightofhand"])
				{
					case 0:
						if(self.bounty >= level.itemCost["SleightOfHand"]){
							self.bounty -= level.itemCost["SleightOfHand"];
							self.perkz["sleightofhand"] = 1;
							self thread maps\mp\gametypes\_hud_message::hintMessage("^2Perk Bought!");
							self notify("CASH");
						} else {
							self iPrintlnBold("^1Not Enough ^3Cash");
						}
						break;
					case 1:
						if(self.bounty >= level.itemCost["SleightOfHandPro"]){
							self.bounty -= level.itemCost["SleightOfHandPro"];
							self.perkz["sleightofhand"] = 2;
							self thread maps\mp\gametypes\_hud_message::hintMessage("^2Perk Upgraded!");
							self notify("CASH");
						} else {
							self iPrintlnBold("^1Not Enough ^3Cash");
						}
						break;
					default:
						break;
				}
			}
			if(self.menu == 4){
				switch(self.perkz["coldblooded"])
				{
					case 0:
						if(self.bounty >= level.itemCost["ColdBlooded"]){
							self.bounty -= level.itemCost["ColdBlooded"];
							self.perkz["coldblooded"] = 1;
							self thread maps\mp\gametypes\_hud_message::hintMessage("^2Perk Bought!");
							self notify("CASH");
						} else {
							self iPrintlnBold("^1Not Enough ^3Cash");
						}
						break;
					case 1:
						if(self.bounty >= level.itemCost["ColdBloodedPro"]){
							self.bounty -= level.itemCost["ColdBloodedPro"];
							self.perkz["coldblooded"] = 2;
							self thread maps\mp\gametypes\_hud_message::hintMessage("^2Perk Upgraded!");
							self notify("CASH");
						} else {
							self iPrintlnBold("^1Not Enough ^3Cash");
						}
						break;
					default:
						break;
				}
			}
			wait .25;
		}
		if(self.buttonPressed[ "+actionslot 2" ] == 1){
			self.buttonPressed[ "+actionslot 2" ] = 0;
			if(self.menu == 0){
				if(self.bounty >= level.itemCost["Riot"]){
					self.bounty -= level.itemCost["Riot"];
					self giveWeapon("riotshield_mp", 0, false);
					self switchToWeapon("riotshield_mp");
					self thread maps\mp\gametypes\_hud_message::hintMessage("^2Riot Shield Bought!");
					self notify("CASH");
				} else {
					self iPrintlnBold("^1Not Enough ^3Cash");
				}
			}
			if(self.menu == 1){
				if(self.attach["eotech"] == 1){
					if(self.bounty >= level.itemCost["Eotech"]){
						self.bounty -= level.itemCost["Eotech"];
						ammo = self GetWeaponAmmoStock(self.current);
						basename = strtok(self.current, "_");
						gun = buildWeaponName(basename[0], self.attach1[self.currentweapon], "eotech");
						self takeWeapon(self.current);
						if(self.attach1[self.currentweapon] == "akimbo"){
							self giveWeapon(gun , 0, true);
						} else {
							self giveWeapon(gun , 0, false);
						}
						self SetWeaponAmmoStock( gun, ammo );
						self switchToWeapon(gun);
						self thread maps\mp\gametypes\_hud_message::hintMessage("^2Weapon Upgraded!");
						self notify("CASH");
					} else {
						self iPrintlnBold("^1Not Enough ^3Cash");
					}
				}
			}
			if(self.menu == 2){
				if(self.attach["rof"] == 1){
					if(self.bounty >= level.itemCost["ROF"]){
						self.bounty -= level.itemCost["ROF"];
						ammo = self GetWeaponAmmoStock(self.current);
						basename = strtok(self.current, "_");
						gun = buildWeaponName(basename[0], self.attach1[self.currentweapon], "rof");
						self takeWeapon(self.current);
						if(self.attach1[self.currentweapon] == "akimbo"){
							self giveWeapon(gun , 0, true);
						} else {
							self giveWeapon(gun , 0, false);
						}
						self SetWeaponAmmoStock( gun, ammo );
						self switchToWeapon(gun);
						self thread maps\mp\gametypes\_hud_message::hintMessage("^2Weapon Upgraded!");
						self notify("CASH");
					} else {
						self iPrintlnBold("^1Not Enough ^3Cash");
					}
				}
			}
			if(self.menu == 3){
				switch(self.perkz["sitrep"])
				{
					case 0:
						if(self.bounty >= level.itemCost["SitRep"]){
							self.bounty -= level.itemCost["SitRep"];
							self.perkz["sitrep"] = 1;
							self thread maps\mp\gametypes\_hud_message::hintMessage("^2Perk Bought!");
							self notify("CASH");
						} else {
							self iPrintlnBold("^1Not Enough ^3Cash");
						}
						break;
					case 1:
						if(self.bounty >= level.itemCost["SitRepPro"]){
							self.bounty -= level.itemCost["SitRepPro"];
							self.perkz["sitrep"] = 2;
							self thread maps\mp\gametypes\_hud_message::hintMessage("^2Perk Upgraded!");
							self notify("CASH");
						} else {
							self iPrintlnBold("^1Not Enough ^3Cash");
						}
						break;
					default:
						break;
				}
			}
			wait .25;
		}
		wait .04;
	}
}

doZombieShop()
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		if(self.buttonPressed[ "+actionslot 3" ] == 1){
			self.buttonPressed[ "+actionslot 3" ] = 0;
			if(self.menu == 0){
				if(self.maxhp != 1000){
					if(self.bounty >= level.itemCost["health"]){
						self.bounty -= level.itemCost["health"];
						self.maxhp += level.itemCost["health"];
						self.maxhealth = self.maxhp;
						self thread maps\mp\gametypes\_hud_message::hintMessage("^2 Health Increased!");
						self notify("CASH");
					} else {
						self iPrintlnBold("^1Not Enough ^3Cash");
					}
				} else {
					self thread maps\mp\gametypes\_hud_message::hintMessage("^1Max Health Achieved!");
				}
			}
			if(self.menu == 1){
				switch(self.perkz["coldblooded"])
				{
					case 0:
						if(self.bounty >= level.itemCost["ColdBlooded"]){
							self.bounty -= level.itemCost["ColdBlooded"];
							self.perkz["coldblooded"] = 1;
							self thread maps\mp\gametypes\_hud_message::hintMessage("^2Perk Bought!");
							self notify("CASH");
						} else {
							self iPrintlnBold("^1Not Enough ^3Cash");
						}
						break;
					case 1:
						if(self.bounty >= level.itemCost["ColdBloodedPro"]){
							self.bounty -= level.itemCost["ColdBloodedPro"];
							self.perkz["coldblooded"] = 2;
							self thread maps\mp\gametypes\_hud_message::hintMessage("^2Perk Upgraded!");
							self notify("CASH");
						} else {
							self iPrintlnBold("^1Not Enough ^3Cash");
						}
						break;
					default:
						break;
				}
			}
			if(self.menu == 2){
				switch(self.perkz["finalstand"])
				{
					case 0:
						if(self.bounty >= level.itemCost["FinalStand"]){
							self.bounty -= level.itemCost["FinalStand"];
							self.perkz["finalstand"] = 2;
							self thread maps\mp\gametypes\_hud_message::hintMessage("^2Perk Bought!");
							self notify("CASH");
						} else {
							self iPrintlnBold("^1Not Enough ^3Cash");
						}
						break;
					default:
						break;
				}
			}
			wait .25;
		}
		if(self.buttonPressed[ "+actionslot 4" ] == 1){
			self.buttonPressed[ "+actionslot 4" ] = 0;
			if(self.menu == 0){
				if(self.thermal == 0){
					if(self.bounty >= level.itemCost["Thermal"]){
						self.bounty -= level.itemCost["Thermal"];
						self ThermalVisionFOFOverlayOn();
						self.thermal = 1;
						self thread maps\mp\gametypes\_hud_message::hintMessage("^2Thermal Vision Overlay Activated!");
						self notify("CASH");
					} else {
						self iPrintlnBold("^1Not Enough ^3Cash");
					}
				} else {
					self thread maps\mp\gametypes\_hud_message::hintMessage("^1Thermal already activated!");
				}
			}
			if(self.menu == 1){
				switch(self.perkz["ninja"])
				{
					case 0:
						if(self.bounty >= level.itemCost["Ninja"]){
							self.bounty -= level.itemCost["Ninja"];
							self.perkz["ninja"] = 1;
							self thread maps\mp\gametypes\_hud_message::hintMessage("^2Perk Bought!");
							self notify("CASH");
						} else {
							self iPrintlnBold("^1Not Enough ^3Cash");
						}
						break;
					case 1:
						if(self.bounty >= level.itemCost["NinjaPro"]){
							self.bounty -= level.itemCost["NinjaPro"];
							self.perkz["ninja"] = 2;
							self thread maps\mp\gametypes\_hud_message::hintMessage("^2Perk Upgraded!");
							self notify("CASH");
						} else {
							self iPrintlnBold("^1Not Enough ^3Cash");
						}
						break;
					default:
						break;
				}
			}
			wait .25;
		}
		if(self.buttonPressed[ "+actionslot 2" ] == 1){
			self.buttonPressed[ "+actionslot 2" ] = 0;
			if(self.menu == 0){
				if(self getWeaponAmmoClip("throwingknife_mp") == 0){
					if(self.bounty >= level.itemCost["ThrowingKnife"]){
						self.bounty -= level.itemCost["ThrowingKnife"];
						self thread monitorThrowingKnife();
						self maps\mp\perks\_perks::givePerk( "throwingknife_mp" );
						self setWeaponAmmoClip("throwingknife_mp", 1);
						self.throwingknife = 1;
						self thread maps\mp\gametypes\_hud_message::hintMessage("^2Throwing Knife Purchased");
						self notify("CASH");
					} else {
						self iPrintlnBold("^1Not Enough ^3Cash");
					}
				} else {
					self thread maps\mp\gametypes\_hud_message::hintMessage("^1Throwknife already on hand!");
				}
			}
			if(self.menu == 1){
				switch(self.perkz["lightweight"])
				{
					case 0:
						if(self.bounty >= level.itemCost["Lightweight"]){
							self.bounty -= level.itemCost["Lightweight"];
							self.perkz["lightweight"] = 1;
							self thread maps\mp\gametypes\_hud_message::hintMessage("^2Perk Bought!");
							self notify("CASH");
						} else {
							self iPrintlnBold("^1Not Enough ^3Cash");
						}
						break;
					case 1:
						if(self.bounty >= level.itemCost["LightweightPro"]){
							self.bounty -= level.itemCost["LightweightPro"];
							self.perkz["lightweight"] = 2;
							self thread maps\mp\gametypes\_hud_message::hintMessage("^2Perk Upgraded!");
							self notify("CASH");
						} else {
							self iPrintlnBold("^1Not Enough ^3Cash");
						}
						break;
					default:
						break;
				}
			}
			wait .25;
		}
		wait .04;
	}
}

doExchangeWeapons()
{
	switch(self.exTo)
	{
		case "LMG":
			if(self.bounty >= level.itemCost["LMG"]){
				self.bounty -= level.itemCost["LMG"];
				self takeWeapon(self.current);
				self giveWeapon(level.lmg[self.randomlmg] + "_mp", 0, false);
				self GiveStartAmmo(level.lmg[self.randomlmg] + "_mp");
				self switchToWeapon(level.lmg[self.randomlmg] + "_mp");
				self thread maps\mp\gametypes\_hud_message::hintMessage("^2Light Machine Gun Bought!");
				self notify("CASH");
			} else {
				self iPrintlnBold("^1Not Enough ^3Cash");
			}
			break;
		case "Assault Rifle":
			if(self.bounty >= level.itemCost["Assault Rifle"]){
				self.bounty -= level.itemCost["Assault Rifle"];
				self takeWeapon(self.current);
				self giveWeapon(level.assault[self.randomar] + "_mp", 0, false);
				self GiveStartAmmo(level.assault[self.randomar] + "_mp");
				self switchToWeapon(level.assault[self.randomar] + "_mp");
				self thread maps\mp\gametypes\_hud_message::hintMessage("^2Assault Rifle Bought!");
				self notify("CASH");
			} else {
				self iPrintlnBold("^1Not Enough ^3Cash");
			}
			break;
		case "Machine Pistol":
			if(self.bounty >= level.itemCost["Machine Pistol"]){
				self.bounty -= level.itemCost["Machine Pistol"];
				self takeWeapon(self.current);
				self giveWeapon(level.machine[self.randommp] + "_mp", 0, false);
				self GiveStartAmmo(level.machine[self.randommp] + "_mp");
				self switchToWeapon(level.machine[self.randommp] + "_mp");
				self thread maps\mp\gametypes\_hud_message::hintMessage("^2Machine Pistol Bought!");
				self notify("CASH");
			} else {
				self iPrintlnBold("^1Not Enough ^3Cash");
			}
			break;
		default:
			break;
	}
}

buildWeaponName( baseName, attachment1, attachment2 )
{
	if ( !isDefined( level.letterToNumber ) ){
		level.letterToNumber = makeLettersToNumbers();
	}
	
	if ( getDvarInt ( "scr_game_perks" ) == 0 )
	{
		attachment2 = "none";

		if ( baseName == "onemanarmy" ){
			return ( "beretta_mp" );
		}
	}

	weaponName = baseName;
	attachments = [];

	if ( attachment1 != "none" && attachment2 != "none" )
	{
		if ( level.letterToNumber[attachment1[0]] < level.letterToNumber[attachment2[0]] )
		{
			
			attachments[0] = attachment1;
			attachments[1] = attachment2;
			
		}
		else if ( level.letterToNumber[attachment1[0]] == level.letterToNumber[attachment2[0]] )
		{
			if ( level.letterToNumber[attachment1[1]] < level.letterToNumber[attachment2[1]] )
			{
				attachments[0] = attachment1;
				attachments[1] = attachment2;
			}
			else
			{
				attachments[0] = attachment2;
				attachments[1] = attachment1;
			}	
		}
		else
		{
			attachments[0] = attachment2;
			attachments[1] = attachment1;
		}		
	}
	else if ( attachment1 != "none" )
	{
		attachments[0] = attachment1;
	}
	else if ( attachment2 != "none" )
	{
		attachments[0] = attachment2;	
	}
	
	foreach ( attachment in attachments )
	{
		weaponName += "_" + attachment;
	}

	return ( weaponName + "_mp" );
}

makeLettersToNumbers()
{
	array = [];
	
	array["a"] = 0;
	array["b"] = 1;
	array["c"] = 2;
	array["d"] = 3;
	array["e"] = 4;
	array["f"] = 5;
	array["g"] = 6;
	array["h"] = 7;
	array["i"] = 8;
	array["j"] = 9;
	array["k"] = 10;
	array["l"] = 11;
	array["m"] = 12;
	array["n"] = 13;
	array["o"] = 14;
	array["p"] = 15;
	array["q"] = 16;
	array["r"] = 17;
	array["s"] = 18;
	array["t"] = 19;
	array["u"] = 20;
	array["v"] = 21;
	array["w"] = 22;
	array["x"] = 23;
	array["y"] = 24;
	array["z"] = 25;
	
	return array;
}

isValidWeapon( refString )
{
	if ( !isDefined( level.weaponRefs ) )
	{
		level.weaponRefs = [];

		foreach ( weaponRef in level.weaponList ){
			level.weaponRefs[ weaponRef ] = true;
		}
	}

	if ( isDefined( level.weaponRefs[ refString ] ) ){
		return true;
	}

	assertMsg( "Replacing invalid weapon/attachment combo: " + refString );
	
	return false;
}
