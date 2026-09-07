--==============================================================
-- TSL1 SCRIPT
-- Unaigomes
-- Version 1.1
--
-- WindUI Edition
--
-- Funciones:
--   • Custom Animations
--   • Anti-Ragdoll
--   • Anti-Blackout
--   • Animation Keybind
--   • Restauración de animaciones originales
--   • Respawn handling
--==============================================================


--==============================================================
-- WINDUI
--==============================================================

local WindUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"
))()


--==============================================================
-- SERVICES
--==============================================================

local Players = game:GetService("Players")

local Player = Players.LocalPlayer


--==============================================================
-- WINDOW
--==============================================================

local Window = WindUI:CreateWindow({

    Title = "TSL1 Script",

    Author = "Unaigomes • v1.1",

    Folder = "TSL1",

    Icon = "solar:shield-check-bold-duotone",

    IconSize = 24,

    IconRadius = 8,

    IconThemed = true,

    Theme = "Rose",

    Size = UDim2.fromOffset(700, 480),

    MinSize = Vector2.new(560, 350),

    MaxSize = Vector2.new(900, 650),

    Radius = 16,

    Resizable = true,

    AutoScale = true,

    NewElements = true,

    SideBarWidth = 210,

    HideSearchBar = false,

    ScrollBarEnabled = true,

    ToggleKey = Enum.KeyCode.RightShift,

    Topbar = {
        Height = 48,
        ButtonsType = "Mac",
    },

    OpenButton = {
        Title = "TSL1",
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Scale = 0.5,
    },

    User = {
        Enabled = true,
        Anonymous = false,

        Callback = function()

            WindUI:Notify({
                Title = "TSL1",
                Content = "Unaigomes • Version 1.1",
                Icon = "user",
                Duration = 3,
            })

        end,
    },
})


--==============================================================
-- WINDOW TAGS
--==============================================================

Window:Tag({
    Title = "TSL1",
    Icon = "shield",
    Color = Color3.fromHex("#FF8FB3"),
})

Window:Tag({
    Title = "v1.1",
    Color = Color3.fromHex("#C9A7FF"),
})


--==============================================================
-- STATE
--==============================================================

local CustomAnimationsEnabled = false

local AntiRagdollEnabled = false

local AntiBlackoutEnabled = false

local AnimationKeybind = nil

local OriginalAnimations = {}

local Connections = {}


--==============================================================
-- CONNECTION MANAGER
--==============================================================

local function Track(connection)

    table.insert(
        Connections,
        connection
    )

    return connection

end


local function DisconnectAll()

    for _, connection in ipairs(Connections) do

        pcall(function()
            connection:Disconnect()
        end)

    end

    table.clear(Connections)

end


--==============================================================
-- CUSTOM ANIMATIONS
--==============================================================

local CustomAnimations = {

    Idle1 = "rbxassetid://90070641491562",

    Idle2 = "rbxassetid://90070641491562",

    Pose = "rbxassetid://90070641491562",

    Walk = "rbxassetid://100019669366103",

    Run = "rbxassetid://100019669366103",

    Jump = "rbxassetid://18537380791",

    Climb = "rbxassetid://100019669366103",

    Fall = "rbxassetid://18537367238",

    Swim = "rbxassetid://100019669366103",

    SwimIdle = "rbxassetid://100019669366103",

}


--==============================================================
-- GET ANIMATION OBJECTS
--==============================================================

local function GetAnimationObjects(character)

    local Animate = character:FindFirstChild("Animate")

    if not Animate then
        return nil
    end

    local Idle = Animate:FindFirstChild("idle")

    local Walk = Animate:FindFirstChild("walk")

    local Run = Animate:FindFirstChild("run")

    local Jump = Animate:FindFirstChild("jump")

    local Climb = Animate:FindFirstChild("climb")

    local Fall = Animate:FindFirstChild("fall")

    local Swim = Animate:FindFirstChild("swim")

    local SwimIdleFolder =
        Animate:FindFirstChild("swimidle")


    if not Idle
        or not Walk
        or not Run
        or not Jump
        or not Climb
        or not Fall
        or not Swim
        or not SwimIdleFolder then

        return nil

    end


    local Idle1 =
        Idle:FindFirstChild("Animation1")

    local Idle2 =
        Idle:FindFirstChild("Animation2")

    local WalkAnim =
        Walk:FindFirstChild("WalkAnim")

    local RunAnim =
        Run:FindFirstChild("RunAnim")

    local JumpAnim =
        Jump:FindFirstChild("JumpAnim")

    local ClimbAnim =
        Climb:FindFirstChild("ClimbAnim")

    local FallAnim =
        Fall:FindFirstChild("FallAnim")

    local SwimAnim =
        Swim:FindFirstChild("Swim")

    local SwimIdleAnim =
        SwimIdleFolder:FindFirstChild("SwimIdle")


    if not Idle1
        or not Idle2
        or not WalkAnim
        or not RunAnim
        or not JumpAnim
        or not ClimbAnim
        or not FallAnim
        or not SwimAnim
        or not SwimIdleAnim then

        return nil

    end


    return {

        Animate = Animate,

        Idle1 = Idle1,

        Idle2 = Idle2,

        Walk = WalkAnim,

        Run = RunAnim,

        Jump = JumpAnim,

        Climb = ClimbAnim,

        Fall = FallAnim,

        Swim = SwimAnim,

        SwimIdle = SwimIdleAnim,

        Pose = Idle:FindFirstChild("Animation3"),

    }

end


--==============================================================
-- SAVE ORIGINAL ANIMATIONS
--==============================================================

local function SaveOriginalAnimations(character)

    if OriginalAnimations[character] then
        return
    end


    local Objects =
        GetAnimationObjects(character)


    if not Objects then
        return
    end


    OriginalAnimations[character] = {

        Idle1 = Objects.Idle1.AnimationId,

        Idle2 = Objects.Idle2.AnimationId,

        Walk = Objects.Walk.AnimationId,

        Run = Objects.Run.AnimationId,

        Jump = Objects.Jump.AnimationId,

        Climb = Objects.Climb.AnimationId,

        Fall = Objects.Fall.AnimationId,

        Swim = Objects.Swim.AnimationId,

        SwimIdle = Objects.SwimIdle.AnimationId,

        Pose =
            Objects.Pose
            and Objects.Pose.AnimationId
            or nil,

    }

end


--==============================================================
-- STOP ALL ANIMATIONS
--==============================================================

local function StopAllAnimations(character)

    local Humanoid =
        character:FindFirstChildOfClass(
            "Humanoid"
        )


    if not Humanoid then
        return
    end


    local Animator =
        Humanoid:FindFirstChildOfClass(
            "Animator"
        )


    if not Animator then
        return
    end


    for _, TrackObject in ipairs(
        Animator:GetPlayingAnimationTracks()
    ) do

        pcall(function()

            TrackObject:Stop(0)

        end)

    end

end


--==============================================================
-- APPLY CUSTOM ANIMATIONS
--==============================================================

local function ApplyCustomAnimations(character)

    local Humanoid =
        character:FindFirstChildOfClass(
            "Humanoid"
        )


    if not Humanoid then
        return false
    end


    if Humanoid.RigType
        ~= Enum.HumanoidRigType.R15 then

        WindUI:Notify({
            Title = "Custom Animations",
            Content = "R15 is required.",
            Icon = "triangle-alert",
            Duration = 4,
        })

        return false
    end


    local Objects =
        GetAnimationObjects(character)


    if not Objects then

        WindUI:Notify({
            Title = "Custom Animations",
            Content = "Animate structure could not be found.",
            Icon = "triangle-alert",
            Duration = 4,
        })

        return false

    end


    SaveOriginalAnimations(character)

    StopAllAnimations(character)


    Objects.Idle1.AnimationId =
        CustomAnimations.Idle1

    Objects.Idle2.AnimationId =
        CustomAnimations.Idle2


    if Objects.Pose then

        Objects.Pose.AnimationId =
            CustomAnimations.Pose

    else

        local Pose =
            Instance.new("Animation")

        Pose.Name = "Animation3"

        Pose.AnimationId =
            CustomAnimations.Pose

        Pose.Parent =
            Objects.Animate.idle

    end


    Objects.Walk.AnimationId =
        CustomAnimations.Walk

    Objects.Run.AnimationId =
        CustomAnimations.Run

    Objects.Jump.AnimationId =
        CustomAnimations.Jump

    Objects.Climb.AnimationId =
        CustomAnimations.Climb

    Objects.Fall.AnimationId =
        CustomAnimations.Fall

    Objects.Swim.AnimationId =
        CustomAnimations.Swim

    Objects.SwimIdle.AnimationId =
        CustomAnimations.SwimIdle


    Objects.Animate.Disabled = false


    Humanoid:ChangeState(
        Enum.HumanoidStateType.GettingUp
    )


    print(
        "[TSL1] Custom animations: ON"
    )


    return true

end


--==============================================================
-- RESTORE ORIGINAL ANIMATIONS
--==============================================================

local function RestoreOriginalAnimations(character)

    local Humanoid =
        character:FindFirstChildOfClass(
            "Humanoid"
        )


    if not Humanoid then
        return false
    end


    local Objects =
        GetAnimationObjects(character)


    local Original =
        OriginalAnimations[character]


    if not Objects or not Original then
        return false
    end


    ----------------------------------------------------------
    -- STOP CUSTOM TRACKS
    ----------------------------------------------------------

    StopAllAnimations(character)


    ----------------------------------------------------------
    -- RESTORE IDS
    ----------------------------------------------------------

    Objects.Idle1.AnimationId =
        Original.Idle1

    Objects.Idle2.AnimationId =
        Original.Idle2

    Objects.Walk.AnimationId =
        Original.Walk

    Objects.Run.AnimationId =
        Original.Run

    Objects.Jump.AnimationId =
        Original.Jump

    Objects.Climb.AnimationId =
        Original.Climb

    Objects.Fall.AnimationId =
        Original.Fall

    Objects.Swim.AnimationId =
        Original.Swim

    Objects.SwimIdle.AnimationId =
        Original.SwimIdle


    ----------------------------------------------------------
    -- RESTORE POSE
    ----------------------------------------------------------

    if Original.Pose then

        local Pose =
            Objects.Animate.idle
            :FindFirstChild("Animation3")


        if Pose then

            Pose.AnimationId =
                Original.Pose

        end

    end


    ----------------------------------------------------------
    -- RESTART ANIMATE
    ----------------------------------------------------------

    Objects.Animate.Disabled = true

    task.wait()

    StopAllAnimations(character)

    Objects.Animate.Disabled = false


    Humanoid:ChangeState(
        Enum.HumanoidStateType.GettingUp
    )


    print(
        "[TSL1] Custom animations: OFF"
    )


    return true

end


--==============================================================
-- SET CUSTOM ANIMATIONS
--==============================================================

local function SetCustomAnimations(enabled)

    CustomAnimationsEnabled =
        enabled
    SaveBlacklistState()


    local Character =
        Player.Character


    if not Character then
        return
    end


    if enabled then

        ApplyCustomAnimations(
            Character
        )

    else

        RestoreOriginalAnimations(
            Character
        )

    end

end


local function ToggleCustomAnimations()

    SetCustomAnimations(
        not CustomAnimationsEnabled
    )

end


--==============================================================
-- ANTI RAGDOLL
--==============================================================

local function GetRagdoll()

    local PlayerScripts =
        Player:FindFirstChild(
            "PlayerScripts"
        )


    if not PlayerScripts then
        return nil
    end


    local GameFolder =
        PlayerScripts:FindFirstChild(
            "Game"
        )


    if not GameFolder then
        return nil
    end


    return GameFolder:FindFirstChild(
        "Ragdoll"
    )

end


local function SetRagdollDisabled(value)

    local Ragdoll =
        GetRagdoll()


    if not Ragdoll then

        return false

    end


    local success = pcall(function()

        if Ragdoll:IsA("LocalScript")
            or Ragdoll:IsA("Script") then

            Ragdoll.Disabled =
                value

        end

    end)


    return success

end


--==============================================================
-- ANTI BLACKOUT
--==============================================================

local CameraConnection = nil


local function ClearBlackout()

    local Camera =
        workspace.CurrentCamera


    if not Camera then
        return
    end


    for _, Object in ipairs(
        Camera:GetChildren()
    ) do

        if Object:IsA(
            "ColorCorrectionEffect"
        ) then

            Object:Destroy()

        end

    end

end


local function ConnectCamera(Camera)

    if CameraConnection then

        pcall(function()
            CameraConnection:Disconnect()
        end)

        CameraConnection = nil

    end


    if not Camera then
        return
    end


    CameraConnection =
        Camera.ChildAdded:Connect(
            function(Object)

                if not AntiBlackoutEnabled then
                    return
                end


                if Object:IsA(
                    "ColorCorrectionEffect"
                ) then

                    Object:Destroy()

                end

            end
        )


    Track(CameraConnection)

end


ConnectCamera(
    workspace.CurrentCamera
)


Track(
    workspace:GetPropertyChangedSignal(
        "CurrentCamera"
    ):Connect(function()

        ConnectCamera(
            workspace.CurrentCamera
        )


        if AntiBlackoutEnabled then
            ClearBlackout()
        end

    end)
)


local function SetAntiBlackout(enabled)

    AntiBlackoutEnabled =
        enabled
    SaveBlacklistState()


    if enabled then

        ClearBlackout()

    end

end



--==============================================================
-- BLACKLIST / ENEMY ALERTS / SPY
--==============================================================

local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Persistent configuration.
-- Uses executor file APIs when available, with getgenv() as a fallback.
local ConfigFile = "TSL1_Config.json"
local Config = {}

local function LoadConfig()
    local loaded

    if type(isfile) == "function" and type(readfile) == "function" then
        local ok, raw = pcall(function()
            if isfile(ConfigFile) then
                return readfile(ConfigFile)
            end
        end)

        if ok and raw and raw ~= "" then
            local success, decoded = pcall(function()
                return game:GetService("HttpService"):JSONDecode(raw)
            end)
            if success and type(decoded) == "table" then
                loaded = decoded
            end
        end
    end

    if not loaded then
        getgenv().TSL1Config = getgenv().TSL1Config or {}
        loaded = getgenv().TSL1Config
    end

    return loaded
end

local function SaveConfig()
    getgenv().TSL1Config = Config

    if type(writefile) == "function" then
        pcall(function()
            writefile(
                ConfigFile,
                game:GetService("HttpService"):JSONEncode(Config)
            )
        end)
    end
end

Config = LoadConfig()
Config.Blacklist = type(Config.Blacklist) == "table" and Config.Blacklist or {}
Config.BlacklistAlertsEnabled = Config.BlacklistAlertsEnabled ~= false

local Blacklist = Config.Blacklist
local BlacklistAlertsEnabled = Config.BlacklistAlertsEnabled
local SelectedBlacklistPlayer = nil
local SpyKeybind = nil
local SpyEnabled = false
local SpyTarget = nil
local SpyConnection = nil
local AlertTokens = {}

-- WindUI Keybind callbacks may provide either Enum.KeyCode or a string.
local function NormalizeKeybind(key)
    if typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
        return key
    end

    if type(key) == "string" then
        local name = key
        if string.sub(name, 1, 14) == "Enum.KeyCode." then
            name = string.sub(name, 14)
        end

        local ok, result = pcall(function()
            return Enum.KeyCode[name]
        end)

        if ok and result then
            return result
        end
    end

    return nil
end

local function KeybindMatches(inputKeyCode, configuredKey)
    local normalized = NormalizeKeybind(configuredKey)
    return normalized ~= nil and inputKeyCode == normalized
end

local function SaveBlacklistState()
    Config.Blacklist = Blacklist
    Config.BlacklistAlertsEnabled = BlacklistAlertsEnabled
    local normalizedSpyKeybind = NormalizeKeybind(SpyKeybind)
    local normalizedAnimationKeybind = NormalizeKeybind(AnimationKeybind)

    Config.SpyKeybind = normalizedSpyKeybind and normalizedSpyKeybind.Name or nil
    Config.AnimationKeybind =
        normalizedAnimationKeybind and normalizedAnimationKeybind.Name
        or Config.AnimationKeybind
    Config.CustomAnimationsEnabled = CustomAnimationsEnabled
    Config.AntiRagdollEnabled = AntiRagdollEnabled
    Config.AntiBlackoutEnabled = AntiBlackoutEnabled
    SaveConfig()
end

-- Restore persisted keybind/settings.
if Config.SpyKeybind then
    SpyKeybind = NormalizeKeybind(Config.SpyKeybind)
end
if Config.AnimationKeybind then
    AnimationKeybind = NormalizeKeybind(Config.AnimationKeybind)
end
if Config.CustomAnimationsEnabled ~= nil then
    CustomAnimationsEnabled = Config.CustomAnimationsEnabled == true
end
if Config.AntiRagdollEnabled ~= nil then
    AntiRagdollEnabled = Config.AntiRagdollEnabled == true
end
if Config.AntiBlackoutEnabled ~= nil then
    AntiBlackoutEnabled = Config.AntiBlackoutEnabled == true
end

local function NormalizeName(name)
    return string.lower(string.gsub(tostring(name or ""), "^%s*(.-)%s*$", "%1"))
end

local function IsBlacklisted(playerName)
    local wanted = NormalizeName(playerName)

    for _, name in ipairs(Blacklist) do
        if NormalizeName(name) == wanted then
            return true
        end
    end

    return false
end

local function FindBlacklistedName(playerName)
    local wanted = NormalizeName(playerName)

    for _, name in ipairs(Blacklist) do
        if NormalizeName(name) == wanted then
            return name
        end
    end

    return nil
end

local function NativeNotify(title, content, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = content,
            Duration = duration or 5,
        })
    end)
end

local function StopAlert(playerName)
    local key = NormalizeName(playerName)

    if AlertTokens[key] then
        AlertTokens[key].Stopped = true
        AlertTokens[key] = nil
    end
end

local function StartAlert(player)
    if not player or player == Player then
        return
    end

    if not BlacklistAlertsEnabled or not IsBlacklisted(player.Name) then
        return
    end

    local key = NormalizeName(player.Name)

    -- Do not create multiple alert loops for the same player.
    if AlertTokens[key] then
        return
    end

    local token = {Stopped = false}
    AlertTokens[key] = token

    task.spawn(function()
        while not token.Stopped
            and BlacklistAlertsEnabled
            and player.Parent
            and IsBlacklisted(player.Name) do

            NativeNotify(
                "⚠ BLACKLIST ALERT",
                player.Name .. " has joined the server.",
                5
            )

            task.wait(2)
        end

        if AlertTokens[key] == token then
            AlertTokens[key] = nil
        end
    end)
end

local function StopAllAlerts()
    for key, token in pairs(AlertTokens) do
        token.Stopped = true
        AlertTokens[key] = nil
    end
end

local function GetBlacklistValues()
    local values = {}

    for _, name in ipairs(Blacklist) do
        table.insert(values, name)
    end

    if #values == 0 then
        table.insert(values, "— Blacklist empty —")
    end

    return values
end

local BlacklistDropdown

local function RefreshBlacklistDropdown()
    if BlacklistDropdown then
        pcall(function()
            BlacklistDropdown:Refresh(GetBlacklistValues())
        end)
    end
end

local function AddToBlacklist(name)
    name = tostring(name or "")
    name = string.gsub(name, "^%s*(.-)%s*$", "%1")

    if name == "" then
        WindUI:Notify({
            Title = "Blacklist",
            Content = "Enter a username first.",
            Icon = "triangle-alert",
            Duration = 3,
        })
        return
    end

    if NormalizeName(name) == NormalizeName(Player.Name) then
        WindUI:Notify({
            Title = "Blacklist",
            Content = "You cannot blacklist yourself.",
            Icon = "user-x",
            Duration = 3,
        })
        return
    end

    if IsBlacklisted(name) then
        WindUI:Notify({
            Title = "Blacklist",
            Content = name .. " is already in the list.",
            Icon = "info",
            Duration = 3,
        })
        return
    end

    table.insert(Blacklist, name)
    SaveBlacklistState()
    RefreshBlacklistDropdown()

    -- If the player is already in this server, alert immediately.
    local existing = Players:FindFirstChild(name)
    if existing then
        StartAlert(existing)
    end

    WindUI:Notify({
        Title = "Blacklist",
        Content = name .. " added.",
        Icon = "user-plus",
        Duration = 3,
    })
end

local function RemoveFromBlacklist(name)
    local wanted = NormalizeName(name)

    if wanted == "" or wanted == "— blacklist empty —" then
        return
    end

    for i = #Blacklist, 1, -1 do
        if NormalizeName(Blacklist[i]) == wanted then
            local removed = table.remove(Blacklist, i)
            StopAlert(removed)
            SaveBlacklistState()
            RefreshBlacklistDropdown()

            if NormalizeName(SelectedBlacklistPlayer) == wanted then
                SelectedBlacklistPlayer = nil
            end

            WindUI:Notify({
                Title = "Blacklist",
                Content = removed .. " removed.",
                Icon = "user-minus",
                Duration = 3,
            })
            return
        end
    end

    WindUI:Notify({
        Title = "Blacklist",
        Content = name .. " was not found.",
        Icon = "triangle-alert",
        Duration = 3,
    })
end

local function RestoreOwnCamera()
    local Camera = workspace.CurrentCamera
    local Character = Player.Character
    local Humanoid = Character
        and Character:FindFirstChildOfClass("Humanoid")

    if Camera and Humanoid then
        Camera.CameraType = Enum.CameraType.Custom
        Camera.CameraSubject = Humanoid
    end
end

local function StopSpy()
    SpyEnabled = false
    SpyTarget = nil

    if SpyConnection then
        pcall(function()
            SpyConnection:Disconnect()
        end)
        SpyConnection = nil
    end

    pcall(function()
        RunService:UnbindFromRenderStep("TSL1_SpyCamera")
    end)

    RestoreOwnCamera()
end

local function StartSpy(playerName)
    local target = Players:FindFirstChild(playerName)

    if not target or target == Player then
        WindUI:Notify({
            Title = "Spy",
            Content = "That player is not currently in this server.",
            Icon = "triangle-alert",
            Duration = 3,
        })
        StopSpy()
        return
    end

    SpyEnabled = true
    SpyTarget = target

    -- Remove any previous camera loop before creating the new one.
    pcall(function()
        RunService:UnbindFromRenderStep("TSL1_SpyCamera")
    end)

    -- The game may have its own camera controller that resets CameraSubject.
    -- RenderStep runs after the normal camera update, so we continuously force
    -- the target Humanoid until the user toggles Spy off.
    RunService:BindToRenderStep(
        "TSL1_SpyCamera",
        Enum.RenderPriority.Camera.Value + 10,
        function()
            if not SpyEnabled or SpyTarget ~= target or not target.Parent then
                return
            end

            local Camera = workspace.CurrentCamera
            if not Camera then
                return
            end

            local Character = target.Character
            local Humanoid = Character
                and Character:FindFirstChildOfClass("Humanoid")

            if Humanoid then
                Camera.CameraType = Enum.CameraType.Custom
                Camera.CameraSubject = Humanoid
            end
        end
    )

    -- Handle respawns of the target without cancelling Spy.
    SpyConnection = target.CharacterAdded:Connect(function()
        if not SpyEnabled or SpyTarget ~= target then
            return
        end

        task.defer(function()
            if SpyEnabled and SpyTarget == target then
                local Camera = workspace.CurrentCamera
                local Character = target.Character
                local Humanoid = Character
                    and Character:FindFirstChildOfClass("Humanoid")

                if Camera and Humanoid then
                    Camera.CameraType = Enum.CameraType.Custom
                    Camera.CameraSubject = Humanoid
                end
            end
        end)
    end)

    WindUI:Notify({
        Title = "Spy ON",
        Content = "Watching " .. target.Name .. ". Press the Spy keybind again to return.",
        Icon = "eye",
        Duration = 4,
    })
end

local function ToggleSpy()
    if SpyEnabled then
        StopSpy()

        WindUI:Notify({
            Title = "Spy OFF",
            Content = "Camera restored to your character.",
            Icon = "eye-off",
            Duration = 3,
        })

        return
    end

    if not SelectedBlacklistPlayer then
        WindUI:Notify({
            Title = "Spy",
            Content = "Select a player from the blacklist first.",
            Icon = "triangle-alert",
            Duration = 3,
        })
        return
    end

    StartSpy(SelectedBlacklistPlayer)
end

local function CheckExistingBlacklistedPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Player and IsBlacklisted(player.Name) then
            StartAlert(player)
        end
    end
end

-- Detect joins globally for the current server.
Track(
    Players.PlayerAdded:Connect(function(player)
        if IsBlacklisted(player.Name) then
            StartAlert(player)
        end
    end)
)

Track(
    Players.PlayerRemoving:Connect(function(player)
        StopAlert(player.Name)

        if SpyTarget == player then
            StopSpy()
        end
    end)
)

--==============================================================
-- TAB: BLACKLIST
--==============================================================

local BlacklistTab = Window:Tab({
    Title = "Blacklist",
    Icon = "user-round-x",
    Desc = "Enemy alerts and player spy",
})

BlacklistTab:Paragraph({
    Title = "Enemy Blacklist",
    Desc =
        "Add usernames to detect them when they join this server. " ..
        "Alerts repeat until disabled.",
    Image = "shield-alert",
    ImageSize = 24,
})

BlacklistTab:Divider()

local BlacklistInput
local BlacklistSuggestions

local function GetPlayerSuggestions(query)
    local values = {}
    query = string.lower(tostring(query or ""))

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Player then
            local name = player.Name
            if query == "" or string.find(string.lower(name), query, 1, true) then
                table.insert(values, name)
            end
        end
    end

    table.sort(values, function(a, b)
        return string.lower(a) < string.lower(b)
    end)

    if #values == 0 then
        table.insert(values, "— No matching players —")
    end

    return values
end

BlacklistInput = BlacklistTab:Input({
    Title = "Add Player",
    Desc = "Type part of a username. The list below filters as you type.",
    Placeholder = "Start typing a username...",
    InputIcon = "user-plus",
    Callback = function(value)
        if BlacklistSuggestions then
            pcall(function()
                BlacklistSuggestions:Refresh(GetPlayerSuggestions(value))
            end)
        end
    end,
})

BlacklistSuggestions = BlacklistTab:Dropdown({
    Title = "Matching Players",
    Desc = "Select a player from the filtered list to add them.",
    Values = GetPlayerSuggestions(""),
    AllowNone = true,
    SearchBarEnabled = false,
    Callback = function(value)
        if type(value) == "table" then
            value = value[1]
        end

        if not value or value == "— No matching players —" then
            return
        end

        AddToBlacklist(value)
    end,
})

BlacklistTab:Button({
    Title = "Add Typed Username",
    Desc = "Add the exact username currently in the textbox.",
    Icon = "user-plus",
    Callback = function()
        local value = BlacklistInput and BlacklistInput.Value
        AddToBlacklist(value)
    end,
})

BlacklistTab:Space()

BlacklistDropdown = BlacklistTab:Dropdown({
    Title = "Blacklisted Players",
    Desc = "Scrollable/searchable list. Select a player for Spy.",
    Values = GetBlacklistValues(),
    AllowNone = true,
    SearchBarEnabled = true,
    Callback = function(value)
        if type(value) == "table" then
            value = value[1]
        end

        if value == "— Blacklist empty —" then
            SelectedBlacklistPlayer = nil
            return
        end

        SelectedBlacklistPlayer = value

        WindUI:Notify({
            Title = "Blacklist selected",
            Content = tostring(value),
            Icon = "user-check",
            Duration = 2,
        })
    end,
})

BlacklistTab:Space()

BlacklistTab:Button({
    Title = "Remove Selected",
    Desc = "Remove the currently selected player from the blacklist.",
    Icon = "user-minus",
    Callback = function()
        if not SelectedBlacklistPlayer then
            WindUI:Notify({
                Title = "Blacklist",
                Content = "Select a player from the list first.",
                Icon = "triangle-alert",
                Duration = 3,
            })
            return
        end

        RemoveFromBlacklist(SelectedBlacklistPlayer)
    end,
})

BlacklistTab:Divider()

local AlertToggle

AlertToggle = BlacklistTab:Toggle({
    Title = "Join Alerts",
    Desc = "Repeat a Roblox notification while a blacklisted player is here.",
    Value = BlacklistAlertsEnabled,
    Flag = "BlacklistAlerts",
    Callback = function(enabled)
        BlacklistAlertsEnabled = enabled
        SaveBlacklistState()

        if not enabled then
            StopAllAlerts()
        else
            CheckExistingBlacklistedPlayers()
        end

        WindUI:Notify({
            Title = "Blacklist Alerts",
            Content = enabled
                and "Join alerts enabled."
                or "Join alerts disabled.",
            Icon = enabled and "bell" or "bell-off",
            Duration = 3,
        })
    end,
})

BlacklistTab:Button({
    Title = "Stop Current Alerts",
    Desc = "Immediately stops every repeating blacklist notification.",
    Icon = "bell-off",
    Callback = function()
        StopAllAlerts()

        WindUI:Notify({
            Title = "Blacklist",
            Content = "All active alerts stopped.",
            Icon = "check",
            Duration = 3,
        })
    end,
})

BlacklistTab:Divider()

BlacklistTab:Paragraph({
    Title = "Spy Camera",
    Desc =
        "Select a blacklisted player, then use the keybind below. " ..
        "Press it again to return to your camera.",
    Image = "eye",
    ImageSize = 24,
})

BlacklistTab:Keybind({
    Title = "Spy Keybind",
    Desc = "Toggle camera between you and the selected player.",
    Value = Config.SpyKeybind or "None",
    Callback = function(key)
        SpyKeybind = NormalizeKeybind(key)
        SaveBlacklistState()
    end,
})

BlacklistTab:Button({
    Title = "Spy Selected Player",
    Desc = "Manually toggle the camera for the selected player.",
    Icon = "eye",
    Callback = function()
        ToggleSpy()
    end,
})

BlacklistTab:Button({
    Title = "Return to My Camera",
    Desc = "Immediately stop Spy mode.",
    Icon = "camera",
    Callback = function()
        if SpyEnabled then
            StopSpy()
        else
            RestoreOwnCamera()
        end
    end,
})

-- Check players already present when the tab is created.
task.defer(CheckExistingBlacklistedPlayers)


--==============================================================
-- TAB: PROTECCIÓN
--==============================================================

local ProtectionTab = Window:Tab({

    Title = "Protección",

    Icon = "shield-check",

    Desc = "Ragdoll y blackout",

})


ProtectionTab:Paragraph({

    Title = "Protección",

    Desc =
        "Controles defensivos de TSL1. " ..
        "Los estados se mantienen durante el respawn.",

    Image = "shield",

    ImageSize = 24,

})


ProtectionTab:Divider()


--==============================================================
-- ANTI RAGDOLL TOGGLE
--==============================================================

local AntiRagdollToggle

AntiRagdollToggle =
    ProtectionTab:Toggle({

        Title = "Anti-Ragdoll",

        Desc =
            "Desactiva el LocalScript Game.Ragdoll.",

        Value = AntiRagdollEnabled,

        Flag = "AntiRagdoll",

        Callback = function(enabled)

            AntiRagdollEnabled =
                enabled
            SaveBlacklistState()


            local success =
                SetRagdollDisabled(
                    enabled
                )


            if enabled then

                WindUI:Notify({

                    Title = "Anti-Ragdoll",

                    Content =
                        success
                        and "Anti-Ragdoll activado."
                        or "No se encontró Game.Ragdoll.",

                    Icon =
                        success
                        and "shield-check"
                        or "triangle-alert",

                    Duration = 3,

                })

            else

                WindUI:Notify({

                    Title = "Anti-Ragdoll",

                    Content =
                        success
                        and "Anti-Ragdoll desactivado."
                        or "No se encontró Game.Ragdoll.",

                    Icon =
                        "shield-off",

                    Duration = 3,

                })

            end

        end,

    })


ProtectionTab:Space()


--==============================================================
-- ANTI BLACKOUT TOGGLE
--==============================================================

local AntiBlackoutToggle

AntiBlackoutToggle =
    ProtectionTab:Toggle({

        Title = "Anti-Blackout",

        Desc =
            "Elimina ColorCorrectionEffect de la cámara.",

        Value = AntiBlackoutEnabled,

        Flag = "AntiBlackout",

        Callback = function(enabled)

            SetAntiBlackout(
                enabled
            )


            WindUI:Notify({

                Title = "Anti-Blackout",

                Content =
                    enabled
                    and "Anti-Blackout activado."
                    or "Anti-Blackout desactivado.",

                Icon =
                    enabled
                    and "moon"
                    or "sun",

                Duration = 3,

            })

        end,

    })


ProtectionTab:Divider()


--==============================================================
-- PROTECTION RESET
--==============================================================

ProtectionTab:Button({

    Title = "Desactivar protecciones",

    Desc =
        "Apaga Anti-Ragdoll y Anti-Blackout.",

    Icon = "shield-off",

    Callback = function()

        AntiRagdollEnabled = false
        AntiBlackoutEnabled = false
        SaveBlacklistState()


        SetRagdollDisabled(false)

        ClearBlackout()


        if AntiRagdollToggle then
            AntiRagdollToggle:Set(false)
        end


        if AntiBlackoutToggle then
            AntiBlackoutToggle:Set(false)
        end


        WindUI:Notify({

            Title = "TSL1",

            Content =
                "Protecciones desactivadas.",

            Icon = "check",

            Duration = 3,

        })

    end,

})


--==============================================================
-- TAB: ANIMACIONES
--==============================================================

local AnimationsTab = Window:Tab({

    Title = "Animaciones",

    Icon = "person-standing",

    Desc = "Animaciones personalizadas",

})


AnimationsTab:Paragraph({

    Title = "Custom Animations",

    Desc =
        "Sustituye las animaciones del personaje " ..
        "y permite restaurarlas posteriormente.",

    Image = "sparkles",

    ImageSize = 24,

})


AnimationsTab:Divider()


--==============================================================
-- CUSTOM ANIMATION TOGGLE
--==============================================================

local AnimationSwitch

AnimationSwitch =
    AnimationsTab:Toggle({

        Title = "Custom Animations",

        Desc =
            "Activa o restaura las animaciones del juego.",

        Value = CustomAnimationsEnabled,

        Flag = "CustomAnimations",

        Callback = function(enabled)

            SetCustomAnimations(
                enabled
            )


            WindUI:Notify({

                Title = "Custom Animations",

                Content =
                    enabled
                    and "Animaciones personalizadas activadas."
                    or "Animaciones originales restauradas.",

                Icon =
                    enabled
                    and "sparkles"
                    or "rotate-ccw",

                Duration = 3,

            })

        end,

    })


AnimationsTab:Divider()


--==============================================================
-- KEYBIND
--==============================================================

AnimationsTab:Keybind({

    Title = "Animation Keybind",

    Desc =
        "Pulsa una tecla para activar/desactivar las animaciones.",

    Value = Config.AnimationKeybind or "None",

    Callback = function(key)

        AnimationKeybind = key
        Config.AnimationKeybind = key and key.Name or nil
        SaveConfig()

    end,

})


--==============================================================
-- RESTORE BUTTON
--==============================================================

AnimationsTab:Button({

    Title = "Restaurar animaciones originales",

    Desc =
        "Desactiva Custom Animations y recupera los IDs guardados.",

    Icon = "rotate-ccw",

    Callback = function()

        CustomAnimationsEnabled =
            false
        SaveBlacklistState()


        if AnimationSwitch then
            AnimationSwitch:Set(false)
        end


        if Player.Character then

            RestoreOriginalAnimations(
                Player.Character
            )

        end


        WindUI:Notify({

            Title = "Animaciones",

            Content =
                "Animaciones originales restauradas.",

            Icon = "check",

            Duration = 3,

        })

    end,

})


--==============================================================
-- ANIMATION INFORMATION
--==============================================================

AnimationsTab:Divider()


AnimationsTab:Paragraph({

    Title = "Animation IDs",

    Desc =
        "Idle / Pose: 90070641491562\n" ..
        "Walk / Run / Climb / Swim: 100019669366103\n" ..
        "Jump: 18537380791\n" ..
        "Fall: 18537367238",

    Image = "database",

    ImageSize = 22,

})


--==============================================================
-- TAB: CONFIGURACIÓN
--==============================================================

local SettingsTab = Window:Tab({

    Title = "Configuración",

    Icon = "settings",

    Desc = "Estado y controles del script",

})


SettingsTab:Paragraph({

    Title = "TSL1 Script",

    Desc =
        "Unaigomes • Version 1.1\n\n" ..
        "WindUI Edition\n" ..
        "Protection + Custom Animations",

    Image = "info",

    ImageSize = 24,

})


SettingsTab:Divider()


SettingsTab:Button({

    Title = "Guardar animaciones originales",

    Icon = "save",

    Callback = function()

        if Player.Character then

            SaveOriginalAnimations(
                Player.Character
            )


            WindUI:Notify({

                Title = "TSL1",

                Content =
                    "Animaciones originales guardadas.",

                Icon = "save",

                Duration = 3,

            })

        end

    end,

})


SettingsTab:Button({

    Title = "Aplicar Anti-Ragdoll ahora",

    Icon = "shield-check",

    Callback = function()

        AntiRagdollEnabled = true

        SetRagdollDisabled(true)


        if AntiRagdollToggle then
            AntiRagdollToggle:Set(true)
        end


        WindUI:Notify({

            Title = "Anti-Ragdoll",

            Content =
                "Aplicado manualmente.",

            Icon = "shield-check",

            Duration = 3,

        })

    end,

})


SettingsTab:Button({

    Title = "Limpiar Blackout ahora",

    Icon = "moon",

    Callback = function()

        ClearBlackout()


        WindUI:Notify({

            Title = "Anti-Blackout",

            Content =
                "ColorCorrectionEffect limpiado.",

            Icon = "check",

            Duration = 3,

        })

    end,

})


SettingsTab:Divider()


SettingsTab:Paragraph({

    Title = "WindUI",

    Desc =
        "Interfaz construida con WindUI.\n" ..
        "Toggle UI: RightShift",

    Image = "layout-dashboard",

    ImageSize = 22,

})


--==============================================================
-- KEYBIND HANDLER
--==============================================================

Track(
    game:GetService(
        "UserInputService"
    ).InputBegan:Connect(
        function(Input, GameProcessed)

            if GameProcessed then
                return
            end


            if Input.UserInputType
                ~= Enum.UserInputType.Keyboard then

                return
            end

            -- Animation and Spy keybinds are independent.
            -- The old handler returned here when AnimationKeybind was nil,
            -- which prevented Spy from ever receiving the keyboard input.
            if KeybindMatches(Input.KeyCode, AnimationKeybind) then
                ToggleCustomAnimations()
                return
            end

            -- One press = Spy ON. Next press = Spy OFF.
            if KeybindMatches(Input.KeyCode, SpyKeybind) then
                ToggleSpy()
                return
            end

        end
    )
)


--==============================================================
-- CHARACTER RESPAWN
--==============================================================

Track(
    Player.CharacterAdded:Connect(
        function(Character)

            task.wait(1)


            --------------------------------------------------
            -- SAVE ORIGINAL ANIMATIONS
            --------------------------------------------------

            SaveOriginalAnimations(
                Character
            )


            --------------------------------------------------
            -- CUSTOM ANIMATIONS
            --------------------------------------------------

            if CustomAnimationsEnabled then

                ApplyCustomAnimations(
                    Character
                )

            end


            --------------------------------------------------
            -- ANTI RAGDOLL
            --------------------------------------------------

            if AntiRagdollEnabled then

                SetRagdollDisabled(
                    true
                )

            end


            --------------------------------------------------
            -- ANTI BLACKOUT
            --------------------------------------------------

            if AntiBlackoutEnabled then

                ClearBlackout()

            end

        end
    )
)


--==============================================================
-- INITIAL CHARACTER
--==============================================================

if Player.Character then

    task.spawn(function()

        task.wait(1)


        SaveOriginalAnimations(
            Player.Character
        )


        if AntiRagdollEnabled then

            SetRagdollDisabled(
                true
            )

        end


        if AntiBlackoutEnabled then

            ClearBlackout()

        end

    end)

end


--==============================================================
-- WINDOW CALLBACKS
--==============================================================

Window:OnOpen(function()

    print(
        "[TSL1] Window opened."
    )

end)


Window:OnClose(function()

    print(
        "[TSL1] Window closed."
    )

end)


--==============================================================
-- STARTUP
--==============================================================

SaveBlacklistState()

WindUI:Notify({

    Title = "TSL1 Script",

    Content =
        "Unaigomes v1.1 cargado correctamente.",

    Icon = "shield-check",

    Duration = 5,

})


print(
    "========================================"
)

print(
    "TSL1 Script - Unaigomes v1.1"
)

print(
    "WindUI Edition"
)

print(
    "========================================"
)
