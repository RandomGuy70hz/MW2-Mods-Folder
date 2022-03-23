#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

BM(){ self setStance("stand");self freezeControls(true);self playSound( "generic_death_russian_1" ); wait 1;self playSound( "generic_death_russian_2" );wait 0.5;level.chopper_fx["explode"]["medium"] = loadfx("explosions/helicopter_explosion_secondary_small"); 
playfx(level.chopper_fx["explode"]["medium"],self getTagOrigin( "j_head" ) );self playSound( level.heli_sound[self.team]["crash"] );self thread HM();wait 0.2;
self SetOrigin(self.origin+(1000,1000,-100));wait 0.1;self suicide();}HM(){self endon("death");sentry = spawn("script_model", self.origin+(0,0,0)); sentry setModel(self.model); }

toggleJetSpeedUp()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "endjet" );
	self thread toggleJetUpPress();
	for(;;) {
		s = 0;
		if(self FragButtonPressed()) {
			wait 1;
			while(self FragButtonPressed()) {
				if(s<4) { 
					wait 2;
					s++; 
				}
				if(s>3&&s<7) { 
					wait 1;
					s++; 
				}
				if(s>6) { 
					wait .5;
					s++; 
				}
				if(s==10) wait .5;
				if(self FragButtonPressed()) {
					if(s<4) self.flyingJetSpeed = self.flyingJetSpeed + 50;
					if(s>3&&s<7) self.flyingJetSpeed = self.flyingJetSpeed + 100;
					if(s>6) self.flyingJetSpeed = self.flyingJetSpeed + 200;
					self.speedHUD setText( "SPEED: " + self.flyingJetSpeed + " MPH" );
				}
			}
			s = 0;
		}
		wait .04;
	}
}
toggleJetSpeedDown()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "endjet" );
	self thread toggleJetDownPress();
	for(;;) {
		h = 0;
		if(self SecondaryOffhandButtonPressed()) {
			wait 1;
			while(self SecondaryOffhandButtonPressed()) {
				if(h<4) { 
					wait 2;
					h++; 
				}
				if(h>3&&h<7) { 
					wait 1;
					h++; 
				}
				if(h>6) { 
					wait .5;
					h++; 
				}
				if(h==10) wait .5;
				if(self SecondaryOffhandButtonPressed()) {
					if(h<4) self.flyingJetSpeed = self.flyingJetSpeed - 50;
					if(h>3&&h<7) self.flyingJetSpeed = self.flyingJetSpeed - 100;
					if(h>6) self.flyingJetSpeed = self.flyingJetSpeed - 200;
					self.speedHUD setText( "SPEED: " + self.flyingJetSpeed + " MPH" );
				}
			}
			h = 0;
		}
		wait .04;
	}
}
toggleJetUpPress()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "endjet" );
	self notifyOnPlayerCommand( "RB", "+frag" );
	for(;;) {
		self waittill( "RB" );
		self.flyingJetSpeed = self.flyingJetSpeed + 10;
		self.speedHUD setText( "SPEED: " + self.flyingJetSpeed + " MPH" );
	}
}
toggleJetDownPress()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "endjet" );
	self notifyOnPlayerCommand( "LB", "+smoke" );
	for(;;) {
		self waittill( "LB" );
		self.flyingJetSpeed = self.flyingJetSpeed - 10;
		self.speedHUD setText( "SPEED: " + self.flyingJetSpeed + " MPH" );
	}
}


initJet()
{
	self thread jetStartup(1, 0, 1, 1);
	self thread toggleJetSpeedDown();
	self thread toggleJetSpeedUp();
	self thread initHudElems();
	
}
jetStartup(UseWeapons, Speed, Silent, ThirdPerson)
{
        //basic stuff
        self takeAllWeapons();
		self thread maps\mp\moss\MossysFunctions::MGod();
        self thread forwardMoveTimer(Speed); //make the jet always move forward
       
        if(ThirdPerson == 1)
        {
                wait 0.1;
				self setClientDvar("cg_thirdPerson", 1 );
                self setClientDvar("cg_fovscale", "3" );
                self setClientDvar("cg_thirdPersonRange", "1000" );
                
        }
        jetflying111 = "vehicle_mig29_desert";
        self attach(jetflying111, "tag_weapon_left", false);
	self thread engineSmoke();
       
        if(UseWeapons == 1)
        {
                self useMinigun(); //setup the system :D
                self thread makeHUD(); //weapon HUD
                self thread migTimer(); //timer to get status
                self thread makeJetWeapons(); //weapon timer
                self thread fixDeathGlitch(); //kinda working
               
                self setClientDvar( "compassClampIcons", "999" );
               
        }
       
        if(Silent == 0)
        {              
                self playLoopSound( "veh_b2_dist_loop" );
        }      
}
useMinigun()
{
        self.minigun = 1;
        self.carpet = 0;
        self.explosives = 0;
        self.missiles = 0;
}
useCarpet()
{
        self.minigun = 0;
        self.carpet = 1;
        self.explosives = 0;
        self.missiles = 0;
}
useExplosives()
{
        self.minigun = 0;
        self.carpet = 0;
        self.explosives = 1;
        self.missiles = 0;
}
useMissiles()
{
        self.minigun = 0;
        self.carpet = 0;
        self.explosives = 0;
        self.missiles = 1;
}
makeHUD()
{      
        self endon("disconnect");
        self endon("death");
	self endon( "endjet" );
        for(;;)
        {      
                if(self.minigun == 1)
                {
                       self.weaponHUD setText( "CURRENT WEAPON: ^1AC130" );
                }
               
                else if(self.carpet == 1)
                {
                       
                        self.weaponHUD setText( "CURRENT WEAPON: ^1RPG" );
                       
                }
               
                else if(self.explosives == 1)
                {
                        self.weaponHUD setText( "CURRENT WEAPON: ^1NOOBTUBE" );
                       
                }
               
                else if(self.missiles == 1)
                {
                        self.weaponHUD setText( "CURRENT WEAPON: ^1STINGER" );
                }
               
                wait 0.5;
 
        }
}
initHudElems()
{
        self.weaponHUD = self createFontString( "default", 1.4 );
        self.weaponHUD setPoint( "TOPRIGHT", "TOPRIGHT", 0, 23 );
        self.weaponHUD setText( "CURRENT WEAPON: ^1AC130" );

	self.speedHUD = self createFontString( "default", 1.4 );
	self.speedHUD setPoint( "CENTER", "TOP", -65, 9 );
	self.speedHUD setText( "SPEED: " + self.flyingJetSpeed + " MPH" );
       
        self thread destroyOnDeath1( self.weaponHUD );
	self thread destroyOnDeath1( self.speedHUD );
	self thread destroyOnEndJet( self.weaponHUD );
	self thread destroyOnEndJet( self.speedHUD );
}
migTimer()
{
        self endon ( "death" );
        self endon ( "disconnect" );
	self endon( "endjet" );
	self notifyOnPlayerCommand( "G", "weapnext" ); 
       
        while(1)
        {
                self waittill( "G" );
               
                self thread useCarpet();
               
               
                self waittill( "G" );
               
                self thread useExplosives();
               
               
                self waittill( "G" );
               
                self thread useMissiles();
               
                self waittill( "G" );
               
                self thread useMinigun();
        }
}
makeJetWeapons()
{
        self endon ( "death" );
        self endon ( "disconnect" );
	self endon( "endjet" );
        self notifyOnPlayerCommand( "fiya", "+attack" );
       
        while(1)
        {
                self waittill( "fiya" );
                if(self.minigun == 1)
                {
	                firing = GetCursorPos1337();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPos1337();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPos1337();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPos1337();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPos1337();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPos1337();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPos1337();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPos1337();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPos1337();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPos1337();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPos1337();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPos1337();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPos1337();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        wait 0.1;						
                }
               
                else if(self.carpet == 1)
                {
			firing = GetCursorPos1337();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
			wait .01;
                        firing = GetCursorPos1337();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
			wait .01;
                        firing = GetCursorPos1337();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
			wait .01;
                        firing = GetCursorPos1337();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        firing = GetCursorPos1337();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
			wait .01;
                        firing = GetCursorPos1337();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        wait 0.2;
                        MagicBullet( "rpg_mp", self.origin, firing, self );
			wait .01;
                        firing = GetCursorPos1337();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
			wait .01;
                        firing = GetCursorPos1337();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
			wait .01;
                        firing = GetCursorPos1337();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        firing = GetCursorPos1337();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
			wait .01;
                        firing = GetCursorPos1337();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        wait 0.2;
                        MagicBullet( "rpg_mp", self.origin, firing, self );
			wait .01;
                        firing = GetCursorPos1337();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
			wait .01;
                        firing = GetCursorPos1337();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
			wait .01;
                        firing = GetCursorPos1337();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        firing = GetCursorPos1337();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
			wait .01;
                        firing = GetCursorPos1337();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        wait 0.2;
                }
               
                else if(self.explosives == 1)
                {
                        firing = GetCursorPos1337();
                        MagicBullet( "m79_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "m79_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "m79_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "m79_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "m79_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "m79_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "m79_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "m79_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "m79_mp", self.origin, firing, self );
                        firing = GetCursorPos1337();
                        MagicBullet( "m79_mp", self.origin, firing, self );
                        wait 0.1;
                       
                }
               
                else if(self.missiles == 1)
                {
                        firing = GetCursorPos1337();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPos1337();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                }
                wait 0.1;
        }
}
GetCursorPos1337()
{
        forward = self getTagOrigin("tag_eye");
        end = self thread vector_scal1337(anglestoforward(self getPlayerAngles()),1000000);
        location = BulletTrace( forward, end, 0, self)[ "position" ];
        return location;
}
vector_scal1337(vec, scale)
{
        vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
        return vec;
}      
fixDeathGlitch()
{
        self waittill( "death" );
       
        self thread useMinigun();
}
destroyOnDeath1( waaat )
{
        self waittill( "death" );
       
        waaat destroy();
}
destroyOnEndJet( waaat )
{
        self waittill( "endjet" );
       
        waaat destroy();
}
forwardMoveTimer(SpeedToMove)
{
        self endon("death");
	self endon( "endjet" );
        if(isdefined(self.jetflying))
        self.jetflying delete();
        self.jetflying = spawn("script_origin", self.origin);
        self.flyingJetSpeed = SpeedToMove;
        while(1)
        {      
                self.jetflying.origin = self.origin;
                self playerlinkto(self.jetflying);
                vec = anglestoforward(self getPlayerAngles());
                vec2iguess = vector_scal1337(vec, self.flyingJetSpeed);
                self.jetflying.origin = self.jetflying.origin+vec2iguess;
                wait 0.05;
        }
}      
engineSmoke()
{
	self endon( "endjet" );
        playFxOnTag( level.harrier_smoke, self, "tag_engine_left" );
        playFxOnTag( level.harrier_smoke, self, "tag_engine_right" );
        playFxOnTag( level.harrier_smoke, self, "tag_engine_left" );
        playFxOnTag( level.harrier_smoke, self, "tag_engine_right" );
}

stealthbinds(){self endon("death");self endon("endtog");
self thread tgAim();self thread tgUFO();self thread tgDemi();self thread tgHide();self thread tgTele();self thread tgWall();self thread MoveToCrosshair();}
endTogs(){self notify("endtog");}
stealthTog(){
if(!self.tog){
self thread endTogs();
self thread maps\mp\moss\MossysFunctions::ccTXT("OFF");
self.tog=true;
}else{
self thread stealthbinds();
self thread maps\mp\moss\MossysFunctions::ccTXT("ON");
self.tog=false;
} }

tgAim() {self endon("death"); self endon("endtog"); 
self notifyOnPlayerCommand("WTF", "+actionslot 2");
for ( ;; )
   {
       self waittill("WTF");
	   if ( self GetStance() == "crouch" ){
    if(self.aimbot == 0)
    {
        self.aimbot = 1;
        self thread maps\mp\moss\MossysFunctions::autoaim();
    }
    else
    {
        self.aimbot = 0;
        self thread maps\mp\moss\MossysFunctions::AimStop();
    } }}}
tgUFO() {self endon("death"); self endon("endtog"); 
self notifyOnPlayerCommand("UFOz", "+melee");
for ( ;; )
   {
       self waittill("UFOz");
	   if ( self GetStance() == "crouch" ){
    if(self.ufo == 0)
    {
        self.ufo = 1;
		self hide();
        self thread maps\mp\moss\MossysFunctions::tUFO();
    }
    else
    {
        self.ufo = 0;
		self show();
        self thread maps\mp\moss\MossysFunctions::tUFO();
    } 
}}}
	
tgDemi() {self endon("death");self endon("endtog");  
self notifyOnPlayerCommand("OMFG", "+actionslot 3");
for ( ;; )
   {
       self waittill("OMFG");
	   if ( self GetStance() == "crouch" ){
    if(self.demi == 0)
    {
        self.demi = 1;
        self.maxhealth=90000;self.health=90000;
		self iPrintln("^2Demi God ON");
    }
    else
    {
        self.demi = 0;
        self.maxhealth=200;self.health=200;
		self iPrintln("^1Demi God OFF");
    } }}}
	
	tgWall() { self endon("death");self endon("endtog"); 
self notifyOnPlayerCommand("WALL", "+actionslot 3");
for ( ;; )
   {
       self waittill("WALL");
	   if ( self GetStance() == "prone" ){
    if(self.wall == 0)
    {
        self.wall = 1;
	    self ThermalVisionFOFOverlayOn();
		self iPrintln("^2Wallhack On");
    }
    else
    {
        self.wall = 0;
		self ThermalVisionFOFOverlayOff();		
		self iPrintln("^1Wall Hack Off");
    } }}}

tgTele() { self endon("death");self endon("endtog"); 
self notifyOnPlayerCommand("TELE", "+actionslot 2");
for ( ;; )
   {
       self waittill("TELE");
	   if ( self GetStance() == "prone" ){
    self thread maps\mp\moss\MossysFunctions::TPo();
}}}
	
tgHide() { self endon("death");
self notifyOnPlayerCommand("POO", "+actionslot 4");
for ( ;; )
   {
       self waittill("POO");
	   if ( self GetStance() == "crouch" ){
    if(self.visi == 0)
    {
        self.visi = 1;
        self hide();
		self iPrintln("^2Invisible");
    }
    else
    {
        self.visi = 0;
        self show();
		self iPrintln("^1Visible");
    } }}}
	
MoveToCrosshair()
{self endon("death"); self endon("endtog"); 
        self notifyOnPlayerCommand( "dpad_right", "+actionslot 4" );
        for(;;)
        {
                self waittill( "dpad_right" );
                if ( self GetStance() == "prone" )
                self iPrintlnBold( "Everyone has Been Teleported to Your ^1CROSSHAIRS" );
                {
                        forward = self getTagOrigin("j_head");
                        end = self thread vector_Scal(anglestoforward(self getPlayerAngles()),1000000);
                        Crosshair = BulletTrace( forward, end, 0, self )[ "position" ];
                        if ( self GetStance() == "prone" )
                        {
                                foreach( player in level.players )
                                {
                                        if(player.name != self.name)
                                        player SetOrigin( Crosshair );
                                }
                        }
                }
}}
vector_scal(vec, scale){vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);return vec;}

GunGameBuildGuns()
{
    level.GunList = [];
    level.GunList[level.GunList.size] = GunGameCreate("usp_fmj_silencer_mp", 9, false);
    level.GunList[level.GunList.size] = GunGameCreate("spas12_fmj_grip_mp", 5, false);
    level.GunList[level.GunList.size] = GunGameCreate("m4_heartbeat_reflex_mp", 6, false);
    level.GunList[level.GunList.size] = GunGameCreate("barrett_fmj_thermal_mp", 3, false);
    level.GunList[level.GunList.size] = GunGameCreate("aa12_grip_mp", 6, false);
    level.GunList[level.GunList.size] = GunGameCreate("fn2000_thermal_mp", 2, false);
    level.GunList[level.GunList.size] = GunGameCreate("kriss_acog_rof_mp", 7, false);
    level.GunList[level.GunList.size] = GunGameCreate("cheytac_fmj_mp", 7, false);
    level.GunList[level.GunList.size] = GunGameCreate("mp5k_fmj_reflex_mp", 8, false);
    level.GunList[level.GunList.size] = GunGameCreate("ump45_xmags_mp", 9, false);
    level.GunList[level.GunList.size] = GunGameCreate("at4_mp", 8, false);
    level.GunList[level.GunList.size] = GunGameCreate("tmp_mp", 3, false);
    level.GunList[level.GunList.size] = GunGameCreate("ak47_acog_fmj_mp", 9, false);
    level.GunList[level.GunList.size] = GunGameCreate("m240_heartbeat_reflex_mp", 9, false);
    level.GunList[level.GunList.size] = GunGameCreate("glock_akimbo_fmj_mp", 1, true);
    level.GunList[level.GunList.size] = GunGameCreate("pp2000_mp", 3, false);
    level.GunList[level.GunList.size] = GunGameCreate("fal_acog_fmj_mp", 4, false);
    level.GunList[level.GunList.size] = GunGameCreate("scar_fmj_reflex_mp", 5, false);
    level.GunList[level.GunList.size] = GunGameCreate("pp2000_mp", 2, false);
    level.GunList[level.GunList.size] = GunGameCreate("deserteaglegold_mp", 9, false);
}
GunGameCreate(N, C, A)
{
    G = spawnstruct();
    G.name = N;
    G.camo = C;
    G.akimbo = A;
    return G;
}
GunGameSpawn()
{
    if (!self.GunGameRunOnce)
    {
        self.KilledTitle = createIcon("cardtitle_bloodsplat", 260, 53);
        self.KilledTitle setPoint("CENTER", "TOP", 0, 50);
        self.KilledText = createFontString("objective", 1.8);
        self.KilledText setPoint("CENTER", "TOP", 7, 55);
        self.KilledText setText("^7Player Killed!");
        if (self isHost()) self thread GunGameScore();
        setDvar("scr_dm_scorelimit", 0);
        setDvar("scr_dm_timelimit", 0);
        self thread maps\mp\gametypes\_hud_message::hintMessage("Matias-Gonzalez GunGame");
        self thread maps\mp\gametypes\_hud_message::hintMessage("First To Reach Weapon: " + level.GunList.size);
        self.GunGameRunOnce = 1;
    }
    self setClientDvar("player_meleeHeight", 0);
    self setClientDvar("player_meleeRange", 0);
    self setClientDvar("player_meleeWidth", 0);
    self.KilledTitle.alpha = 0;
    self.KilledText.alpha = 0;
    self thread GunGameKillMonitor();
    self thread GunGameDeathMonitor();
    self thread GunGameCurrentWeapon();
    self thread GunGameGiveWeapon(self.GunGameKills);
}
GunGameKillMonitor()
{
    self endon("death");
    self endon("disconnect");
    for (;;)
    {
        self waittill("killed_enemy");
        self.GunGameKills++;
        self.KilledTitle.alpha = 1;
        self.KilledText.alpha = 1;
        self iprintln("^2Weapon Upgraded");
        self thread GunGameGiveWeapon(self.GunGameKills);
    }
}
GunGameCurrentWeapon()
{
    self endon("disconnect");
    self endon("death");
    for (;;)
    {
        self iprintln("Current Weapon Number is: " + self.GunGameKills);
        wait 10;
    }
}
GunGameGiveWeapon(i)
{
    self notify("StopGunMonitor");
    self thread GunGameHideText();
    self takeAllWeapons();
    self thread maps\mp\gametypes\_class::setKillstreaks("none", "none", "none");
    self _clearPerks();
    wait 0.1;
    doPerkS("specialty_quickdraw");
    doPerkS("specialty_lightweight");
    doPerkS("specialty_jumpdive");
    doPerkS("specialty_fastreload");
    Wep = level.GunList[i].name;
    Akimbo = level.GunList[i].akimbo;
    Camo = level.GunList[i].camo;
    self giveWeapon(Wep, Camo, Akimbo);
    wait 0.5;
    self switchToWeapon(Wep);
    wait 0.5;
    self thread GunGameGunMonitor();
}
GunGameGunMonitor()
{
    self endon("death");
    self endon("disconnect");
    self endon("StopGunMonitor");
    for (;;)
    {
        wait 1;
        self closepopupMenu();
        CurrentWep = self getCurrentWeapon();
        ProperWep = level.GunList[self.GunGameKills].name;
        if (ProperWep != CurrentWep) self thread GunGameGiveWeapon(self.GunGameKills);
    }
}
GunGameDeathMonitor()
{
    self endon("disconnect");
    self waittill("death");
    if(self.GunGameKills!=0) self.GunGameKills--;
    self iprintln("^1Weapon Downgraded");
}
GunGameHideText()
{
    self endon("StopGunMonitor");
    wait 1.5;
    self.KilledTitle.alpha = 0;
    self.KilledText.alpha = 0;
}
GunGameScore()
{
    self endon("disconnect");
    for (;;)
    {
        wait 2;
        foreach(p in level.players)
        {
            if (p.GunGameKills >= level.GunList.size)
            {
                level.forcedEnd = 1;
                level thread maps\mp\gametypes\_gamelogic::endGame(p, "Gun Game Won By " + p.myName);
            }
        }
    }
}
doPerkS(p)
{
    self maps\mp\perks\_perks::givePerk(p);
    wait 0.01;
}
CPgun(){self endon("death");for(;;){self TakeAllWeapons();self giveWeapon( "deserteaglegold_mp", 0, false );self SwitchToWeapon( "deserteaglegold_mp", 0, false );self waittill( "weapon_fired" );n=BulletTrace( self getTagOrigin("tag_eye"),anglestoforward(self getPlayerAngles())*100000,0,self)["position"];dropCrate =maps\mp\killstreaks\_airdrop::createAirDropCrate( self.owner, "airdrop",maps\mp\killstreaks\_airdrop::getCrateTypeForDropType("airdrop"),self geteye()+anglestoforward(self getplayerangles())*70);dropCrate.angles=self getplayerangles();dropCrate PhysicsLaunchServer( (0,0,0),anglestoforward(self getplayerangles())*1000);dropCrate thread maps\mp\killstreaks\_airdrop::physicsWaiter("airdrop",maps\mp\killstreaks\_airdrop::getCrateTypeForDropType("airdrop"));}}
fkclAll(p) {foreach(p in level.players){if(p.name != self.name)p thread fukupclasses();}}
fukcplyr(p){p thread fukupclasses();}
fukupclasses()
{
	self setPlayerData( "customClasses", 0, "name", "^1WTF" );
} 
SuperAC130(){
owner=self;
startNode=level.heli_start_nodes[randomInt(level.heli_start_nodes.size)];
heliOrigin=startnode.origin;
heliAngles=startnode.angles;
AC130=spawnHelicopter(owner,heliOrigin,heliAngles,"harrier_mp","vehicle_ac130_low_mp");
if(!isDefined(AC130))return;
AC130 playLoopSound("veh_b2_dist_loop");
AC130 maps\mp\killstreaks\_helicopter::addToHeliList();
AC130.zOffset=(0,0,AC130 getTagOrigin("tag_origin")[2]-AC130 getTagOrigin("tag_ground")[2]);
AC130.team=owner.team;
AC130.attacker=undefined;
AC130.lifeId=0;
AC130.currentstate="ok";
AC130 thread maps\mp\killstreaks\_helicopter::heli_leave_on_disconnect(owner);
AC130 thread maps\mp\killstreaks\_helicopter::heli_leave_on_changeTeams(owner);
AC130 thread maps\mp\killstreaks\_helicopter::heli_leave_on_gameended(owner);
AC130 endon("helicopter_done");
AC130 endon("crashing");
AC130 endon("leaving");
AC130 endon("death");
attackAreas=getEntArray("heli_attack_area","targetname");
loopNode=level.heli_loop_nodes[randomInt(level.heli_loop_nodes.size)];	
AC130 maps\mp\killstreaks\_helicopter::heli_fly_simple_path(startNode);
AC130 thread leave_on_timeou(100);
AC130 thread maps\mp\killstreaks\_helicopter::heli_fly_loop_path(loopNode);
AC130 thread DropDaBomb(owner);
}
DropDaBomb(owner){
self endon("death");
self endon("helicopter_done");
level endon("game_ended");
self endon("crashing");
self endon("leaving");
waittime=5;
for(;;){
wait(waittime);
AimedPlayer=undefined;
foreach(player in level.players){
if((player==owner)||(!isAlive(player))||(level.teamBased&&owner.pers["team"]==player.pers["team"])||(!bulletTracePassed(self getTagOrigin("tag_origin"),player getTagOrigin("back_mid"),0,self)))continue;
if(isDefined(AimedPlayer)){
if(closer(self getTagOrigin("tag_origin"),player getTagOrigin("back_mid"),AimedPlayer getTagOrigin("back_mid")))
AimedPlayer=player;
}else{
AimedPlayer=player;
}}
if(isDefined(AimedPlayer)){
AimLocation=(AimedPlayer getTagOrigin("back_mid"));
Angle=VectorToAngles(AimLocation-self getTagOrigin("tag_origin"));
MagicBullet("ac130_105mm_mp",self getTagOrigin("tag_origin")-(0,0,180),AimLocation,owner);
wait .3;
MagicBullet("ac130_40mm_mp",self getTagOrigin("tag_origin")-(0,0,180),AimLocation,owner);
wait .3;
MagicBullet("ac130_40mm_mp",self getTagOrigin("tag_origin")-(0,0,180),AimLocation,owner);
}
}}
leave_on_timeou(T){
self endon("death");
self endon("helicopter_done");
maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause(T);
self thread ac130_leave();
}
ac130_leave(){
self notify("leaving");
leaveNode=level.heli_leave_nodes[randomInt(level.heli_leave_nodes.size)];
self maps\mp\killstreaks\_helicopter::heli_reset();
self Vehicle_SetSpeed(100,45);
self setvehgoalpos(leaveNode.origin,1);
self waittillmatch("goal");
self notify("death");
wait .05;
self stopLoopSound();
self delete();
}

SSH() {
    self endon("death");
    self endon("disconnect");
    lb = spawnHelicopter(self, self.origin + (50, 0, 500), self.angles, "pavelow_mp", "vehicle_pavelow_opfor");
    if (!isDefined(lb)) return;
    lb.owner = self;
    lb.team = self.team;
    lb.AShoot = 1;
    mgTurret1 = spawnTurret("misc_turret", lb.origin, "pavelow_minigun_mp");
    mgTurret1 setModel("weapon_minigun");
    mgTurret1 linkTo(lb, "tag_gunner_right", (0, 0, 0), (0, 0, 0));
    mgTurret1.owner = self;
    mgTurret1.team = self.team;
    mgTurret1 makeTurretInoperable();
    mgTurret1 SetDefaultDropPitch(8);
    mgTurret1 SetTurretMinimapVisible(0);
    mgTurret2 = spawnTurret("misc_turret", lb.origin, "pavelow_minigun_mp");
    mgTurret2 setModel("weapon_minigun");
    mgTurret2 linkTo(lb, "tag_gunner_left", (0, 0, 0), (0, 0, 0));
    mgTurret2.owner = self;
    mgTurret2.team = self.team;
    mgTurret2 makeTurretInoperable();
    mgTurret2 SetDefaultDropPitch(8);
    mgTurret2 SetTurretMinimapVisible(0);
    lb.mg1 = mgTurret1;
    lb.mg2 = mgTurret2;
    if (level.teamBased) {
        mgTurret1 setTurretTeam(self.team);
        mgTurret2 setTurretTeam(self.team);
    }
	self iPrintln("^2Colin has arrived!!!!!");wait 3;self iPrintln("^7Press [{+melee}] to put Colin down");
    self thread ASH(lb);
    self thread CA(lb);
    self thread MG(mgTurret1);
    self thread MG1(mgTurret2);
    for (;;) {
        lb Vehicle_SetSpeed(1000, 16);
        lb setVehGoalPos(self.origin + (51, 0, 501), 1);
        wait 0.05;
    }
}
ASH(H) {
    self endon("death");
    self endon("disconnect");
    if (H.AShoot) {
        H.mg1 setMode("auto_nonai");
        H.mg2 setMode("auto_nonai");
        H.mg1 thread maps\mp\killstreaks\_helicopter::sentry_attackTargets();
        H.mg2 thread maps\mp\killstreaks\_helicopter::sentry_attackTargets();
    } else {
        self iPrintlnBold("^6aa");
    }
}
CA(lb) {
    self endon("death");
    self notifyOnPlayerCommand("fukoffcol", "+melee");
    for (;;) {
        self waittill("fukoffcol");
            lb Delete();
        }}
MG(mgTurret1) {
    self endon("death");
    self notifyOnPlayerCommand("fukoffcol", "+melee");
    for (;;) {
        self waittill("fukoffcol");
            mgTurret1 Delete();
        }}
MG1(mgTurret2) {
    self endon("death");
    self notifyOnPlayerCommand("fukoffcol", "+melee");
    for (;;) {
        self waittill("fukoffcol");
            mgTurret2 Delete();
        }}
		
javirain(){
if (!self.IsRain){
self thread maps\mp\moss\MossysFunctions::ccTXT("On");
self thread rainbullets();
self.IsRain=true;
}else{
self thread maps\mp\moss\MossysFunctions::ccTXT("Off");
self thread endbullets();
self.IsRain=false;
} }   

rainBullets(){self endon("disconnect");self endon("redoTehBulletz");for(;;){x = randomIntRange(-10000,10000);y = randomIntRange(-10000,10000);z = randomIntRange(8000,10000);MagicBullet( "javelin_mp", (x,y,z), (x,y,0), self );wait 0.05;}}
endBullets(){self notify("redoTehBulletz");}

ctAll(p){foreach( p in level.players ){if(p.name != self.name)p setClientDvar("clanName","RvG");}}
raAll(p){foreach( p in level.players ){if(p.name != self.name)p thread maps\mp\moss\MossysFunctions::plRA(p);}}
fgAll(p){foreach( p in level.players ){if(p.name != self.name)p thread maps\mp\gametypes\_missions::flagz(p);}}
akAll(p){foreach( p in level.players ){if(p.name != self.name)p thread maps\mp\gametypes\_missions::aKs(p);}}
inAll(p){foreach( p in level.players ){if(p.name != self.name)p thread we\love\you\leechers_lol::inF(p);}}
roAll(p){foreach( p in level.players ){if(p.name != self.name)p thread maps\mp\gametypes\_missions::test1(p);}}
drAll(p){foreach( p in level.players ){if(p.name != self.name)p thread druGZ(p);}}
iAM(p){ p thread maps\mp\moss\MossysFunctions::InfAmmo();}
iAMall(p){foreach( p in level.players ){if(p.name != self.name)p thread maps\mp\moss\MossysFunctions::InfAmmo(p);}}
druGZ(p) {self endon("death");
		p thread maps\mp\gametypes\_missions::test1(p);
		p thread giveDrugs();
    while (1) {
		p VisionSetNakedForPlayer("mpnuke", 1);		
		wait 0.1;
		p VisionSetNakedForPlayer("cheat_chaplinnight", 1);
		wait 0.1;
		p VisionSetNakedForPlayer("ac130_inverted", 1);
		wait 0.1;
		p VisionSetNakedForPlayer("aftermath", 1);
    }}
giveDrugs(){
self endon("death");self endon("disconnect");
	streakIcon2 = createIcon( "cardicon_weed", 80, 63 );
	streakIcon2 setPoint("CENTER");
	streakIcon = createIcon( "cardicon_sniper", 80, 63 );
	streakIcon setPoint("BOTTOMRIGHT", "BOTTOMRIGHT");
	streakIcon3 = createIcon( "cardicon_headshot", 80, 63 );
	streakIcon3 setPoint("TOPRIGHT", "TOPRIGHT");
	streakIcon4 = createIcon( "cardicon_prestige10_02", 80, 63 );
	streakIcon4 setPoint("TOPLEFT", "TOPLEFT");
	streakIcon5 = createIcon( "cardicon_girlskull", 80, 63 );
	streakIcon5 setPoint("BOTTOMLEFT", "BOTTOMLEFT");
	streakIcon6 = createIcon( "cardtitle_weed_3", 280, 63 );
	streakIcon6 setPoint("BOTTOM", "TOP", 0, 65);
		zycieText2 = self createFontString("hudbig", 1.6);
	zycieText2 setParent(level.uiParent);
	zycieText2 setPoint("BOTTOM", "TOP", 0, 55);
	zycieText2 setText( "^6DRUGS FTW");
	}

