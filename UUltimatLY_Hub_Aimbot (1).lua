-- UUltimatLY Hub | Blox Fruits PvP - FULL WindUI Conversion
-- Original by realryzu (UUltimatLY) → UI converted to WindUI by request

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/main.lua"))()

-- Load all your modules (same as original)
local AimlockModule     = loadstring(game:HttpGet("https://raw.githubusercontent.com/jaanu91/Ip/refs/heads/main/Dk"))()
local ESPModule         = loadstring(game:HttpGet("https://raw.githubusercontent.com/jaanu91/Ip/refs/heads/main/Gk"))()
local SilentAimModule   = loadstring(game:HttpGet("https://raw.githubusercontent.com/jaanu91/Ip/refs/heads/main/Bg"))()
local StuffsModule      = loadstring(game:HttpGet("https://raw.githubusercontent.com/jaanu91/Ip/refs/heads/main/Stuf"))()
local OthersStuffsModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/jaanu91/Ip/refs/heads/main/Mot"))()
local UiSettingsModule  = loadstring(game:HttpGet("https://raw.githubusercontent.com/jaanu91/Ip/refs/heads/main/Vot"))()
local ZSkillModule      = loadstring(game:HttpGet("https://raw.githubusercontent.com/jaanu91/Ip/refs/heads/main/Teku"))()

local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local TeleportService   = game:GetService("TeleportService")
local StarterGui        = game:GetService("StarterGui")

local Settings = OthersStuffsModule.LoadSettings() or {}
local PlayerList = {"None"}

-- ══════════════════════════════════════════════════════════════════════════════
--                            Floating Toggle Button
-- ══════════════════════════════════════════════════════════════════════════════

local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "UUltimatLYToggle"
ToggleGui.ResetOnSpawn = false
ToggleGui.Parent = game.CoreGui

local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "MainToggle"
ToggleBtn.Size = UDim2.new(0, 48, 0, 48)
ToggleBtn.Position = UDim2.new(0, 12, 0, 12)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ToggleBtn.BackgroundTransparency = 0.35
ToggleBtn.Image = "rbxassetid://73642467719097"
ToggleBtn.ImageColor3 = Color3.fromRGB(255, 180, 100)
ToggleBtn.AutoButtonColor = false
ToggleBtn.ZIndex = 9999
ToggleBtn.Parent = ToggleGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(1, 0)
Corner.Parent = ToggleBtn

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(255, 140, 0)
Stroke.Thickness = 2.5
Stroke.Transparency = 0.6
Stroke.Parent = ToggleBtn

-- Simple drag function (WindUI doesn't have built-in draggable widget like Kavo)
local dragging, dragInput, dragStart, startPos
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleBtn.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        ToggleBtn.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ══════════════════════════════════════════════════════════════════════════════
--                               WindUI Window
-- ══════════════════════════════════════════════════════════════════════════════

local Window = WindUI:Create({
    Title = "UUltimatLY Hub | Blox Fruits PvP",
    SubTitle = "Executor: " .. (function()
        if syn then return "Synapse X"
        elseif KRNL_LOADED then return "KRNL"
        elseif fluxus then return "Fluxus"
        elseif getexecutorname then return getexecutorname() or "Unknown"
        else return "Unknown" end
    end)(),
    ToggleKey = Enum.KeyCode.M,
    CanResize = true,
    DefaultToggle = true,
})

-- Connect floating button to toggle UI
ToggleBtn.MouseButton1Click:Connect(function()
    Window:Toggle()
end)

-- ══════════════════════════════════════════════════════════════════════════════
--                                 TABS
-- ══════════════════════════════════════════════════════════════════════════════

do -- Executor Status
    local Tab = Window:CreateTab("◇ Executor")
    local Sec = Tab:CreateSection("Information")
    Sec:CreateLabel("Current Executor: " .. Window.SubTitle:match("Executor: (.+)"))
    Sec:CreateLabel("Status: " .. ((Window.SubTitle:find("Solara") or Window.SubTitle:find("Xeno") or Window.SubTitle:find("Krnl")) and "Not Working" or "Working"))
end

do -- Changelog
    local Tab = Window:CreateTab("⛓ Changelog")
    local Sec = Tab:CreateSection("Latest Updates")
    local changes = {
        "New Aimbot by realryzu (UUltimatLY)",
        "Added Target Info (Name/Health)",
        "Script Optimization & FPS Boost",
        "Fixed Soul Guitar M1 in Silent Aim",
        "RTX Visuals (Autumn/Summer/Spring/Winter)",
        "Custom Global Text Font",
        "Dash No Cooldown",
        "Remove Fog / Lava",
        "Z Skills working (except Godhuman Z)",
        "Fruit M1 Closest Attack Fix",
        "Buddy Sword X Silent Aim Fix"
    }
    for _, txt in ipairs(changes) do
        Sec:CreateLabel("• " .. txt)
    end
end

do -- Aimbot Tab
    local Tab = Window:CreateTab("❖ Aimbot")
    local Sec = Tab:CreateSection("Main Settings")

    Sec:CreateToggle({Name = "Aimlock Players", Default = Settings.AimlockPlayers or false, Callback = function(v)
        AimlockModule:SetPlayerAimlock(v)
        Settings.AimlockPlayers = v
    end})

    Sec:CreateToggle({Name = "Aimlock Mini Toggle (Players)", Default = Settings.AimlockPlayersMiniTogglePlayers or false, Callback = function(v)
        AimlockModule:SetMiniTogglePlayerAimlock(v)
        Settings.AimlockPlayersMiniTogglePlayers = v
    end})

    Sec:CreateToggle({Name = "Aimlock NPC/Boss", Default = Settings.AimlockNPC or false, Callback = function(v)
        AimlockModule:SetNpcAimlock(v)
        Settings.AimlockNPC = v
    end})

    Sec:CreateToggle({Name = "Prediction", Default = Settings.Prediction or false, Callback = function(v)
        AimlockModule:SetPrediction(v)
        Settings.Prediction = v
    end})

    Sec:CreateDropdown({Name = "Prediction Amount", Options = {"0.12","0.135","0.15","0.165","0.2","0.3","0.4"}, 
        Default = tostring(Settings.PredictionAmount or 0.135), Callback = function(v)
            local n = tonumber(v)
            if n then AimlockModule:SetPredictionTime(n) Settings.PredictionAmount = n end
        end})
end

do -- Silent Aim Tab
    local Tab = Window:CreateTab("⛩ Silent Aim")
    local Sec = Tab:CreateSection("Settings")

    local saToggles = {
        {name = "Silent Aim Players",        key = "SilentAimPlayers",        func = SilentAimModule.SetPlayerSilentAim},
        {name = "Silent Mini Toggle Players", key = "SilentMiniTogglePlayers", func = SilentAimModule.SetMiniTogglePlayerSilentAim},
        {name = "Silent Aim NPC",            key = "SilentAimNPC",            func = SilentAimModule.SetNPCSilentAim},
        {name = "Silent Mini Toggle NPC",    key = "SilentMiniToggleNPC",     func = SilentAimModule.SetMiniToggleNpcSilentAim},
        {name = "Silent Aim Prediction",     key = "SilentAimPrediction",     func = SilentAimModule.SetPrediction},
        {name = "Highlight Target",          key = "Highlight",               func = SilentAimModule.SetHighlight},
        {name = "Z | M1 Skills (except Godhuman Z)", key = "Zskillmone", func = SilentAimModule.SetZSkillorM1},
        {name = "Auto Ken Haki",             key = "AutoKen",                 func = SilentAimModule.SetAutoKen},
    }

    for _, t in ipairs(saToggles) do
        Sec:CreateToggle({Name = t.name, Default = Settings[t.key] or false, Callback = function(v)
            t.func(v)
            Settings[t.key] = v
        end})
    end

    Sec:CreateDropdown({Name = "Prediction Strength", Options = {"0.12","0.135","0.15","0.165","0.2","0.3","0.4"}, 
        Default = tostring(Settings.SilentAimPredictionFuture or 0.135), Callback = function(v)
            local n = tonumber(v) if n then SilentAimModule:SetPredictionAmount(n) Settings.SilentAimPredictionFuture = n end
        end})

    Sec:CreateDropdown({Name = "Max Distance", Options = {"400","600","800","1000","1500","2000"}, 
        Default = tostring(Settings.SilentAimDistanceLimit or 1000), Callback = function(v)
            local n = tonumber(v) if n then SilentAimModule:SetDistanceLimit(n) Settings.SilentAimDistanceLimit = n end
        end})

    -- Player selector
    local targetDropdown
    local function updatePlayerList()
        local list = {"None"}
        for _, p in Players:GetPlayers() do
            if p ~= Players.LocalPlayer then table.insert(list, p.Name) end
        end
        if targetDropdown then targetDropdown:SetOptions(list) end
    end

    targetDropdown = Sec:CreateDropdown({
        Name = "Target Player (Manual Lock)",
        Options = PlayerList,
        Default = "None",
        Callback = function(v)
            SilentAimModule:SetSelectedPlayer(v == "None" and nil or v)
        end
    })

    Players.PlayerAdded:Connect(updatePlayerList)
    Players.PlayerRemoving:Connect(updatePlayerList)
    task.spawn(updatePlayerList)
end

do -- Features Tab
    local Tab = Window:CreateTab("✿ Features")
    local Sec = Tab:CreateSection("Toggles & Utilities")

    local features = {
        {name = "ESP Players",             key = "ESPPlayers",      func = ESPModule.SetESP},
        {name = "Auto V3 Race Ability",    key = "V3Skill",         func = ESPModule.SetV3},
        {name = "Bunny Hop",               key = "BunnyHop",        func = ESPModule.SetBunnyhop},
        {name = "Auto Buso (Aura)",        key = "AuraSkill",       func = ESPModule.SetBuso},
        {name = "FPS Boost",               key = "FpsBoost",        func = StuffsModule.SetFpsBoost},
        {name = "Infinite Energy",         key = "INFEnergy",       func = StuffsModule.SetINFEnergy},
        {name = "Walk on Water",           key = "WalkonWater",     func = StuffsModule.SetWalkWater},
        {name = "Fast Attack",             key = "FastAttack",      func = StuffsModule.SetFastAttack},
        {name = "Remove Lava",             key = "Lava",            func = StuffsModule.SetLava},
        {name = "Remove Fog",              key = "Fog",             func = StuffsModule.SetFog},
        {name = "Dodge No Cooldown",       key = "Dodge",           func = ESPModule.SetNoDodgeCD},
        {name = "Auto V4 Transform",       key = "V4",              func = UiSettingsModule.SetV4},
        {name = "Fruit Spawn Notifier",    key = "FruitCheck",      func = UiSettingsModule.SetFruitCheck},
        {name = "Teleport Fruits To You",  key = "TeleportFruit",   func = UiSettingsModule.SetTeleportFruit},
        {name = "Show Target Info",        key = "Opponent",        func = ZSkillModule.SetInfo},
    }

    for _, f in ipairs(features) do
        Sec:CreateToggle({Name = f.name, Default = Settings[f.key] or false, Callback = function(v)
            f.func(v)
            Settings[f.key] = v
        end})
    end

    Sec:CreateButton({Name = "Join Discord", Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/dtkbvtrM7G")
            StarterGui:SetCore("SendNotification", {Title = "UUltimatLY", Text = "Discord link copied!", Duration = 4})
        end
    end})
end

do -- Settings Manager Tab
    local Tab = Window:CreateTab("⚙ Settings")
    local Sec = Tab:CreateSection("Configuration")

    Sec:CreateTextbox({Name = "Join Server (JobId)", Placeholder = "Paste JobId...", Callback = function(jobid)
        if jobid and #jobid > 10 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobid, Players.LocalPlayer)
        end
    end})

    Sec:CreateButton({Name = "Save Settings", Callback = function()
        OthersStuffsModule.SaveSettings(Settings)
        StarterGui:SetCore("SendNotification", {Title = "Settings", Text = "Saved successfully!", Duration = 3})
    end})

    Sec:CreateButton({Name = "Reset Settings", Callback = function()
        OthersStuffsModule.ResetSettings()
        Settings = {}
        StarterGui:SetCore("SendNotification", {Title = "Settings", Text = "Reset complete", Duration = 3})
    end})

    -- Font selector (example - adjust if your module supports it)
    Sec:CreateDropdown({
        Name = "Global Font",
        Options = {"Arcade","Cartoon","Code","Highway","SciFi","Fantasy","Antique","Gotham","SourceSansPro"},
        Default = Settings.GlobalFont or "Gotham",
        Callback = function(v)
            if ESPModule.SetGlobalFont then
                ESPModule:SetGlobalFont(Enum.Font[v])
                Settings.GlobalFont = v
            end
        end
    })
end

-- Final initialization
OthersStuffsModule:ApplySettings(Settings, {
    Aimlock = AimlockModule,
    SilentAim = SilentAimModule,
    ESP = ESPModule,
    Stuffs = StuffsModule,
    Ui = UiSettingsModule,
    Zskill = ZSkillModule
})

OthersStuffsModule.StartFruitNotifier()

-- Quick toggle Silent Aim with G key (like original)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then
        Settings.SilentAimPlayers = not (Settings.SilentAimPlayers or false)
        SilentAimModule:SetPlayerSilentAim(Settings.SilentAimPlayers)
        StarterGui:SetCore("SendNotification", {
            Title = "Silent Aim",
            Text = Settings.SilentAimPlayers and "Enabled" or "Disabled",
            Duration = 2.5
        })
    end
end)

print("[UUltimatLY Hub] → WindUI version loaded successfully!")
