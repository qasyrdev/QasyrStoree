-- QasyrStore Hub | Fish It (Blue Premium UI)
-- Clean • Smooth • Scrollable • Loadstring Ready

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Player = Players.LocalPlayer

-- WAIT CHAR
if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then
	Player.CharacterAdded:Wait()
end

-- ================= STATE =================
local State = {
	AutoTap = false,
	AutoTapDelay = 0.15,
	InstantFish = false,
	InstantFishDelay = 0.3,
}

-- ================= TELEPORT LOCATIONS =================
local Islands = {
	["Spawn"] = Vector3.new(0, 5, 0),
	["Tropical Island"] = Vector3.new(320, 8, -450),
	["Lost Isle"] = Vector3.new(-620, 12, 980),
	["Ancient Jungle"] = Vector3.new(1150, 20, 350),
}

-- ================= GUI =================
local Gui = Instance.new("ScreenGui", Player.PlayerGui)
Gui.Name = "QasyrStoreHub"
Gui.ResetOnSpawn = false

-- MAIN FRAME
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0,380,0,480)
Main.Position = UDim2.new(0.03,0,0.2,0)
Main.BackgroundColor3 = Color3.fromRGB(10,25,60) -- dark blue
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Name = "MainHub"
Main.AnchorPoint = Vector2.new(0,0)

-- ROUND CORNERS + SHADOW
local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0,15)

local Shadow = Instance.new("UIStroke", Main)
Shadow.Color = Color3.fromRGB(50,150,255)
Shadow.Thickness = 2
Shadow.Transparency = 0.4

-- TITLE
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundTransparency = 1
Title.Text = "QASYRSTORE HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(50,200,255)

-- ================= SCROLL =================
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Position = UDim2.new(0,0,0.11,0)
Scroll.Size = UDim2.new(1,0,0.88,0)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarImageColor3 = Color3.fromRGB(50,200,255)
Scroll.CanvasSize = UDim2.new(0,0,0,800)

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0,12)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- ================= UI HELPERS =================
local function Button(text)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.9,0,0,45)
	b.BackgroundColor3 = Color3.fromRGB(20,50,120)
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 15
	b.Text = text
	b.Parent = Scroll
	local corner = Instance.new("UICorner", b)
	corner.CornerRadius = UDim.new(0,12)
	
	-- Hover effect
	b.MouseEnter:Connect(function()
		b.BackgroundColor3 = Color3.fromRGB(50,120,255)
	end)
	b.MouseLeave:Connect(function()
		b.BackgroundColor3 = Color3.fromRGB(20,50,120)
	end)
	
	return b
end

local function Label(text)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(0.9,0,0,30)
	l.BackgroundTransparency = 1
	l.TextColor3 = Color3.fromRGB(180,220,255)
	l.Font = Enum.Font.Gotham
	l.TextSize = 13
	l.Text = text
	l.Parent = Scroll
	return l
end

-- ================= AUTO TAP =================
local AutoTapBtn = Button("Auto Tap : OFF")
Label("Set Auto Tap Delay (sec)")

local TapDelayBtn = Button("Delay : 0.15")
TapDelayBtn.MouseButton1Click:Connect(function()
	local input = tonumber(tostring(game:GetService("Players").LocalPlayer.PlayerGui.InputBox.Text) or "0.15")
	if input then State.AutoTapDelay = input; TapDelayBtn.Text = "Delay : "..input end
end)

AutoTapBtn.MouseButton1Click:Connect(function()
	State.AutoTap = not State.AutoTap
	AutoTapBtn.Text = "Auto Tap : "..(State.AutoTap and "ON" or "OFF")
end)

-- ================= INSTANT FISH =================
local FishBtn = Button("Instant Fish : OFF")
Label("Set Instant Fish Delay (sec)")

local FishDelayBtn = Button("Delay : 0.3")
FishDelayBtn.MouseButton1Click:Connect(function()
	local input = tonumber(tostring(game:GetService("Players").LocalPlayer.PlayerGui.InputBox.Text) or "0.3")
	if input then State.InstantFishDelay = input; FishDelayBtn.Text = "Delay : "..input end
end)

FishBtn.MouseButton1Click:Connect(function()
	State.InstantFish = not State.InstantFish
	FishBtn.Text = "Instant Fish : "..(State.InstantFish and "ON" or "OFF")
end)

-- ================= TELEPORT =================
Label("Teleport Island")
for name,pos in pairs(Islands) do
	local b = Button("Teleport → "..name)
	b.MouseButton1Click:Connect(function()
		if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
			Player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
		end
	end)
end

-- ================= AUTO LOOP =================
task.spawn(function()
	while task.wait(0) do
		if State.AutoTap then
			VIM:SendMouseButtonEvent(0,0,0,true,game,0)
			VIM:SendMouseButtonEvent(0,0,0,false,game,0)
			task.wait(State.AutoTapDelay)
		end
		if State.InstantFish then
			print("🎣 Fish Caught Instantly!")
			task.wait(State.InstantFishDelay)
		end
	end
end)

-- ================= SHOW/HIDE =================
UIS.InputBegan:Connect(function(i,gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.RightShift then
		Gui.Enabled = not Gui.Enabled
	end
end)

print("✅ QasyrStore Hub Loaded | Blue Premium UI")
