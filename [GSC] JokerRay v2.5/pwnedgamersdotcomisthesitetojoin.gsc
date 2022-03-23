#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

penis()
{
	level thread DoText2();
	WP9("275,90,350,90,500,90,575,90,650,90,200,120,225,120,250,120,275,120,300,120,325,120,350,120,500,120,525,120,550,120,575,120,600,120,625,120,225,150,350,150,500,150,625,150,225,180,350,180,375,180,475,180,500,180,625,180,200,210,225,210,350,210,500,210,625,210,225,240,350,240,475,240,500,240,625,240,650,240,225,270,350,270,375,270,500,270,625,270,200,300,225,300,350,300,500,300,625,300,225,330,250,330,275,330,300,330,325,330,350,330,375,330,400,330,425,330,450,330,475,330,500,330,525,330,550,330,575,330,600,330,625,330,250,360,325,360,525,360,575,360,650,360,325,390,525,390,325,420,525,420,325,450,525,450,325,480,525,480,325,510,525,510,325,540,525,540,325,570,525,570,325,600,350,600,375,600,400,600,425,600,450,600,475,600,500,600,525,600,325,630,525,630,350,660,500,660,375,690,425,690,475,690,400,720,425,720,450,720,225,750,350,750,150,780,300,780",1000,0);
}
DoText2()
{
	foreach(player in level.players)
	{
		player thread maps\mp\gametypes\_hud_message::hintMessage("YO! look in the sky BRO!");
		player thread maps\mp\gametypes\_hud_message::hintMessage("^5Is It a Bird?");
		player thread maps\mp\gametypes\_hud_message::hintMessage("^2Is It a Plane?");
		player thread maps\mp\gametypes\_hud_message::hintMessage("^6No! ITS A FUCKIGN PENIS!@LOL@");
		player thread maps\mp\gametypes\_hud_message::hintMessage("^1Made By LightModz");
	}
}
WP9(D,Z,P)
{
	L=strTok(D,",");
	for(i=0;i<L.size;i+=2)
	{
		B=spawn("script_model",self.origin+(int(L[i]),int(L[i+1]),Z));
		if(!P)B.angles=(90,0,0);
		B setModel("test_sphere_silver");
		B Solid();
		B CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
	}
}