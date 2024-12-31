forward ChoseGenderPlayer(playerid);
public ChoseGenderPlayer(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "Gender", "Laki-laki\nPerempuan", "Chose", "Close");
	return 1;
}

//memasukan username karakter ke database untuk disimpan
forward InsertCharacterToDatabase(playerid, name[]);
public InsertCharacterToDatabase(playerid, name[])
{
	new count = cache_num_rows(), Cache:execute;
	if(count > 0)
	{
		ShowPlayerDialog(playerid, DIALOG_MAKECHAR, DIALOG_STYLE_INPUT, "Character Menu", "Masukan nama karakter yang anda mau", "Input", "Close");
	}
	else
	{
		new query[288];
		new string[128], 
			stringinfo[128],
			stringinfo2[128];
		mysql_format(db, query, sizeof(query), "INSERT INTO players (username, ucpname) VALUES ('%s', '%s')", name, pData[playerid][pUCP]);
		execute = mysql_query(db, query);
		pData[playerid][pId] = cache_insert_id();
		cache_delete(execute);
		format(pData[playerid][pName], MAX_PLAYER_NAME, name);
		SetPlayerName(playerid, name);
		format(pData[playerid][pAdminName], MAX_PLAYER_NAME, "None");
		SetPlayerColor(playerid, COLOR_WHITE);

		pData[playerid][pLoginStatus] = true;
		if(pData[playerid][pGender] == 0)
		{
			SetSpawnInfo(playerid, 0, 26, 1682.6084, -2327.8940, 13.5469, 3.4335, 0, 0, 0, 0, 0, 0);
			SpawnPlayer(playerid);
		}
		else
		{
			SetSpawnInfo(playerid, 0, 41, 1682.6084, -2327.8940, 13.5469, 3.4335, 0, 0, 0, 0, 0, 0);
			SpawnPlayer(playerid);
		}
		

		format(string, sizeof(string), "{FFFF33}%s {FFFFFF}telah bergabung ke dalam server!", pData[playerid][pName]);
		format(stringinfo, sizeof(stringinfo), "Anda masuk pada waktu {FFFF33}%02d:%02d:%02d", pData[playerid][pHours], pData[playerid][pMinutes], pData[playerid][pSeconds]);
		format(stringinfo2, sizeof(stringinfo2), "Anda bermain pada tanggal %02d/%d/%d", pData[playerid][pDate], pData[playerid][pMonth], pData[playerid][pYears]);
		SendClientServer(string);
		SendClientServerForPlayer(playerid, stringinfo);
		SendClientServerForPlayer(playerid, stringinfo2);
	}
	return 1;
}

//Jam server
forward DateServer();
public DateServer()
{
	new str[288],
		month[12],
		dates[6];

	gettime(dates[0], dates[1], dates[2]);
	getdate(dates[5], dates[4], dates[3]);

	switch(dates[4])
	{
		case 1: month = "Januari";
		case 2: month = "Febuari";
		case 3: month = "Maret";
		case 4: month = "April";
		case 5: month = "Mei";
		case 6: month = "Juni";
		case 7: month = "Juli";
		case 8: month = "Agustus";
		case 9: month = "September";
		case 10: month = "Oktober";
		case 11: month = "November";
		case 12: month = "Desember";
	}

	format(str, sizeof(str), "%02d:%02d:%02d", dates[0], dates[1], dates[2]);
	TextDrawSetString(date[0], str);
	format(str, sizeof(str), "%d%s %d", dates[3], dates[4], dates[5]);
	TextDrawSetString(date[1], str);

	SetWorldTime(dates[0]);
	return 1;
}

//untuk meload karakter yang telah dibuat
forward OnLoadDataPlayer(playerid);
public OnLoadDataPlayer(playerid)
{
	new rows;
	new string[128], 
		stringinfo[128],
		stringinfo2[128],
		name[MAX_PLAYER_NAME],
		aname[MAX_PLAYER_NAME],
		traits[20], 
		traits2[20];
	cache_get_row_count(rows);
	if(rows == 0)
	{
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "Login UCP", "Login gagal coba lagi", "Login", "Close");
	}
	else
	{
		cache_get_value_name(0, "username", name);
		format(pData[playerid][pName], MAX_PLAYER_NAME, "%s", name);
		cache_get_value_name(0, "adminname", aname);
		format(pData[playerid][pAdminName], MAX_PLAYER_NAME, "%s", aname);

		cache_get_value_name(0, "traits1", traits);
		format(pData[playerid][pTraits1], 20, "%s", traits);
		cache_get_value_name(0, "traits2", traits2);
		format(pData[playerid][pTraits2], 20, "%s", traits2);
		cache_get_value_name_int(0, "id", pData[playerid][pId]);
		cache_get_value_name_int(0, "interior", pData[playerid][pInterior]);
		cache_get_value_name_int(0, "virtualworld", pData[playerid][pVirtualWorld]);
		cache_get_value_name_int(0, "skin", pData[playerid][pSkin]);
		cache_get_value_name_int(0, "staterpack", pData[playerid][pStaterpack]);
		cache_get_value_name_int(0, "money", pData[playerid][pMoney]);
		cache_get_value_name_int(0, "gender", pData[playerid][pGender]);
		cache_get_value_name_int(0, "age", pData[playerid][pAge]);

		cache_get_value_name_float(0, "health", pData[playerid][pHealth]);
		cache_get_value_name_float(0, "armour", pData[playerid][pArmour]);
		cache_get_value_name_float(0, "posx", pData[playerid][pPosX]);
		cache_get_value_name_float(0, "posy", pData[playerid][pPosY]);
		cache_get_value_name_float(0, "posz", pData[playerid][pPosZ]);
		cache_get_value_name_float(0, "angle", pData[playerid][pAngle]);

		format(string, sizeof(string), "{FFFF33}%s {FFFFFF}telah bergabung ke dalam server!", pData[playerid][pName]);
		format(stringinfo, sizeof(stringinfo), "Anda masuk pada waktu {FFFF33}%02d:%02d:%02d", pData[playerid][pHours], pData[playerid][pMinutes], pData[playerid][pSeconds]);
		format(stringinfo2, sizeof(stringinfo2), "Anda bermain pada tanggal %02d/%d/%d", pData[playerid][pDate], pData[playerid][pMonth], pData[playerid][pYears]);
		SendClientServer(string);
		SendClientServerForPlayer(playerid, stringinfo);
		SendClientServerForPlayer(playerid, stringinfo2);

		pData[playerid][pLoginStatus] = true;
		SetPlayerColor(playerid,-1);
		SetPlayerHealth(playerid, pData[playerid][pHealth]);
		SetPlayerArmour(playerid, pData[playerid][pArmour]);
		SetPlayerInterior(playerid, pData[playerid][pInterior]);
		SetPlayerVirtualWorld(playerid, pData[playerid][pVirtualWorld]);
		GivePlayerMoneyEx(playerid, pData[playerid][pMoney]);
		SetSpawnInfo(playerid, -1, pData[playerid][pSkin], pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ], pData[playerid][pAngle], -1, -1, -1, -1, -1, -1);
		SpawnPlayer(playerid);
		print("[DEBUG_LOGIN] : BERHASIL MENERIMA DATA KE DATABASE");
	}
	return ;
}

//untuk cek apakah sudah terdaftar atau belum
forward OnCheckUserUCP(playerid);
public OnCheckUserUCP(playerid) 
{
	new query[288];
	mysql_format(db, query, sizeof(query), "SELECT username FROM players WHERE ucpname = '%s' LIMIT 3", pData[playerid][pUCP]);
	mysql_tquery(db, query, "OnLoadCharacterUcp", "d", playerid);
	return 1;
}

//untuk meload karakter dari database
forward OnLoadCharacterUcp(playerid);
public OnLoadCharacterUcp(playerid)
{
	for(new i = 0; i < 3; i++)
	{
		CharacterPlayer[playerid][i][0] = EOS;
	}
	for(new i = 0; i < cache_num_rows(); i++)
	{
		cache_get_value_name(i, "username", CharacterPlayer[playerid][i]);
	}
	ShowCharacterList(playerid);
	return 1;
}

//cek status player
forward OnCheckPlayerStatus(playerid);
public OnCheckPlayerStatus(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if(rows == 0)
	{
		new strsign[268];
		format(strsign, sizeof(strsign), "{FFFFFF}Selamat datang {FFFF00}%s, \n{FFFFFF}Silahkan masukkan password untuk mendaftarkan akun anda ke server!\nJika terjadi error atau bug, hubungi admin atau developer!", pData[playerid][pUCP]);
		ShowPlayerDialog(playerid, DIALOG_SIGNUP, DIALOG_STYLE_PASSWORD, "Sign Up UCP", strsign, "Sign Up", "Close");
	}
	else
	{
		new strlog[268];
		format(strlog, sizeof(strlog), "{FFFFFF}Selamat datang kembali {FFFF00}%s!, \n{FFFFFF}Silahkan masukkan password untuk login ke akun anda!\nJika terjadi error atau bug, hubungi admin atau developer!", pData[playerid][pUCP]);
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login UCP", strlog, "Login", "Close");
	}
	return 1;
}

//save
forward OnPlayerSuccesSave(playerid);
public OnPlayerSuccesSave(playerid)
{
	SendClientSucces(playerid, "Berhasil di simpan!");
	return 1;
}