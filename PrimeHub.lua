-- [[ PRIME HUB | MM2 EDITION ]] --
-- [[ EXCLUSIVELY FOR Vónzz ]] --
-- [[ LOGO: IMG_20260512_181419.jpg ]] --

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Prime Hub | MM2 Edition",
   LoadingTitle = "Prime Hub Initializing...",
   LoadingSubtitle = "for Vónzz",
   ConfigurationSaving = { Enabled = true, FolderName = "PrimeHub_Vonzz", FileName = "Config" },
   Discord = { Enabled = true, Invite = "VW76aRUTtA", RememberJoins = true },
   KeySystem = true,
   KeySettings = {
      Title = "Vónzz License System",
      Subtitle = "Key Required",
      Note = "Private: Vonzz_Private_2026 | Public: VonzzPrime_2026",
      FileName = "VonzzKey",
      SaveKey = true,
      Key = {"VonzzPrime_2026", "Vonzz_Private_2026"} 
   }
})

-- // NOTIFICATION LOGO IMG_20260512_1419.jpg // --
Rayfield:Notify({
   Title = "Prime Hub Activated!",
   Content = "Skidders Roll Out! Loaded for Vónzz.",
   Duration = 7,
   Image = "rbxassetid://IMG_20260512_181419.jpg",
})

-- // TABS // --
local Main = Window:CreateTab("Main", 4483362458)
local Combat = Window:CreateTab("Combat", 4483362458)
local Misc = Window:CreateTab("Misc", 4483362458)

-- // MAIN: GET GUN FEATURES (ONYX STYLE) // --
Main:CreateToggle({
   Name = "Auto Get Gun (Onyx Style)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoGetGun = Value
      spawn(function()
         while _G.AutoGetGun do
            task.wait(0.5)
            local GunDrop = workspace:FindFirstChild("GunDrop", true)
            if GunDrop and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local oldPos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = GunDrop.CFrame
                task.wait(0.2)
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldPos
            end
         end
      end)
   end,
})

Main:CreateButton({
   Name = "Grab Gun Once (Manual)",
   Callback = function()
      local GunDrop = workspace:FindFirstChild("GunDrop", true)
      if GunDrop then
         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = GunDrop.CFrame
      end
   end,
})

-- // COMBAT: SHOOT MURDERER (DRAG & AIM) // --
Combat:CreateToggle({
   Name = "Silent Aim (Shoot Murderer)",
   CurrentValue = false,
   Callback = function(Value)
      _G.SilentAim = Value
      spawn(function()
         while _G.SilentAim do
            task.wait()
            local Gun = game.Players.LocalPlayer.Character:FindFirstChild("Gun")
            if Gun then
               for _, v in pairs(game.Players:GetPlayers()) do
                  if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Knife") then
                     -- Logic tembak otomatis ke arah Murderer
                     local args = { [1] = v.Character.HumanoidRootPart.Position }
                     Gun.KnifeLocal.CreateBeam:FireServer(unpack(args))
                  end
               end
            end
         end
      end)
   end,
})

-- // MISC: INSTANT SERVERHOP // --
Misc:CreateButton({
   Name = "Instant Serverhop",
   Callback = function()
      local Http = game:GetService("HttpService")
      local TPS = game:GetService("TeleportService")
      local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
      
      Rayfield:Notify({Title = "Serverhopping...", Content = "Finding a new server...", Duration = 3})
      
      local _srv = Http:JSONDecode(game:HttpGet(Api))
      for _, s in pairs(_srv.data) do
         if s.playing < s.maxPlayers and s.id ~= game.JobId then
            TPS:TeleportToPlaceInstance(game.PlaceId, s.id)
            break
         end
      end
   end,
})

Misc:CreateButton({
   Name = "Copy Discord Link",
   Callback = function()
      setclipboard("https://discord.gg/VW76aRUTtA")
      Rayfield:Notify({Title = "Copied!", Content = "Discord link copied to clipboard.", Duration = 3})
   end,
})
