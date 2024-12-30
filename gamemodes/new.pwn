//Dibuat dengan cinta dan kesabaran(ga bisa ngoding pawno jir!)

#include <a_samp>
#include <Pawn.CMD>
#include <sscanf2>
#include <a_mysql>

//max character for player
#define MAX_CHAR 3

//===================[ENUM]===================
enum PlayerData{
	pUCP[MAX_PLAYER_NAME],
	pChar,
	pPassword,
	pId,
	bool:pLoginStatus,
	pName[MAX_PLAYER_NAME],
	Float:pHealth,
	Float:pArmour,
	Float:pPosX, Float:pPosY, Float:pPosZ, Float:pAngle,
	pInterior, 
	pVirtualWorld,
	pSkin,
	pStaterpack,
	pSeconds, 
	pMinutes, 
	pHours,
	pDate,
	pMonth,
	pYears, 
}

enum {
	DIALOG_LOGIN,
	DIALOG_SIGNUP,
	DIALOG_CLIST,
	DIALOG_MAKECHAR,
}

new pData[MAX_PLAYERS][PlayerData];
new CharacterPlayer[MAX_PLAYERS][MAX_CHAR][MAX_PLAYER_NAME + 1];

//===================[VARIABLE]===================
new MySQL:db;
//textdraw tanggal dan jam
new Text:date[2];
//textdraw name
new PlayerText:servername[MAX_PLAYERS][2];

#define MYSQL_HOST "localhost"
#define MYSQL_USERNAME "root"
#define MYSQL_PASSWORD ""
#define MYSQL_DATABASE "local"

main()
{
	print("\n----------------------------------");
	print(" AMBATUKAMMM");
	print("----------------------------------\n");
}

//===================[CALLBACK SAMP]===================
public OnGameModeInit()
{
	LoadTextdraw();
	SetTimer("DateServer", 1000, true);
	MysqlGetStatusConnection();
	SetGameModeText("TnsaWRLd project");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	mysql_close(db);
	return 1;
}

public OnPlayerRequestClass(playerid)
{
	if(!pData[playerid][pLoginStatus])
	{
		new query[288];
		mysql_format(db, query, sizeof(query), "SELECT * FROM ucp WHERE user = '%e'", pData[playerid][pUCP]);
		mysql_pquery(db, query, "OnCheckPlayerStatus", "d", playerid);
	}
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	if(!pData[playerid][pLoginStatus])
	{
		SendClientMessage(playerid, -1, "{FF0000}Anda harus masuk akun terlebih dahulu!");
		return 0;
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	LoadTextdrawForPlayer(playerid);
	for(new i = 0; i < 2; i++)
	{
		TextDrawShowForPlayer(playerid, date[i]);
	}
	GetTimePlayer(playerid);
	GetPlayerDate(playerid);
	GetUCPName(playerid);
	ResetEnum(playerid);
	SetPlayerColor(playerid,-1);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	SaveAllDataPlayer(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	for(new i = 0; i < 2; i++)
	{
		PlayerTextDrawShow(playerid, servername[playerid][i]);
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_SIGNUP)
	{
		if(!response) return Kick(playerid);
		if(strlen(inputtext) < 6)
		{
			ShowPlayerDialog(playerid, DIALOG_SIGNUP, DIALOG_STYLE_PASSWORD, "Sign Up UCP", "{FFFFFF}Password invalid!(minimal 6 karakter)\nJika terjadi error atau bug, hubungi admin atau developer!", "Sign Up", "Close");
		}

		new query[300];
		mysql_format(db, query, sizeof(query), "INSERT INTO ucp (user, password) VALUES ('%e', MD5('%e'))", pData[playerid][pUCP], inputtext);
		mysql_pquery(db, query, "OnCheckUserUCP", "d", playerid);
	}

	if(dialogid == DIALOG_LOGIN)
	{
		if(!response) return Kick(playerid);
		if(strlen(inputtext) < 6)
		{
			ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login UCP", "{FFFFFF}Password invalid!(minimal 6 karakter)\nJika terjadi error atau bug, hubungi admin atau developer!", "Login", "Close");
		}

		new query[268];
		mysql_format(db, query, sizeof(query), "SELECT * FROM ucp WHERE user = '%e' AND password = MD5('%e')", pData[playerid][pUCP], inputtext);
		mysql_tquery(db, query, "OnCheckUserUCP", "d", playerid);
	}

	if(dialogid == DIALOG_CLIST)
	{
		if(response)
		{
			if(CharacterPlayer[playerid][listitem][0] == EOS) return ShowPlayerDialog(playerid, DIALOG_MAKECHAR, DIALOG_STYLE_INPUT, "Character Menu", "Masukan nama karakter yang anda mau", "Input", "Close");
			pData[playerid][pChar] = listitem;
			SetPlayerName(playerid, CharacterPlayer[playerid][listitem]);

			new query[288];
			mysql_format(db, query, sizeof(query), "SELECT * FROM players WHERE username = '%e' LIMIT 1;", CharacterPlayer[playerid][pData[playerid][pChar]]);
			mysql_tquery(db, query, "OnLoadDataPlayer", "d", playerid);
		}
	}

	if(dialogid == DIALOG_MAKECHAR)
	{
		if(response)
		{
			if(strlen(inputtext) < 1 || strlen(inputtext) > 24) return ShowPlayerDialog(playerid, DIALOG_MAKECHAR, DIALOG_STYLE_INPUT, "Character Menu", "Masukan nama karakter yang anda mau\n Nama yang kamu masukan invalid(3-24 karakter)", "Input", "Close");
			if(!CekSimbol(inputtext)) return ShowPlayerDialog(playerid, DIALOG_MAKECHAR, DIALOG_STYLE_INPUT, "Character Menu", "Masukan nama karakter yang anda mau\n Nama yang kamu masukan invalid(Contoh : Mateo_Gonzalez)", "Input", "Close");

			new CharQuery[188];
			mysql_format(db, CharQuery, sizeof(CharQuery), "SELECT * FROM players WHERE username = '%s'", inputtext);
			mysql_tquery(db, CharQuery, "InsertCharacterToDatabase", "ds", playerid, inputtext);
		}
	}
	return 1;
}

//====================================[CALLBACK]====================================================

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

		pData[playerid][pLoginStatus] = true;
		SetSpawnInfo(playerid, 0, 26, 1682.6084, -2327.8940, 13.5469, 3.4335, 0, 0, 0, 0, 0, 0);
		SpawnPlayer(playerid);

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
		stringinfo2[128];
	cache_get_row_count(rows);
	if(rows == 0)
	{
		cache_get_value_name_int(0, "id", pData[playerid][pId]);
		cache_get_value_name_int(0, "interior", pData[playerid][pInterior]);
		cache_get_value_name_int(0, "virtualworld", pData[playerid][pVirtualWorld]);
		cache_get_value_name_int(0, "skin", pData[playerid][pSkin]);
		cache_get_value_name_int(0, "staterpack", pData[playerid][pStaterpack]);

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
		SetPlayerHealth(playerid, pData[playerid][pHealth]);
		SetPlayerArmour(playerid, pData[playerid][pArmour]);
		SetPlayerInterior(playerid, pData[playerid][pInterior]);
		SetPlayerVirtualWorld(playerid, pData[playerid][pVirtualWorld]);
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
	mysql_format(db, query, sizeof(query), "SELECT username, skin FROM players WHERE ucpname = '%s' LIMIT 3", pData[playerid][pUCP]);
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

//====================================[Function]====================================================
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

//load texdraw khusus player
LoadTextdrawForPlayer(playerid)
{
	servername[playerid][0] = CreatePlayerTextDraw(playerid, 293.000000, 5.000000, "Sencillo");
	PlayerTextDrawFont(playerid, servername[playerid][0], 0);
	PlayerTextDrawLetterSize(playerid, servername[playerid][0], 0.312500, 1.299998);
	PlayerTextDrawTextSize(playerid, servername[playerid][0], 100.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, servername[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, servername[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, servername[playerid][0], 1);
	PlayerTextDrawColor(playerid, servername[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, servername[playerid][0], 75);
	PlayerTextDrawBoxColor(playerid, servername[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, servername[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, servername[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, servername[playerid][0], 0);

	servername[playerid][1] = CreatePlayerTextDraw(playerid, 324.000000, 5.000000, "Roleplay");
	PlayerTextDrawFont(playerid, servername[playerid][1], 0);
	PlayerTextDrawLetterSize(playerid, servername[playerid][1], 0.312500, 1.299998);
	PlayerTextDrawTextSize(playerid, servername[playerid][1], 100.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, servername[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, servername[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, servername[playerid][1], 1);
	PlayerTextDrawColor(playerid, servername[playerid][1], -1962934017);
	PlayerTextDrawBackgroundColor(playerid, servername[playerid][1], 75);
	PlayerTextDrawBoxColor(playerid, servername[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, servername[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, servername[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, servername[playerid][1], 0);

}

// load texdraw tanpa player
LoadTextdraw()
{
		//=============[JAM DAN TANGGAL]=====================
	date[0] = TextDrawCreate(546.000000, 26.000000, "00:00:00");
	TextDrawFont(date[0], 1);
	TextDrawLetterSize(date[0], 0.362500, 1.650000);
	TextDrawTextSize(date[0], 400.000000, 17.000000);
	TextDrawSetOutline(date[0], 1);
	TextDrawSetShadow(date[0], 0);
	TextDrawAlignment(date[0], 1);
	TextDrawColor(date[0], -1);
	TextDrawBackgroundColor(date[0], 255);
	TextDrawBoxColor(date[0], 50);
	TextDrawUseBox(date[0], 0);
	TextDrawSetProportional(date[0], 1);
	TextDrawSetSelectable(date[0], 0);

	date[1] = TextDrawCreate(42.000000, 429.000000, "00 Januari 2024");
	TextDrawFont(date[1], 1);
	TextDrawLetterSize(date[1], 0.341666, 1.350000);
	TextDrawTextSize(date[1], 400.000000, 17.000000);
	TextDrawSetOutline(date[1], 1);
	TextDrawSetShadow(date[1], 0);
	TextDrawAlignment(date[1], 1);
	TextDrawColor(date[1], -1);
	TextDrawBackgroundColor(date[1], 255);
	TextDrawBoxColor(date[1], 50);
	TextDrawUseBox(date[1], 0);
	TextDrawSetProportional(date[1], 1);
	TextDrawSetSelectable(date[1], 0);
}

//mysql saja
stock MysqlGetStatusConnection(ttl = 3)
{
	db = mysql_connect(MYSQL_HOST, MYSQL_USERNAME, MYSQL_PASSWORD, MYSQL_DATABASE);
	if(mysql_errno(db) != 0)
	{
		if(ttl > 1)
		{
			print("[MYSQL] : Mencoba menghubungkan kembali ke database");
			return MysqlGetStatusConnection(ttl-1);
		}
		else
		{
			print("[MYSQL] : Gagal menghubungkan ke server");
		}
	}
	else
	{
		print("[MYSQL] : Berhasil tersambung kedalam database!");
	}
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
}

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

	new query[1688];
	mysql_format(db, query, sizeof(query), "UPDATE players SET health = '%f', armour = '%f', posx = '%f', posy = '%f', posz = '%f', angle = '%f', interior = '%d', virtualworld = '%d', skin = '%d', staterpack = '%d' WHERE id = '%d'", 
		pData[playerid][pHealth], pData[playerid][pArmour],
		pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ], pData[playerid][pAngle],
		pData[playerid][pInterior], pData[playerid][pVirtualWorld], pData[playerid][pSkin], temp,
		pData[playerid][pId]);
	mysql_pquery(db, query, "OnPlayerSuccesSave", "d", playerid);
	return 1;
}

//====================================[CMD]====================================================

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

	GivePlayerMoney(playerid, 10000);
	pData[playerid][pStaterpack] = 1;
	SendClientSucces(playerid, "Anda berhasil mengklaim staterpack sebanyak 10K");
	return 1;
}