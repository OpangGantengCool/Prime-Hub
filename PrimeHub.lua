-- // PRIME HUB VÓNZZ | DELTA EDITION (NO EXTERNAL LIBRARY) // --
-- Semua fitur built-in, UI manual, teks putih, kompatibel Delta

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- // GLOBAL TOGGLES // --
_G.AutoGrab = false
_G.MasterESP = false
_G.AutoShoot = false
_G.GunDropESP = false
_G.AntiAFK = false
_G.Walkspeed = 16
_G.JumpPower = 50

-- // BUAT UI UTAMA (MENU) // --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PrimeHubVonz"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
MainFrame.BackgroundTransparency = 0.05
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)

-- Judul + Drag
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 35, 55)
TitleBar.BackgroundTransparency = 0
local TitleCorner = Instance.new("UICorner", TitleBar)
TitleCorner.CornerRadius = UDim.new(0, 12)
local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.Text = "Prime Hub | Vónzz Edition (Delta)"
TitleLabel.TextColor3 = Color3.new(1,1,1)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBold

-- Close button
local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.AutoButtonColor = false
local CloseCorner = Instance.new("UICorner", CloseBtn)
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Drag logic
local function makeDraggable(frame)
    local dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragStart = nil
        end
    end)
    UserInput.InputChanged:Connect(function(input)
        if dragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(TitleBar)

-- Scrolling frame untuk fitur
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, 0, 1, -50)
Scroll.Position = UDim2.new(0, 0, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 6
Scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)

local UIList = Instance.new("UIListLayout", Scroll)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)

-- Fungsi membuat toggle
local function addToggle(parent, text, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -16, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(25, 30, 50)
    frame.BackgroundTransparency = 0.3
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    
    local toggleBtn = Instance.new("TextButton", frame)
    toggleBtn.Size = UDim2.new(0, 50, 0, 30)
    toggleBtn.Position = UDim2.new(1, -60, 0, 5)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.new(1,1,1)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0,200,0) or Color3.fromRGB(150,50,50)
    local btnCorner = Instance.new("UICorner", toggleBtn)
    btnCorner.CornerRadius = UDim.new(0, 6)
    
    local state = default
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0,200,0) or Color3.fromRGB(150,50,50)
        callback(state)
    end)
    callback(state)
    return toggleBtn
end

local function addButton(parent, text, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -16, 0, 40)
    frame.BackgroundTransparency = 1
    
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(40, 60, 100)
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- === BUAT TAB (SIMPLE) === --
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, 0, 0, 40)
TabBar.Position = UDim2.new(0, 0, 0, 0)
TabBar.BackgroundTransparency = 1

local tabs = {"Main", "Visual", "Combat", "Opti"}
local activeTab = nil

for i, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton", TabBar)
    tabBtn.Size = UDim2.new(0.25, -2, 1, 0)
    tabBtn.Position = UDim2.new((i-1)*0.25, 2, 0, 0)
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Color3.new(1,1,1)
    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 40, 70)
    tabBtn.AutoButtonColor = false
    local tabCorner = Instance.new("UICorner", tabBtn)
    tabCorner.CornerRadius = UDim.new(0, 6)
    
    local contentFrame = Instance.new("Frame", Scroll)
    contentFrame.Name = tabName .. "Content"
    contentFrame.Size = UDim2.new(1, 0, 0, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.LayoutOrder = i
    contentFrame.Visible = (i == 1)
    
    local contentList = Instance.new("UIListLayout", contentFrame)
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Padding = UDim.new(0, 6)
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, child in ipairs(Scroll:GetChildren()) do
            if child:IsA("Frame") and child.Name:match("Content") then
                child.Visible = false
            end
        end
        contentFrame.Visible = true
        Scroll.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 20)
    end)
    
    -- Isi konten per tab
    if tabName == "Main" then
        addToggle(contentFrame, "Instant Auto Grab Gun", false, function(v) _G.AutoGrab = v
            spawn(function()
                while _G.AutoGrab do task.wait(0.1)
                    local drop = workspace:FindFirstChild("GunDrop", true)
                    if drop and LocalPlayer.Character then
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, drop, 0)
                        task.wait(0.05)
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, drop, 1)
                    end
                end
            end)
        end)
        addToggle(contentFrame, "Show Action Buttons", true, function(v)
            local gui = ScreenGui:FindFirstChild("FloatingButtons")
            if gui then gui.Visible = v end
        end)
        addToggle(contentFrame, "Anti AFK", false, function(v)
            _G.AntiAFK = v
            spawn(function()
                while _G.AntiAFK do task.wait(60)
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0,0,0.1))
                    end
                end
            end)
        end)
        local wsSlider = addSlider(contentFrame, "Walkspeed", 16, 16, 120, function(v) _G.Walkspeed = v
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = v end
        end)
        local jpSlider = addSlider(contentFrame, "Jump Power", 50, 50, 300, function(v) _G.JumpPower = v
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = v end
        end)
    elseif tabName == "Visual" then
        addToggle(contentFrame, "Master Role ESP", false, function(v) _G.MasterESP = v
            spawn(function()
                while _G.MasterESP do task.wait(0.3)
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                            local hl = plr.Character:FindFirstChild("PrimeESP") or Instance.new("Highlight", plr.Character)
                            hl.Name = "PrimeESP"
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            local hasKnife = plr.Character:FindFirstChild("Knife") or plr.Backpack:FindFirstChild("Knife")
                            local hasGun = plr.Character:FindFirstChild("Gun") or plr.Backpack:FindFirstChild("Gun")
                            if hasKnife then
                                hl.FillColor = plr.Character.Head.Transparency > 0.5 and Color3.fromRGB(255,80,255) or Color3.new(1,0,0)
                            elseif hasGun then
                                hl.FillColor = Color3.fromRGB(255,215,0)
                            else
                                hl.FillColor = Color3.fromRGB(100,200,255)
                            end
                            hl.FillTransparency = 0.6
                        end
                    end
                end
            end)
        end)
        addToggle(contentFrame, "ESP Gun Drop", false, function(v) _G.GunDropESP = v
            spawn(function()
                while _G.GunDropESP do task.wait(0.5)
                    for _, drop in pairs(workspace:GetDescendants()) do
                        if drop.Name == "GunDrop" and drop:IsA("BasePart") then
                            if not drop:FindFirstChild("GunESP") then
                                local bill = Instance.new("BillboardGui", drop)
                                bill.Name = "GunESP"
                                bill.Size = UDim2.new(0,3,0,3)
                                bill.AlwaysOnTop = true
                                local label = Instance.new("TextLabel", bill)
                                label.Size = UDim2.new(1,0,1,0)
                                label.BackgroundTransparency = 1
                                label.Text = "🔫 GUN"
                                label.TextColor3 = Color3.new(1,1,0)
                                label.TextScaled = true
                            end
                        else
                            if drop:FindFirstChild("GunESP") then drop.GunESP:Destroy() end
                        end
                    end
                end
            end)
        end)
    elseif tabName == "Combat" then
        addToggle(contentFrame, "Auto Shoot Murderer", false, function(v) _G.AutoShoot = v
            spawn(function()
                while _G.AutoShoot do task.wait(0.2)
                    local gun = LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
                    if gun then
                        for _, plr in pairs(Players:GetPlayers()) do
                            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Knife") then
                                local remote = gun:FindFirstChild("KnifeLocal") and gun.KnifeLocal:FindFirstChild("CreateBeam")
                                if remote then remote:FireServer(plr.Character.HumanoidRootPart.Position) end
                                break
                            end
                        end
                    end
                end
            end)
        end)
        addButton(contentFrame, "Force Shoot (Arahkan ke Murderer)", function()
            local gun = LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
            if gun then
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Knife") then
                        local remote = gun:FindFirstChild("KnifeLocal") and gun.KnifeLocal:FindFirstChild("CreateBeam")
                        if remote then remote:FireServer(plr.Character.HumanoidRootPart.Position) end
                        break
                    end
                end
            end
        end)
    elseif tabName == "Opti" then
        addButton(contentFrame, "Full FPS Boost", function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic
                elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") then v:Destroy()
                elseif v:IsA("Shadow") then v.Enabled = false end
            end
            settings().Rendering.QualityLevel = 1
            game:GetService("Lighting").GlobalShadows = false
            setfpscap(60)
        end)
        addButton(contentFrame, "Reset Graphics", function()
            settings().Rendering.QualityLevel = 10
            game:GetService("Lighting").GlobalShadows = true
            setfpscap(999)
        end)
    end
    table.insert(Scroll:GetChildren(), contentFrame)
end

-- Helper slider (karena addSlider belum didefinisikan)
function addSlider(parent, text, defaultValue, minVal, maxVal, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -16, 0, 55)
    frame.BackgroundColor3 = Color3.fromRGB(25, 30, 50)
    frame.BackgroundTransparency = 0.3
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.5, 0, 0.4, 0)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    local valueLabel = Instance.new("TextLabel", frame)
    valueLabel.Size = UDim2.new(0.3, 0, 0.4, 0)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 5)
    valueLabel.Text = tostring(defaultValue)
    valueLabel.TextColor3 = Color3.new(1,1,1)
    valueLabel.BackgroundTransparency = 1
    
    local slider = Instance.new("TextBox", frame)
    slider.Size = UDim2.new(0.9, 0, 0.3, 0)
    slider.Position = UDim2.new(0.05, 0, 0.55, 0)
    slider.Text = tostring(defaultValue)
    slider.TextColor3 = Color3.new(1,1,1)
    slider.BackgroundColor3 = Color3.fromRGB(40, 50, 80)
    slider.ClearTextOnFocus = false
    local sliderCorner = Instance.new("UICorner", slider)
    sliderCorner.CornerRadius = UDim.new(0, 6)
    
    local function updateValue(newVal)
        local num = tonumber(newVal) or defaultValue
        num = math.clamp(num, minVal, maxVal)
        slider.Text = tostring(math.floor(num))
        valueLabel.Text = tostring(math.floor(num))
        callback(math.floor(num))
    end
    
    slider.FocusLost:Connect(function(enter)
        if enter then updateValue(slider.Text) end
    end)
    
    updateValue(defaultValue)
    return slider
end

-- Floating Buttons
local FloatGui = Instance.new("ScreenGui", game.CoreGui)
FloatGui.Name = "FloatingButtons"
FloatGui.ResetOnSpawn = false

-- Toggle menu button (Optimus)
local ToggleMenuBtn = Instance.new("ImageButton", FloatGui)
ToggleMenuBtn.Size = UDim2.new(0, 55, 0, 55)
ToggleMenuBtn.Position = UDim2.new(0.02, 0, 0.12, 0)
ToggleMenuBtn.Image = "rbxassetid://6031094786"  -- fallback
ToggleMenuBtn.BackgroundTransparency = 1
ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
-- Jika gambar gagal
task.wait(1)
if ToggleMenuBtn.Image == "rbxasset://textures/ui/ImageLoader/ImagePlaceholder.png" or ToggleMenuBtn.Image == "" then
    ToggleMenuBtn.Image = ""
    ToggleMenuBtn.Text = "🔥"
    ToggleMenuBtn.TextColor3 = Color3.new(1,1,1)
    ToggleMenuBtn.TextScaled = true
    ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(30,30,60)
    ToggleMenuBtn.BackgroundTransparency = 0
    local corner = Instance.new("UICorner", ToggleMenuBtn)
    corner.CornerRadius = UDim.new(1,0)
end

-- Get Gun floating
local GetGunBtn = Instance.new("TextButton", FloatGui)
GetGunBtn.Size = UDim2.new(0, 70, 0, 70)
GetGunBtn.Position = UDim2.new(0.15, 0, 0.45, 0)
GetGunBtn.Text = "🔫 GET GUN"
GetGunBtn.TextColor3 = Color3.new(1,1,1)
GetGunBtn.BackgroundColor3 = Color3.fromRGB(25,35,55)
GetGunBtn.Visible = true
local btnCorner = Instance.new("UICorner", GetGunBtn)
btnCorner.CornerRadius = UDim.new(1,0)
GetGunBtn.MouseButton1Click:Connect(function()
    local drop = workspace:FindFirstChild("GunDrop", true)
    if drop and LocalPlayer.Character then
        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, drop, 0)
        task.wait(0.05)
        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, drop, 1)
    end
end)

-- Shoot panel
local ShootFrame = Instance.new("Frame", FloatGui)
ShootFrame.Size = UDim2.new(0, 150, 0, 70)
ShootFrame.Position = UDim2.new(0.7, 0, 0.25, 0)
ShootFrame.BackgroundColor3 = Color3.fromRGB(20,25,50)
ShootFrame.Visible = true
local frameCorner = Instance.new("UICorner", ShootFrame)
frameCorner.CornerRadius = UDim.new(0, 12)

local ShootBtn = Instance.new("TextButton", ShootFrame)
ShootBtn.Size = UDim2.new(1,0,1,0)
ShootBtn.Text = "🔫 SHOOT MURDERER"
ShootBtn.TextColor3 = Color3.new(1,1,1)
ShootBtn.BackgroundTransparency = 1
ShootBtn.TextScaled = true
ShootBtn.MouseButton1Click:Connect(function()
    local gun = LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
    if not gun then
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="Error", Text="No gun!", Duration=2})
        return
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Knife") then
            local remote = gun:FindFirstChild("KnifeLocal") and gun.KnifeLocal:FindFirstChild("CreateBeam")
            if remote then remote:FireServer(plr.Character.HumanoidRootPart.Position) end
            break
        end
    end
end)

-- Drag untuk floating buttons
makeDraggable(GetGunBtn)
makeDraggable(ShootFrame)
makeDraggable(ToggleMenuBtn)

-- Notifikasi
setclipboard("TB TV")
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Prime Hub Vónzz (Delta)",
    Text = "✅ Loaded! Tap 🔥 button to open menu",
    Duration = 5
})

-- Update walkspeed/jump on respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = _G.Walkspeed
        hum.JumpPower = _G.JumpPower
    end
end)

print("Prime Hub Vónzz Delta Edition loaded. No external library required.")
