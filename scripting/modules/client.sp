static bool g_kickEventDisabled[MAXPLAYERS + 1];

void Client_EnableKickEvent(int client) {
    g_kickEventDisabled[client] = false;
}

void Client_DisableKickEvent(int client) {
    g_kickEventDisabled[client] = true;
}

bool Client_IsKickEventDisabled(int client) {
    return g_kickEventDisabled[client];
}
