void UseCase_OpenSettingsMenu(int client, int target) {
    Settings_QueryForClient(client, target, QueryType_Menu);
}

void UseCase_CheckSettings(int client) {
    Settings_QueryForServer(client, QueryType_Validation);
}

void UseCase_OnCheckSettings(int client, StringMap settings) {
    if (CheckSettingsType(client, settings)) {
        CheckSettingsRange(client, settings);
    }
}

static bool CheckSettingsType(int client, StringMap settings) {
    if (Variable_ValidationMode() < ValidationMode_Type) {
        return false;
    }

    char cvarName[CVAR_NAME_SIZE];
    char cvarValue[CVAR_VALUE_SIZE];

    for (int i = 0; i < Settings_Size(); i++) {
        Settings_GetCvarName(i, cvarName);
        Settings_Get(settings, cvarName, cvarValue);

        ValueType valueType = Settings_GetValueType(i);
        bool isValid;

        if (valueType == ValueType_Int) {
            isValid = CheckIntegerType(client, cvarName, cvarValue);
        } else {
            isValid = CheckFloatType(client, cvarName, cvarValue);
        }

        if (!isValid) {
            return false;
        }
    }

    return true;
}

static void CheckSettingsRange(int client, StringMap settings) {
    if (Variable_ValidationMode() < ValidationMode_Value) {
        return;
    }

    char cvarName[CVAR_NAME_SIZE];
    char cvarValue[CVAR_VALUE_SIZE];

    for (int i = 0; i < Settings_Size(); i++) {
        Settings_GetCvarName(i, cvarName);
        Settings_Get(settings, cvarName, cvarValue);

        ValueType valueType = Settings_GetValueType(i);
        bool isValid;

        if (valueType == ValueType_Int) {
            isValid = CheckIntegerRange(client, cvarName, cvarValue, i);
        } else {
            isValid = CheckFloatRange(client, cvarName, cvarValue, i);
        }

        if (!isValid) {
            break;
        }
    }
}

static bool CheckIntegerType(int client, const char[] cvarName, const char[] cvarValue) {
    if (!Validator_IsInt(cvarValue)) {
        KickClient(client, "%t", "Invalid integer format", cvarName, cvarValue);
        Message_PlayerKickedForInvalidType(client, cvarName, cvarValue);

        return false;
    }

    return true;
}

static bool CheckFloatType(int client, const char[] cvarName, const char[] cvarValue) {
    if (!Validator_IsFloat(cvarValue)) {
        KickClient(client, "%t", "Invalid float format", cvarName, cvarValue);
        Message_PlayerKickedForInvalidType(client, cvarName, cvarValue);

        return false;
    }

    return true;
}

static bool CheckIntegerRange(int client, const char[] cvarName, const char[] cvarValue, int cvarIndex) {
    int minValue = Variable_CvarLimitInteger(cvarIndex * CvarLimit_Amount + CvarLimit_Min);
    int maxValue = Variable_CvarLimitInteger(cvarIndex * CvarLimit_Amount + CvarLimit_Max);
    int value = StringToInt(cvarValue);

    if (value < minValue || value > maxValue) {
        KickClient(client, "%t", "Invalid integer value", cvarName, cvarValue, minValue, maxValue);
        Message_PlayerKickedForInvalidValue(client, cvarName, cvarValue);

        return false;
    }

    return true;
}

static bool CheckFloatRange(int client, const char[] cvarName, const char[] cvarValue, int cvarIndex) {
    float minValue = Variable_CvarLimitFloat(cvarIndex * CvarLimit_Amount + CvarLimit_Min);
    float maxValue = Variable_CvarLimitFloat(cvarIndex * CvarLimit_Amount + CvarLimit_Max);
    float value = StringToFloat(cvarValue);

    if (value < minValue || value > maxValue) {
        KickClient(client, "%t", "Invalid float value", cvarName, cvarValue, minValue, maxValue);
        Message_PlayerKickedForInvalidValue(client, cvarName, cvarValue);

        return false;
    }

    return true;
}

int UseCase_FindPreviousClient(int client) {
    for (int i = client - 1; i > 0; i--) {
        if (IsValidClient(i)) {
            return i;
        }
    }

    return CLIENT_NOT_FOUND;
}

int UseCase_FindNextClient(int client) {
    for (int i = client + 1; i <= MaxClients; i++) {
        if (IsValidClient(i)) {
            return i;
        }
    }

    return CLIENT_NOT_FOUND;
}

static bool IsValidClient(int client) {
    return IsClientInGame(client) && !IsFakeClient(client) && !IsClientSourceTV(client);
}
