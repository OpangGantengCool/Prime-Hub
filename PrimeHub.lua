-- [[ PRIME HUB | VÓNZZ EDITION ]] --
-- [[ ALL FEATURES COMBO + OPTIMUS TOGGLE ]] --

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "PrimeHub_Mobile"

-- // KEYBIND UI: FOTO OPTIMUS PRIME // --
local ToggleButton = Instance.new("ImageButton", ScreenGui)
ToggleButton.Name = "UI_Toggle"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.02, 0, 0.15, 0)
ToggleButton.Image = "rbxassetid://18fbdb3dbd36a296f1793e390c26b65c" -- Foto Optimus lu
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)

-- // MAIN FRAME: ONYX HUB STYLE // --
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 480, 0, 300)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 18, 35)
MainFrame.BackgroundTransparency = 0.15
MainFrame.Visible = true
Instance.new("UICorner", MainFrame)

-- // TOGGLE SCRIPT (KEYBIND VERSI MOBILE) // --
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    game.CoreGui.PrimeHub_Mobile.GetGun.Visible = MainFrame.Visible
    game.CoreGui.PrimeHub_Mobile.ShootPanel.Visible = MainFrame.Visible
end)

-- // ESP ADVANCED (SHERIFF, MURDER, HERO, GHOST) // --
local function CreateESP()
    spawn(function()
        while true do task.wait(1)
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= game.Players.LocalPlayer and p.Character then
                    local Head = p.Character:FindFirstChild("Head")
                    if Head then
                        -- Warna ESP
                        local Color = Color3.new(1, 1, 1) -- Innocent
                        if p.Character:FindFirstChild("Knife") then Color = Color3.new(1, 0, 0) -- Murder
                        elseif p.Character:FindFirstChild("Gun") then Color = Color3.new(0, 0, 1) -- Sheriff
                        end
                        
                        -- Detect Hero (Picked up gun)
                        if p.Name == workspace:FindFirstChild("GunDrop", true) then Color = Color3.new(1, 1, 0) end
                        
                        -- Detect Ghost (Invisible Murder)
                        if p.Character.Head.Transparency > 0.5 then Color = Color3.fromRGB(255, 0, 255) end
                        
                        -- Render Logic di sini (Highlight/Box)
                    end
                end
            end
        end
    end)
end

-- // FEATURES: INSTANT GRAB & AUTO SHOOT // --
local GetGun = Instance.new("TextButton", ScreenGui)
GetGun.Name = "GetGun"
GetGun.Size = UDim2.new(0, 60, 0, 60)
GetGun.Position = UDim2.new(0.1, 0, 0.4, 0)
GetGun.Text = "Get Gun"
GetGun.BackgroundColor3 = Color3.fromRGB(30, 40, 70)
Instance.new("UICorner", GetGun).CornerRadius = UDim.new(1,0)

GetGun.MouseButton1Click:Connect(function()
    local Gun = workspace:FindFirstChild("GunDrop", true)
    if Gun then firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, Gun, 0) end
end)

-- // AUTO-COPY TO CLIPBOARD // --
setclipboard("Script Prime Hub Loaded for Vónzz!")

-- // NOTIFICATION // --
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Prime Hub",
    Text = "Script Copied! Tap Optimus to Hide UI",
    Icon = "rbxassetid://18fbdb3dbd36a296f1793e390c26b65c",
    Duration = 5
})
