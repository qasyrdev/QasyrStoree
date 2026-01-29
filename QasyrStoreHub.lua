-- QasyrStore Hub – Full Final Version
-- Fish It Blatant Edition (Local Only)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Player = Players.LocalPlayer

-- Wait character
if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then
    Player.CharacterAdded:Wait()
end

-- ================= STATE =================
local State = {
    AutoTap = false,
    InstantFishing = false,
    Blatant = false,
    AutoSell = false,
    CurrentMode = "Legit",
    DelayReel = 0.2,
    DelayFishing = 0.2,
    InstantDelay = 0
}

local Bag = 0
local TimeCounter = 0

-- ================= TELEPORT PULAU =================
local Islands = {
    ["Ancient Jungle"] = Vector3.new(120,0,340),
    ["Ancient Ruin"] = Vector3.new(-250,0,180),
    ["Coral Reefs"] = Vector3.new(450,0,-100),
    ["Crater Island"] = Vector3.new(-400,0,-350),
    ["Crystal Depths"] = Vector3.new(220,0,-420),
    ["Esoteric Deep"] = Vector3.new(-120,0,500),
    ["Fisherman Island"] = Vector3.new(0,0,0),
    ["Kohana Volcano"] = Vector3.new(300,0,300),
    ["Secret Temple"] = Vector3.new(-350,0,250),
    ["Secret Passage"] = Vector3.new(150,0,-250),
    ["Sisnypus Statue"] = Vector3.new(-200,0,-150),
    ["Treasure Room"] = Vector3.new(400,0,400),
    ["Tropical Grove"] = Vector3.new(-100,0,350),
    ["Weather Machine"] = Vector3.new(50,0,-400)
}

-- ================= GUI =================
local Gui = Instance.new("ScreenGui")
Gui.Name = "QasyrStoreHub"
Gui.ResetOnSpawn = false
Gui.Parent = Player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 360, 0, 520)
Main.Position = UDim2.new(0.05,0,0.15,0)
Main.BackgroundColor3 = Color3.fromRGB(20,60,220)
Main.BackgroundTransparency = 0.1
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "QasyrStore Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1

-- Helper functions
local function createButton(text,y,parent)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.9,0,0,35)
    b.Position = UDim2.new(0.05,0,y,0)
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 15
    b.Text = text
    b.AutoButtonColor = true
    return b
end

local function createLabel(text,y,parent)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(0.9,0,0,25)
    l.Position = UDim2.new(0.05,0,y,0)
    l.Text = text
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.TextColor3 = Color3.fromRGB(255,255,255)
    l.BackgroundTransparency = 1
    return l
end

-- ================= SCROLL FRAME PULAU =================
local ScrollFrame = Instance.new("ScrollingFrame", Main)
ScrollFrame.Size = UDim2.new(0.9,0,0.35,0)
ScrollFrame.Position = UDim2.new(0.05,0,0.25,0)
ScrollFrame.CanvasSize = UDim2.new(0,0,#Islands*40)
ScrollFrame.ScrollBarThickness = 8
ScrollFrame.BackgroundTransparency = 0.2
ScrollFrame.BackgroundColor3 = Color3.fromRGB(30,80,220)

for islandName, coord in pairs(Islands) do
    local btn = createButton(islandName, 0, ScrollFrame)
    btn.Position = UDim2.new(0,0,(#ScrollFrame:GetChildren()-1)*40,0)
    btn.MouseButton1Click:Connect(function()
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(coord)
        end
    end)
end

-- ================= STATUS =================
local Status = createLabel("Status: Idle", 0.62, Main)

-- ================= FISHING BUTTONS =================
local AutoTapBtn = createButton("Auto Tap: OFF", 0.05, Main)
AutoTapBtn.MouseButton1Click:Connect(function()
    State.AutoTap = not State.AutoTap
    AutoTapBtn.Text = "Auto Tap: "..(State.AutoTap and "ON" or "OFF")
end)

local InstantBtn = createButton("Instant Fishing: OFF", 0.12, Main)
InstantBtn.MouseButton1Click:Connect(function()
    State.InstantFishing = not State.InstantFishing
    InstantBtn.Text = "Instant Fishing: "..(State.InstantFishing and "ON" or "OFF")
end)

local BlatantBtn = createButton("Blatant: OFF", 0.19, Main)
BlatantBtn.MouseButton1Click:Connect(function()
    State.Blatant = not State.Blatant
    BlatantBtn.Text = "Blatant: "..(State.Blatant and "ON" or "OFF")
end)

local AutoSellBtn = createButton("Auto Sell: OFF", 0.26, Main)
AutoSellBtn.MouseButton1Click:Connect(function()
    State.AutoSell = not State.AutoSell
    AutoSellBtn.Text = "Auto Sell: "..(State.AutoSell and "ON" or "OFF")
end)

-- ================= AUTO TAP =================
task.spawn(function()
    while task.wait(0.15) do
        if State.AutoTap then
            VIM:SendMouseButtonEvent(0,0,0,true,game,0)
            VIM:SendMouseButtonEvent(0,0,0,false,game,0)
            Status.Text = "Status: Auto Tapping 🖱️"
        end
    end
end)

-- ================= INSTANT / BLATANT FISHING =================
task.spawn(function()
    while task.wait(0.1) do
        TimeCounter = TimeCounter + 0.1

        if State.InstantFishing then
            Status.Text = "Status: Instant Fishing 🎣"
            task.wait(State.InstantDelay)
            Bag = Bag + 1
        end

        if State.Blatant then
            Status.Text = "Status: Blatant Fishing 🎣"
            task.wait(State.DelayFishing)
            Bag = Bag + 1
            task.wait(State.DelayReel)
        end

        if State.AutoSell and Bag >= 100 then
            Bag = 0
            Status.Text = "Status: Auto Sold ✔"
        end
    end
end)

-- ================= DETECTOR =================
task.spawn(function()
    while task.wait(1) do
        Status.Text = string.format("Time: %.1f | Bag: %d | Mode: %s", TimeCounter, Bag, State.CurrentMode)
    end
end)

-- ================= TOGGLE GUI =================
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Gui.Enabled = not Gui.Enabled
    end
end)

print("✅ QasyrStore Hub Loaded – Full Final Version")
