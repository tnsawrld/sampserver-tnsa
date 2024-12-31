CMD:setdev(playerid, params[])
{
    new targetid;
    if(!IsPlayerAdmin(playerid)) return SendClientError(playerid, "Anda tak memiliki hak memakai command ini");
    if(sscanf(params, "i", targetid)) return SendClientUsage(playerid, "/setdev [id]");
    if(!IsPlayerConnected(targetid)) return SendClientError(playerid, "Player yang anda maksud tak terhubung kedalam server!");
    if(pData[playerid][pAdmin] == 6) return SendClientError(playerid, "Anda sudah menjadi developer");

    pData[playerid][pAdmin] = 6;
    new query[122];
    SendClientSucces(playerid, "Anda berhasil mennjadikan anda sebagai developer!");
    mysql_format(db, query, sizeof(query), "UPDATE players SET admin = '%d' WHERE id = '%d'", pData[playerid][pAdmin], pData[playerid][pId]);
    mysql_pquery(db, query);
    return 1;
}

CMD:infoadmin(playerid)
{
    if(!pData[playerid][pAdmin]) return SendClientError(playerid, "Anda tak memiliki akses untuk cmd ini!");
    new str[128];
    format(str, sizeof(str), "Nama admin : %s\n rank = %d", pData[playerid][pAdminName], pData[playerid][pAdmin]);
    SendClientSucces(playerid, str);
    return 1;
}
