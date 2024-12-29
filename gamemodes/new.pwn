// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#include <a_samp>
#include <Pawn.CMD>
#include <sscanf2>
#include <a_mysql>

enum PlayerData{
	pId, 
	bool:pLoginStatus,
	pName[MAX_PLAYER_NAME],
	pPassword,
	Float:pHealth,
	Float:pArmour,
	Float:pPosX, Float:pPosY, Float:pPosZ, Float:pAngle,
	pInterior, 
	pVirtualWorld,
	pSkin,
}

enum {
	DIALOG_LOGIN,
	DIALOG_SIGNUP,
}

new pData[MAX_PLAYERS][PlayerData];

new MySQL:db;

#define MYSQL_HOST "localhost"
#define MYSQL_USERNAME "root"
#define MYSQL_PASSWORD ""
#define MYSQL_DATABASE "local"

#define COLOR_WHITE "0xFF0000FF"


main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}

public OnGameModeInit()
{
	MysqlGetStatusConnection();
	SetGameModeText("Blank Script");
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
		mysql_format(db, query, sizeof(query), "SELECT id FROM players WHERE username = '%e'", pData[playerid][pName]);
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
	GetName(playerid);
	ResetEnum(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	SaveAllDataPlayer(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_SIGNUP)
	{
		if(!response) return Kick(playerid);
		if(strlen(inputtext) < 6)
		{
			ShowPlayerDialog(playerid, DIALOG_SIGNUP, DIALOG_STYLE_PASSWORD, "Sign Up", "Daftarkan akun anda, minimal 6 huruf", "Sign Up", "Close");
		}

		new query[300];
		mysql_format(db, query, sizeof(query), "INSERT INTO players (username, password) VALUES ('%e', MD5('%e'))", pData[playerid][pName], inputtext);
		mysql_pquery(db, query, "OnPlayerSignUp", "d", playerid);
	}

	if(dialogid == DIALOG_LOGIN)
	{
		if(!response) return Kick(playerid);
		if(strlen(inputtext) < 6)
		{
			ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Login ke akun anda, minimal 6 huruf", "Login", "Close");
		}

		new query[268];
		mysql_format(db, query, sizeof(query), "SELECT * FROM players WHERE username = '%e' AND password = MD5('%e')", pData[playerid][pName], inputtext);
		mysql_tquery(db, query, "OnPlayerLogin", "d", playerid);
	} 
	return 1;
}

//====================================[CALLBACK]====================================================

forward OnPlayerLogin(playerid);
public OnPlayerLogin(playerid)
{
	new rows;
	new string[128];
	cache_get_row_count(rows);
	if(rows == 0)
	{
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Password salah, coba lagi!", "Login", "Close");
	}
	else
	{
		cache_get_value_name_int(0, "id", pData[playerid][pId]);
		cache_get_value_name_int(0, "interior", pData[playerid][pInterior]);
		cache_get_value_name_int(0, "virtualworld", pData[playerid][pVirtualWorld]);
		cache_get_value_name_int(0, "skin", pData[playerid][pSkin]);

		cache_get_value_name_float(0, "health", pData[playerid][pHealth]);
		cache_get_value_name_float(0, "armour", pData[playerid][pArmour]);
		cache_get_value_name_float(0, "posx", pData[playerid][pPosX]);
		cache_get_value_name_float(0, "posy", pData[playerid][pPosY]);
		cache_get_value_name_float(0, "posz", pData[playerid][pPosZ]);
		cache_get_value_name_float(0, "angle", pData[playerid][pAngle]);

		format(string, sizeof(string), "{FFFF33}%s {FFFFFF}telah bergabung ke dalam server!", pData[playerid][pName]);
		SendClientServer(string);
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

forward OnPlayerSignUp(playerid);
public OnPlayerSignUp(playerid) 
{
	new string[128];
	pData[playerid][pId] = cache_insert_id();
	pData[playerid][pLoginStatus] = true;
	format(string, sizeof(string), "{FFFF00}[SERVER] : {00FFFF}%s {FFFFFF}telah bergabung ke dalam server!", pData[playerid][pName]);
	SendClientMessageToAll(-1, string);
	SetSpawnInfo(playerid, 0, 26, 1682.6084, -2327.8940, 13.5469, 3.4335, 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
	print("[DEBUG_SIGN_UP] : BERHASIL MENGIRIM DATA KE DATABASE");
	return 1;
}

forward OnCheckPlayerStatus(playerid);
public OnCheckPlayerStatus(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if(rows == 0)
	{
		ShowPlayerDialog(playerid, DIALOG_SIGNUP, DIALOG_STYLE_PASSWORD, "Sign Up", "Daftarkan akun anda", "Sign Up", "Close");
	}
	else
	{
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Login ke akun anda", "Login", "Close");
	}
	return 1;
}

forward OnPlayerSuccesSave(playerid);
public OnPlayerSuccesSave(playerid)
{
	SendClientSucces(playerid, "Berhasil di simpan!");
	return 1;
}

//====================================[Function]====================================================
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

GetName(playerid)
{
	GetPlayerName(playerid, pData[playerid][pName], MAX_PLAYER_NAME);
	return pData[playerid][pName];
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

ResetEnum(playerid)
{
    pData[playerid][pId] = 0; 
    pData[playerid][pLoginStatus] = false;
    pData[playerid][pSkin] = 0;
    pData[playerid][pVirtualWorld] = 0;
    pData[playerid][pInterior] = 0;
}

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

	new query[1688];
	mysql_format(db, query, sizeof(query), "UPDATE players SET health = '%f', armour = '%f', posx = '%f', posy = '%f', posz = '%f', angle = '%f', interior = '%d', virtualworld = '%d', skin = '%d' WHERE id = '%d'", 
		pData[playerid][pHealth], pData[playerid][pArmour],
		pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ], pData[playerid][pAngle],
		pData[playerid][pInterior], pData[playerid][pVirtualWorld], pData[playerid][pSkin],
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