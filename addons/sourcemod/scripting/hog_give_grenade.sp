#pragma semicolon 1
#pragma newdecls required

#include <sdktools_functions>
#include <hog_core>

ConVar
	cvGiveGrenade[3];

bool
	bEnableGiveGrenade;

char sGrenadeList[][] =
{
	"weapon_hegrenade",
	"weapon_flashbang",
	"weapon_smokegrenade"
};

public Plugin myinfo = 
{
	name = "[Hog] Grenate Giver",
	author = "Nek.'a 2x2 | ggwp.site ",
	description = "Выдача гранат всем кроме Кабана",
	version = "1.0.0",
	url = "https://ggwp.site/"
};

public void OnPluginStart()
{
	cvGiveGrenade[0] = CreateConVar("sm_hog_no_give_he", "2", "Сколько гранат будет выдачаться в начале раунда НЕ Кабану?");
	cvGiveGrenade[1] = CreateConVar("sm_hog_no_give_fl", "2", "Сколько флешек будет выдачаться в начале раунда НЕ Кабану?");
	cvGiveGrenade[2] = CreateConVar("sm_hog_no_give_sm", "2", "Сколько дыма будет выдачаться в начале раунда НЕ Кабану?");

	HookEvent("player_spawn", Event_PlayerSpawn);
	HookEvent("round_start", Event_OnStart);
	HookEvent("round_end", Event_OnEnd);

	AutoExecConfig(true, "hog_grenade_give_no", "hog");
}

void Event_PlayerSpawn(Event hEvent, const char[] name, bool dontBroadcast)
{
	if(!bEnableGiveGrenade)
        return;

	int client = GetClientOfUserId(GetEventInt(hEvent, "userid"));

	if(HOG_ValideClient(client) && !HOG_GetStstusHog(client))
	{
		GiveWeaponHog(client);
	}	
}

void Event_OnStart(Event hEvent, const char[] name, bool dontBroadcast)
{
	bEnableGiveGrenade = false;
}

void Event_OnEnd(Event hEvent, const char[] name, bool dontBroadcast)
{
	bEnableGiveGrenade = true;
}

stock void GiveWeaponHog(int client)
{
	for(int i = 11, j = 0; i < 14; i++, j++)
	{
		if(GetEntProp(client, Prop_Send, "m_iAmmo", _, i) < 1)
			GivePlayerItem(client, sGrenadeList[j]);
		if(!(GetEntProp(client, Prop_Send, "m_iAmmo", _, i) >= cvGiveGrenade[j].IntValue))
			SetEntProp(client, Prop_Send, "m_iAmmo", cvGiveGrenade[j].IntValue, _, i);
	}
}