//save lah bejir
SaveAllDataPlayer(playerid)
{
	if(!pData[playerid][pLoginStatus]) return 1;

	GetPlayerHealth(playerid, pData[playerid][pHealth]);
	GetPlayerArmour(playerid, pData[playerid][pArmour]);
	GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
	GetPlayerFacingAngle(playerid, pData[playerid][pAngle]);

	pData[playerid][pInterior] = GetPlayerInterior(playerid);
	pData[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid);
	pData[playerid][pSkin] = GetPlayerSkin(playerid);
	new temp = pData[playerid][pStaterpack];
	pData[playerid][pMoney] = GetPlayerMoney(playerid);
	

	new query[1688];
	mysql_format(db, query, sizeof(query), "UPDATE players SET admin = '%d', adminname = '%s', health = '%f', armour = '%f', posx = '%f', posy = '%f', posz = '%f', angle = '%f', interior = '%d', virtualworld = '%d', skin = '%d', money = '%d', staterpack = '%d', gender = '%d', age = '%d', traits1 = '%s', traits2 = '%s' WHERE id = '%d'", 
		pData[playerid][pAdmin], pData[playerid][pAdminName],
		pData[playerid][pHealth], pData[playerid][pArmour],
		pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ], pData[playerid][pAngle],
		pData[playerid][pInterior], pData[playerid][pVirtualWorld], pData[playerid][pSkin], pData[playerid][pMoney], temp, pData[playerid][pGender], pData[playerid][pAge],
		pData[playerid][pTraits1], pData[playerid][pTraits2], 
		pData[playerid][pId]);
	mysql_pquery(db, query, "OnPlayerSuccesSave", "d", playerid);
	return 1;
}