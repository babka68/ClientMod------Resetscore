 // Подключим библиотеку ClientMod API для определения клиента игрока
#include <clientmod>          
// Подключим саму библиотеку с цветами
#include <clientmod/multicolors>   

#pragma newdecls required
#pragma semicolon 1

// ConVar 
// Статус плагина
bool g_bEnable;

// Уведомление о доступных командах
bool g_bJoin_Info;

// Уведомление о сбросе счета
bool g_bShow_Info_Reset;

// Уведомление о доступных командах по таймеру
float g_fTime_Join_Info;

public Plugin myinfo = 
{
	name = "[ClientMod] ResetScore", 
	author = "babka68", 
	description = "Плагин позволяет обнулять <Убийства> <Смерти>", 
	version = "1.0", 
	url = "http://tmb-css.ru, https://hlmod.ru, https://vk.com/zakazserver68"
};

public void OnPluginStart()
{
	if (GetEngineVersion() != Engine_SourceSDK2006)
		SetFailState("EN: This plugin works only on CS:S v34 with ClientMod support | RU: Этот плагин работает только в CS:S v34 с поддержкой ClientMod");
	
	LoadTranslations("clientmod/resetscore_cssold.phrases");
	
	AddCommandListener(PerformCommand, "say");
	AddCommandListener(PerformCommand, "say_team");
	
	ConVar cvar;
	cvar = CreateConVar("sm_enable", "1", "1 - Включить, 0 - Отключить плагин. (по умолчанию: 1)", _, true, 0.0, true, 1.0);
	cvar.AddChangeHook(CVarChanged_Enable);
	g_bEnable = cvar.BoolValue;
	
	cvar = CreateConVar("sm_join_info_chat", "1", "Отвечает за вывод сообщения о доступных командах, после успешного подключения на сервер (по умолчанию: 1)", _, true, 0.0, true, 1.0);
	cvar.AddChangeHook(CVarChanged_Join_Info_Chat);
	g_bJoin_Info = cvar.BoolValue;
	
	cvar = CreateConVar("sm_join_info_time", "15", "Отвечает за время вывода сообщения о доступных командах(по умолчанию: 15)", _, true, 0.0, true, 300.0);
	cvar.AddChangeHook(CVarChanged_Time_Join_Info);
	g_fTime_Join_Info = cvar.FloatValue;
	
	cvar = CreateConVar("sm_show_silent_info_reset", "1", "Отвечает за вывод сообщения о сброшенном счёте игрока (по умолчанию: 1)", _, true, 0.0, true, 1.0);
	cvar.AddChangeHook(CVarChanged_Show_Info_Reset);
	g_bShow_Info_Reset = cvar.BoolValue;
	
	AutoExecConfig(true, "clientmod/resetscore");
}

public void CVarChanged_Enable(ConVar cvar, const char[] oldValue, const char[] newValue)
{
	g_bEnable = cvar.BoolValue;
}

public void CVarChanged_Join_Info_Chat(ConVar cvar, const char[] oldValue, const char[] newValue)
{
	g_bJoin_Info = cvar.BoolValue;
}

public void CVarChanged_Time_Join_Info(ConVar cvar, const char[] oldValue, const char[] newValue)
{
	g_fTime_Join_Info = cvar.FloatValue;
}

public void CVarChanged_Show_Info_Reset(ConVar cvar, const char[] oldValue, const char[] newValue)
{
	g_bShow_Info_Reset = cvar.BoolValue;
}

public void OnClientPutInServer(int client)
{
	if (IsFakeClient(client))
		return;
	
	if (g_bJoin_Info)
	{
		CreateTimer(g_fTime_Join_Info, Timer_Notification_Of_Commands, GetClientUserId(client));
	}
}

public Action Timer_Notification_Of_Commands(Handle hTimer, any data)
{
	int client = GetClientOfUserId(data);
	
	if (client && IsClientInGame(client))
	{
		// MoreColors. Если команду набрал ClientMod-игрок, он увидит именно это:
		MC_PrintToChat(client, "%t %t", "prefix_clientmod", "timer_notification_of_commands_clientmod");
		// Colors. А если команду набрал игрок со старым клиентом, он увидит это:
		C_PrintToChat(client, "%t %t", "prefix_old", "timer_notification_of_commands_old");
	}
	return Plugin_Stop;
}

public Action PerformCommand(int client, const char[] szCmd, int iArgs)
{
	if (!client)
	{
		return Plugin_Continue;
	}
	
	if (!g_bEnable)
	{
		// MoreColors. Если команду набрал ClientMod-игрок, он увидит именно это:
		MC_PrintToChat(client, "%t %t", "prefix_clientmod", "plugin_status_clientmod");
		// Colors. А если команду набрал игрок со старым клиентом, он увидит это:
		C_PrintToChat(client, "%t %t", "prefix_old", "plugin_status_old");
		return Plugin_Handled;
	}
	
	static char buffer[MAX_NAME_LENGTH];
	// Извлекает всю строку аргумента команды одним куском из текущей консольной или серверной команды.
	GetCmdArgString(buffer, sizeof(buffer));
	// Удаляет пару кавычек из строки, если она существует.
	StripQuotes(buffer);
	// Удаляет пробельные символы из начала и конца строки.
	TrimString(buffer);
	
	// TODO: Сделать квар или файл, для написания желаемых команд.
	// Сравнивает две строки лексиографически.
	if (strcmp(buffer, "!rs") && strcmp(buffer, "!кы") && strcmp(buffer, "!resetscore") && strcmp(buffer, "!куыуесщку"))
	{
		return Plugin_Continue;
	}
	
	if (g_bShow_Info_Reset)
	{
		
		if (client && IsClientInGame(client) && !IsFakeClient(client) && GetClientFrags(client) == 0 && GetClientDeaths(client) == 0)
		{
			// MoreColors. Если команду набрал ClientMod-игрок, он увидит именно это:
			MC_PrintToChat(client, "%t %t", "prefix_clientmod", "points_already_null_clientmod");
			// Colors. А если команду набрал игрок со старым клиентом, он увидит это:
			C_PrintToChat(client, "%t %t", "prefix_old", "points_already_null_old");
			return Plugin_Handled;
		}
		
		// MoreColors. Если команду набрал ClientMod-игрок, он увидит именно это:
		MC_PrintToChat(client, "%t %t", "prefix_clientmod", "success_reset_points_clientmod");
		// Colors. А если команду набрал игрок со старым клиентом, он увидит это:
		C_PrintToChat(client, "%t %t", "prefix_old", "success_reset_points_old");
		
		// Фраги
		SetEntProp(client, Prop_Data, "m_iFrags", 0);
		// Смерти
		SetEntProp(client, Prop_Data, "m_iDeaths", 0);
	}
	
	return Plugin_Continue;
} 