void Event_Create() {
    HookEvent("player_spawn", OnPlayerSpawn);
    HookEvent("player_disconnect", OnPlayerDisconnect);
}

static void OnPlayerSpawn(Event event, const char[] name, bool dontBroadcast) {
    int userId = event.GetInt("userid");
    int client = GetClientOfUserId(userId);
    int inAliveTeam = GetClientTeam(client) > TEAM_SPECTATOR;

    if (inAliveTeam && Variable_CheckOnSpawn()) {
        UseCase_CheckSettings(client);
    }
}

static Action OnPlayerDisconnect(Event event, const char[] name, bool dontBroadcast) {
    int userId = event.GetInt("userid");
    int client = GetClientOfUserId(userId);

    if (Client_IsKickEventDisabled(client)) {
        event.BroadcastDisabled = true;

        return Plugin_Changed;
    }

    return Plugin_Continue;
}
