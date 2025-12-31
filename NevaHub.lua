-- Discord Webhook Notifier for Rare Items in Blox Fruits
-- With "Working" Visual Confirmation

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

-- === CONFIG ===
local WebhookURL = "https://discordapp.com/api/webhooks/1427237227360030800/T7TZx7p9U_iiIaPV6LBd2Gg2HxicA5q0_GC54tI30PvcWCzEyy-EGYYNh2clxyaT3Iei"  -- <<< CHANGE THIS!

local RareItems = {
    "Leopard Fruit", "Dragon Fruit", "Kitsune Fruit", "Venom Fruit", "Dough Fruit", 
    "Mammoth Fruit", "T-Rex Fruit", "Shadow Fruit", "Spirit Fruit", "Control Fruit",
    "God's Chalice", "Mirror Fractal", "Hallow Essence", "Fist of Darkness",
    "Cursed Dual Katana", "Dark Dagger", "Tushita", "Yama", "True Triple Katana"
}

-- === VISUAL CONFIRMATION ===
local function ShowWorkingIndicator()
    -- Simple console animation
    print("╔════════════════════════════════════════════╗")
    print("║   DISCORD RARE ITEM NOTIFIER - ACTIVE      ║")
    print("║   Checking every 10 seconds...             ║")
    print("║   Made by Grok - Enjoy the grind! 🏴‍☠️     ║")
    print("╚════════════════════════════════════════════╝")
    
    -- Optional: Floating GUI on screen (toggle if you don't want it)
    local showGUI = true  -- Change to false if you don't want on-screen text
    if showGUI then
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Parent = game.CoreGui
        ScreenGui.ResetOnSpawn = false
        
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0, 280, 0, 60)
        Frame.Position = UDim2.new(0.5, -140, 0.1, 0)
        Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Frame.BorderSizePixel = 0
        Frame.Parent = ScreenGui
        
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 12)
        UICorner.Parent = Frame
        
        local UIGradient = Instance.new("UIGradient")
        UIGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 100)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 80))
        }
        UIGradient.Rotation = 90
        UIGradient.Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 0.2)
        }
        UIGradient.Parent = Frame
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Text = "RARE ITEM NOTIFIER ACTIVE\nDiscord Alerts Enabled"
        Label.TextColor3 = Color3.new(1,1,1)
        Label.TextScaled = true
        Label.Font = Enum.Font.GothamBold
        Label.TextStrokeTransparency = 0.7
        Label.TextStrokeColor3 = Color3.fromRGB(0, 255, 100)
        Label.Parent = Frame
        
        -- Pulse effect
        spawn(function()
            while Frame.Parent do
                TweenService:Create(Frame, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    BackgroundTransparency = 0.3
                }):Play()
                wait(2)
                TweenService:Create(Frame, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    BackgroundTransparency = 0.6
                }):Play()
                wait(2)
            end
        end)
    end
end

-- === CORE FUNCTIONALITY ===
local CurrentInventory = {}

local function GetInventory()
    local inv = {}
    for _, tool in pairs(plr.Backpack:GetChildren()) do
        if tool:IsA("Tool") then table.insert(inv, tool.Name) end
    end
    for _, tool in pairs(plr.Character:GetChildren()) do
        if tool:IsA("Tool") then table.insert(inv, tool.Name) end
    end
    pcall(function()
        local stored = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventory")
        for _, item in pairs(stored) do
            if item.Name then table.insert(inv, item.Name) end
        end
    end)
    return inv
end

local function SendWebhook(itemName)
    if WebhookURL == "YOUR_WEBHOOK_URL_HERE" then return end
    
    local data = {
        ["content"] = "@everyone **RARE ITEM ALERT!**",
        ["embeds"] = {{
            ["title"] = "🎉 NEW RARE ITEM OBTAINED!",
            ["description"] = "**Player:** " .. plr.DisplayName .. " (@" .. plr.Name .. ")\n**Item:** " .. itemName .. "\n**Level:** " .. plr.Data.Level.Value .. "\n**Bounty:** " .. (plr.leaderstats["Bounty/Honor"].Value or "N/A"),
            ["color"] = 16711680,
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    
    pcall(function()
        HttpService:PostAsync(WebhookURL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)
end

-- === STARTUP ===
ShowWorkingIndicator()

-- Initial scan
for _, item in pairs(GetInventory()) do
    CurrentInventory[item] = true
end

-- Monitoring loop
spawn(function()
    while wait(10) do
        pcall(function()
            local newInv = GetInventory()
            for _, item in pairs(newInv) do
                if not CurrentInventory[item] and table.find(RareItems, item) then
                    SendWebhook(item)
                    CurrentInventory[item] = true
                end
            end
            CurrentInventory = {}
            for _, item in pairs(newInv) do
                CurrentInventory[item] = true
            end
        end)
    end
end)

print("Notifier is now running! Rare item alerts will be sent to Discord.")
