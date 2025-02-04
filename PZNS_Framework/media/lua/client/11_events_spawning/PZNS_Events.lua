local PZNS_CombatUtils = require("02_mod_utils/PZNS_CombatUtils");
local PZNS_UtilsDataGroups = require("02_mod_utils/PZNS_UtilsDataGroups");
local PZNS_UtilsDataNPCs = require("02_mod_utils/PZNS_UtilsDataNPCs");
local PZNS_UtilsDataZones = require("02_mod_utils/PZNS_UtilsDataZones");
local PZNS_UtilsNPCs = require("02_mod_utils/PZNS_UtilsNPCs");
local PZNS_WorldUtils = require("02_mod_utils/PZNS_WorldUtils");

-- Cows: Sandbox Options if needed
Events.OnInitGlobalModData.Add(PZNS_GetSandboxOptions);
--
Events.OnGameStart.Add(PZNS_UtilsDataGroups.PZNS_GetCreateActiveGroupsModData);
Events.OnGameStart.Add(PZNS_UtilsDataNPCs.PZNS_GetCreateActiveNPCsModData);
Events.OnGameStart.Add(PZNS_UtilsDataZones.PZNS_GetCreateActiveZonesModData);

-- Cows: Perhaps someone else can come up with the multiplayer group creation...
Events.OnGameStart.Add(PZNS_UtilsDataNPCs.PZNS_InitLoadNPCsData);
Events.OnGameStart.Add(PZNS_LocalPlayerGroupCreation);
Events.OnGameStart.Add(PZNS_UpdateISWorldMapRender);
Events.OnGameStart.Add(PZNS_CreateNPCPanelInfo);
Events.OnGameStart.Add(PZNS_CreatePVPButton);
Events.OnGameStart.Add(PZNS_ResetJillTesterSpeechTable);

-- Cows: Events that should load after all other game start events.
local function PZNS_Events()
    -- Events.OnKeyPressed.Add(PZNS_KeyBindAction);
    Events.OnWeaponSwing.Add(PZNS_WeaponSwing);
    Events.OnWeaponHitCharacter.Add(PZNS_CombatUtils.PZNS_CalculatePlayerDamage);
    --
    Events.OnFillWorldObjectContextMenu.Add(PZNS_ContextMenu.PZNS_OnFillWorldObjectContextMenu);
    --
    Events.OnRefreshInventoryWindowContainers.Add(PZNS_AddNPCInv);
    Events.OnFillInventoryObjectContextMenu.Add(PZNS_NPCInventoryContext);
    --
    if (IsNPCsNeedsActive ~= true) then
        Events.EveryHours.Add(PZNS_UtilsNPCs.PZNS_ClearAllNPCsAllNeedsLevel);
    end
    -- Cows: May need to change this to OnPlayerUpdate to address https://github.com/shadowhunter100/PZNS/issues/34...
    -- Cows: Maybe not, since the NPCs will be unloaded much more aggressively/sooner at 45 squares, will confirm after more testing.
    Events.EveryOneMinute.Add(PZNS_WorldUtils.PZNS_SpawnNPCIfSquareIsLoaded);
    Events.OnRenderTick.Add(PZNS_UpdateAllJobsRoutines);
    Events.OnRenderTick.Add(PZNS_RenderNPCsText);
end

Events.OnGameStart.Add(PZNS_Events);
Events.OnSave.Add(PZNS_UtilsDataNPCs.PZNS_SaveAllNPCData);
