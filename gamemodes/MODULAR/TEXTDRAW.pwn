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