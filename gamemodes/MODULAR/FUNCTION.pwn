GivePlayerMoneyEx(playerid, ammount)
{
	pData[playerid][pMoney] += ammount;
	GivePlayerMoney(playerid, ammount);
}

//Untuk menampilkan list karakter
ShowCharacterList(playerid)
{
	new name[288], count, str[288];
	for(new i = 0; i < 3; i++) if(CharacterPlayer[playerid][i][0] != EOS)
	{
		format(str, sizeof(str), "%s\n", CharacterPlayer[playerid][i]);
		strcat(name, str);
		count++;
	}
	if(count < MAX_CHAR)
		strcat(name, "+ New Character");
	ShowPlayerDialog(playerid, DIALOG_CLIST, DIALOG_STYLE_LIST, "Character List", name, "Select", "Close");
	return 1;
}

stock CekSimbol(player[])
{
    for(new n = 0; n < strlen(player); n++)
    {
        if (player[n] == '_' && player[n+1] >= 'A' && player[n+1] <= 'Z') return 1;
        if (player[n] == ']' || player[n] == '[') return 0;
	}
    return 0;
}

GetPlayerDate(playerid)
{
	new tanggal[3];
	getdate(tanggal[2], tanggal[1], tanggal[0]);

	pData[playerid][pDate] = tanggal[0];
	pData[playerid][pMonth] = tanggal[1];
	pData[playerid][pYears] = tanggal[2];
	return 1;
}

GetTimePlayer(playerid) 
{
	new seconds, minutes, hours;
	gettime(hours, minutes, seconds);
	pData[playerid][pSeconds] = seconds;
	pData[playerid][pMinutes] = minutes;
	pData[playerid][pHours] = hours;
	return 1;
}

GetUCPName(playerid)
{
	GetPlayerName(playerid, pData[playerid][pUCP], MAX_PLAYER_NAME);
	return pData[playerid][pUCP];
}

stock SendClientUsage(playerid, message[])
{
	new usage[128];
	format(usage, sizeof(usage), "{FFFF00}[USAGE] : {FFFFFF}%s", message);
	SendClientMessage(playerid, -1, usage);
	return 1;
}

stock SendClientError(playerid, message[])
{
	new usage[128];
	format(usage, sizeof(usage), "{FF0000}[ERROR] : {FFFFFF}%s", message);
	SendClientMessage(playerid, -1, usage);
	return 1;
}

stock SendClientSucces(playerid, message[])
{
	new usage[128];
	format(usage, sizeof(usage), "{00FF00}[SUCCES] : {FFFFFF}%s", message);
	SendClientMessage(playerid, -1, usage);
	return 1;
}

stock SendClientInfo(playerid, message[])
{
	new usage[128];
	format(usage, sizeof(usage), "{99FF00}[INFO] : {FFFFFF}%s", message);
	SendClientMessage(playerid, -1, usage);
	return 1;
}

stock SendClientServer(message[])
{
	new usage[128];
	format(usage, sizeof(usage), "{00FFFF}[SERVER] : {FFFFFF}%s", message);
	SendClientMessageToAll(-1, usage);
	return 1;
}

stock SendClientServerForPlayer(playerid, message[])
{
	new usage[128];
	format(usage, sizeof(usage), "{00FFFF}[SERVER] : {FFFFFF}%s", message);
	SendClientMessage(playerid, -1, usage);
	return 1;
}

ResetEnum(playerid)
{
    pData[playerid][pId] = 0; 
    pData[playerid][pLoginStatus] = false;
    pData[playerid][pSkin] = 0;
    pData[playerid][pVirtualWorld] = 0;
    pData[playerid][pInterior] = 0;
	pData[playerid][pStaterpack] = 0;
	pData[playerid][pGender] = 0;
	pData[playerid][pAge] = 0;
	pData[playerid][pMoney] = 0;
	pData[playerid][pAdmin] = 0;
}
