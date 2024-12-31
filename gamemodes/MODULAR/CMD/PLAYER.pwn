CMD:veh(playerid, params[])
{
	new vehid;
	if(sscanf(params, "i", vehid))
	{
		SendClientUsage(playerid, "/veh <id> <id kendaraan>");
		return 1;
	}
	
	if(vehid < 400 || vehid > 611)
	{
		SendClientError(playerid, "Invalid id vehicle! 400-611!");
		return 1;
	}

	new Float:x, Float:y, Float:z, Float:angle;
	GetPlayerPos(playerid, Float:x, Float:y, Float:z);
	GetPlayerFacingAngle(playerid, Float:angle);

	CreateVehicle(vehid, Float:x, Float:y, Float:z, Float:angle, 0, 0, 1, 0);
	return 1;
}

CMD:saveme(playerid)
{
	SaveAllDataPlayer(playerid);
	return 1;
}

CMD:claim(playerid)
{
	if(!pData[playerid][pLoginStatus]) return SendClientError(playerid, "Anda belum login ke akun!");
	if(pData[playerid][pStaterpack] == 1) return SendClientError(playerid, "Anda sudah pernah menklaim staterpack!");

	GivePlayerMoneyEx(playerid, 10000);
	pData[playerid][pStaterpack] = 1;
	SendClientSucces(playerid, "Anda berhasil mengklaim staterpack sebanyak 10K");
	return 1;
}

//only testing
CMD:gender(playerid)
{
	if(pData[playerid][pGender] == 0)
	{
		SendClientSucces(playerid, "Anda berkelamin pria");
	}
	else 
	{
		SendClientSucces(playerid, "Anda berkelamin wanita");
	}
	return 1;
}

CMD:stats(playerid)
{
	new str[1888];
	new Gender[12];
	if(pData[playerid][pGender] == 0)
	{
		format(Gender, sizeof(Gender), "Laki-Laki");
	}
	else
	{
		format(Gender, sizeof(Gender), "Perempuan");
	}

	format(str, sizeof(str), "{FFFFFF}[Nama : {33FF66}%s{FFFFFF}] [Umur : {33FF66}%d{FFFFFF}] [Gender = {33FF66}%s{FFFFFF}]\n[Traits 1 : {33FF66}%s{FFFFFF}] [Traits 2 : {33FF66}%s{FFFFFF}] [Money : {33FF66}%d{FFFFFF}] [Skin : {33FF66}%d{FFFFFF}]\n", 
		pData[playerid][pName], pData[playerid][pAge], Gender, pData[playerid][pTraits1], pData[playerid][pTraits2], pData[playerid][pMoney], pData[playerid][pSkin]);
	ShowPlayerDialog(playerid, DIALOG_STATS, DIALOG_STYLE_MSGBOX, "Stats Players", str, "ok", "");
	return 1;
}