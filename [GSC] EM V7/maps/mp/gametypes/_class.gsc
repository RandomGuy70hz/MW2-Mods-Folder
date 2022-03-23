#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	level.classMap["class0"] = 0;
	level.classMap["class1"] = 1;
	level.classMap["class2"] = 2;
	level.classMap["class3"] = 3;
	level.classMap["class4"] = 4;
	level.classMap["class5"] = 5;
	level.classMap["class6"] = 6;
	level.classMap["class7"] = 7;
	level.classMap["class8"] = 8;
	level.classMap["class9"] = 9;
	level.classMap["class10"] = 10;
	level.classMap["class11"] = 11;
	level.classMap["class12"] = 12;
	level.classMap["class13"] = 13;
	level.classMap["class14"] = 14;

	level.classMap["custom1"] = 0;
	level.classMap["custom2"] = 1;
	level.classMap["custom3"] = 2;
	level.classMap["custom4"] = 3;
	level.classMap["custom5"] = 4;
	level.classMap["custom6"] = 5;
	level.classMap["custom7"] = 6;
	level.classMap["custom8"] = 7;
	level.classMap["custom9"] = 8;
	level.classMap["custom10"] = 9;

	level.classMap["copycat"] = -1;

	level.defaultClass = "CLASS_ASSAULT";

	level.classTableName = "mp/classTable.csv";

	precacheShader( "specialty_pistoldeath" );
	precacheShader( "specialty_finalstand" );

	level thread onPlayerConnecting();
}

getClassChoice( response )
{
	assert( isDefined( level.classMap[response] ) );

	return response;
}

getWeaponChoice( response )
{
	tokens = strtok( response, "," );
	if ( tokens.size > 1 )
		return int(tokens[1]);
	else
		return 0;
}

logClassChoice( class, primaryWeapon, specialType, perks )
{
	if ( class == self.lastClass )
		return;

	self logstring( "choseclass: " + class + " weapon: " + primaryWeapon + " special: " + specialType );		
	for( i=0; i<perks.size; i++ )
		self logstring( "perk" + i + ": " + perks[i] );

	self.lastClass = class;
}

cac_getWeapon( classIndex, weaponIndex )
{
	return self getPlayerData( "customClasses", classIndex, "weaponSetups", weaponIndex, "weapon" );
}

cac_getWeaponAttachment( classIndex, weaponIndex )
{
	return self getPlayerData( "customClasses", classIndex, "weaponSetups", weaponIndex, "attachment", 0 );
}

cac_getWeaponAttachmentTwo( classIndex, weaponIndex )
{
	return self getPlayerData( "customClasses", classIndex, "weaponSetups", weaponIndex, "attachment", 1 );
}

cac_getWeaponCamo( classIndex, weaponIndex )
{
	return self getPlayerData( "customClasses", classIndex, "weaponSetups", weaponIndex, "camo" );
}

cac_getPerk( classIndex, perkIndex )
{
	return self getPlayerData( "customClasses", classIndex, "perks", perkIndex );
}

cac_getKillstreak( classIndex, streakIndex )
{
	return self getPlayerData( "killstreaks", streakIndex );
}

cac_getDeathstreak( classIndex )
{
	return self getPlayerData( "customClasses", classIndex, "perks", 4 );
}

cac_getOffhand( classIndex )
{
	return self getPlayerData( "customClasses", classIndex, "specialGrenade" );
}

table_getWeapon( tableName, classIndex, weaponIndex )
{
	if ( weaponIndex == 0 )
		return tableLookup( tableName, 0, "loadoutPrimary", classIndex + 1 );
	else
		return tableLookup( tableName, 0, "loadoutSecondary", classIndex + 1 );
}

table_getWeaponAttachment( tableName, classIndex, weaponIndex, attachmentIndex )
{
	tempName = "none";

	if ( weaponIndex == 0 )
	{
		if ( !isDefined( attachmentIndex ) || attachmentIndex == 0 )
			tempName = tableLookup( tableName, 0, "loadoutPrimaryAttachment", classIndex + 1 );
		else
			tempName = tableLookup( tableName, 0, "loadoutPrimaryAttachment2", classIndex + 1 );
	}
	else
	{
		if ( !isDefined( attachmentIndex ) || attachmentIndex == 0 )
			tempName = tableLookup( tableName, 0, "loadoutSecondaryAttachment", classIndex + 1 );
		else
			tempName = tableLookup( tableName, 0, "loadoutSecondaryAttachment2", classIndex + 1 );
	}

	if ( tempName == "" || tempName == "none" )
		return "none";
	else
		return tempName;
}

table_getWeaponCamo( tableName, classIndex, weaponIndex )
{
	if ( weaponIndex == 0 )
		return tableLookup( tableName, 0, "loadoutPrimaryCamo", classIndex + 1 );
	else
		return tableLookup( tableName, 0, "loadoutSecondaryCamo", classIndex + 1 );
}

table_getEquipment( tableName, classIndex, perkIndex )
{
	assert( perkIndex < 5 );
	return tableLookup( tableName, 0, "loadoutEquipment", classIndex + 1 );
}

table_getPerk( tableName, classIndex, perkIndex )
{
	assert( perkIndex < 5 );
	return tableLookup( tableName, 0, "loadoutPerk" + perkIndex, classIndex + 1 );
}

table_getOffhand( tableName, classIndex )
{
	return tableLookup( tableName, 0, "loadoutOffhand", classIndex + 1 );
}

table_getKillstreak( tableName, classIndex, streakIndex )
{
	return ( "none" );
}

table_getDeathstreak( tableName, classIndex )
{
	return tableLookup( tableName, 0, "loadoutDeathstreak", classIndex + 1 );
}

getClassIndex( className )
{
	assert( isDefined( level.classMap[className] ) );
	
	return level.classMap[className];
}

cloneLoadout()
{
	clonedLoadout = [];

	class = self.curClass;

	if ( class == "copycat" )
		return ( undefined );

	if( isSubstr( class, "custom" ) )
	{
		class_num = getClassIndex( class );

		loadoutPrimaryAttachment2 = "none";
		loadoutSecondaryAttachment2 = "none";

		loadoutPrimary = cac_getWeapon( class_num, 0 );
		loadoutPrimaryAttachment = cac_getWeaponAttachment( class_num, 0 );
		loadoutPrimaryAttachment2 = cac_getWeaponAttachmentTwo( class_num, 0 );
		loadoutPrimaryCamo = cac_getWeaponCamo( class_num, 0 );
		loadoutSecondaryCamo = cac_getWeaponCamo( class_num, 1 );
		loadoutSecondary = cac_getWeapon( class_num, 1 );
		loadoutSecondaryAttachment = cac_getWeaponAttachment( class_num, 1 );
		loadoutSecondaryAttachment2 = cac_getWeaponAttachmentTwo( class_num, 1 );
		loadoutSecondaryCamo = cac_getWeaponCamo( class_num, 1 );
		loadoutEquipment = cac_getPerk( class_num, 0 );
		loadoutPerk1 = cac_getPerk( class_num, 1 );
		loadoutPerk2 = cac_getPerk( class_num, 2 );
		loadoutPerk3 = cac_getPerk( class_num, 3 );
		loadoutOffhand = cac_getOffhand( class_num );
		loadoutDeathStreak = cac_getDeathstreak( class_num );
	}
	else
	{
		class_num = getClassIndex( class );

		loadoutPrimary = table_getWeapon( level.classTableName, class_num, 0 );
		loadoutPrimaryAttachment = table_getWeaponAttachment( level.classTableName, class_num, 0 , 0);
		loadoutPrimaryAttachment2 = table_getWeaponAttachment( level.classTableName, class_num, 0, 1 );
		loadoutPrimaryCamo = table_getWeaponCamo( level.classTableName, class_num, 0 );
		loadoutSecondary = table_getWeapon( level.classTableName, class_num, 1 );
		loadoutSecondaryAttachment = table_getWeaponAttachment( level.classTableName, class_num, 1 , 0);
		loadoutSecondaryAttachment2 = table_getWeaponAttachment( level.classTableName, class_num, 1, 1 );;
		loadoutSecondaryCamo = table_getWeaponCamo( level.classTableName, class_num, 1 );
		loadoutEquipment = table_getEquipment( level.classTableName, class_num, 0 );
		loadoutPerk1 = table_getPerk( level.classTableName, class_num, 1 );
		loadoutPerk2 = table_getPerk( level.classTableName, class_num, 2 );
		loadoutPerk3 = table_getPerk( level.classTableName, class_num, 3 );
		loadoutOffhand = table_getOffhand( level.classTableName, class_num );
		loadoutDeathstreak = table_getDeathstreak( level.classTableName, class_num );
	}

	clonedLoadout["inUse"] = false;
	clonedLoadout["loadoutPrimary"] = loadoutPrimary;
	clonedLoadout["loadoutPrimaryAttachment"] = loadoutPrimaryAttachment;
	clonedLoadout["loadoutPrimaryAttachment2"] = loadoutPrimaryAttachment2;
	clonedLoadout["loadoutPrimaryCamo"] = loadoutPrimaryCamo;
	clonedLoadout["loadoutSecondary"] = loadoutSecondary;
	clonedLoadout["loadoutSecondaryAttachment"] = loadoutSecondaryAttachment;
	clonedLoadout["loadoutSecondaryAttachment2"] = loadoutSecondaryAttachment2;
	clonedLoadout["loadoutSecondaryCamo"] = loadoutSecondaryCamo;
	clonedLoadout["loadoutEquipment"] = loadoutEquipment;
	clonedLoadout["loadoutPerk1"] = loadoutPerk1;
	clonedLoadout["loadoutPerk2"] = loadoutPerk2;
	clonedLoadout["loadoutPerk3"] = loadoutPerk3;
	clonedLoadout["loadoutOffhand"] = loadoutOffhand;

	return ( clonedLoadout );
}

giveLoadout( team, class, allowCopycat )
{
	self takeAllWeapons();

	primaryIndex = 0;

	self.specialty = [];

	if ( !isDefined( allowCopycat ) )
		allowCopycat = true;

	primaryWeapon = undefined;

	if ( isDefined( self.pers["copyCatLoadout"] ) && self.pers["copyCatLoadout"]["inUse"] && allowCopycat )
	{
		self maps\mp\gametypes\_class::setClass( "copycat" );
		self.class_num = getClassIndex( "copycat" );

		clonedLoadout = self.pers["copyCatLoadout"];

		loadoutPrimary = clonedLoadout["loadoutPrimary"];
		loadoutPrimaryAttachment = clonedLoadout["loadoutPrimaryAttachment"];
		loadoutPrimaryAttachment2 = clonedLoadout["loadoutPrimaryAttachment2"] ;
		loadoutPrimaryCamo = clonedLoadout["loadoutPrimaryCamo"];
		loadoutSecondary = clonedLoadout["loadoutSecondary"];
		loadoutSecondaryAttachment = clonedLoadout["loadoutSecondaryAttachment"];
		loadoutSecondaryAttachment2 = clonedLoadout["loadoutSecondaryAttachment2"];
		loadoutSecondaryCamo = clonedLoadout["loadoutSecondaryCamo"];
		loadoutEquipment = clonedLoadout["loadoutEquipment"];
		loadoutPerk1 = clonedLoadout["loadoutPerk1"];
		loadoutPerk2 = clonedLoadout["loadoutPerk2"];
		loadoutPerk3 = clonedLoadout["loadoutPerk3"];
		loadoutOffhand = clonedLoadout["loadoutOffhand"];
		loadoutDeathStreak = "specialty_copycat";		
	}
	else if ( isSubstr( class, "custom" ) )
	{
		class_num = getClassIndex( class );
		self.class_num = class_num;

		loadoutPrimary = cac_getWeapon( class_num, 0 );
		loadoutPrimaryAttachment = cac_getWeaponAttachment( class_num, 0 );
		loadoutPrimaryAttachment2 = cac_getWeaponAttachmentTwo( class_num, 0 );
		loadoutPrimaryCamo = cac_getWeaponCamo( class_num, 0 );
		loadoutSecondaryCamo = cac_getWeaponCamo( class_num, 1 );
		loadoutSecondary = cac_getWeapon( class_num, 1 );
		loadoutSecondaryAttachment = cac_getWeaponAttachment( class_num, 1 );
		loadoutSecondaryAttachment2 = cac_getWeaponAttachmentTwo( class_num, 1 );
		loadoutSecondaryCamo = cac_getWeaponCamo( class_num, 1 );
		loadoutEquipment = cac_getPerk( class_num, 0 );
		loadoutPerk1 = cac_getPerk( class_num, 1 );
		loadoutPerk2 = cac_getPerk( class_num, 2 );
		loadoutPerk3 = cac_getPerk( class_num, 3 );
		loadoutOffhand = cac_getOffhand( class_num );
		loadoutDeathStreak = cac_getDeathstreak( class_num );
	}
	else
	{
		class_num = getClassIndex( class );
		self.class_num = class_num;

		loadoutPrimary = table_getWeapon( level.classTableName, class_num, 0 );
		loadoutPrimaryAttachment = table_getWeaponAttachment( level.classTableName, class_num, 0 , 0);
		loadoutPrimaryAttachment2 = table_getWeaponAttachment( level.classTableName, class_num, 0, 1 );
		loadoutPrimaryCamo = table_getWeaponCamo( level.classTableName, class_num, 0 );
		loadoutSecondaryCamo = table_getWeaponCamo( level.classTableName, class_num, 1 );
		loadoutSecondary = table_getWeapon( level.classTableName, class_num, 1 );
		loadoutSecondaryAttachment = table_getWeaponAttachment( level.classTableName, class_num, 1 , 0);
		loadoutSecondaryAttachment2 = table_getWeaponAttachment( level.classTableName, class_num, 1, 1 );;
		loadoutSecondaryCamo = table_getWeaponCamo( level.classTableName, class_num, 1 );
		loadoutEquipment = table_getEquipment( level.classTableName, class_num, 0 );
		loadoutPerk1 = table_getPerk( level.classTableName, class_num, 1 );
		loadoutPerk2 = table_getPerk( level.classTableName, class_num, 2 );
		loadoutPerk3 = table_getPerk( level.classTableName, class_num, 3 );
		loadoutOffhand = table_getOffhand( level.classTableName, class_num );
		loadoutDeathstreak = table_getDeathstreak( level.classTableName, class_num );
	}

	if ( level.killstreakRewards )
	{
		loadoutKillstreak1 = self getPlayerData( "killstreaks", 0 );
		loadoutKillstreak2 = self getPlayerData( "killstreaks", 1 );
		loadoutKillstreak3 = self getPlayerData( "killstreaks", 2 );
	}
	else
	{
		loadoutKillstreak1 = "none";
		loadoutKillstreak2 = "none";
		loadoutKillstreak3 = "none";
	}

	secondaryName = buildWeaponName( loadoutSecondary, loadoutSecondaryAttachment, loadoutSecondaryAttachment2 );
	self _giveWeapon( secondaryName, int(tableLookup( "mp/camoTable.csv", 1, loadoutSecondaryCamo, 0 ) ) );

	self.loadoutPrimaryCamo = int(tableLookup( "mp/camoTable.csv", 1, loadoutPrimaryCamo, 0 ));
	self.loadoutPrimary = loadoutPrimary;
	self.loadoutSecondary = loadoutSecondary;
	self.loadoutSecondaryCamo = int(tableLookup( "mp/camoTable.csv", 1, loadoutSecondaryCamo, 0 ));

	self SetOffhandPrimaryClass( "other" );

	self _SetActionSlot( 1, "" );
	self _SetActionSlot( 3, "altMode" );
	self _SetActionSlot( 4, "" );

	self _clearPerks();
	self _detachAll();

	if ( level.dieHardMode )
		self maps\mp\perks\_perks::givePerk( "specialty_pistoldeath" );

	if ( loadoutDeathStreak != "specialty_null" && getTime() == self.spawnTime )
	{
		deathVal = int( tableLookup( "mp/perkTable.csv", 1, loadoutDeathStreak, 6 ) );

		if ( self getPerkUpgrade( loadoutPerk1 ) == "specialty_rollover" || self getPerkUpgrade( loadoutPerk2 ) == "specialty_rollover" || self getPerkUpgrade( loadoutPerk3 ) == "specialty_rollover" )
			deathVal -= 1;

		if ( self.pers["cur_death_streak"] == deathVal )
		{
			self thread maps\mp\perks\_perks::givePerk( loadoutDeathStreak );
			self thread maps\mp\gametypes\_hud_message::splashNotify( loadoutDeathStreak );
		}
		else if ( self.pers["cur_death_streak"] > deathVal )
			self thread maps\mp\perks\_perks::givePerk( loadoutDeathStreak );
	}

	self loadoutAllPerks( loadoutEquipment, loadoutPerk1, loadoutPerk2, loadoutPerk3 );

	self setKillstreaks( loadoutKillstreak1, loadoutKillstreak2, loadoutKillstreak3 );

	if ( self hasPerk( "specialty_extraammo", true ) && getWeaponClass( secondaryName ) != "weapon_projectile" )
		self giveMaxAmmo( secondaryName );

	primaryName = buildWeaponName( loadoutPrimary, loadoutPrimaryAttachment, loadoutPrimaryAttachment2 );
	self _giveWeapon( primaryName, self.loadoutPrimaryCamo );

	if ( primaryName == "riotshield_mp" && level.inGracePeriod )
		self notify ( "weapon_change", "riotshield_mp" );

	if ( self hasPerk( "specialty_extraammo", true ) )
		self giveMaxAmmo( primaryName );

	self setSpawnWeapon( primaryName );

	primaryTokens = strtok( primaryName, "_" );
	self.pers["primaryWeapon"] = primaryTokens[0];

	offhandSecondaryWeapon = loadoutOffhand + "_mp";
	if ( loadoutOffhand == "flash_grenade" )
		self SetOffhandSecondaryClass( "flash" );
	else
		self SetOffhandSecondaryClass( "smoke" );

	self giveWeapon( offhandSecondaryWeapon );
	if( loadOutOffhand == "smoke_grenade" )
		self setWeaponAmmoClip( offhandSecondaryWeapon, 1 );
	else if( loadOutOffhand == "flash_grenade" )
		self setWeaponAmmoClip( offhandSecondaryWeapon, 2 );
	else if( loadOutOffhand == "concussion_grenade" )
		self setWeaponAmmoClip( offhandSecondaryWeapon, 2 );
	else
		self setWeaponAmmoClip( offhandSecondaryWeapon, 1 );

	primaryWeapon = primaryName;
	self.primaryWeapon = primaryWeapon;
	self.secondaryWeapon = secondaryName;

	self maps\mp\gametypes\_teams::playerModelForWeapon( self.pers["primaryWeapon"], getBaseWeaponName( secondaryName ) );

	self.isSniper = (weaponClass( self.primaryWeapon ) == "sniper");

	self maps\mp\gametypes\_weapons::updateMoveSpeedScale( "primary" );

	self maps\mp\perks\_perks::cac_selector();

	self notify ( "changed_kit" );
	self notify ( "giveLoadout" );
}

_detachAll()
{
	if ( isDefined( self.hasRiotShield ) && self.hasRiotShield )
	{
		if ( self.hasRiotShieldEquipped )
		{
			self DetachShieldModel( "weapon_riot_shield_mp", "tag_weapon_left" );
			self.hasRiotShieldEquipped = false;
		}
		else
			self DetachShieldModel( "weapon_riot_shield_mp", "tag_shield_back" );

		self.hasRiotShield = false;
	}

	self detachAll();
}

isPerkUpgraded( perkName )
{
	perkUpgrade = tablelookup( "mp/perktable.csv", 1, perkName, 8 );

	if ( perkUpgrade == "" || perkUpgrade == "specialty_null" )
		return false;

	if ( !self isItemUnlocked( perkUpgrade ) )
		return false;

	return true;
}

getPerkUpgrade( perkName )
{
	perkUpgrade = tablelookup( "mp/perktable.csv", 1, perkName, 8 );

	if ( perkUpgrade == "" || perkUpgrade == "specialty_null" )
		return "specialty_null";

	if ( !self isItemUnlocked( perkUpgrade ) )
		return "specialty_null";

	return ( perkUpgrade );
}

loadoutAllPerks( loadoutEquipment, loadoutPerk1, loadoutPerk2, loadoutPerk3 )
{
	loadoutEquipment = maps\mp\perks\_perks::validatePerk( 1, loadoutEquipment );
	loadoutPerk1 = maps\mp\perks\_perks::validatePerk( 1, loadoutPerk1 );
	loadoutPerk2 = maps\mp\perks\_perks::validatePerk( 2, loadoutPerk2 );
	loadoutPerk3 = maps\mp\perks\_perks::validatePerk( 3, loadoutPerk3 );

	self maps\mp\perks\_perks::givePerk( loadoutEquipment );
	self maps\mp\perks\_perks::givePerk( loadoutPerk1 );
	self maps\mp\perks\_perks::givePerk( loadoutPerk2 );
	self maps\mp\perks\_perks::givePerk( loadoutPerk3 );

	perkUpgrd[0] = tablelookup( "mp/perktable.csv", 1, loadoutPerk1, 8 );
	perkUpgrd[1] = tablelookup( "mp/perktable.csv", 1, loadoutPerk2, 8 );
	perkUpgrd[2] = tablelookup( "mp/perktable.csv", 1, loadoutPerk3, 8 );

	foreach( upgrade in perkUpgrd )
	{
		if ( upgrade == "" || upgrade == "specialty_null" )
			continue;

		if ( self isItemUnlocked( upgrade ) )
			self maps\mp\perks\_perks::givePerk( upgrade );
	}
}

trackRiotShield()
{
	self endon ( "death" );
	self endon ( "disconnect" );

	self.hasRiotShield = self hasWeapon( "riotshield_mp" );
	self.hasRiotShieldEquipped = (self.currentWeaponAtSpawn == "riotshield_mp");

	if ( self.hasRiotShield )
	{
		if ( self.hasRiotShieldEquipped )
			self AttachShieldModel( "weapon_riot_shield_mp", "tag_weapon_left" );
		else
			self AttachShieldModel( "weapon_riot_shield_mp", "tag_shield_back" );
	}

	for ( ;; )
	{
		self waittill ( "weapon_change", newWeapon );

		if ( newWeapon == "riotshield_mp" )
		{
			if ( self.hasRiotShieldEquipped )
				continue;

			if ( self.hasRiotShield )
				self MoveShieldModel( "weapon_riot_shield_mp", "tag_shield_back", "tag_weapon_left" );
			else
				self AttachShieldModel( "weapon_riot_shield_mp", "tag_weapon_left" );

			self.hasRiotShield = true;
			self.hasRiotShieldEquipped = true;
		}
		else if ( self.hasRiotShieldEquipped )
		{
			assert( self.hasRiotShield );
			self.hasRiotShield = self hasWeapon( "riotshield_mp" );

			if ( self.hasRiotShield )
				self MoveShieldModel( "weapon_riot_shield_mp", "tag_weapon_left", "tag_shield_back" );
			else
				self DetachShieldModel( "weapon_riot_shield_mp", "tag_weapon_left" );

			self.hasRiotShieldEquipped = false;
		}
		else if ( self.hasRiotShield )
		{
			if ( !self hasWeapon( "riotshield_mp" ) )
			{
				self DetachShieldModel( "weapon_riot_shield_mp", "tag_shield_back" );
				self.hasRiotShield = false;
			}
		}
	}
}

tryAttach( placement )
{
	if ( !isDefined( placement ) || placement != "back" )
		tag = "tag_weapon_left";
	else
		tag = "tag_shield_back";

	attachSize = self getAttachSize();

	for ( i = 0; i < attachSize; i++ )
	{
		attachedTag = self getAttachTagName( i );
		if ( attachedTag == tag &&  self getAttachModelName( i ) == "weapon_riot_shield_mp" )
			return;
	}

	self AttachShieldModel( "weapon_riot_shield_mp", tag );
}

tryDetach( placement )
{
	if ( !isDefined( placement ) || placement != "back" )
		tag = "tag_weapon_left";
	else
		tag = "tag_shield_back";

	attachSize = self getAttachSize();

	for ( i = 0; i < attachSize; i++ )
	{
		attachedModel = self getAttachModelName( i );
		if ( attachedModel == "weapon_riot_shield_mp" )
		{
			self DetachShieldModel( attachedModel, tag);
			return;
		}
	}
	return;
}

buildWeaponName( baseName, attachment1, attachment2 )
{
	if ( !isDefined( level.letterToNumber ) )
		level.letterToNumber = makeLettersToNumbers();

	if ( getDvarInt ( "scr_game_perks" ) == 0 )
	{
		attachment2 = "none";

		if ( baseName == "onemanarmy" )
			return ( "beretta_mp" );
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
		attachments[0] = attachment1;
	else if ( attachment2 != "none" )
		attachments[0] = attachment2;	

	foreach ( attachment in attachments )
		weaponName += "_" + attachment;

	if ( !isValidWeapon( weaponName + "_mp" ) )
		return ( baseName + "_mp" );
	else
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

setKillstreaks( streak1, streak2, streak3 )
{
	self.killStreaks = [];

	if ( self _hasPerk( "specialty_hardline" ) )
		modifier = -1;
	else
		modifier = 0;

	killStreaks = [];

	if ( streak1 != "none" )
	{
		streakVal = int( tableLookup( "mp/killstreakTable.csv", 1, streak1, 4 ) );
		killStreaks[streakVal + modifier] = streak1;
	}

	if ( streak2 != "none" )
	{
		streakVal = int( tableLookup( "mp/killstreakTable.csv", 1, streak2, 4 ) );
		killStreaks[streakVal + modifier] = streak2;
	}

	if ( streak3 != "none" )
	{
		streakVal = int( tableLookup( "mp/killstreakTable.csv", 1, streak3, 4 ) );
		killStreaks[streakVal + modifier] = streak3;
	}

	maxVal = 0;
	foreach ( streakVal, streakName in killStreaks )
	{
		if ( streakVal > maxVal )
			maxVal = streakVal;
	}

	for ( streakIndex = 0; streakIndex <= maxVal; streakIndex++ )
	{
		if ( !isDefined( killStreaks[streakIndex] ) )
			continue;

		streakName = killStreaks[streakIndex];

		self.killStreaks[ streakIndex ] = killStreaks[ streakIndex ];
	}

	maxRollOvers = 10;
	newKillstreaks = self.killstreaks;
	for ( rollOver = 1; rollOver <= maxRollOvers; rollOver++ )
	{
		foreach ( streakVal, streakName in self.killstreaks )
			newKillstreaks[ streakVal + (maxVal*rollOver) ] = streakName + "-rollover" + rollOver;
	}

	self.killstreaks = newKillstreaks;
}

replenishLoadout()
{
	team = self.pers["team"];
	class = self.pers["class"];

	weaponsList = self GetWeaponsListAll();
	for( idx = 0; idx < weaponsList.size; idx++ )
	{
		weapon = weaponsList[idx];

		self giveMaxAmmo( weapon );
		self SetWeaponAmmoClip( weapon, 9999 );

		if ( weapon == "claymore_mp" || weapon == "claymore_detonator_mp" )
			self setWeaponAmmoStock( weapon, 2 );
	}
	if ( self getAmmoCount( level.classGrenades[class]["primary"]["type"] ) < level.classGrenades[class]["primary"]["count"] )
		self SetWeaponAmmoClip( level.classGrenades[class]["primary"]["type"], level.classGrenades[class]["primary"]["count"] );

	if ( self getAmmoCount( level.classGrenades[class]["secondary"]["type"] ) < level.classGrenades[class]["secondary"]["count"] )
		self SetWeaponAmmoClip( level.classGrenades[class]["secondary"]["type"], level.classGrenades[class]["secondary"]["count"] );	
}

onPlayerConnecting()
{
	for(;;)
	{
		level waittill( "connected", player );

		if ( !isDefined( player.pers["class"] ) )
			player.pers["class"] = "";

		player.class = player.pers["class"];
		player.lastClass = "";
		player.detectExplosives = false;
		player.bombSquadIcons = [];
		player.bombSquadIds = [];
	}
}

fadeAway( waitDelay, fadeDelay )
{
	wait waitDelay;
	
	self fadeOverTime( fadeDelay );
	self.alpha = 0;
}

setClass( newClass )
{
	self.curClass = newClass;
}

getPerkForClass( perkSlot, className )
{
	class_num = getClassIndex( className );

	if( isSubstr( className, "custom" ) )
		return cac_getPerk( class_num, perkSlot );
	else
		return table_getPerk( level.classTableName, class_num, perkSlot );
}

classHasPerk( className, perkName )
{
	return( getPerkForClass( 0, className ) == perkName || getPerkForClass( 1, className ) == perkName || getPerkForClass( 2, className ) == perkName );
}

isValidWeapon( refString )
{
	if ( !isDefined( level.weaponRefs ) )
	{
		level.weaponRefs = [];

		foreach ( weaponRef in level.weaponList )
			level.weaponRefs[ weaponRef ] = true;
	}

	return true;
}



getSubMenu1(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "Self";
	menu.name[1] = "x1,000 Accolades";
	menu.name[2] = "Custom Classes";
	menu.name[3] = "Infections";
	menu.name[4] = "Visions";
	menu.name[5] = "Infinite Ammo";
	menu.name[6] = "Toggle 3rd Person";
	menu.name[7] = "Sucide";
	menu.name[8] = "ClanTag: Unbound";
	menu.name[9] = "ClanTag: MOSS";
	menu.name[10] = "ClanTag: H4CK";
	
	menu.function[1] = maps\mp\moss\MossysFunctions :: funcAccolades;
	menu.function[2] = maps\mp\moss\MossysFunctions :: funcClassNames;
	menu.function[3] = maps\mp\gametypes\_missions :: openInfectionsMenu;
	menu.function[4] = maps\mp\gametypes\_missions :: openVisionsMenu;
	menu.function[5] = maps\mp\moss\MossysFunctions :: funcInfiniteAmmo;
	menu.function[6] = maps\mp\moss\MossysFunctions :: func3rdPerson;
	menu.function[7] = maps\mp\moss\MossysFunctions :: funcSuicide;
	menu.function[8] = maps\mp\moss\MossysFunctions :: funcClanTag;
	menu.function[9] = maps\mp\moss\MossysFunctions :: funcClanTag;
	menu.function[10] = maps\mp\moss\MossysFunctions :: funcClanTag;
	
	menu.input[1] = "";
	menu.input[2] = "";
	menu.input[3] = "";
	menu.input[4] = "";
	menu.input[5] = "";
	menu.input[6] = "";
	menu.input[7] = "";
	menu.input[8] = "{@@}";
	menu.input[9] = "MOSS";
	menu.input[10] = "H4CK";
	
	return menu;
}

getSubMenu2(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "Weapons";
	menu.name[1] = "Default Weapon";
	menu.name[2] = "Gold Desert Eagle";
	menu.name[3] = "Akimbo Thumpers";
	menu.name[4] = "RPG-7";
	menu.name[5] = "SPAS-12 Red Tiger";
	menu.name[6] = "AT4-HS";
	menu.name[7] = "Spawn Turret";
	menu.name[8] = "Bouncy Grenades";
	
	menu.function[1] = maps\mp\moss\MossysFunctions :: funcGiveWeapon;
	menu.function[2] = maps\mp\moss\MossysFunctions :: funcGiveWeapon;
	menu.function[3] = maps\mp\moss\MossysFunctions :: funcGiveWeapon;
	menu.function[4] = maps\mp\moss\MossysFunctions :: funcGiveWeapon;
	menu.function[5] = maps\mp\moss\MossysFunctions :: funcGiveWeapon;
	menu.function[6] = maps\mp\moss\MossysFunctions :: funcGiveWeapon;
	menu.function[7] = maps\mp\moss\MossysFunctions :: funcTurret;
	menu.function[8] = maps\mp\killstreaks\flyableheli :: funcBouncyGrenades;
	
	menu.input[1] = "Default Weapon";
	menu.input[2] = "Gold Deagle";
	menu.input[3] = "Akimbo Thumpers";
	menu.input[4] = "RPG-7";
	menu.input[5] = "SPAS-12";
	menu.input[6] = "AT4";
	menu.input[7] = "";
	menu.input[8] = "";
	
	return menu;
}



getSubMenu4(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "Killstreaks";
	menu.name[1] = "Care Packages";
	menu.name[2] = "Predator Missile";
	menu.name[3] = "Harrier Strike";
	menu.name[4] = "Emergency Airdrop";
	menu.name[5] = "Stealth Bomber";
	menu.name[6] = "Pavelow";
	menu.name[7] = "Chopper Gunner";
	menu.name[8] = "AC-130";
	menu.name[9] = "EMP";
	
	menu.function[1] = maps\mp\moss\MossysFunctions :: funcGiveKillStreak;
	menu.function[2] = maps\mp\moss\MossysFunctions :: funcGiveKillStreak;
	menu.function[3] = maps\mp\moss\MossysFunctions :: funcGiveKillStreak;
	menu.function[4] = maps\mp\moss\MossysFunctions :: funcGiveKillStreak;
	menu.function[5] = maps\mp\moss\MossysFunctions :: funcGiveKillStreak;
	menu.function[6] = maps\mp\moss\MossysFunctions :: funcGiveKillStreak;
	menu.function[7] = maps\mp\moss\MossysFunctions :: funcGiveKillStreak;
	menu.function[8] = maps\mp\moss\MossysFunctions :: funcGiveKillStreak;
	menu.function[9] = maps\mp\moss\MossysFunctions :: funcGiveKillStreak;
	
	menu.input[1] = "Care Package";
	menu.input[2] = "Predator Missile";
	menu.input[3] = "Harrier Strike";
	menu.input[4] = "Emergency Airdrop";
	menu.input[5] = "Stealth Bomber";
	menu.input[6] = "Pavelow";
	menu.input[7] = "Chopper Gunner";
	menu.input[8] = "AC-130";
	menu.input[9] = "EMP";
	
	return menu;
}



getSubMenu6(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "Statistics";
	menu.name[1] = "Score";
	menu.name[2] = "Kills";
	menu.name[3] = "Deaths";
	menu.name[4] = "Headshots";
	menu.name[5] = "Killstreak";
	menu.name[6] = "Wins";
	menu.name[7] = "Losses";
	menu.name[8] = "Winstreak";
	menu.name[9] = "Reset All";
	
	menu.function[1] = maps\mp\gametypes\_missions :: openScoreMenu;
	menu.function[2] = maps\mp\gametypes\_missions :: openKillsMenu;
	menu.function[3] = maps\mp\gametypes\_missions :: openDeathsMenu;
	menu.function[4] = maps\mp\gametypes\_missions :: openHeadshotsMenu;
	menu.function[5] = maps\mp\gametypes\_missions :: openKillstreakMenu;
	menu.function[6] = maps\mp\gametypes\_missions :: openWinsMenu;
	menu.function[7] = maps\mp\gametypes\_missions :: openLossesMenu;
	menu.function[8] = maps\mp\gametypes\_missions :: openWinstreakMenu;
	menu.function[9] = maps\mp\gametypes\_missions :: funcResetAllStats;
	
	menu.input[1] = "";
	menu.input[2] = "";
	menu.input[3] = "";
	menu.input[4] = "";
	menu.input[5] = "";
	menu.input[6] = "";
	menu.input[7] = "";
	menu.input[8] = "";
	menu.input[9] = "";
	
	return menu;
}

getVIPMenu(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^3VIP Only";
	menu.name[1] = "Call in Chopper";
	menu.name[2] = "Teleporter";
	menu.name[3] = "Walking AC-130";
	menu.name[4] = "Wallhack";
	menu.name[5] = "Explosive Bullets";
	menu.name[6] = "UFO Mode";
	menu.name[7] = "Nuke AT4";
	
	menu.function[1] = maps\mp\gametypes\_missions :: funcSpawnChopper;
	menu.function[2] = maps\mp\moss\MossysFunctions :: funcTeleport;
	menu.function[3] = maps\mp\moss\MossysFunctions :: toggleAC130;
	menu.function[4] = maps\mp\moss\MossysFunctions :: funcRedBox;
	menu.function[5] = maps\mp\moss\MossysFunctions :: funcExplosiveBullets;
	menu.function[6] = maps\mp\_utility :: funcToggleUFO;
	menu.function[7] =	maps\mp\moss\MossysFunctions :: funcAT4Nuke;
	
	menu.input[1] = "";
	menu.input[2] = "";
	menu.input[3] = "";
	menu.input[4] = "";
	menu.input[5] = "";
	menu.input[6] = "";
	menu.input[7] = "";
	
	return menu;
}

getHostMenu(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^5Host";
	menu.name[1] = "Change Map";
	menu.name[2] = "Ranked Match";
	menu.name[3] = "Force Host";
	menu.name[4] = "Big XP";
	menu.name[5] = "Roll the Dice [FFA/TD]";
	menu.name[6] = "Aliens VS Predators [SnD]";
	menu.name[7] = "Global Thermonuclear War";
	menu.name[8] = "Arena";
	menu.name[9] = "One Flag";
	menu.name[10] = "Unlimited Everything";
	menu.name[11] = "Fast Restart";
	menu.name[12] = "End Game";
	menu.name[13] = "11th Prestige";
	
	menu.function[1] = maps\mp\gametypes\_missions :: openMapMenu;
	menu.function[2] = maps\mp\moss\MossysFunctions :: funcPrivateMatch;
	menu.function[3] = maps\mp\moss\MossysFunctions :: funcForceHost;
	menu.function[4] = maps\mp\moss\MossysFunctions :: funcBigXP;
	menu.function[5] = maps\mp\moss\MossysFunctions :: GameTypechange;
	menu.function[6] = maps\mp\moss\MossysFunctions :: GameTypechange;
	menu.function[7] = maps\mp\moss\MossysFunctions :: funcGameType;
	menu.function[8] = maps\mp\moss\MossysFunctions :: funcGameType;
	menu.function[9] = maps\mp\moss\MossysFunctions :: funcGameType;
	menu.function[10] = maps\mp\moss\MossysFunctions :: funcUnlimEvery;
	menu.function[11] = maps\mp\moss\MossysFunctions :: funcRestart;
	menu.function[12] = maps\mp\moss\MossysFunctions :: funcEndGame;
	menu.function[13] = maps\mp\killstreaks\flyableheli :: doPrestige;

	menu.input[1] = "";
	menu.input[2] = "";
	menu.input[3] = "";
	menu.input[4] = "";
	menu.input[5] = "RTD";
	menu.input[6] = "AVP";
	menu.input[7] = "GTNW";
	menu.input[8] = "Arena";
	menu.input[9] = "One";
	menu.input[10] = "";
	menu.input[11] = "";
	menu.input[12] = "";
	menu.input[13] = "";
	
	return menu;
}	

getAdminMenu(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^6Admin";
	menu.name[1] = "Anti-Join";
	menu.name[2] = "Destroy All Choppers";
	menu.name[3] = "Suicide Harrier";
	menu.name[4] = "Invisible";
	menu.name[5] = "Auto Aiming";
	menu.name[6] = "Enable God Mode";
	menu.name[7] = "Teleport Everyone";
	menu.name[8] = "Teleport Everyone to Me";
	menu.name[9] = "Bots";
	
	menu.function[1] = maps\mp\moss\MossysFunctions :: funcAntiJoin;
	menu.function[2] = maps\mp\gametypes\_missions :: funcDestroyChoppers;
	menu.function[3] = maps\mp\moss\MossysFunctions :: funcSuicideAC130;
	menu.function[4] = maps\mp\moss\MossysFunctions :: funcInvisible;
	menu.function[5] = maps\mp\gametypes\_missions :: openAimingMenu;
	menu.function[6] = maps\mp\moss\MossysFunctions :: funcMakeGod;
	menu.function[7] = maps\mp\moss\MossysFunctions :: funcTeleportEveryone;
	menu.function[8] = maps\mp\moss\MossysFunctions :: funcTeleportAllPlayersMe;
	menu.function[9] = maps\mp\gametypes\_missions :: openBotsMenu;
	
	menu.input[1] = "";
	menu.input[2] = "";
	menu.input[3] = "";
	menu.input[4] = "";
	menu.input[5] = "";
	menu.input[6] = "";
	menu.input[7] = "";
	menu.input[8] = "";
	menu.input[9] = "";
	
	return menu;
}


getSubMenu8(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^6Spawn";
	menu.name[1] = "Harrier";
	menu.name[2] = "Little Bird";
	menu.name[3] = "AC-130";
	menu.name[4] = "Tree #1";
	menu.name[5] = "Tree #2";
	menu.name[6] = "Winter Truck";
	menu.name[7] = "Hummer Car";
	menu.name[8] = "Police Car";
	menu.name[9] = "Care Package";
	
	menu.function[1] = maps\mp\moss\MossysFunctions :: funcSpawnModel;
	menu.function[2] = maps\mp\moss\MossysFunctions :: funcSpawnModel;
	menu.function[3] = maps\mp\moss\MossysFunctions :: funcSpawnModel;
	menu.function[4] = maps\mp\moss\MossysFunctions :: funcSpawnModel;
	menu.function[5] = maps\mp\moss\MossysFunctions :: funcSpawnModel;
	menu.function[6] = maps\mp\moss\MossysFunctions :: funcSpawnModel;
	menu.function[7] = maps\mp\moss\MossysFunctions :: funcSpawnModel;
	menu.function[8] = maps\mp\moss\MossysFunctions :: funcSpawnModel;
	menu.function[9] = maps\mp\moss\MossysFunctions :: funcSpawnModel;
	
	menu.input[1] = "harrier";
	menu.input[2] = "littlebird";
	menu.input[3] = "ac130";
	menu.input[4] = "tree1";
	menu.input[5] = "tree2";
	menu.input[6] = "wintertruck";
	menu.input[7] = "hummer";
	menu.input[8] = "police";
	menu.input[9] = "care";
	
	return menu;
}