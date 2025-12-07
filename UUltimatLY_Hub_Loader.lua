-- ═══════════════════════════════════════════════════════════════════════════════
-- ULTIMATLY HUB - OFFICIAL 2025 GOD TIER LOADER (COMPLETE PERSOURCE EDITION)
-- Author        : ErenxKuki
-- Version       : 1.0 - December 07, 2025
-- Discord       : Your Discord Server
-- Key Pastebin  : https://pastebin.com/raw/CmRXXVd3
-- Blacklist     : https://pastebin.com/raw/YOUR_BLACKLIST_ID
-- Features      : Premium GUI, Script Selector, Update Notes, 24h Key + Countdown,
--                 Anti-Detection, Blacklist System, TDT-Style Discord Logs,
--                 No External Libs, Draggable, Close Button, Obfuscation-Ready
-- ═══════════════════════════════════════════════════════════════════════════════

-- Services
local Players              = game:GetService("Players")
local HttpService          = game:GetService("HttpService")
local TweenService         = game:GetService("TweenService")
local SoundService         = game:GetService("SoundService")
local RunService           = game:GetService("RunService")
local MarketplaceService   = game:GetService("MarketplaceService")

-- Local References
local LocalPlayer          = Players.LocalPlayer
local PlayerGui            = LocalPlayer:WaitForChild("PlayerGui")

-- =============================================================================
-- CONFIGURATION (ONLY EDIT THESE LINES)
-- =============================================================================
local CONFIG = {
    MAIN_HUB_SCRIPT       = "https://raw.githubusercontent.com/erenxkuki/UUltimatLY-Hub-Main/refs/heads/main/UUltimatLY_Hub_v1.lua",
    DAILY_KEY_PASTEBIN    = "https://pastebin.com/raw/CmRXXVd3",
    BLACKLIST_PASTEBIN    = "https://pastebin.com/raw/YOUR_BLACKLIST_ID_HERE",
    DISCORD_WEBHOOK       = "https://discord.com/api/webhooks/1446824870787809381/jxuEqqw3fis9JB7qBqUwJgCcTwRPzEjVmlf_7nJi59ZCbhpKXMqmIa7nwv9BUp4VQTuB",
    HUB_LOGO              = "rbxassetid://71108055000421",
    INJECT_SOUND          = "rbxassetid://126809185957420",
    GUI_TITLE             = "UltimatLY Hub 2025",
    VERSION               = "v1.0 - December 07, 2025"
}

-- =============================================================================
-- AVAILABLE SCRIPTS (ADD/REMOVE HERE)
-- =============================================================================
local AVAILABLE_SCRIPTS = {
    ["Main Hub (Recommended)"]      = CONFIG.MAIN_HUB_SCRIPT,
    ["Chest Farm "]                 = "https://raw.githubusercontent.com/erenxkuki/UUltimatLY-Hub-Main/refs/heads/main/UUltimatLY_Auto_Chest.lua",
    ["Main Hub V2"]                 = "https://raw.githubusercontent.com/erenxkuki/UUltimatLY-Hub-Main/refs/heads/main/UUltimatLY_Hub_V2.lua",
    ["Main Hub V3"]                 = "https://raw.githubusercontent.com/erenxkuki/UUltimatLY-Hub-Main/refs/heads/main/UUltimatLY_Hub_V3.lua",
    ["ESP + Fruit Sniper"]          = "SOON..."
}

-- =============================================================================
-- UPDATE NOTES (DISPLAYED IN GUI)
-- =============================================================================
local UPDATE_NOTES = {
    "Added premium GUI with script selector",
    "Implemented 24h key system with live countdown",
    "Discord execution logging",
    "Blacklist system with auto-refresh",
    "Anti-detection + anti-debug protection",
    "Multiple script support",
}

-- =============================================================================
-- BLACKLIST SYSTEM
-- =============================================================================
local BLACKLISTED_USERS = {}

local function loadBlacklist()
    local success, result = pcall(function()
        return game:HttpGet(CONFIG.BLACKLIST_PASTEBIN)
    end)
    if success and result then
        for userid in result:gmatch("%d+") do
            BLACKLISTED_USERS[tonumber(userid)] = true
        end
    end
end

loadBlacklist()
task.spawn(function()
    while task.wait(300) do -- Refresh every 5 minutes
        loadBlacklist()
    end
end)

-- =============================================================================
-- ANTI-DETECTION & SECURITY
-- =============================================================================
local function isDebugActive()
    return pcall(debug.getinfo) or pcall(getfenv) or pcall(function() return syn end)
end

local function triggerBan(reason)
    pcall(function()
        HttpService:PostAsync(CONFIG.DISCORD_WEBHOOK, HttpService:JSONEncode({
            embeds = {{title = "BLACKLIST TRIGGERED", color = 16711680,
                fields = {
                    {name = "Player", value = LocalPlayer.Name.." (@"..LocalPlayer.DisplayName..")"},
                    {name = "UserId", value = tostring(LocalPlayer.UserId)},
                    {name = "Reason", value = reason}
                }
            }}
        }), Enum.HttpContentType.ApplicationJson)
    end)
    PlayerGui:ClearAllChildren()
    while true do task.wait(10) end
end

if BLACKLISTED_USERS[LocalPlayer.UserId] then
    triggerBan("Perma Blacklisted")
    return
end

if isDebugActive() then
    triggerBan("Debug Tools Detected")
    return
end

-- =============================================================================
-- SECURE HTTP FETCH
-- =============================================================================
local function secureFetch(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success and result then
        return result:gsub("%s+", "")
    end
    return nil
end

-- =============================================================================
-- KEY SYSTEM & VALIDATION
-- =============================================================================
local DAILY_KEY = secureFetch(CONFIG.DAILY_KEY_PASTEBIN)
local SAVED_DATA = (isfile and isfile("UltimatLY_Key.dat")) and HttpService:JSONDecode(readfile("UltimatLY_Key.dat")) or {}
local KEY_IS_VALID = SAVED_DATA.key == DAILY_KEY and (os.time() - (SAVED_DATA.timestamp or 0)) < 86400

-- =============================================================================
-- DISCORD LOGGING (TDT STYLE)
-- =============================================================================
local function logExecution(keyUsed)
    pcall(function()
        HttpService:PostAsync(CONFIG.DISCORD_WEBHOOK, HttpService:JSONEncode({
            embeds = {{
                title = "UltimatLY Hub Activated",
                color = 65535,
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                fields = {
                    {name = "Player", value = LocalPlayer.Name, inline = true},
                    {name = "UserId", value = tostring(LocalPlayer.UserId), inline = true},
                    {name = "Display", value = "@"..LocalPlayer.DisplayName, inline = true},
                    {name = "Key Used", value = "||"..keyUsed.."||", inline = false},
                    {name = "Game", value = MarketplaceService:GetProductInfo(game.PlaceId).Name},
                    {name = "Join", value = "[Click to Join](https://roblox.com/games/"..game.PlaceId..")", inline = true}
                },
                thumbnail = {url = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=420&height=420&format=png"},
                footer = {text = "UltimatLY Hub • "..os.date("%m/%d/%Y %I:%M %p")}
            }}
        }), Enum.HttpContentType.ApplicationJson, false, {["Content-Type"] = "application/json"})
    end)
end

-- =============================================================================
-- PREMIUM GUI (PERSOURCE STYLE)
-- =============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimatLY_Hub_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 620, 0, 520)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 25)
Corner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 200, 255)
Stroke.Thickness = 4
Stroke.Transparency = 0.3
Stroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 100)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = CONFIG.GUI_TITLE
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 38
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Position = UDim2.new(0, 110, 0, 0)
TitleLabel.Parent = TitleBar

local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 90, 0, 90)
Logo.Position = UDim2.new(0, 15, 0, 5)
Logo.Image = CONFIG.HUB_LOGO
Logo.BackgroundTransparency = 1
Logo.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 80, 0, 80)
CloseButton.Position = UDim2.new(1, -90, 0, 10)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.TextSize = 48
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar
CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.5), {Transparency = 1}):Play()
    task.wait(0.5)
    ScreenGui:Destroy()
end)

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -40, 0, 60)
StatusLabel.Position = UDim2.new(0, 20, 0, 120)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
StatusLabel.Text = KEY_IS_VALID and "Access Granted — Choose Script Below" or "Enter Your Access Key"
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 28
StatusLabel.Parent = MainFrame

-- Countdown Timer
local CountdownLabel = Instance.new("TextLabel")
CountdownLabel.Size = UDim2.new(1, -40, 0, 50)
CountdownLabel.Position = UDim2.new(0, 20, 0, 180)
CountdownLabel.BackgroundTransparency = 1
CountdownLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
CountdownLabel.Text = ""
CountdownLabel.Font = Enum.Font.Gotham
CountdownLabel.TextSize = 22
CountdownLabel.Parent = MainFrame

task.spawn(function()
    while task.wait(1) do
        if KEY_IS_VALID then
            local remaining = 86400 - (os.time() - (SAVED_DATA.timestamp or 0))
            if remaining > 0 then
                local h = math.floor(remaining / 3600)
                local m = math.floor((remaining % 3600) / 60)
                local s = remaining % 60
                CountdownLabel.Text = string.format("Access expires in %02d:%02d:%02d", h, m, s)
            else
                CountdownLabel.Text = "Key Expired"
                CountdownLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
        end
    end
end)

-- Script Selector
local SelectorLabel = Instance.new("TextLabel")
SelectorLabel.Size = UDim2.new(1, -40, 0, 50)
SelectorLabel.Position = UDim2.new(0, 20, 0, 240)
SelectorLabel.BackgroundTransparency = 1
SelectorLabel.Text = "Select Script:"
SelectorLabel.TextColor3 = Color3.new(1, 1, 1)
SelectorLabel.Font = Enum.Font.GothamBold
SelectorLabel.TextSize = 26
SelectorLabel.Parent = MainFrame

local ScriptDropdown = Instance.new("TextButton")
ScriptDropdown.Size = UDim2.new(1, -80, 0, 70)
ScriptDropdown.Position = UDim2.new(0, 40, 0, 290)
ScriptDropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ScriptDropdown.Text = "Choose Script..."
ScriptDropdown.TextColor3 = Color3.new(1, 1, 1)
ScriptDropdown.Font = Enum.Font.Gotham
ScriptDropdown.TextSize = 22
Instance.new("UICorner", ScriptDropdown).CornerRadius = UDim.new(0, 16)
ScriptDropdown.Parent = MainFrame

local DropdownList = Instance.new("ScrollingFrame")
DropdownList.Size = UDim2.new(1, -80, 0, 200)
DropdownList.Position = UDim2.new(0, 40, 0, 370)
DropdownList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
DropdownList.BorderSizePixel = 0
DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownList.ScrollBarThickness = 8
DropdownList.Visible = false
Instance.new("UICorner", DropdownList).CornerRadius = UDim.new(0, 16)
DropdownList.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 8)
ListLayout.Parent = DropdownList

ScriptDropdown.MouseButton1Click:Connect(function()
    DropdownList.Visible = not DropdownList.Visible
end)

for scriptName, scriptUrl in pairs(AVAILABLE_SCRIPTS) do
    local option = Instance.new("TextButton")
    option.Size = UDim2.new(1, 0, 0, 60)
    option.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    option.Text = scriptName
    option.TextColor3 = Color3.new(1, 1, 1)
    option.Font = Enum.Font.Gotham
    option.TextSize = 20
    Instance.new("UICorner", option).CornerRadius = UDim.new(0, 12)
    option.Parent = DropdownList

    option.MouseButton1Click:Connect(function()
        ScriptDropdown.Text = scriptName
        DropdownList.Visible = false
        if KEY_IS_VALID then
            SoundService:PlayLocalSound(CONFIG.INJECT_SOUND)
            logExecution(DAILY_KEY)
            task.wait(1.5)
            loadstring(secureFetch(scriptUrl) or "")()
            StatusLabel.Text = scriptName .. " Loaded — Enjoy God Mode"
        else
            StatusLabel.Text = "Key Required to Load Scripts"
        end
    end)
    DropdownList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 20)
end

-- Update Notes Section
local NotesLabel = Instance.new("TextLabel")
NotesLabel.Size = UDim2.new(1, -40, 0, 50)
NotesLabel.Position = UDim2.new(0, 20, 0, 580)
NotesLabel.BackgroundTransparency = 1
NotesLabel.Text = "Update Notes:"
NotesLabel.TextColor3 = Color3.new(1, 1, 1)
NotesLabel.Font = Enum.Font.GothamBold
NotesLabel.TextSize = 26
NotesLabel.Parent = MainFrame

local NotesFrame = Instance.new("ScrollingFrame")
NotesFrame.Size = UDim2.new(1, -80, 0, 150)
NotesFrame.Position = UDim2.new(0, 40, 0, 630)
NotesFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
NotesFrame.BorderSizePixel = 0
NotesFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
NotesFrame.ScrollBarThickness = 8
Instance.new("UICorner", NotesFrame).CornerRadius = UDim.new(0, 16)
NotesFrame.Parent = MainFrame

local NotesLayout = Instance.new("UIListLayout")
NotesLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotesLayout.Padding = UDim.new(0, 8)
NotesLayout.Parent = NotesFrame

for _, note in ipairs(UPDATE_NOTES) do
    local noteLabel = Instance.new("TextLabel")
    noteLabel.Size = UDim2.new(1, 0, 0, 40)
    noteLabel.BackgroundTransparency = 1
    noteLabel.Text = "• " .. note
    noteLabel.TextColor3 = Color3.new(1, 1, 1)
    noteLabel.Font = Enum.Font.Gotham
    noteLabel.TextSize = 18
    noteLabel.TextXAlignment = Enum.TextXAlignment.Left
    noteLabel.Parent = NotesFrame
    NotesFrame.CanvasSize = UDim2.new(0, 0, 0, NotesLayout.AbsoluteContentSize.Y + 20)
end

-- Auto Execute Main Hub if Key Valid
if KEY_IS_VALID then
    SoundService:PlayLocalSound(CONFIG.INJECT_SOUND)
    logExecution(DAILY_KEY)
    task.wait(1.5)
    loadstring(secureFetch(CONFIG.MAIN_HUB_SCRIPT) or "")()
    StatusLabel.Text = "Main Hub Loaded — Welcome Back King"
end

print("UltimatLY Hub -  LOADER IS READY")