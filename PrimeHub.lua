-- [[ PRIME HUB | MOBILE VÓNZZ EDITION (FIXED + EXTREME) ]]
-- Fitur: ESP Role, Auto Grab Gun, Auto Shoot Murderer, ESP Gun Drop, FPS Boost, Floating UI, Anti-AFK, Walkspeed/Jump, dll.

-- // LOAD VENYX (DENGAN ERROR HANDLING) // --
local VenyxLoaded, Venyx = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/Venyx-UI-Library/main/source.lua"))()
end)
if not VenyxLoaded then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Error", Text = "Gagal load Venyx. Cek koneksi.", Duration = 5
    })
    return
end

local UI = Venyx.new("Prime Hub | Vónzz Edition (Fixed)")

-- // THEME: TEKS PUTIH TOTAL (DIJAMIN) // --
local Theme = {
    Background = Color3.fromRGB(8, 12, 25),
    Glow = Color3.fromRGB(0, 120, 255),
    Accent = Color3.fromRGB(0, 160, 255),
    LightContrast = Color3.fromRGB(20, 28, 45),
    DarkContrast = Color3.fromRGB(3, 8, 18),
    TextColor = Color3.fromRGB(255, 255, 255),  -- PUTIH
    SubTextColor = Color3.fromRGB(200, 200, 200)
}
UI:SetTheme(Theme)

-- // PAGES // --
local Main = UI:addPage("Main", 5012544693)
local Visual = UI:addPage("Visual", 5012544693)
local Combat = UI:addPage("Combat", 5012544693)
local Opti = UI:addPage("Optimization", 5012544693)

-- ======================== GLOBAL VARIABLES ======================== --
_G.AutoGrab = false
_G.MasterESP = false
_G.AutoShoot = false
_G.GunDropESP = false
_G.Walkspeed = 16
_G.JumpPower = 50
_G.AntiAFK = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ======================== MAIN SECTION ======================== --
local MainSection = Main:addSection("Core Features")

-- Auto Grab Gun (FIXED: lebih halus)
MainSection:addToggle("Instant Auto Grab Gun", nil, function(v)
    _G.AutoGrab = v
    spawn(function()
        while _G.AutoGrab do
            task.wait(0.1)
            local gunDrop = workspace:FindFirstChild("GunDrop", true)
            if gunDrop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = LocalPlayer.Character.HumanoidRootPart
                firetouchinterest(hrp, gunDrop, 0)
                task.wait(0.05)
                firetouchinterest(hrp, gunDrop, 1)
            end
        end
    end)
end)

-- Show/Hide Floating Buttons (FIXED: GUI dibuat duluan, lihat bawah)
MainSection:addToggle("Show Action Buttons", nil, function(v)
    local gui = game.CoreGui:FindFirstChild("PrimeMobileV2")
    if gui then
        local getGun = gui:FindFirstChild("GetGun")
        local shootPanel = gui:FindFirstChild("ShootPanel")
        if getGun then getGun.Visible = v end
        if shootPanel then shootPanel.Visible = v end
    end
end)

-- Walkspeed & Jump Power (FITUR TAMBAHAN)
MainSection:addSlider("Walkspeed", {min=16, max=120, default=16}, function(v)
    _G.Walkspeed = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)
MainSection:addSlider("Jump Power", {min=50, max=300, default=50}, function(v)
    _G.JumpPower = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = v
    end
end)

-- Anti AFK (FITUR TAMBAHAN)
MainSection:addToggle("Anti AFK (Kick Protection)", nil, function(v)
    _G.AntiAFK = v
    spawn(function()
        while _G.AntiAFK do
            task.wait(60)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0,0,0.1))
            end
        end
    end)
end)

-- ======================== VISUAL SECTION (ESP) ======================== --
local VisualSection = Visual:addSection("ESP Player")

-- ESP ROLE (FIXED: logika hero/sheriff jelas)
VisualSection:addToggle("Master Role ESP", nil, function(v)
    _G.MasterESP = v
    spawn(function()
        while _G.MasterESP do
            task.wait(0.3)
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                    local highlight = plr.Character:FindFirstChild("PrimeESP")
                    if not highlight then
                        highlight = Instance.new("Highlight", plr.Character)
                        highlight.Name = "PrimeESP"
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.OutlineTransparency = 0.5
                    end
                    
                    -- Deteksi role berdasarkan tool
                    local hasKnife = plr.Character:FindFirstChild("Knife") or (plr.Backpack:FindFirstChild("Knife") and true)
                    local hasGun = plr.Character:FindFirstChild("Gun") or (plr.Backpack:FindFirstChild("Gun") and true)
                    
                    if hasKnife then
                        -- Murderer
                        if plr.Character.Head.Transparency > 0.5 then
                            highlight.FillColor = Color3.fromRGB(255, 80, 255) -- Ghost Murder (Pink terang)
                        else
                            highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Merah
                        end
                    elseif hasGun then
                        -- Hero (pemegang gun)
                        highlight.FillColor = Color3.fromRGB(255, 215, 0) -- Emas/Kuning Hero
                    else
                        -- Innocent atau Sheriff (tidak ada senjata)
                        highlight.FillColor = Color3.fromRGB(100, 200, 255) -- Biru terang
                    end
                    highlight.FillTransparency = 0.6
                    highlight.OutlineColor = Color3.fromRGB(255,255,255)
                else
                    -- Hapus highlight jika karakter tidak ada
                    if plr.Character then
                        local old = plr.Character:FindFirstChild("PrimeESP")
                        if old then old:Destroy() end
                    end
                end
            end
        end
    end)
end)

-- ESP Gun Drop (FITUR TAMBAHAN: menandai posisi senjata jatuh)
VisualSection:addToggle("ESP Gun Drop (Bilah)", nil, function(v)
    _G.GunDropESP = v
    spawn(function()
        while _G.GunDropESP do
            task.wait(0.5)
            for _, drop in pairs(workspace:GetDescendants()) do
                if drop.Name == "GunDrop" and drop:IsA("BasePart") then
                    local esp = drop:FindFirstChild("GunESPBillboard")
                    if not esp then
                        local bill = Instance.new("BillboardGui", drop)
                        bill.Name = "GunESPBillboard"
                        bill.Size = UDim2.new(0, 3, 0, 3)
                        bill.AlwaysOnTop = true
                        local label = Instance.new("TextLabel", bill)
                        label.Size = UDim2.new(1,0,1,0)
                        label.BackgroundTransparency = 1
                        label.Text = "🔫 GUN DROP"
                        label.TextColor3 = Color3.new(1,1,0)
                        label.TextStrokeTransparency = 0
                        label.TextScaled = true
                    end
                else
                    if drop:FindFirstChild("GunESPBillboard") then
                        drop:FindFirstChild("GunESPBillboard"):Destroy()
                    end
                end
            end
        end
    end)
end)

-- ======================== COMBAT SECTION ======================== --
local CombatSection = Combat:addSection("Auto Combat")

-- Auto Shoot Murderer (FITUR TAMBAHAN: tembak otomatis jika murderer dalam jarak)
CombatSection:addToggle("Auto Shoot Murderer", nil, function(v)
    _G.AutoShoot = v
    spawn(function()
        while _G.AutoShoot do
            task.wait(0.2)
            local gun = LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
            if not gun then continue end
            
            local nearestMurderer = nil
            local minDist = 30 -- jarak tembak efektif
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local hasKnife = plr.Character:FindFirstChild("Knife") or (plr.Backpack:FindFirstChild("Knife"))
                    if hasKnife then
                        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            nearestMurderer = plr
                        end
                    end
                end
            end
            if nearestMurderer then
                local remote = gun:FindFirstChild("KnifeLocal") and gun.KnifeLocal:FindFirstChild("CreateBeam")
                if remote then
                    remote:FireServer(nearestMurderer.Character.HumanoidRootPart.Position)
                end
            end
        end
    end)
end)

-- Tombol manual shoot (dari UI floating sudah ada, tapi tambah di menu)
CombatSection:addButton("Force Shoot (Arahkan ke Murderer)", function()
    local gun = LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
    if not gun then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Knife") then
            local remote = gun:FindFirstChild("KnifeLocal") and gun.KnifeLocal:FindFirstChild("CreateBeam")
            if remote then
                remote:FireServer(plr.Character.HumanoidRootPart.Position)
                break
            end
        end
    end
end)

-- ======================== OPTIMIZATION SECTION ======================== --
local OptiSection = Opti:addSection("Mobile Boost & Graphics")

OptiSection:addButton("Full FPS Boost (Extreme)", function()
    -- Matikan efek visual
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Material ~= Enum.Material.SmoothPlastic then
            v.Material = Enum.Material.SmoothPlastic
        elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") then
            v:Destroy()
        elseif v:IsA("Shadow") then
            v.Enabled = false
        end
    end
    settings().Rendering.QualityLevel = 1
    game:GetService("Lighting").GlobalShadows = false
    game:GetService("Lighting").FogEnd = 1000
    setfpscap(60)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title="Boost", Text="FPS Boost Aktif", Duration=2})
end)

OptiSection:addButton("Reset Graphics", function()
    settings().Rendering.QualityLevel = 10
    game:GetService("Lighting").GlobalShadows = true
    game:GetService("Lighting").FogEnd = 100000
    setfpscap(999)
end)

-- ======================== FLOATING MOBILE UI (DENGAN FOTO OPTIMUS YANG PASTI KELIHATAN) ======================== --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "PrimeMobileV2"
ScreenGui.ResetOnSpawn = false

-- TOMBOL TOGGLE MENU (FOTO OPTIMUS – DENGAN FALLBACK)
local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 60, 0, 60)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.12, 0)
ToggleBtn.BackgroundTransparency = 1

-- URL foto Optimus (ganti dengan ID yang valid. ID berikut menampilkan robot transformer)
local optimusAssetId = "rbxassetid://6031094786"  -- ID decal Optimus Prime (bisa diganti)
ToggleBtn.Image = optimusAssetId

-- Jika gambar gagal load (tidak keliatan), fallback ke teks "OP"
ToggleBtn.ImageTransparency = 0
ToggleBtn.MouseButton1Click:Connect(function()
    UI:toggle()
end)

-- Deteksi jika gambar error (tidak muncul)
task.wait(1)
if ToggleBtn.Image == "" or ToggleBtn.Image == "rbxasset://textures/ui/ImageLoader/ImagePlaceholder.png" then
    ToggleBtn.Image = ""
    ToggleBtn.Text = "🔥"
    ToggleBtn.TextColor3 = Color3.new(1,1,1)
    ToggleBtn.TextScaled = true
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(30,30,60)
    ToggleBtn.BackgroundTransparency = 0
    local corner = Instance.new("UICorner", ToggleBtn)
    corner.CornerRadius = UDim.new(1,0)
end

-- Floating Get Gun (Bulat)
local GetGun = Instance.new("TextButton", ScreenGui)
GetGun.Size = UDim2.new(0, 70, 0, 70)
GetGun.Position = UDim2.new(0.15, 0, 0.45, 0)
GetGun.Text = "🔫 GET GUN"
GetGun.TextColor3 = Color3.new(1,1,1)
GetGun.BackgroundColor3 = Color3.fromRGB(25, 35, 55)
GetGun.Visible = false
local corner1 = Instance.new("UICorner", GetGun)
corner1.CornerRadius = UDim.new(1,0)

-- Floating Shoot Panel (Kotak)
local ShootPanel = Instance.new("Frame", ScreenGui)
ShootPanel.Size = UDim2.new(0, 180, 0, 85)
ShootPanel.Position = UDim2.new(0.75, 0, 0.25, 0)
ShootPanel.BackgroundColor3 = Color3.fromRGB(15, 20, 45)
ShootPanel.Visible = false
local corner2 = Instance.new("UICorner", ShootPanel)
corner2.CornerRadius = UDim.new(0, 12)

local ShootBtn = Instance.new("TextButton", ShootPanel)
ShootBtn.Size = UDim2.new(1,0,1,0)
ShootBtn.Text = "🔫 SHOOT MURDERER"
ShootBtn.BackgroundTransparency = 1
ShootBtn.TextColor3 = Color3.new(1,1,1)
ShootBtn.TextScaled = true

-- DRAG LOGIC MOBILE (DIPERBAIKI UNTUK MULTI-TOUCH)
local function makeDraggable(obj)
    local dragging = false
    local dragStart
    local startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)
    obj.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInput.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(GetGun)
makeDraggable(ShootPanel)
makeDraggable(ToggleBtn)

-- FUNGSI TOMBOL
GetGun.MouseButton1Click:Connect(function()
    local gunDrop = workspace:FindFirstChild("GunDrop", true)
    if gunDrop and LocalPlayer.Character then
        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, gunDrop, 0)
        task.wait(0.05)
        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, gunDrop, 1)
    end
end)

ShootBtn.MouseButton1Click:Connect(function()
    local gun = LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
    if not gun then
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="Gagal", Text="Kamu tidak punya gun!", Duration=2})
        return
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Knife") then
            local remote = gun:FindFirstChild("KnifeLocal") and gun.KnifeLocal:FindFirstChild("CreateBeam")
            if remote then
                remote:FireServer(plr.Character.HumanoidRootPart.Position)
                break
            end
        end
    end
end)

-- NOTIFIKASI AWAL (FIXED syntax & clipboard)
setclipboard("TB TV")
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Prime Hub Vónzz",
    Text = "✅ TB TV Copied! Tap Optimus to open menu",
    Icon = "rbxassetid://6031094786",
    Duration = 5
})

-- UPDATE WALKSPEED & JUMP POWER SECARA REAL-TIME (jika karakter respawn)
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = _G.Walkspeed
        hum.JumpPower = _G.JumpPower
    end
end)

print("Prime Hub Vónzz Edition LOADED – Semua teks putih, foto Optimus fallback siap.")
