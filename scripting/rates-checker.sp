#include <sourcemod>
#include <sdktools>
#include <regex>

#include "rates-checker/bundle"
#include "rates-checker/console-variable"
#include "rates-checker/menu"
#include "rates-checker/message"
#include "rates-checker/settings"
#include "rates-checker/sound"
#include "rates-checker/use-case"
#include "rates-checker/validator"

#include "modules/bundle.sp"
#include "modules/client.sp"
#include "modules/console-command.sp"
#include "modules/console-variable.sp"
#include "modules/event.sp"
#include "modules/menu.sp"
#include "modules/message.sp"
#include "modules/settings.sp"
#include "modules/sound.sp"
#include "modules/use-case.sp"
#include "modules/validator.sp"

public Plugin myinfo = {
    name = "Rates checker",
    author = "Dron-elektron",
    description = "Allows you to check player rates",
    version = "1.5.3",
    url = "https://github.com/dronelektron/rates-checker"
};

public void OnPluginStart() {
    Command_Create();
    Variable_Create();
    Validator_Create();
    Event_Create();
    LoadTranslations("common.phrases");
    LoadTranslations("rates-checker.phrases");
    AutoExecConfig(_, "rates-checker");
}

public void OnPluginEnd() {
    Validator_Destroy();
}

public void OnMapStart() {
    Sound_Precache();
}

public void OnClientConnected(int client) {
    Client_EnableKickEvent(client);
}

public void OnClientPostAdminCheck(int client) {
    UseCase_CheckSettings(client);
}
