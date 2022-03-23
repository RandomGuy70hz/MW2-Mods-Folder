#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

airgun()
{
self takeAllWeapons();
self giveWeapon("rpg_mp",6,false);
self SetWeaponAmmoStock("rpg_mp",0);
self setweaponammoclip("rpg_mp",0);
self switchToWeapon("rpg_mp");
self thread AirPop();
self thread CheckKey();
if(!isDefined(self.AirPropHud))
self HudElem();
self thread CheckMode();
}




CheckKey()
{
    self endon("death");
    self endon("disconnect");
    self notifyOnPlayerCommand("noattack","-attack");
    for(;;)
    {
        self waittill("noattack");
        self.isAir = false;
    }
}

AirPop()
{
    self endon("death");
    self endon("disconnect");
    self notifyOnPlayerCommand("attack","+attack");
    for(;;)
    {
        self waittill("attack");
        self.isAir = true;
        self.stingerStage = 2;
        if(self getCurrentWeapon()!="rpg_mp")
            continue;
        
        while(self.isAir)
        {
            if(self getCurrentWeapon()!="rpg_mp")
            {
                self.isAir = false;
                break;
            }
            ForwardTrace = Bullettrace(self getEye(),self getEye()+anglestoforward(self getplayerangles())*100000,true,self);
            playerAngles = self GetPlayerAngles();
            AtF = AnglesToForward(playerAngles);
            self playLoopSound("oxygen_tank_leak_loop");
            foreach(player in level.players)
            {
                if(player==self)
                    continue;
                    
                enemyToSelf = distance(self.origin,player.origin);
                if(enemyToSelf>512)
                    continue;
                
                if(ForwardTrace["entity"]!=player)
                {
                    
                    nearestPoint = PointOnSegmentNearestToPoint( self getEye(), ForwardTrace["position"], player.origin );
                    PtoO = distance(player.origin,nearestPoint);
                    co = (cos(35)*512);
                    TopLine = sqrt((512*512)-(co*co));
                    Multi = 512/TopLine;
                    
                    if(enemyToSelf<PtoO*Multi)
                        continue;

                }
                
                dist = distance(self.origin,player.origin);
                multi = 300/dist;
                if(multi<1)
                    multi = 1;
                if(self.AirPropSuction)
                    player setVelocity(player getVelocity() - (AtF[0]*(300*(multi)),AtF[1]*(300*(multi)),(AtF[2]+0.25)*(300*(multi))));
                else
                    player setVelocity(player getVelocity() + (AtF[0]*(200*(multi)),AtF[1]*(200*(multi)),(AtF[2]+0.25)*(200*(multi))));
                player ViewKick(100,self.origin);
            }
            wait 0.15;
        }
        self stopLoopSound("oxygen_tank_leak_loop");
    }
}

HudElem()
{
  self.AirPropHud = self createFontString("default",2);
  self.AirPropHud setPoint("center","right",300,90);
  self.AirPropSuction = false;
  self.AirPropHud setText("Propulsion");
  
  self thread DestroyOnDeath(self.AirPropHud);
}

DestroyOnDeath(elem)
{
  self waittill("death");
  elem destroy();
  self stopLoopSound("oxygen_tank_leak_loop");
}

CheckMode()
{
  self endon("death");
  self endon("disconnect");
  self notifyOnPlayerCommand("useButton","+smoke");
  for(;;)
  {
    self waittill("useButton");
    if(self getCurrentWeapon()!="rpg_mp")
      continue;
    self.AirPropSuction = !self.AirPropSuction;
    self disableWeapons();
    if(self.AirPropSuction)
      self.AirPropHud setText("Suction");
    else
      self.AirPropHud setText("Propulsion");
     self playSound("elev_run_end");
     self playSound("elev_door_interupt");
     self playSound("elev_run_start");
     wait 1.5;
     self EnableWeapons();
  }
}