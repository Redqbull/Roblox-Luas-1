local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Lester Quality⚡",
    LoadingTitle = "Lester",
    LoadingSubtitle = "by Lester",
    ConfigurationSaving = {
       Enabled = false,
       FolderName = nil, -- Create a custom folder for your hub/game
       FileName = "Lester Hub"
    },
    Discord = {
       Enabled = false,
       Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
       RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
    KeySystem = false, -- Set this to true to use our key system
    KeySettings = {
       Title = "Untitled",
       Subtitle = "Key System",
       Note = "No method of obtaining the key is provided",
       FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
       SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
 })

 local MainTab = Window:CreateTab("Aimbot+", nil) -- Title, Image
 local MainSection = MainTab:CreateSection("Main")

 Rayfield:Notify({
    Title = "Lester Quality",
    Content = "if your gonna cheat, cheat right -Lester",
    Duration = 5,
    Image = nil,
    Actions = { -- Notification Buttons
       Ignore = {
          Name = "Okay!",
          Callback = function()
          print("The user tapped Okay!")
       end
    },
 },
 })

 local Button = MainTab:CreateButton({
    Name = "Aimbot",
    Callback = function()
        local teamCheck = false
        local fov = 150
        local smoothing = 1
        
        local RunService = game:GetService("RunService")
        
        local FOVring = Drawing.new("Circle")
        FOVring.Visible = true
        FOVring.Thickness = 1.5
        FOVring.Radius = fov
        FOVring.Transparency = 1
        FOVring.Color = Color3.fromRGB(255, 255, 255)
        FOVring.Position = workspace.CurrentCamera.ViewportSize/2
        
        local function getClosest(cframe)
           local ray = Ray.new(cframe.Position, cframe.LookVector).Unit
           
           local target = nil
           local mag = math.huge
           
           for i,v in pairs(game.Players:GetPlayers()) do
               if v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v ~= game.Players.LocalPlayer and (v.Team ~= game.Players.LocalPlayer.Team or (not teamCheck)) then
                   local magBuf = (v.Character.Head.Position - ray:ClosestPoint(v.Character.Head.Position)).Magnitude
                   
                   if magBuf < mag then
                       mag = magBuf
                       target = v
                   end
               end
           end
           
           return target
        end
        
        loop = RunService.RenderStepped:Connect(function()
           local UserInputService = game:GetService("UserInputService")
           local pressed = --[[UserInputService:IsKeyDown(Enum.KeyCode.E)]] UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) --Enum.UserInputType.MouseButton2
           local localPlay = game.Players.localPlayer.Character
           local cam = workspace.CurrentCamera
           local zz = workspace.CurrentCamera.ViewportSize/2
           
           if pressed then
               local Line = Drawing.new("Line")
               local curTar = getClosest(cam.CFrame)
               local ssHeadPoint = cam:WorldToScreenPoint(curTar.Character.Head.Position)
               ssHeadPoint = Vector2.new(ssHeadPoint.X, ssHeadPoint.Y)
               if (ssHeadPoint - zz).Magnitude < fov then
                   workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(cam.CFrame.Position, curTar.Character.Head.Position), smoothing)
               end
           end
           
           if UserInputService:IsKeyDown(Enum.KeyCode.Delete) then
               loop:Disconnect()
               FOVring:Remove()
           end
        end)
    end,
 })

 local EspTab = Window:CreateTab("Esp+", nil) -- Title, Image
 local Section = EspTab:CreateSection("Esp")

 local Button = EspTab:CreateButton({
    Name = "Esp",
    Callback = function()
            -- Preview: https://cdn.discordapp.com/attachments/796378086446333984/818089455897542687/unknown.png
    -- Made by Blissful#4992
    local Settings = {
        Box_Color = Color3.fromRGB(255, 0, 0),
        Tracer_Color = Color3.fromRGB(255, 0, 0),
        Tracer_Thickness = 1,
        Box_Thickness = 1,
        Tracer_Origin = "Bottom", -- Middle or Bottom if FollowMouse is on this won't matter...
        Tracer_FollowMouse = false,
        Tracers = false
    }
    local Team_Check = {
        TeamCheck = false, -- if TeamColor is on this won't matter...
        Green = Color3.fromRGB(0, 255, 0),
        Red = Color3.fromRGB(255, 0, 0)
    }
    local TeamColor = true

    --// SEPARATION
    local player = game:GetService("Players").LocalPlayer
    local camera = game:GetService("Workspace").CurrentCamera
    local mouse = player:GetMouse()

    local function NewQuad(thickness, color)
        local quad = Drawing.new("Quad")
        quad.Visible = false
        quad.PointA = Vector2.new(0,0)
        quad.PointB = Vector2.new(0,0)
        quad.PointC = Vector2.new(0,0)
        quad.PointD = Vector2.new(0,0)
        quad.Color = color
        quad.Filled = false
        quad.Thickness = thickness
        quad.Transparency = 1
        return quad
    end

local function NewLine(thickness, color)
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(0, 0)
    line.Color = color 
    line.Thickness = thickness
    line.Transparency = 1
    return line
end

local function Visibility(state, lib)
    for u, x in pairs(lib) do
        x.Visible = state
    end
end

local function ToColor3(col) --Function to convert, just cuz c;
    local r = col.r --Red value
    local g = col.g --Green value
    local b = col.b --Blue value
    return Color3.new(r,g,b); --Color3 datatype, made of the RGB inputs
end

local black = Color3.fromRGB(0, 0 ,0)
local function ESP(plr)
    local library = {
        --//Tracer and Black Tracer(black border)
        blacktracer = NewLine(Settings.Tracer_Thickness*2, black),
        tracer = NewLine(Settings.Tracer_Thickness, Settings.Tracer_Color),
        --//Box and Black Box(black border)
        black = NewQuad(Settings.Box_Thickness*2, black),
        box = NewQuad(Settings.Box_Thickness, Settings.Box_Color),
        --//Bar and Green Health Bar (part that moves up/down)
        healthbar = NewLine(3, black),
        greenhealth = NewLine(1.5, black)
    }

    local function Colorize(color)
        for u, x in pairs(library) do
            if x ~= library.healthbar and x ~= library.greenhealth and x ~= library.blacktracer and x ~= library.black then
                x.Color = color
            end
        end
    end

    local function Updater()
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            if plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Head") ~= nil then
                local HumPos, OnScreen = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                if OnScreen then
                    local head = camera:WorldToViewportPoint(plr.Character.Head.Position)
                    local DistanceY = math.clamp((Vector2.new(head.X, head.Y) - Vector2.new(HumPos.X, HumPos.Y)).magnitude, 2, math.huge)
                    
                    local function Size(item)
                        item.PointA = Vector2.new(HumPos.X + DistanceY, HumPos.Y - DistanceY*2)
                        item.PointB = Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY*2)
                        item.PointC = Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY*2)
                        item.PointD = Vector2.new(HumPos.X + DistanceY, HumPos.Y + DistanceY*2)
                    end
                    Size(library.box)
                    Size(library.black)

                    --//Tracer 
                    if Settings.Tracers then
                        if Settings.Tracer_Origin == "Middle" then
                            library.tracer.From = camera.ViewportSize*0.5
                            library.blacktracer.From = camera.ViewportSize*0.5
                        elseif Settings.Tracer_Origin == "Bottom" then
                            library.tracer.From = Vector2.new(camera.ViewportSize.X*0.5, camera.ViewportSize.Y) 
                            library.blacktracer.From = Vector2.new(camera.ViewportSize.X*0.5, camera.ViewportSize.Y)
                        end
                        if Settings.Tracer_FollowMouse then
                            library.tracer.From = Vector2.new(mouse.X, mouse.Y+36)
                            library.blacktracer.From = Vector2.new(mouse.X, mouse.Y+36)
                        end
                        library.tracer.To = Vector2.new(HumPos.X, HumPos.Y + DistanceY*2)
                        library.blacktracer.To = Vector2.new(HumPos.X, HumPos.Y + DistanceY*2)
                    else 
                        library.tracer.From = Vector2.new(0, 0)
                        library.blacktracer.From = Vector2.new(0, 0)
                        library.tracer.To = Vector2.new(0, 0)
                        library.blacktracer.To = Vector2.new(0, 02)
                    end

                    --// Health Bar
                    local d = (Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY*2) - Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY*2)).magnitude 
                    local healthoffset = plr.Character.Humanoid.Health/plr.Character.Humanoid.MaxHealth * d

                    library.greenhealth.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2)
                    library.greenhealth.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2 - healthoffset)

                    library.healthbar.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2)
                    library.healthbar.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y - DistanceY*2)

                    local green = Color3.fromRGB(0, 255, 0)
                    local red = Color3.fromRGB(255, 0, 0)

                    library.greenhealth.Color = red:lerp(green, plr.Character.Humanoid.Health/plr.Character.Humanoid.MaxHealth);

                    if Team_Check.TeamCheck then
                        if plr.TeamColor == player.TeamColor then
                            Colorize(Team_Check.Green)
                        else 
                            Colorize(Team_Check.Red)
                        end
                    else 
                        library.tracer.Color = Settings.Tracer_Color
                        library.box.Color = Settings.Box_Color
                    end
                    if TeamColor == true then
                        Colorize(plr.TeamColor.Color)
                    end
                    Visibility(true, library)
                else 
                    Visibility(false, library)
                end
            else 
                Visibility(false, library)
                if game.Players:FindFirstChild(plr.Name) == nil then
                    connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Updater)()
end

for i, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.Name ~= player.Name then
        coroutine.wrap(ESP)(v)
    end
end

game.Players.PlayerAdded:Connect(function(newplr)
    if newplr.Name ~= player.Name then
        coroutine.wrap(ESP)(newplr)
    end
end)
    end,
 })

 local PlayerTab = Window:CreateTab("Player", nil) -- Title, Image
 local PlayerSection = PlayerTab:CreateSection("Player")

 local Slider = PlayerTab:CreateSlider({
    Name = "WalkSpeed Slider",
    Range = {1, 350},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "sliderws", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Value)
    end,
 })

 local Slider = PlayerTab:CreateSlider({
    Name = "JumpPower Slider",
    Range = {1, 350},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "sliderjp", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
         game.Players.LocalPlayer.Character.Humanoid.JumpPower = (Value)
    end,
 })

 local Button = PlayerTab:CreateButton({
    Name = "Infinite Jump Toggle",
    Callback = function()
        --Toggles the infinite jump between on or off on every script run
 _G.infinjump = not _G.infinjump
 
 if _G.infinJumpStarted == nil then
     --Ensures this only runs once to save resources
     _G.infinJumpStarted = true
     
     --Notifies readiness
     game.StarterGui:SetCore("SendNotification", {Title="Youtube Hub"; Text="Infinite Jump Activated!"; Duration=5;})
 
     --The actual infinite jump
     local plr = game:GetService('Players').LocalPlayer
     local m = plr:GetMouse()
     m.KeyDown:connect(function(k)
         if _G.infinjump then
             if k:byte() == 32 then
             humanoid = game:GetService'Players'.LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
             humanoid:ChangeState('Jumping')
             wait()
             humanoid:ChangeState('Seated')
             end
         end
     end)
 end
    end,
 })
 
 local DahoodTab = Window:CreateTab("Dahood", nil) -- Title, Image
 local DahoodSection = DahoodTab:CreateSection("Dahood")

 local Button = DahoodTab:CreateButton({
    Name = "Azure Modded",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Actyrn/Scripts/main/AzureModded"))()
    end,
 })

 local ArsenalTab = Window:CreateTab("Arsenal", nil) -- Title, Image
 local  ArsenalSection = ArsenalTab:CreateSection("Arsenal")

 local Button = ArsenalTab:CreateButton({
    Name = "Leg hub (Sponsor)",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/G6Ubkkuv"))()
    end,
 })

 local Button = Tab:CreateButton({
    Name = "Button Example",
    Callback = function()
    -- The function that takes place when the button is pressed
    end,
 })