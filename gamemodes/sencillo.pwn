//Dibuat dengan cinta dan kesabaran(ga bisa ngoding pawno jir!)

#include <a_samp>
#include <Pawn.CMD>
#include <sscanf2>
#include <a_mysql>

#define MAX_CHAR 3 // max caracter
#define COLOR_WHITE 0xFFFFFFAA
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
	pMoney,
	pStaterpack,
	pGender,
	pAge[50],
	pTraits1[20],
	pTraits2[20],
	pSeconds, 
	pMinutes, 
	pHours,
	pDate,
	pMonth,
	pYears,
	pAdmin,
	pAdminName[12],
}

enum {
	DIALOG_LOGIN,
	DIALOG_SIGNUP,
	DIALOG_CLIST,
	DIALOG_MAKECHAR,
	DIALOG_GENDER,
	DIALOG_TRAITS1,
	DIALOG_TRAITS2,
	DIALOG_AGE,
	DIALOG_STATS,
}

new pData[MAX_PLAYERS][PlayerData];
new CharacterPlayer[MAX_PLAYERS][MAX_CHAR][MAX_PLAYER_NAME + 1];

//===================[VARIABLE]===================
new MySQL:db;
//textdraw tanggal dan jam
new Text:date[2];
//textdraw name
new PlayerText:servername[MAX_PLAYERS][2];

main()
{
	print("\n----------------------------------");
	print(" AMBATUKAMMM");
	print("----------------------------------\n");
}

#include "MODULAR\FUNCTION.pwn"
#include "MODULAR\CALLBACK.pwn"
#include "MODULAR\DIALOG.pwn"
#include "MODULAR\DEFINE.pwn"
#include "MODULAR\ADMIN.pwn"
#include "MODULAR\SAVE.pwn"
#include "MODULAR\TEXTDRAW.pwn"
#include "MODULAR\CMD\PLAYER.pwn"

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
	SetPlayerColor(playerid, COLOR_WHITE);
	ShowPlayerMarkers(0);
	return 1;
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
