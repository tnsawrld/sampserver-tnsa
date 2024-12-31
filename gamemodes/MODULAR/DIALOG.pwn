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
			if(CharacterPlayer[playerid][listitem][0] == EOS) return ShowPlayerDialog(playerid, DIALOG_MAKECHAR, DIALOG_STYLE_INPUT, "Character Menu", "Masukan nama karakter yang anda mau\n Nama yang kamu masukan invalid(Contoh : Mateo_Gonzalez)", "Input", "Close");
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
			mysql_tquery(db, CharQuery, "ChoseGenderPlayer", "d", playerid);
			format(pData[playerid][pName], MAX_PLAYER_NAME, "%s", inputtext);
		}
	}

	if(dialogid == DIALOG_GENDER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new str[128];
					pData[playerid][pGender] = 0;
					format(str, sizeof(str), "Masukan usia yang akan di beri kepada {FFFF33}%s.", pData[playerid][pName]);
					ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Age", str, "Continue", "");
				}
				case 1:
				{
					new str[128];
					pData[playerid][pGender] = 1;
					format(str, sizeof(str), "Masukan usia yang akan di beri kepada {FFFF33}%s.", pData[playerid][pName]);
					ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Age", str, "Continue", "");
				}
			}
		}
	}

	if(dialogid == DIALOG_AGE)
	{
		if(response)
		{
			new str[128];
			format(str, sizeof(str), "Masukan usia yang akan di beri kepada {FFFF33}%s.\n {FFFFFF}Umur yang di input tidak boleh lebih dari 100 dan kurang dari 1", pData[playerid][pName]);
			if(strlen(inputtext) <= 1 || strlen(inputtext) >= 3) return ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Age", str, "Continue", "");
			pData[playerid][pAge] = strval(inputtext);

			new traits[288];
			format(traits, sizeof(traits), "Pemarah\nRamah\nBaik\nlucu\nAngkuh\nPemalas\nPemalu\nCerdas\nBodoh\nEgois\nNaif");
			ShowPlayerDialog(playerid, DIALOG_TRAITS1, DIALOG_STYLE_LIST, "Traits 1", traits, "Chose", "");
		}
	}

	if(dialogid == DIALOG_TRAITS1)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0 :
				{
					format(pData[playerid][pTraits1], 20, "%s", "Pemarah");
					ShowPlayerDialog(playerid, DIALOG_TRAITS2, DIALOG_STYLE_LIST, "Traits 2", "Pemarah\nRamah\nBaik\nlucu\nAngkuh\nPemalas\nPemalu\nCerdas\nBodoh\nEgois\nNaif", "Chose", "");
				}
				case 1 :
				{
					format(pData[playerid][pTraits1], 20, "%s", "Ramah");
					ShowPlayerDialog(playerid, DIALOG_TRAITS2, DIALOG_STYLE_LIST, "Traits 2", "Pemarah\nRamah\nBaik\nlucu\nAngkuh\nPemalas\nPemalu\nCerdas\nBodoh\nEgois\nNaif", "Chose", "");
				}
				case 2 :
				{
					format(pData[playerid][pTraits1], 20, "%s", "Baik");
					ShowPlayerDialog(playerid, DIALOG_TRAITS2, DIALOG_STYLE_LIST, "Traits 2", "Pemarah\nRamah\nBaik\nlucu\nAngkuh\nPemalas\nPemalu\nCerdas\nBodoh\nEgois\nNaif", "Chose", "");
				}
				case 3 :
				{
					format(pData[playerid][pTraits1], 20, "%s", "Lucu");
					ShowPlayerDialog(playerid, DIALOG_TRAITS2, DIALOG_STYLE_LIST, "Traits 2", "Pemarah\nRamah\nBaik\nlucu\nAngkuh\nPemalas\nPemalu\nCerdas\nBodoh\nEgois\nNaif", "Chose", "");
				}
				case 4 :
				{
					format(pData[playerid][pTraits1], 20, "%s", "Angkuh");
					ShowPlayerDialog(playerid, DIALOG_TRAITS2, DIALOG_STYLE_LIST, "Traits 2", "Pemarah\nRamah\nBaik\nlucu\nAngkuh\nPemalas\nPemalu\nCerdas\nBodoh\nEgois\nNaif", "Chose", "");
				}
				case 5 :
				{
					format(pData[playerid][pTraits1], 20, "%s", "Pemalas");
					ShowPlayerDialog(playerid, DIALOG_TRAITS2, DIALOG_STYLE_LIST, "Traits 2", "Pemarah\nRamah\nBaik\nlucu\nAngkuh\nPemalas\nPemalu\nCerdas\nBodoh\nEgois\nNaif", "Chose", "");
				}
				case 6 :
				{
					format(pData[playerid][pTraits1], 20, "%s", "Pemalu");
					ShowPlayerDialog(playerid, DIALOG_TRAITS2, DIALOG_STYLE_LIST, "Traits 2", "Pemarah\nRamah\nBaik\nlucu\nAngkuh\nPemalas\nPemalu\nCerdas\nBodoh\nEgois\nNaif", "Chose", "");
				}
				case 7 :
				{
					format(pData[playerid][pTraits1], 20, "%s", "Cerdas");
					ShowPlayerDialog(playerid, DIALOG_TRAITS2, DIALOG_STYLE_LIST, "Traits 2", "Pemarah\nRamah\nBaik\nlucu\nAngkuh\nPemalas\nPemalu\nCerdas\nBodoh\nEgois\nNaif", "Chose", "");
				}
				case 8 :
				{
					format(pData[playerid][pTraits1], 20, "%s", "Bodoh");
					ShowPlayerDialog(playerid, DIALOG_TRAITS2, DIALOG_STYLE_LIST, "Traits 2", "Pemarah\nRamah\nBaik\nlucu\nAngkuh\nPemalas\nPemalu\nCerdas\nBodoh\nEgois\nNaif", "Chose", "");
				}
				case 9 :
				{
					format(pData[playerid][pTraits1], 20, "%s", "Egois");
					ShowPlayerDialog(playerid, DIALOG_TRAITS2, DIALOG_STYLE_LIST, "Traits 2", "Pemarah\nRamah\nBaik\nlucu\nAngkuh\nPemalas\nPemalu\nCerdas\nBodoh\nEgois\nNaif", "Chose", "");
				}
				case 10 :
				{
					format(pData[playerid][pTraits1], 20, "%s", "Naif");
					ShowPlayerDialog(playerid, DIALOG_TRAITS2, DIALOG_STYLE_LIST, "Traits 2", "Pemarah\nRamah\nBaik\nlucu\nAngkuh\nPemalas\nPemalu\nCerdas\nBodoh\nEgois\nNaif", "Chose", "");
				}
			}
		}
	}

	if(dialogid == DIALOG_TRAITS2)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0 :
				{
					new CharQuery[288];
					format(pData[playerid][pTraits2], 20, "%s", "Pemarah");
					mysql_format(db, CharQuery, sizeof(CharQuery), "SELECT * FROM players WHERE username = '%s'", pData[playerid][pName]);
					mysql_tquery(db, CharQuery, "InsertCharacterToDatabase", "ds", playerid, pData[playerid][pName]);
				}
				case 1 :
				{
					new CharQuery[288];
					format(pData[playerid][pTraits2], 20, "%s", "Ramah");
					mysql_format(db, CharQuery, sizeof(CharQuery), "SELECT * FROM players WHERE username = '%s'", pData[playerid][pName]);
					mysql_tquery(db, CharQuery, "InsertCharacterToDatabase", "ds", playerid, pData[playerid][pName]);
				}
				case 2 :
				{
					new CharQuery[288];
					format(pData[playerid][pTraits2], 20, "%s", "Baik");
					mysql_format(db, CharQuery, sizeof(CharQuery), "SELECT * FROM players WHERE username = '%s'", pData[playerid][pName]);
					mysql_tquery(db, CharQuery, "InsertCharacterToDatabase", "ds", playerid, pData[playerid][pName]);
				}
				case 3 :
				{
					new CharQuery[288];
					format(pData[playerid][pTraits2], 20, "%s", "Lucu");
					mysql_format(db, CharQuery, sizeof(CharQuery), "SELECT * FROM players WHERE username = '%s'", pData[playerid][pName]);
					mysql_tquery(db, CharQuery, "InsertCharacterToDatabase", "ds", playerid, pData[playerid][pName]);
				}
				case 4 :
				{
					new CharQuery[288];
					format(pData[playerid][pTraits2], 20, "%s", "Angkuh");
					mysql_format(db, CharQuery, sizeof(CharQuery), "SELECT * FROM players WHERE username = '%s'", pData[playerid][pName]);
					mysql_tquery(db, CharQuery, "InsertCharacterToDatabase", "ds", playerid, pData[playerid][pName]);
				}
				case 5 :
				{
					new CharQuery[288];
					format(pData[playerid][pTraits2], 20, "%s", "Pemalas");
					mysql_format(db, CharQuery, sizeof(CharQuery), "SELECT * FROM players WHERE username = '%s'", pData[playerid][pName]);
					mysql_tquery(db, CharQuery, "InsertCharacterToDatabase", "ds", playerid, pData[playerid][pName]);
				}
				case 6 :
				{
					new CharQuery[288];
					format(pData[playerid][pTraits2], 20, "%s", "Pemalu");
					mysql_format(db, CharQuery, sizeof(CharQuery), "SELECT * FROM players WHERE username = '%s'", pData[playerid][pName]);
					mysql_tquery(db, CharQuery, "InsertCharacterToDatabase", "ds", playerid, pData[playerid][pName]);
				}
				case 7 :
				{
					new CharQuery[288];
					format(pData[playerid][pTraits2], 20, "%s", "Cerdas");
					mysql_format(db, CharQuery, sizeof(CharQuery), "SELECT * FROM players WHERE username = '%s'", pData[playerid][pName]);
					mysql_tquery(db, CharQuery, "InsertCharacterToDatabase", "ds", playerid, pData[playerid][pName]);
				}
				case 8 :
				{
					new CharQuery[288];
					format(pData[playerid][pTraits2], 20, "%s", "Bodoh");
					mysql_format(db, CharQuery, sizeof(CharQuery), "SELECT * FROM players WHERE username = '%s'", pData[playerid][pName]);
					mysql_tquery(db, CharQuery, "InsertCharacterToDatabase", "ds", playerid, pData[playerid][pName]);
				}
				case 9 :
				{
					new CharQuery[288];
					format(pData[playerid][pTraits2], 20, "%s", "Egois");
					mysql_format(db, CharQuery, sizeof(CharQuery), "SELECT * FROM players WHERE username = '%s'", pData[playerid][pName]);
					mysql_tquery(db, CharQuery, "InsertCharacterToDatabase", "ds", playerid, pData[playerid][pName]);
				}
				case 10 :
				{
					new CharQuery[288];
					format(pData[playerid][pTraits2], 20, "%s", "Naif");
					mysql_format(db, CharQuery, sizeof(CharQuery), "SELECT * FROM players WHERE username = '%s'", pData[playerid][pName]);
					mysql_tquery(db, CharQuery, "InsertCharacterToDatabase", "ds", playerid, pData[playerid][pName]);
				}
			}
		}
	}
	return 1;
}