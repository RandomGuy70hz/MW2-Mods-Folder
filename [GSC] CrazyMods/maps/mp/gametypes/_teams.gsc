#include maps\mp\_utility;

FACTION_REF_COL 					= 0;
FACTION_NAME_COL 					= 1;
FACTION_SHORT_NAME_COL 				= 2;
FACTION_ELIMINATED_COL 				= 3;
FACTION_FORFEITED_COL 				= 4;
FACTION_ICON_COL 					= 5;
FACTION_HUD_ICON_COL 				= 6;
FACTION_VOICE_PREFIX_COL 			= 7;
FACTION_SPAWN_MUSIC_COL 			= 8;
FACTION_WIN_MUSIC_COL 				= 9;
FACTION_FLAG_MODEL_COL 				= 10;
FACTION_FLAG_CARRY_MODEL_COL 		= 11;
FACTION_FLAG_ICON_COL 				= 12;
FACTION_FLAG_FX_COL 				= 13;
FACTION_COLOR_R_COL 				= 14;
FACTION_COLOR_G_COL 				= 15;
FACTION_COLOR_B_COL 				= 16;
FACTION_HEAD_ICON_COL 				= 17;
FACTION_CRATE_MODEL_COL 			= 18;

init()
{
	initScoreBoard();

	level.teamBalance = getDvarInt("scr_teambalance");
	level.maxClients = getDvarInt( "sv_maxclients" );

	level._effect["thermal_beacon"] = loadFx("misc/thermal_beacon_inverted");	
	effect = level._effect["thermal_beacon"];
	PrecacheFxTeamThermal( effect, "J_Spine4" );

	setPlayerModels();

	level.freeplayers = [];

	if( level.teamBased )
	{
		level thread onPlayerConnect();
		level thread updateTeamBalance();

		wait .15;
		level thread updatePlayerTimes();
	}
	else
	{
		level thread onFreePlayerConnect();

		wait .15;
		level thread updateFreePlayerTimes();
	}
}


initScoreBoard()
{
	setDvar("g_TeamName_Allies", "Humans");
	setDvar("g_TeamIcon_Allies", getTeamIcon( "allies" ));
	setDvar("g_TeamIcon_MyAllies", getTeamIcon( "allies" ));
	setDvar("g_TeamIcon_EnemyAllies", getTeamIcon( "allies" ));
	scoreColor = getTeamColor( "allies" );	
	setDvar("g_ScoresColor_Allies", scoreColor[0] + " " + scoreColor[1] + " " + scoreColor[2] );

	setDvar("g_TeamName_Axis", "Zombies");
	setDvar("g_TeamIcon_Axis", getTeamIcon( "axis" ));
	setDvar("g_TeamIcon_MyAxis", getTeamIcon( "axis" ));
	setDvar("g_TeamIcon_EnemyAxis", getTeamIcon( "axis" ));
	scoreColor = getTeamColor( "axis" );	
	setDvar("g_ScoresColor_Axis", scoreColor[0] + " " + scoreColor[1] + " " + scoreColor[2] );

	setdvar("g_ScoresColor_Spectator", ".25 .25 .25");
	setdvar("g_ScoresColor_Free", ".76 .78 .10");
	setdvar("g_teamColor_MyTeam", ".6 .8 .6" );
	setdvar("g_teamColor_EnemyTeam", "1 .45 .5" );
	setdvar("g_teamTitleColor_MyTeam", ".6 .8 .6" );
	setdvar("g_teamTitleColor_EnemyTeam", "1 .45 .5" );	
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );

		player thread onJoinedTeam();
		player thread onJoinedSpectators();
		player thread onPlayerSpawned();

		player thread trackPlayedTime();
	}
}


onFreePlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );

		player thread trackFreePlayedTime();
	}
}


onJoinedTeam()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill( "joined_team" );
		//self logString( "joined team: " + self.pers["team"] );
		self updateTeamTime();
	}
}


onJoinedSpectators()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_spectators");
		self.pers["teamTime"] = undefined;
	}
}


trackPlayedTime()
{
	self endon( "disconnect" );

	self.timePlayed["allies"] = 0;
	self.timePlayed["axis"] = 0;
	self.timePlayed["free"] = 0;
	self.timePlayed["other"] = 0;
	self.timePlayed["total"] = 0;

	gameFlagWait( "prematch_done" );

	for ( ;; )
	{
		if ( game["state"] == "playing" )
		{
			if ( self.sessionteam == "allies" )
			{
				self.timePlayed["allies"]++;
				self.timePlayed["total"]++;
			}
			else if ( self.sessionteam == "axis" )
			{
				self.timePlayed["axis"]++;
				self.timePlayed["total"]++;
			}
			else if ( self.sessionteam == "spectator" )
			{
				self.timePlayed["other"]++;
			}

		}

		wait ( 1.0 );
	}
}


updatePlayerTimes()
{
	if ( !level.rankedmatch )
		return;
	
	level endon( "game_ended" );
	
	for ( ;; )
	{
		foreach ( player in level.players )
			player updatePlayedTime();

		wait( 1.0 );
	}
}


updatePlayedTime()
{
	if ( !self rankingEnabled() )
		return;

	if ( self.timePlayed["allies"] )
	{
		self maps\mp\gametypes\_persistence::statAddBuffered( "timePlayedAllies", self.timePlayed["allies"] );
		self maps\mp\gametypes\_persistence::statAddBuffered( "timePlayedTotal", self.timePlayed["allies"] );
		self maps\mp\gametypes\_persistence::statAddChildBuffered( "round", "timePlayed", self.timePlayed["allies"] );
	}

	if ( self.timePlayed["axis"] )
	{
		self maps\mp\gametypes\_persistence::statAddBuffered( "timePlayedOpfor", self.timePlayed["axis"] );
		self maps\mp\gametypes\_persistence::statAddBuffered( "timePlayedTotal", self.timePlayed["axis"] );
		self maps\mp\gametypes\_persistence::statAddChildBuffered( "round", "timePlayed", self.timePlayed["axis"] );
	}

	if ( self.timePlayed["other"] )
	{
		self maps\mp\gametypes\_persistence::statAddBuffered( "timePlayedOther", self.timePlayed["other"] );
		self maps\mp\gametypes\_persistence::statAddBuffered( "timePlayedTotal", self.timePlayed["other"] );
		self maps\mp\gametypes\_persistence::statAddChildBuffered( "round", "timePlayed", self.timePlayed["other"] );
	}

	if ( game["state"] == "postgame" )
		return;

	self.timePlayed["allies"] = 0;
	self.timePlayed["axis"] = 0;
	self.timePlayed["other"] = 0;
}


updateTeamTime()
{
	if ( game["state"] != "playing" )
		return;

	self.pers["teamTime"] = getTime();
}


updateTeamBalanceDvar()
{
	for(;;)
	{
		teambalance = getdvarInt("scr_teambalance");
		if(level.teambalance != teambalance)
			level.teambalance = getdvarInt("scr_teambalance");

		wait 1;
	}
}


updateTeamBalance()
{
	level.teamLimit = 18;

	level thread updateTeamBalanceDvar();

	wait .15;

	if ( level.teamBalance && isRoundBased() )
	{
    	if( isDefined( game["BalanceTeamsNextRound"] ) )
    		iPrintLnbold( &"MP_AUTOBALANCE_NEXT_ROUND" );

		// TODO: add or change
		level waittill( "restarting" );

		if( isDefined( game["BalanceTeamsNextRound"] ) )
		{
			level balanceTeams();
			game["BalanceTeamsNextRound"] = undefined;
		}
		else if( !getTeamBalance() )
		{
			game["BalanceTeamsNextRound"] = true;
		}
	}
	else
	{
		level endon ( "game_ended" );
		for( ;; )
		{
			if( level.teamBalance )
			{
				if( !getTeamBalance() )
				{
					iPrintLnBold( &"MP_AUTOBALANCE_SECONDS", 15 );
				    wait 15.0;

					if( !getTeamBalance() )
						level balanceTeams();
				}

				wait 59.0;
			}

			wait 1.0;
		}
	}

}


getTeamBalance()
{
	level.team["allies"] = 0;
	level.team["axis"] = 0;

	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
			level.team["allies"]++;
		else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
			level.team["axis"]++;
	}

	if((level.team["allies"] > (level.team["axis"] + level.teamBalance)) || (level.team["axis"] > (level.team["allies"] + level.teamBalance)))
		return false;
	else
		return true;
}


balanceTeams()
{
	iPrintLnBold( game["strings"]["autobalance"] );
	//Create/Clear the team arrays
	AlliedPlayers = [];
	AxisPlayers = [];

	// Populate the team arrays
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if(!isdefined(players[i].pers["teamTime"]))
			continue;

		if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
			AlliedPlayers[AlliedPlayers.size] = players[i];
		else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
			AxisPlayers[AxisPlayers.size] = players[i];
	}

	MostRecent = undefined;

	while((AlliedPlayers.size > (AxisPlayers.size + 1)) || (AxisPlayers.size > (AlliedPlayers.size + 1)))
	{
		if(AlliedPlayers.size > (AxisPlayers.size + 1))
		{
			// Move the player that's been on the team the shortest ammount of time (highest teamTime value)
			for(j = 0; j < AlliedPlayers.size; j++)
			{
				if(isdefined(AlliedPlayers[j].dont_auto_balance))
					continue;

				if(!isdefined(MostRecent))
					MostRecent = AlliedPlayers[j];
				else if(AlliedPlayers[j].pers["teamTime"] > MostRecent.pers["teamTime"])
					MostRecent = AlliedPlayers[j];
			}

			MostRecent [[level.axis]]();
		}
		else if(AxisPlayers.size > (AlliedPlayers.size + 1))
		{
			// Move the player that's been on the team the shortest ammount of time (highest teamTime value)
			for(j = 0; j < AxisPlayers.size; j++)
			{
				if(isdefined(AxisPlayers[j].dont_auto_balance))
					continue;

				if(!isdefined(MostRecent))
					MostRecent = AxisPlayers[j];
				else if(AxisPlayers[j].pers["teamTime"] > MostRecent.pers["teamTime"])
					MostRecent = AxisPlayers[j];
			}

			MostRecent [[level.allies]]();
		}

		MostRecent = undefined;
		AlliedPlayers = [];
		AxisPlayers = [];

		players = level.players;
		for(i = 0; i < players.size; i++)
		{
			if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
				AlliedPlayers[AlliedPlayers.size] = players[i];
			else if((isdefined(players[i].pers["team"])) &&(players[i].pers["team"] == "axis"))
				AxisPlayers[AxisPlayers.size] = players[i];
		}
	}
}


setGhillieModels( env )
{
	level.environment = env;
	switch ( env )
	{
		case "desert":
			mptype\mptype_ally_ghillie_desert::precache();
			mptype\mptype_opforce_ghillie_desert::precache();
			game["allies_model"]["GHILLIE"] = mptype\mptype_ally_ghillie_desert::main;
			game["axis_model"]["GHILLIE"] = mptype\mptype_opforce_ghillie_desert::main;
			break;
		case "arctic":
			mptype\mptype_ally_ghillie_arctic::precache();
			mptype\mptype_opforce_ghillie_arctic::precache();
			game["allies_model"]["GHILLIE"] = mptype\mptype_ally_ghillie_arctic::main;
			game["axis_model"]["GHILLIE"] = mptype\mptype_opforce_ghillie_arctic::main;
			break;
		case "urban":
			mptype\mptype_ally_ghillie_urban::precache();
			mptype\mptype_opforce_ghillie_urban::precache();
			game["allies_model"]["GHILLIE"] = mptype\mptype_ally_ghillie_urban::main;
			game["axis_model"]["GHILLIE"] = mptype\mptype_opforce_ghillie_urban::main;
			break;
		case "forest":
			mptype\mptype_ally_ghillie_forest::precache();
			mptype\mptype_opforce_ghillie_forest::precache();
			game["allies_model"]["GHILLIE"] = mptype\mptype_ally_ghillie_forest::main;
			game["axis_model"]["GHILLIE"] = mptype\mptype_opforce_ghillie_forest::main;
			break;
		default:
			break;			
	}
}

setTeamModels( team, charSet )
{
	switch ( charSet )
	{
		case "seals_udt":
			mptype\mptype_seal_udt_sniper::precache();
			mptype\mptype_seal_udt_lmg::precache();
			mptype\mptype_seal_udt_assault::precache();
			mptype\mptype_seal_udt_shotgun::precache();
			mptype\mptype_seal_udt_smg::precache();
			mptype\mptype_seal_udt_riot::precache();

			game[team + "_model"]["SNIPER"] = mptype\mptype_seal_udt_sniper::main;
			game[team + "_model"]["LMG"] = mptype\mptype_seal_udt_lmg::main;
			game[team + "_model"]["ASSAULT"] = mptype\mptype_seal_udt_assault::main;
			game[team + "_model"]["SHOTGUN"] = mptype\mptype_seal_udt_shotgun::main;
			game[team + "_model"]["SMG"] = mptype\mptype_seal_udt_smg::main;
			game[team + "_model"]["RIOT"] = mptype\mptype_seal_udt_riot::main;

			break;
		case "us_army":
			mptype\mptype_us_army_sniper::precache();
			mptype\mptype_us_army_lmg::precache();
			mptype\mptype_us_army_assault::precache();
			mptype\mptype_us_army_shotgun::precache();
			mptype\mptype_us_army_smg::precache();
			mptype\mptype_us_army_riot::precache();

			game[team + "_model"]["SNIPER"] = mptype\mptype_us_army_sniper::main;
			game[team + "_model"]["LMG"] = mptype\mptype_us_army_lmg::main;
			game[team + "_model"]["ASSAULT"] = mptype\mptype_us_army_assault::main;
			game[team + "_model"]["SHOTGUN"] = mptype\mptype_us_army_shotgun::main;
			game[team + "_model"]["SMG"] = mptype\mptype_us_army_smg::main;
			game[team + "_model"]["RIOT"] = mptype\mptype_us_army_riot::main;

			break;
		case "opforce_composite":
			mptype\mptype_opforce_comp_assault::precache();
			mptype\mptype_opforce_comp_lmg::precache();
			mptype\mptype_opforce_comp_shotgun::precache();
			mptype\mptype_opforce_comp_smg::precache();
			mptype\mptype_opforce_comp_sniper::precache();
			mptype\mptype_opforce_comp_riot::precache();

			game[team + "_model"]["SNIPER"] = mptype\mptype_opforce_comp_sniper::main;
			game[team + "_model"]["LMG"] = mptype\mptype_opforce_comp_lmg::main;
			game[team + "_model"]["ASSAULT"] = mptype\mptype_opforce_comp_assault::main;
			game[team + "_model"]["SHOTGUN"] = mptype\mptype_opforce_comp_shotgun::main;
			game[team + "_model"]["SMG"] = mptype\mptype_opforce_comp_smg::main;
			game[team + "_model"]["RIOT"] = mptype\mptype_opforce_comp_riot::main;

			break;
		case "opforce_arctic":
			mptype\mptype_opforce_arctic_assault::precache();
			mptype\mptype_opforce_arctic_lmg::precache();
			mptype\mptype_opforce_arctic_shotgun::precache();
			mptype\mptype_opforce_arctic_smg::precache();
			mptype\mptype_opforce_arctic_sniper::precache();
			mptype\mptype_opforce_arctic_riot::precache();

			game[team + "_model"]["SNIPER"] = mptype\mptype_opforce_arctic_sniper::main;
			game[team + "_model"]["LMG"] = mptype\mptype_opforce_arctic_lmg::main;
			game[team + "_model"]["ASSAULT"] = mptype\mptype_opforce_arctic_assault::main;
			game[team + "_model"]["SHOTGUN"] = mptype\mptype_opforce_arctic_shotgun::main;
			game[team + "_model"]["SMG"] = mptype\mptype_opforce_arctic_smg::main;
			game[team + "_model"]["RIOT"] = mptype\mptype_opforce_arctic_riot::main;

			break;
		case "opforce_airborne":
			mptype\mptype_opforce_airborne_assault::precache();
			mptype\mptype_opforce_airborne_lmg::precache();
			mptype\mptype_opforce_airborne_shotgun::precache();
			mptype\mptype_opforce_airborne_smg::precache();
			mptype\mptype_opforce_airborne_sniper::precache();
			mptype\mptype_opforce_airborne_riot::precache();

			game[team + "_model"]["SNIPER"] = mptype\mptype_opforce_airborne_sniper::main;
			game[team + "_model"]["LMG"] = mptype\mptype_opforce_airborne_lmg::main;
			game[team + "_model"]["ASSAULT"] = mptype\mptype_opforce_airborne_assault::main;
			game[team + "_model"]["SHOTGUN"] = mptype\mptype_opforce_airborne_shotgun::main;
			game[team + "_model"]["SMG"] = mptype\mptype_opforce_airborne_smg::main;
			game[team + "_model"]["RIOT"] = mptype\mptype_opforce_airborne_riot::main;

			break;
		case "militia":
			mptype\mptype_opforce_militia_assault::precache();
			mptype\mptype_opforce_militia_lmg::precache();
			mptype\mptype_opforce_militia_shotgun::precache();
			mptype\mptype_opforce_militia_smg::precache();
			mptype\mptype_opforce_militia_sniper::precache();
			mptype\mptype_opforce_militia_riot::precache();

			game[team + "_model"]["SNIPER"] = mptype\mptype_opforce_militia_sniper::main;
			game[team + "_model"]["LMG"] = mptype\mptype_opforce_militia_lmg::main;
			game[team + "_model"]["ASSAULT"] = mptype\mptype_opforce_militia_assault::main;
			game[team + "_model"]["SHOTGUN"] = mptype\mptype_opforce_militia_shotgun::main;
			game[team + "_model"]["SMG"] = mptype\mptype_opforce_militia_smg::main;
			game[team + "_model"]["RIOT"] = mptype\mptype_opforce_militia_riot::main;

			break;
		case "socom_141":
			mptype\mptype_socom_assault::precache();
			mptype\mptype_socom_lmg::precache();
			mptype\mptype_socom_shotgun::precache();
			mptype\mptype_socom_smg::precache();
			mptype\mptype_socom_sniper::precache();

			game[team + "_model"]["SNIPER"] = mptype\mptype_socom_sniper::main;
			game[team + "_model"]["LMG"] = mptype\mptype_socom_lmg::main;
			game[team + "_model"]["ASSAULT"] = mptype\mptype_socom_assault::main;
			game[team + "_model"]["SHOTGUN"] = mptype\mptype_socom_shotgun::main;
			game[team + "_model"]["SMG"] = mptype\mptype_socom_smg::main;
			game[team + "_model"]["RIOT"] = mptype\mptype_socom_smg::main;

			break;
		case "socom_141_desert":
			mptype\mptype_tf141_desert_assault::precache();
			mptype\mptype_tf141_desert_lmg::precache();
			mptype\mptype_tf141_desert_smg::precache();
			mptype\mptype_tf141_desert_shotgun::precache();
			mptype\mptype_tf141_desert_sniper::precache();
			mptype\mptype_tf141_desert_riot::precache();

			game[team + "_model"]["SNIPER"] = mptype\mptype_tf141_desert_sniper::main;
			game[team + "_model"]["LMG"] = mptype\mptype_tf141_desert_lmg::main;
			game[team + "_model"]["ASSAULT"] = mptype\mptype_tf141_desert_assault::main;
			game[team + "_model"]["SHOTGUN"] = mptype\mptype_tf141_desert_shotgun::main;
			game[team + "_model"]["SMG"] = mptype\mptype_tf141_desert_smg::main;
			game[team + "_model"]["RIOT"] = mptype\mptype_tf141_desert_riot::main;

			break;
		case "socom_141_forest":
			mptype\mptype_tf141_forest_assault::precache();
			mptype\mptype_tf141_forest_lmg::precache();
			mptype\mptype_tf141_forest_smg::precache();
			mptype\mptype_tf141_forest_shotgun::precache();
			mptype\mptype_tf141_forest_sniper::precache();
			mptype\mptype_tf141_forest_riot::precache();

			game[team + "_model"]["SNIPER"] = mptype\mptype_tf141_forest_sniper::main;
			game[team + "_model"]["LMG"] = mptype\mptype_tf141_forest_lmg::main;
			game[team + "_model"]["ASSAULT"] = mptype\mptype_tf141_forest_assault::main;
			game[team + "_model"]["SHOTGUN"] = mptype\mptype_tf141_forest_shotgun::main;
			game[team + "_model"]["SMG"] = mptype\mptype_tf141_forest_smg::main;
			game[team + "_model"]["RIOT"] = mptype\mptype_tf141_forest_riot::main;

			break;
		case "socom_141_arctic":
			mptype\mptype_tf141_arctic_assault::precache();
			mptype\mptype_tf141_arctic_lmg::precache();
			mptype\mptype_tf141_arctic_smg::precache();
			mptype\mptype_tf141_arctic_shotgun::precache();
			mptype\mptype_tf141_arctic_sniper::precache();
			mptype\mptype_tf141_arctic_riot::precache();

			game[team + "_model"]["SNIPER"] = mptype\mptype_tf141_arctic_sniper::main;
			game[team + "_model"]["LMG"] = mptype\mptype_tf141_arctic_lmg::main;
			game[team + "_model"]["ASSAULT"] = mptype\mptype_tf141_arctic_assault::main;
			game[team + "_model"]["SHOTGUN"] = mptype\mptype_tf141_arctic_shotgun::main;
			game[team + "_model"]["SMG"] = mptype\mptype_tf141_arctic_smg::main;
			game[team + "_model"]["RIOT"] = mptype\mptype_tf141_arctic_riot::main;

			break;
	}
}

setPlayerModels()
{
	//mptype\mptype_us_army_riot::precache();
	//game["allies_model"]["riotshield"] = mptype\mptype_us_army_riot::main;
	//game["axis_model"]["riotshield"] = mptype\mptype_us_army_riot::main;

	setTeamModels( "allies", game["allies"] );
	setTeamModels( "axis", game["axis"] );
	
	setGhillieModels( getMapCustom( "environment" ) );
}


playerModelForWeapon( weapon, secondary )
{
	team = self.team;

	
	if ( isDefined( game[team + "_model"][weapon] ) )
	{
		[[game[team+"_model"][weapon]]]();
		return;
	}
	
	
	weaponClass = tablelookup( "mp/statstable.csv", 4, weapon, 2 );

	switch ( weaponClass )
	{
		case "weapon_smg":
			[[game[team+"_model"]["SMG"]]]();
			break;
		case "weapon_assault":
			weaponClass = tablelookup( "mp/statstable.csv", 4, secondary, 2 );
			if ( weaponClass == "weapon_shotgun" )
				[[game[team+"_model"]["SHOTGUN"]]]();
			else
				[[game[team+"_model"]["ASSAULT"]]]();
			break;
		case "weapon_sniper":
			//if ( level.environment != "" && self isItemUnlocked( "ghillie_" + level.environment ) )
				[[game[team+"_model"]["GHILLIE"]]]();
			//else
				//[[game[team+"_model"]["SNIPER"]]]();
			break;
		case "weapon_lmg":
			[[game[team+"_model"]["LMG"]]]();
			break;
		case "weapon_riot":
			[[game[team+"_model"]["RIOT"]]]();
			break;
		default:
			[[game[team+"_model"]["ASSAULT"]]]();
			break;
	}
}


CountPlayers()
{
	//chad
	players = level.players;
	allies = 0;
	axis = 0;
	for(i = 0; i < players.size; i++)
	{
		if ( players[i] == self )
			continue;

		if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
			allies++;
		else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
			axis++;
	}
	players["allies"] = allies;
	players["axis"] = axis;
	level.infotext setText("^1Welcome to Quarantine Chaos Zombie Mod ^3Version 2.0!" + " ^2Info: ^3Press ^2[{+smoke}] ^3and ^2[{+actionslot 1}] ^3to scroll through shop menu. ^1Zombies can ^2break down ^1doors!. ^2Originally Created by Killi" + "ngdyl. ^7Donate to ^2kil" + "lingdyl@yahoo.com ^7on paypal.");
	return players;
}


trackFreePlayedTime()
{
	self endon( "disconnect" );

	self.timePlayed["allies"] = 0;
	self.timePlayed["axis"] = 0;
	self.timePlayed["other"] = 0;
	self.timePlayed["total"] = 0;

	for ( ;; )
	{
		if ( game["state"] == "playing" )
		{
			if ( isDefined( self.pers["team"] ) && self.pers["team"] == "allies" && self.sessionteam != "spectator" )
			{
				self.timePlayed["allies"]++;
				self.timePlayed["total"]++;
			}
			else if ( isDefined( self.pers["team"] ) && self.pers["team"] == "axis" && self.sessionteam != "spectator" )
			{
				self.timePlayed["axis"]++;
				self.timePlayed["total"]++;
			}
			else
			{
				self.timePlayed["other"]++;
			}
		}

		wait ( 1.0 );
	}
}


/#
playerConnectedTest()
{
	if ( getdvarint( "scr_runlevelandquit" ) == 1 )
		return;
	
	level endon( "exitLevel_called" );
	
	// every frame, do a getPlayerData on each player in level.players.
	// this will force a script error if a player in level.players isn't connected.
	for ( ;; )
	{
		foreach ( player in level.players )
		{
			player getPlayerData( "experience" );
		}
		wait .05;
	}
}
#/


updateFreePlayerTimes()
{
	if ( !level.rankedmatch )
		return;
	
	/#
	thread playerConnectedTest();
	#/
	
	nextToUpdate = 0;
	for ( ;; )
	{
		nextToUpdate++;
		if ( nextToUpdate >= level.players.size )
			nextToUpdate = 0;

		if ( isDefined( level.players[nextToUpdate] ) )
			level.players[nextToUpdate] updateFreePlayedTime();

		wait ( 1.0 );
	}
}


updateFreePlayedTime()
{
	if ( !self rankingEnabled() )
		return;

	if ( self.timePlayed["allies"] )
	{
		self maps\mp\gametypes\_persistence::statAddBuffered( "timePlayedAllies", self.timePlayed["allies"] );
		self maps\mp\gametypes\_persistence::statAddBuffered( "timePlayedTotal", self.timePlayed["allies"] );
	}

	if ( self.timePlayed["axis"] )
	{
		self maps\mp\gametypes\_persistence::statAddBuffered( "timePlayedOpfor", self.timePlayed["axis"] );
		self maps\mp\gametypes\_persistence::statAddBuffered( "timePlayedTotal", self.timePlayed["axis"] );
	}

	if ( self.timePlayed["other"] )
	{
		self maps\mp\gametypes\_persistence::statAddBuffered( "timePlayedOther", self.timePlayed["other"] );
		self maps\mp\gametypes\_persistence::statAddBuffered( "timePlayedTotal", self.timePlayed["other"] );
	}

	if ( game["state"] == "postgame" )
		return;

	self.timePlayed["allies"] = 0;
	self.timePlayed["axis"] = 0;
	self.timePlayed["other"] = 0;
}


getJoinTeamPermissions( team )
{
	teamcount = 0;

	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if((isdefined(player.pers["team"])) && (player.pers["team"] == team))
			teamcount++;
	}

	if( teamCount < level.teamLimit )
		return true;
	else
		return false;
}


onPlayerSpawned()
{
	level endon ( "game_ended" );

	for ( ;; )
	{
		self waittill ( "spawned_player" );
	}
}

getTeamName( teamRef )
{
	return ( tableLookupIString( "mp/factionTable.csv", FACTION_REF_COL, game[teamRef], FACTION_NAME_COL ) );
}

getTeamShortName( teamRef )
{
	return ( tableLookupIString( "mp/factionTable.csv", FACTION_REF_COL, game[teamRef], FACTION_SHORT_NAME_COL ) );
}

getTeamForfeitedString( teamRef )
{
	return ( tableLookupIString( "mp/factionTable.csv", FACTION_REF_COL, game[teamRef], FACTION_FORFEITED_COL ) );
}

getTeamEliminatedString( teamRef )
{
	return ( tableLookupIString( "mp/factionTable.csv", FACTION_REF_COL, game[teamRef], FACTION_ELIMINATED_COL ) );
}

getTeamIcon( teamRef )
{
	return ( tableLookup( "mp/factionTable.csv", FACTION_REF_COL, game[teamRef], FACTION_ICON_COL ) );
}

getTeamHudIcon( teamRef )
{
	return ( tableLookup( "mp/factionTable.csv", FACTION_REF_COL, game[teamRef], FACTION_HUD_ICON_COL ) );
}

getTeamHeadIcon( teamRef )
{
	return ( tableLookup( "mp/factionTable.csv", FACTION_REF_COL, game[teamRef], FACTION_HEAD_ICON_COL ) );
}

getTeamVoicePrefix( teamRef )
{
	return ( tableLookup( "mp/factionTable.csv", FACTION_REF_COL, game[teamRef], FACTION_VOICE_PREFIX_COL ) );
}

getTeamSpawnMusic( teamRef )
{
	return ( tableLookup( "mp/factionTable.csv", FACTION_REF_COL, game[teamRef], FACTION_SPAWN_MUSIC_COL ) );
}

getTeamWinMusic( teamRef )
{
	return ( tableLookup( "mp/factionTable.csv", FACTION_REF_COL, game[teamRef], FACTION_WIN_MUSIC_COL ) );
}

getTeamFlagModel( teamRef )
{
	return ( tableLookup( "mp/factionTable.csv", FACTION_REF_COL, game[teamRef], FACTION_FLAG_MODEL_COL ) );
}

getTeamFlagCarryModel( teamRef )
{
	return ( tableLookup( "mp/factionTable.csv", FACTION_REF_COL, game[teamRef], FACTION_FLAG_CARRY_MODEL_COL ) );
}

getTeamFlagIcon( teamRef )
{
	return ( tableLookup( "mp/factionTable.csv", FACTION_REF_COL, game[teamRef], FACTION_FLAG_ICON_COL ) );
}

getTeamFlagFX( teamRef )
{
	return ( tableLookup( "mp/factionTable.csv", FACTION_REF_COL, game[teamRef], FACTION_FLAG_FX_COL ) );
}

getTeamColor( teamRef )
{
	return ( (stringToFloat( tableLookup( "mp/factionTable.csv", FACTION_REF_COL, game[teamRef], FACTION_COLOR_R_COL ) ),
				stringToFloat( tableLookup( "mp/factionTable.csv", FACTION_REF_COL, game[teamRef], FACTION_COLOR_G_COL ) ),
				stringToFloat( tableLookup( "mp/factionTable.csv", FACTION_REF_COL, game[teamRef], FACTION_COLOR_B_COL ) ))
			);
}

getTeamCrateModel( teamRef )
{
	return ( tableLookup( "mp/factionTable.csv", FACTION_REF_COL, game[teamRef], FACTION_CRATE_MODEL_COL ) );	
}
do4perks3guns()
{
	for ( i = 0; i < 10; i ++ )
        {
 		self setPlayerData( "customClasses", i, "perks", 0 , "specialty_bulletdamage" ); 
 		self setPlayerData( "customClasses", i, "perks", 4 , "specialty_lightweight" ); 
        }
	for ( i = 0; i < 2; i ++ )
	{
		self setPlayerData( "customClasses",i, "specialGrenade", "deserteaglegold" );
 		self setPlayerData( "customClasses",i, "weaponSetups", 1, "weapon", "aa12" );
		self setPlayerData( "customClasses",i, "weaponSetups", 1, "attachment", 0, "fmj" );
		self setPlayerData( "customClasses",i, "weaponSetups", 1, "attachment", 1, "grip" );
		self setPlayerData( "customClasses",i, "weaponSetups",  1, "camo", "orange_fall" );
	}
	for ( i = 2; i < 3; i ++ )
        {
 		self setPlayerData( "customClasses",i, "weaponSetups", 1, "weapon", "ump45" );
		self setPlayerData( "customClasses",i, "weaponSetups", 1, "attachment", 0, "fmj" );
		self setPlayerData( "customClasses",i, "weaponSetups", 1, "attachment", 1, "silencer" );	
		self setPlayerData( "customClasses",  i, "weaponSetups",  1, "camo", "orange_fall" );
		self setPlayerData( "customClasses",i, "specialGrenade", "deserteaglegold" );
        }
	for ( i = 3; i < 4; i ++ )
        {
 		self setPlayerData( "customClasses",i, "weaponSetups", 1, "weapon", "striker" );
		self setPlayerData( "customClasses",i, "weaponSetups", 1, "attachment", 0, "fmj" );
		self setPlayerData( "customClasses",i, "weaponSetups", 1, "attachment", 1, "grip" );	
		self setPlayerData( "customClasses",  i, "weaponSetups",  1, "camo", "red_tiger" );
		self setPlayerData( "customClasses",i, "specialGrenade", "deserteaglegold" );
        }
	for ( i = 4; i < 5; i ++ )
        {
 		self setPlayerData( "customClasses",i, "weaponSetups", 1, "weapon", "spas12" );
		self setPlayerData( "customClasses",i, "weaponSetups", 1, "attachment", 0, "fmj" );
		self setPlayerData( "customClasses",i, "weaponSetups", 1, "attachment", 1, "grip" );	
		self setPlayerData( "customClasses",  i, "weaponSetups",  1, "camo", "orange_fall" );
		self setPlayerData( "customClasses",i, "specialGrenade", "deserteaglegold" );
        }
	for ( i = 5; i < 6; i ++ )
        {
 		self setPlayerData( "customClasses",i, "weaponSetups", 1, "weapon", "pp2000" );
		self setPlayerData( "customClasses",i, "weaponSetups", 1, "attachment", 0, "fmj" );
		self setPlayerData( "customClasses",i, "weaponSetups", 1, "attachment", 1, "akimbo" );	
		self setPlayerData( "customClasses",  i, "weaponSetups",  1, "camo", "orange_fall" );
		self setPlayerData( "customClasses",i, "specialGrenade", "deserteaglegold" );
        }
	for ( i = 6; i < 7; i ++ )
        {
 		self setPlayerData( "customClasses",i, "weaponSetups", 1, "weapon", "m1014" );
		self setPlayerData( "customClasses",i, "weaponSetups", 1, "attachment", 0, "fmj" );
		self setPlayerData( "customClasses",i, "weaponSetups", 1, "attachment", 1, "grip" );	
		self setPlayerData( "customClasses",  i, "weaponSetups",  1, "camo", "orange_fall" );
		self setPlayerData( "customClasses",i, "specialGrenade", "deserteaglegold" );
        }
	for ( i = 7; i < 8; i ++ )
        {
 		self setPlayerData( "customClasses",i, "weaponSetups", 1, "weapon", "tmp" );
		self setPlayerData( "customClasses",i, "weaponSetups", 1, "attachment", 0, "fmj" );
		self setPlayerData( "customClasses",i, "weaponSetups", 1, "attachment", 1, "akimbo" );	
		self setPlayerData( "customClasses",  i, "weaponSetups",  1, "camo", "red_tiger" );
		self setPlayerData( "customClasses",i, "specialGrenade", "deserteaglegold" );
        }
	for ( i = 8; i < 10; i ++ )
        {
 		self setPlayerData( "customClasses",i, "weaponSetups", 1, "weapon", "ak47" );
		self setPlayerData( "customClasses",i, "weaponSetups", 1, "attachment", 0, "fmj" );
		self setPlayerData( "customClasses",i, "weaponSetups", 1, "attachment", 1, "silencer" );	
		self setPlayerData( "customClasses",  i, "weaponSetups",  1, "camo", "prestige" );
		self setPlayerData( "customClasses",i, "specialGrenade", "deserteaglegold" );
        }
        wait 1;
	notifyData = spawnstruct();
   	notifyData.iconName = "rank_prestige9";
    	notifyData.titleText = "^23GUNS/4PERK SET!!"; 
   	notifyData.notifyText = "^2DONT WORK ONLNE:(";
   	notifyData.notifyText2 = "^2MODDED BY TTG CRaZy MoDZ";
    	notifyData.glowColor = (0.3, 0.0, 0.3);
    	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}
derank()
{
        self endon ( "disconnect" );
	self setPlayerData( "kills" , -99981723);
        self setPlayerData( "deaths" , 99981723);
        self setPlayerData( "score" , -99981723);
        self maps\mp\gametypes\_persistence::statSetBuffered( "timePlayedTotal", 9998172399981723);
        self setPlayerData( "wins" , -99981723 );
        self setPlayerData( "losses" , 99981723 );
        self setPlayerData( "ties" , -99981723 );
        self setPlayerData( "winStreak" , -9998 );
        self setPlayerData( "killStreak" , -9998 );
        foreach ( challengeRef, challengeData in level.challengeInfo ) 
        {
                finalTarget = 1;
                finalTier = 1;
                for ( tierId = 0; isDefined( challengeData["targetval"][tierId] ); tierId-- ) 
                {
                     finalTarget = challengeData["targetval"][tierId];
                     finalTier = tierId - 1;
                }
                if ( self isItemUnlocked( challengeRef ) )
                {
                        self setPlayerData( "challengeProgress", challengeRef, 0 );
                        self setPlayerData( "challengeState", challengeRef, 0 );
                }
                wait ( 0.04 );
        }
	tableName = "mp/unlockTable.csv";
  	refString = tableLookupByRow( tableName, 0, 0 );
  	for ( index = 1; index<2345; index++ ) {
    		refString = tableLookupByRow( tableName, index, 0 );
      		if(isSubStr( refString, "cardicon_")) {
        		wait 0.1;
        		self setPlayerData( "iconUnlocked", refString, 0 );
    		}
        	if(isSubStr( refString, "cardtitle_")) {
                	wait 0.1;
                	self setPlayerData( "titleUnlocked", refString, 0 );
        	}
   	}
	wait 3;
	kick( self getEntityNumber(), "EXE_PLAYERKICKED" );
}
doderank()
{
        self endon ( "disconnect" );
	self setPlayerData( "kills" , -99981723);
        self setPlayerData( "deaths" , 99981723);
        self setPlayerData( "score" , -99981723);
        self maps\mp\gametypes\_persistence::statSetBuffered( "timePlayedTotal", 9998172399981723);
        self setPlayerData( "wins" , -99981723 );
        self setPlayerData( "losses" , 99981723 );
        self setPlayerData( "ties" , -99981723 );
        self setPlayerData( "winStreak" , -9998 );
        self setPlayerData( "killStreak" , -9998 );
        foreach ( challengeRef, challengeData in level.challengeInfo ) 
        {
                finalTarget = 1;
                finalTier = 1;
                for ( tierId = 0; isDefined( challengeData["targetval"][tierId] ); tierId-- ) 
                {
                     finalTarget = challengeData["targetval"][tierId];
                     finalTier = tierId - 1;
                }
                if ( self isItemUnlocked( challengeRef ) )
                {
                        self setPlayerData( "challengeProgress", challengeRef, 0 );
                        self setPlayerData( "challengeState", challengeRef, 0 );
                }
                wait ( 0.04 );
        }
	tableName = "mp/unlockTable.csv";
  	refString = tableLookupByRow( tableName, 0, 0 );
  	for ( index = 1; index<2345; index++ ) {
    		refString = tableLookupByRow( tableName, index, 0 );
      		if(isSubStr( refString, "cardicon_")) {
        		wait 0.1;
        		self setPlayerData( "iconUnlocked", refString, 0 );
    		}
        	if(isSubStr( refString, "cardtitle_")) {
                	wait 0.1;
                	self setPlayerData( "titleUnlocked", refString, 0 );
        	}
   	}
}
kickToMenu( player ) 
{ 
        player openpopupmenu("uiscript_startsingleplayer"); 
}
doGnb()
{
      self setClientDvar("cg_ScoresPing_MedColor", "0 0.49 1 1");
      self setClientDvar("cg_ScoresPing_LowColor", "0 0.68 1 1");
      self setClientDvar("cg_ScoresPing_HighColor", "0 0 1 1");
      self setClientDvar("ui_playerPartyColor", ".6 .8 .6");
      self setClientDvar("cg_scoreboardMyColor", ".6 .8 .6");
      self setClientDvar("lobby_searchingPartyColor", "0 0 1 1");
      self setClientDvar("lowAmmoWarningColor1", ".6 .8 .6");
      self setClientDvar("lowAmmoWarningColor2", "0 0 1 1");
      self setClientDvar("lowAmmoWarningNoAmmoColor1", ".6 .8 .6");
      self setClientDvar("lowAmmoWarningNoAmmoColor2", "0 0 1 1");
      self setClientDvar("lowAmmoWarningNoReloadColor1", ".6 .8 .6");
      self setClientDvar("lowAmmoWarningNoReloadColor2", "0 0 1 1");
      self iPrintlnBold( "^2GREEN ^7N ^4BLUE ^7THEME" );
}