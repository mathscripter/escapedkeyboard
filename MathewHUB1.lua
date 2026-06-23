--[[
🍬 MATHEW HUB
🎮 +1 Speed Keyboard Escape
✨ FEATURES: Custom Speed + Fly
👤 Made by Mathew
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

-- Local Setup
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid", 10)
local RootPart = Character:WaitForChild("HumanoidRootPart", 10)

-- Prevent duplicate
if getgenv().MathewHub_SpeedFly then return end
getgenv().MathewHub_SpeedFly = true

-- ⚙️ SETTINGS
local Settings = {
    Speed = 300,
    FlyEnabled = false,
    FlySpeed = 80
}

-- ======================================
-- 🎨 MENU
-- ======================================
local Gui = Instance.new("ScreenGui")
Gui.Name = "MathewHub_SpeedFly"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 280, 0, 240)
Main.Position = UDim2.new(0.02, 0, 0.05, 0)
Main.BackgroundColor3 = Color3.new(0.1, 0.1, 0.2)
Main.BackgroundTransparency = 0.2
Main.BorderColor3 = Color3.new(0.7, 0.3, 1)
Main.BorderSizePixel = 2
Main.Active = true
Main.Draggable = true
Main.Visible = true
Main.Parent = Gui

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.new(0.2, 0.1, 0.4)
Title.Text = "🍬 MATHEW HUB"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1,1,1)
Title.Parent = Main

-- Speed Section
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.9,0,0,25)
SpeedLabel.Position = UDim2.new(0.05,0,0.18,0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Walk Speed:"
SpeedLabel.TextColor3 = Color3.new(1,1,1)
SpeedLabel.Parent = Main

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0.9,0,0,30)
SpeedBox.Position = UDim2.new(0.05,0,0.28,0)
SpeedBox.BackgroundColor3 = Color3.new(0.25,0.25,0.35)
SpeedBox.TextColor3 = Color3.new(1,1,1)
SpeedBox.Text = "300"
SpeedBox.Parent = Main

-- Fly Toggle
local FlyBtn = Instance.new("TextButton")
FlyBtn.Size = UDim2.new(0.9,0,0,35)
FlyBtn.Position = UDim2.new(0.05,0,0.48,0)
FlyBtn.BackgroundColor3 = Color3.new(0.6,0.2,0.2)
FlyBtn.Text = "🔴 FLY: OFF"
FlyBtn.TextColor3 = Color3.new(1,1,1)
FlyBtn.Font = Enum.Font.GothamBold
FlyBtn.Parent = Main

-- Status
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(0.9,0,0,25)
Status.Position = UDim2.new(0.05,0,0.68,0)
Status.BackgroundTransparency = 1
Status.Text = "✅ Ready"
Status.TextColor3 = Color3.new(0,1,0.5)
Status.Parent = Main

-- Apply
local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Size = UDim2.new(0.9,0,0,35)
ApplyBtn.Position = UDim2.new(0.05,0,0.82,0)
ApplyBtn.BackgroundColor3 = Color3.new(0.1,0.7,0.3)
ApplyBtn.Text = "✅ APPLY"
ApplyBtn.TextColor3 = Color3.new(1,1,1)
ApplyBtn.Font = Enum.Font.GothamBold
ApplyBtn.Parent = Main

-- ======================================
-- FUNCTIONS
-- ======================================

-- Set Speed
local function SetSpeed()
    if Humanoid and Humanoid.Health > 0 then
        Humanoid.WalkSpeed = Settings.Speed
    end
end

-- Fly Logic
local FlyBodyGyro, FlyBodyPos

local function StartFly()
    if not RootPart then return end
    FlyBodyGyro = Instance.new("BodyGyro")
    FlyBodyGyro.P = 2000
    FlyBodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    FlyBodyGyro.CFrame = RootPart.CFrame
    FlyBodyGyro.Parent = RootPart

    FlyBodyPos = Instance.new("BodyPosition")
    FlyBodyPos.MaxForce = Vector3.new(400000, 400000, 400000)
    FlyBodyPos.Position = RootPart.Position
    FlyBodyPos.Parent = RootPart

    Humanoid.PlatformStand = true
end

local function StopFly()
    if FlyBodyGyro then FlyBodyGyro:Destroy() end
    if FlyBodyPos then FlyBodyPos:Destroy() end
    Humanoid.PlatformStand = false
end

-- Fly Movement
RunService.RenderStepped:Connect(function()
    if not Character or not Humanoid or Humanoid.Health <= 0 then return end

    -- Apply Speed
    SetSpeed()

    -- Fly Controls
    if Settings.FlyEnabled and FlyBodyGyro and FlyBodyPos then
        FlyBodyGyro.CFrame = workspace.CurrentCamera.CFrame
        local moveDir = Vector3.new()

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += workspace.CurrentCamera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= workspace.CurrentCamera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= workspace.CurrentCamera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += workspace.CurrentCamera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.new(0,1,0) end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * Settings.FlySpeed
            FlyBodyPos.Position = RootPart.Position + moveDir
        else
            FlyBodyPos.Position = RootPart.Position
        end
    end
end)

-- Reset on Respawn
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid", 10)
    RootPart = newChar:WaitForChild("HumanoidRootPart", 10)
    StopFly()
    Settings.FlyEnabled = false
    FlyBtn.Text = "🔴 FLY: OFF"
    FlyBtn.BackgroundColor3 = Color3.new(0.6,0.2,0.2)
    Status.Text = "✅ Respawned"
end)

-- ======================================
-- BUTTON ACTIONS
-- ======================================

SpeedBox.FocusLost:Connect(function()
    local num = tonumber(SpeedBox.Text)
    if num then
        Settings.Speed = math.clamp(num, 50, 1000)
        SetSpeed()
        Status.Text = "✅ Speed: "..Settings.Speed
    end
end)

FlyBtn.MouseButton1Click:Connect(function()
    Settings.FlyEnabled = not Settings.FlyEnabled
    if Settings.FlyEnabled then
        StartFly()
        FlyBtn.Text = "🟢 FLY: ON"
        FlyBtn.BackgroundColor3 = Color3.new(0.1,0.7,0.3)
        Status.Text = "✈️ Fly Active | WASD + Space/Ctrl"
    else
        StopFly()
        FlyBtn.Text = "🔴 FLY: OFF"
        FlyBtn.BackgroundColor3 = Color3.new(0.6,0.2,0.2)
        Status.Text = "✅ Ready"
    end
end)

ApplyBtn.MouseButton1Click:Connect(function()
    SetSpeed()
    Status.Text = "✅ Settings Saved!"
    task.wait(1)
    Status.Text = "✅ Ready"
end)

-- Hide/Show Menu
UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.Insert then
        Main.Visible = not Main.Visible
    end
end)