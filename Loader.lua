-- ═══════════════════════════════════════════════════ --
--      ULTIMATLY HUB - GOD TIER LOADER 2025 FINAL     --
--  Anti-JS Block Detection + Daily Pastebin Key + All --
-- ═══════════════════════════════════════════════════ --

local Scripts = {
    ["DEFAULT"] = "https://raw.githubusercontent.com/erenxkuki/UUltimatLY-Hub-Main/refs/heads/main/UUltimatLY_Hub_v1.lua",
}

local PASTEBIN_RAW   = "https://pastebin.com/raw/CmRXXVd3E"  -- CHANGE THIS
local KEY_LINK       = "https://linkvertise.com/1402847/Yc15yBMVD4b8?o=sharing"  -- Your link (already added)
local WEBHOOK        = "https://discord.com/api/webhooks/1446824870787809381/jxuEqqw3fis9JB7qBqUwJgCcTwRPzEjVmlf_7nJi59ZCbhpKXMqmIa7nwv9BUp4VQTuB"  -- Put your webhook here or leave empty
local LOGO_ID        = "rbxassetid://71108055000421"

-- Orion Lib
loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
task.wait(3)

-- Inject Sound
local InjectSound = Instance.new("Sound", game:GetService("SoundService"))
InjectSound.SoundId = "rbxassetid://6955039185"

local function FakeInject()
    InjectSound:Play()
    for i = 1, 100, 5 do
        OrionLib:MakeNotification({Name = "UltimatLY", Content = "Injecting... "..i.."%", Image = LOGO_ID, Time = 0.08})
        task.wait(0.04)
    end
end

-- Fetch daily key
local function GetDailyKey()
    local s, key = pcall(function() return game:HttpGet(PASTEBIN_RAW):match("^%s*(.-)%s*$") end)
    return s and key ~= "" and key or nil
end

-- 24h save
local function LoadKey() if isfile("UltimatLY.json") then local d = game.HttpService:JSONDecode(readfile("UltimatLY.json")) if os.time() < d.exp then return d.key end end end
local function SaveKey(k) writefile("UltimatLY.json", game.HttpService:JSONEncode({key = k, exp = os.time() + 86400})) end

-- ANTI-JS BLOCK DETECTION (magic)
local function CheckLinkvertiseWorking()
    local success, body = pcall(function()
        return game:HttpGet(KEY_LINK, false, {["User-Agent"] = "Mozilla/5.0"})
    end)
    if not success then return false end
    -- If JS is disabled or blocked → page contains this exact message
    if body:find("Please enable JavaScript") or body:find("JavaScript ist deaktiviert") or body:find("Activez JavaScript") then
        return false
    end
    return true
end

-- Main UI
local Window = OrionLib:MakeWindow({Name = "UltimatLY Hub", IntroEnabled = true, IntroText = "Loading UltimatLY...", IntroIcon = LOGO_ID, Icon = LOGO_ID})
local Tab = Window:MakeTab({Name = "Injector", Icon = LOGO_ID})

Tab:AddLabel("Welcome "..game.Players.LocalPlayer.DisplayName.."!")

local saved = LoadKey()
local daily = GetDailyKey()

if saved and saved == daily then
    Tab:AddLabel("24h Key Active → Auto Injecting...")
    FakeInject()
    loadstring(game:HttpGet(Scripts["DEFAULT"]))()
else
    Tab:AddLabel("Enter today's key from the link below")
    local box = Tab:AddTextbox({Name = "Key", Default = "", TextDisappear = false, Callback = function() end})
    local status = Tab:AddLabel("Status: Ready")

    Tab:AddButton({Name = "GET KEY", Callback = function()
        setclipboard(KEY_LINK)
        if not CheckLinkvertiseWorking() then
            -- RED WARNING IF JS BLOCKED
            OrionLib:MakeNotification({
                Name = "JAVASCRIPT DISABLED!",
                Content = "Enable JavaScript or disable AdBlock!\nLink copied anyway.",
                Image = LOGO_ID,
                Time = 15
            })
        else
            OrionLib:MakeNotification({Name = "Link Copied!", Content = "Complete ads → sub → copy key from Pastebin", Time = 8})
        end
    end})

    Tab:AddButton({Name = "INJECT", Callback = function()
        if box.Value:gsub("%s+", "") == daily then
            status:Update("Correct Key! Injecting...", Color3.fromRGB(0,255,0))
            SaveKey(daily)
            FakeInject()
            loadstring(game:HttpGet(Scripts["DEFAULT"]))()
        else
            status:Update("Wrong Key!", Color3.fromRGB(255,0,0))
        end
    end})
end

OrionLib:Init()
