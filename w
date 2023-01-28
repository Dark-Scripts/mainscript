-- Murcury Lib
-- Local Shit
local dwCamera = workspace.CurrentCamera
local dwRunService = game:GetService("RunService")
local dwUIS = game:GetService("UserInputService")
local dwEntities = game:GetService("Players")
local dwLocalPlayer = dwEntities.LocalPlayer
local dwMouse = dwLocalPlayer:GetMouse()
local aimParts = {'LeftFoot', 'LeftHand', 'LeftLowerArm', 'LeftLowerLeg', 'LeftUpperArm', 'LeftUpperLeg', 'LowerTorso', 'RightFoot', 'RightHand', 'RightLowerArm', 'RightLowerLeg', 'RightUpperLeg', 'RightUpperArm', 'UpperTorso', 'Head'}
local ArmChams = false
local ArmChams_Color = Color3.new(50, 50, 50)
local ArmMaterial = 'Plastic'
local WeaponChams = false
local WeaponChams_Color = Color3.new(50, 50, 50)
local WeaponMaterial = 'ForceField'
local BodyParts = {'LeftFoot', 'LeftHand', 'LeftLowerArm', 'LeftLowerLeg', 'LeftUpperArm', 'LeftUpperLeg', 'LowerTorso', 'RightFoot', 'RightHand', 'RightLowerArm', 'RightLowerLeg', 'RightUpperLeg', 'RightUpperArm', 'UpperTorso', 'Head'}
local AntiAim_Toggle = false
local Pitch_Type = nil
local Yaw_Type = nil
local AntiAim_Speed = 0
local CustomYaw_Value = 0
local leftrotation = CFrame.new(-150, 0, 0)
local rightrotation = CFrame.new(150, 0, 0)
local backrotation = CFrame.new(-4, 0, 0)
local NoAnims_Toggle = false
local isthirdperson = false
local ChatSpam = false
local Chatspam_Toggled = false
local Chatspam_Wait = 1
local Chatspam_Type = nil
local ChatDebounce = false
local hed = Instance.new('Part', workspace.Terrain)
local rhead = Instance.new('Part', hed)
local rtors = Instance.new('Part', hed)
local Bhop_Toggled = false
local Bhop_Speed = 1
local Visuals_Toggled = false
local NameTags_Toggled = false
local Chams_Toggled = false
local ChamsColor = Color3.fromRGB(50, 50, 50)
rhead.Name = "Head"
rtors.Name = 'UpperTorso'

local settings = {
	isnoclipping = false,
	Aimbot = true,
	Aiming = false,
	Aimbot_AimPart = "Head",
	Aimbot_TeamCheck = true,
	Aimbot_Draw_FOV = true,
	Aimbot_FOV_Radius = 200,
	Aimbot_FOV_Color = Color3.fromRGB(255,255,255)
}

local fovcircle = Drawing.new("Circle")
fovcircle.Visible = settings.Aimbot_Draw_FOV
fovcircle.Radius = settings.Aimbot_FOV_Radius
fovcircle.Color = settings.Aimbot_FOV_Color
fovcircle.Thickness = 1
fovcircle.Filled = false
fovcircle.Transparency = 1
fovcircle.Position = Vector2.new(dwCamera.ViewportSize.X / 2, dwCamera.ViewportSize.Y / 2)
fovcircle.Color = Color3.fromRGB(r,g,b)
game:GetService("RunService").RenderStepped:Wait()

local RainbowChams = false

function UpdateRainbowChams()
	while RainbowChams do
		local hue = math.abs(math.sin(tick() / 10))
		WeaponChams_Color = Color3.fromHSV(hue, 1, 1)
		wait()
	end
end
game:GetService("RunService").RenderStepped:Connect(UpdateRainbowChams)

-- Lib
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Dark-Scripts/ui/main/thing"))()


local gui = Library:create{
    Theme = Library.Themes.Dark
}

-- Tabs
local combat = gui:tab{
    Icon = "rbxassetid://6034996695",
    Name = "Combat"
}
local visuals = gui:tab{
    Icon = "rbxassetid://12290279208",
    Name = "Visuals"
}
local fovs = gui:tab{
    Icon = "rbxassetid://12290540099",
    Name = "FOV Settings"
}
local gmods = gui:tab{
    Icon = "rbxassetid://12290664177",
    Name = "Gun Mods"
}
local anti = gui:tab{
    Icon = "rbxassetid://12290746900",
    Name = "Anti Aim"
}
local PlrF = gui:tab{
    Icon = "rbxassetid://12291312976",
    Name = "Player Features"
}
local misc = gui:tab{
    Icon = "rbxassetid://12290990229",
    Name = "Miscellaneous"
}

-- Combat Shit
combat:button({
    Name = "Aimbot",
    Callback = function()
        dwUIS.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton2 then
				settings.Aiming = true
			end
		end)

		dwUIS.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton2 then
				settings.Aiming = false
			end
		end)

		dwRunService.RenderStepped:Connect(function()


			local dist = math.huge
			local closest_char = nil

			if settings.Aiming then

				for i,v in next, dwEntities:GetChildren() do 

					if v ~= dwLocalPlayer and
					v.Character and
					v.Character:FindFirstChild("HumanoidRootPart") and
					v.Character:FindFirstChild("Humanoid") and
					v.Character:FindFirstChild("Humanoid").Health > 0 then

						if settings.Aimbot_TeamCheck == true and
						v.Team ~= dwLocalPlayer.Team or
						settings.Aimbot_TeamCheck == false then

							local char = v.Character
							local char_part_pos, is_onscreen = dwCamera:WorldToViewportPoint(char[settings.Aimbot_AimPart].Position)

							if is_onscreen then

								local mag = (Vector2.new(dwMouse.X, dwMouse.Y) - Vector2.new(char_part_pos.X, char_part_pos.Y)).Magnitude

								if mag < dist and mag < settings.Aimbot_FOV_Radius then

									dist = mag
									closest_char = char

								end
							end
						end
					end
				end

				if closest_char ~= nil and
				closest_char:FindFirstChild("HumanoidRootPart") and
				closest_char:FindFirstChild("Humanoid") and
				closest_char:FindFirstChild("Humanoid").Health > 0 then

					dwCamera.CFrame = CFrame.new(dwCamera.CFrame.Position, closest_char[settings.Aimbot_AimPart].Position)
				end
			end
		end)
    end,
})
combat:button({
    Name = "Silent Aim",
    Callback = function()
        loadstring(game:HttpGet('https://pastebin.com/raw/EnSX9RiH'))()
    end,
})
combat:dropdown({
    Name = "Aim Part",
    StartingText = "Open me",
    Items = {
        "Head",
        "UpperTorso",
        "LowerTorso",
        "Random"
    },
    Description = "Picks where to aim",
    Callback = function(parts)
        local random_aimpart = aimParts[math.random(#aimParts)]
		if parts == "Random" then
			settings.Aimbot_AimPart = randomAimPart
		else
			settings.Aimbot_AimPart = parts
		end
    end,
})
combat:toggle{
    Name = "Teamcheck",
    Description = "Aim at just enemys or team",
    StartingState = true,
    Callback = function(tc)
        if tc == true then
			settings.Aimbot_TeamCheck = true
		elseif tc == false then
			settings.Aimbot_TeamCheck = false
		end
    end,
}

-- Visuals
visuals:button({
    Name = "Unnamed ESP",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua',true))()
    end,
})
visuals:toggle{
    Name = "Weapon Chams",
    Description = "Makes ur weapon glow",
    StartingState = false,
    Callback = function(value)
        WeaponChams = value
    end,
}
visuals:color_picker({
    Name = "Weapon Color",
    Style = Library.ColorPickerStyles.Legacy,
    Description = "Click to adjust weapon color",
    Callback = function(color3)
        WeaponChams_Color = color3
    end,
})
visuals:dropdown({
    Name = "Weapon Material",
    StartingText = "Open me",
    Items = {
        "Plastic",
        "ForceField",
        "Wood",
        "Grass"
    },
    Description = "Picks what Material ur gun will be",
    Callback = function(text)
        WeaponMaterial = text
    end,
})
visuals:toggle{
    Name = "Rainbow Chams",
    Description = "Makes ur gay",
    StartingState = false,
    Callback = function(value)
        RainbowChams = value
		if RainbowChams then
			UpdateRainbowChams()
		end
    end,
}

-- FOV Settings
fovs:slider{
    Name = "FOV Circle Radius",
    Description = "How big u want the circle to be",
    Max = 1000,
    Default = 200,
    Callback = function(fs)
        settings.Aimbot_FOV_Radius = fs
		fovcircle.Radius = settings.Aimbot_FOV_Radius
    end,
}
fovs:slider{
    Name = "FOV Circle Thickness",
    Description = "How thicc you want the circle to be",
    Max = 100,
    Default = 1,
    Callback = function(tness)
        fovcircle.Thickness = tness
    end,
}
fovs:toggle{
    Name = "FOV Circle Filled",
    Description = "Fill the circle",
    StartingState = false,
    Callback = function(fill)
        if fill == true then
			fovcircle.Filled = true
		elseif fill == false then
			fovcircle.Filled = false
        end
    end,
}
fovs:color_picker({
    Name = "Circle Color",
    Style = Library.ColorPickerStyles.Legacy,
    Description = "Click to adjust circle color",
    Callback = function(color)
        settings.Aimbot_FOV_Color = color
		fovcircle.Color = settings.Aimbot_FOV_Color
    end,
})

-- Gun Mods
gmods:button({
    Name = "Inf Ammo",
    Callback = function()
        while wait() do
			game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.ammocount.Value = 999
			game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.ammocount2.Value = 999
		end
    end,
})
gmods:button({
    Name = "Full Auto",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Dark-Scripts/Arsenal-Scripts/main/Full%20Auto'))()
    end,
})
gmods:button({
    Name = "No Recoil",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Dark-Scripts/Arsenal-Scripts/main/No%20Recoil'))()
    end,
})
gmods:button({
    Name = "No Bullet Spread",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Dark-Scripts/Arsenal-Scripts/main/No%20Spread'))()
    end,
})
gmods:button({
    Name = "No Reload",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Dark-Scripts/Arsenal-Scripts/main/No%20Reload'))()
    end,
})
gmods:button({
    Name = "Fire Rate",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Dark-Scripts/Arsenal-Scripts/main/FireRate'))()
    end,
})
gmods:button({
    Name = "Crits",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Dark-Scripts/Arsenal-Scripts/main/Crits'))()
    end,
})

-- Anti Aim
anti:toggle{
    Name = "Anti Aim Toggle",
    Description = "Toggles anti ain on or off",
    StartingState = false,
    Callback = function(value)
        AntiAim_Toggle = value
    end,
}
anti:toggle{
    Name = "Disable Animations",
    Description = "Disables animations",
    StartingState = false,
    Callback = function(value)
        NoAnims_Toggle = value
    end,
}
anti:dropdown({
    Name = "Pitch Type",
    StartingText = "Up",
    Items = {
        {"Up", 1},
        {"Down", 2},
        {"Zero", 3},
        {"Custom", 4}
    },
    Description = "",
    Callback = function(text)
        Pitch_Type = text
    end,
})
anti:slider{
    Name = "Pitch Value",
    Description = "",
    Min = -150,
    Max = 150,
    Default = 0,
    Callback = function(value)
		CustomPitch_Value = value / 100
	end,
}
anti:dropdown({
    Name = "Yaw Type",
    StartingText = "Open me",
    Items = {
        "Jitter",
        "Spin",
        "Back",
        "Custom"
    },
    Description = "",
    Callback = function(text)
        Yaw_Type = text
    end,
})
anti:slider{
    Name = "Spin Speed",
    Description = "",
    Max = 1000,
    Default = 0,
    Callback = function(value)
		AntiAim_Speed = value
	end,
}
anti:slider{
    Name = "Yaw Value",
    Description = "",
    Max = 360,
    Default = 0,
    Callback = function(value)
		CustomYaw_Value = value
	end,
}
-- Player Stuff
PlrF:slider{
    Name = "Walkspeed (Left Shift",
    Description = "Makes you go zoom",
    Min = 16,
    Max = 500,
    Default = 16,
    Callback = function(v)
		local Player = game:GetService'Players'.LocalPlayer;
		local UIS = game:GetService'UserInputService';
		UIS.InputBegan:connect(function(UserInput)
        	if UserInput.UserInputType == Enum.UserInputType.Keyboard and UserInput.KeyCode == Enum.KeyCode.LeftShift then
            	_G.Running = true
                	while wait() and _G.Running == true do
						game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v;
					end
        		end
			end)
		UIS.InputEnded:connect(function(UserInput)
        	if UserInput.UserInputType == Enum.UserInputType.Keyboard and UserInput.KeyCode == Enum.KeyCode.LeftShift then
                _G.Running = false
        		end
		end)
	end,
}
PlrF:button({
    Name = "Inf Jump",
    Callback = function()
        local InfJumpEnabled = true
		game:GetService("UserInputService").JumpRequest:connect(function()
			if InfJumpEnabled then
				game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
			else
				game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Seated")
			end
		end)
    end,
})
PlrF:toggle{
    Name = "Noclip",
    Description = "Makes you walk through walls",
    StartingState = false,
    Callback = function(noclip)
        if noclip == true then
			settings.isnoclipping = true
		else
			settings.isnoclipping = false
		end

		dwRunService.Stepped:Connect(function()
			if dwLocalPlayer.Character then
				if settings.isnoclipping == true then
					for i,v in pairs(dwLocalPlayer.Character:GetDescendants()) do
						if v:IsA("BasePart") then
							v.CanCollide = false
						end
					end
				elseif settings.isnoclipping == false then
					Stepped:Disconnect()
				end
			end
		end)
    end,
}

-- Misc
misc:button({
    Name = "FE Lagswitch (x to toggle on and off",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Dark-Scripts/Arsenal-Scripts/main/fe%20lagswitch", true))()
    end,
})
misc:button({
    Name = "Inf Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Dark-Scripts/Arsenal-Scripts/main/inf%20yield", true))()
    end,
})

-- While Shit
local function BulletTracer(ray)
 
	local mid = ray.Origin + ray.Direction/2
  
	if workspace.Camera:FindFirstChild("Arms") then
		if workspace.Camera.Arms:FindFirstChild("Bullet") then
			local pr = Instance.new("Part")
			pr.Parent = workspace
			pr.Anchored = true
			pr.CFrame = CFrame.new(mid, ray.Origin)
			pr.Size = Vector3.new(BulletTracer_Thickness, BulletTracer_Thickness, ray.Direction.Magnitude)
			pr.Color = BulletTracers_Color
			pr.Transparency = BulletTracers_Transparency
			pr.Material = Enum.Material.Neon
			print('Rayd')
			wait(3)
			pr:Destroy()
		end
	end
  
 end
  
  
 local function convert_rgb_to_vertex(c3)
	return Vector3.new(c3.R, c3.G, c3.B)
 end
 local mt = getrawmetatable(game)
 local oldNamecall = mt.__namecall
 local oldIndex = mt.__index
 if setreadonly then
	setreadonly(mt, false)
 else
	make_writeable(mt, true)
 end
 local namecallMethod = getnamecallmethod or get_namecall_method
 local newClose = newcclosure or function(f)
	return f
 end
 mt.__namecall = newClose(function(...)
	local method = namecallMethod()
	local args = {...}
  
	if method == "FindPartOnRayWithIgnoreList" then
		if SilentAim_Toggled then
			args[2] = Ray.new(workspace.CurrentCamera.CFrame.Position, (target[bodyname].CFrame.p - workspace.CurrentCamera.CFrame.Position).unit * 500)
		end
	elseif method == 'LoadAnimation' and tostring(args[2]) == 'RunForward' or tostring(args[2]) == 'RunBackward' or
		tostring(args[2]) == 'RunLeft' or tostring(args[2]) == 'RunRight' then
		if NoAnims_Toggle then
			args[2] = fakeanim
		end
	elseif method == 'FireServer' and tostring(args[1]) == "ControlTurn" then
		if AntiAim_Toggle then
			if Pitch_Type == "Custom" then
				args[2] = CustomPitch_Value
			elseif Pitch_Type == 'Down' then
				args[2] = -1.5
			elseif Pitch_Type == "Up" then
				args[2] = 1.5
			elseif Pitch_Type == "Zero" then
				args[2] = 0
			end
		end
	end
  
	return oldNamecall(unpack(args))
 end)
mt.__index = newcclosure(function(self, ...)
	local arg = {...}
  
	if isthirdperson then
		if arg[1] == 'CameraMode' then
			return Enum.CameraMode.Classic
		end
	end
  
  
	return oldIndex(self, ...)
end)
while true do

	if Visuals_Toggled then
 
		if NameTags_Toggled then
			if Teamcheck_Toggled then
				for I,V in pairs (game.Players:GetPlayers()) do
					if V ~= LP then
						if V.TeamColor ~= LP.TeamColor then
							if V.Character and V.Character:FindFirstChild("Head") then
								if V.Character.Head:FindFirstChild("TotallyNotNAMEESP") then
									V.Character.Head['TotallyNotNAMEESP'].TextLabel.TextColor3 = ChamsColor
								else
									local bbgui = Instance.new("BillboardGui",  V.Character['Head'])
									bbgui.Name = "TotallyNotNAMEESP"
									bbgui.AlwaysOnTop = true
									bbgui.StudsOffset = Vector3.new(0, 2, 0)
									bbgui.ClipsDescendants = false
									bbgui.Enabled = true
									bbgui.Size = UDim2.new(0, 200,0, 50)
  
									local boxha = Instance.new('TextLabel', bbgui)
									boxha.Size = UDim2.new(0, 200,0, 50)
									boxha.TextColor3 = ChamsColor
									boxha.Text = V.Name
									boxha.Font = Enum.Font.Code
									boxha.TextSize = 20
									boxha.BackgroundTransparency = 1
									boxha.BorderSizePixel = 0
									boxha.Visible = true
									boxha.Size = UDim2.new(0, 200,0, 50)
									boxha.TextWrapped = true
								end
							end
						elseif V.TeamColor == LP.TeamColor then
							if V.Character and V.Character:FindFirstChild("Head") then
								if V.Character.Head:FindFirstChild("TotallyNotNAMEESP") then
									V.Character.Head['TotallyNotNAMEESP']:Destroy()
								end
							end
						end
					end
				end
			else
				for I,V in pairs (game.Players:GetPlayers()) do
					if V ~= LP then
						if V.Character and V.Character:FindFirstChild("Head") then
							if V.Character.Head:FindFirstChild("TotallyNotNAMEESP") then
								V.Character.Head['TotallyNotNAMEESP'].TextLabel.TextColor3 = ChamsColor
							else
								local bbgui = Instance.new("BillboardGui",  V.Character['Head'])
								bbgui.Name = "TotallyNotNAMEESP"
								bbgui.AlwaysOnTop = true
								bbgui.StudsOffset = Vector3.new(0, 2, 0)
								bbgui.ClipsDescendants = false
								bbgui.Enabled = true
								bbgui.Size = UDim2.new(0, 200,0, 50)
								local boxha = Instance.new('TextLabel', bbgui)
								boxha.Size = UDim2.new(0, 200,0, 50)
								boxha.TextColor3 = ChamsColor
								boxha.Text = V.Name
								boxha.Font = Enum.Font.Code
								boxha.TextSize = 20
								boxha.BackgroundTransparency = 1
								boxha.BorderSizePixel = 0
								boxha.Visible = true
								boxha.Size = UDim2.new(0, 200,0, 50)
								boxha.TextWrapped = true
							end
						end
					end
				end
			end
		end
		if Chams_Toggled then
			if Teamcheck_Toggled then
				for I,V in pairs (game.Players:GetPlayers()) do
					if V ~= LP then
						if V.TeamColor ~= LP.TeamColor then
							if V.Character then
								for X,Z in pairs(V.Character:GetChildren()) do
									if Z.ClassName == 'MeshPart' or Z.ClassName == 'Part' and isInTable(BodyParts, Z.Name) then
										if Z:FindFirstChild("TotallyNotESP") then
											Z['TotallyNotESP'].Color3 = ChamsColor
										else
											if Z.Name == 'Head' then
												local headha = Instance.new("CylinderHandleAdornment",Z)
												headha.Adornee = Z
												headha.Transparency = 0
												headha.AlwaysOnTop = true
												headha.Name = "TotallyNotESP"
												headha.ZIndex = 1
												headha.Color3 = ChamsColor
												headha.Height = 1.3
											else
												local boxha = Instance.new("BoxHandleAdornment",Z)
												boxha.Adornee = Z
												boxha.Transparency = 0
												boxha.AlwaysOnTop = true
												boxha.Name = "TotallyNotESP"
												boxha.Size = Z.Size
												boxha.ZIndex = 1
												boxha.Color3 = ChamsColor
											end
										end
									end
								end
							end
						elseif V.TeamColor == LP.TeamColor then
							if V.Character then
								for X,Z in pairs(V.Character:GetChildren()) do
									if Z.ClassName == 'MeshPart' or Z.ClassName == 'Part' and isInTable(BodyParts, Z.Name) then
										if Z:FindFirstChild("TotallyNotESP") then
											Z['TotallyNotESP']:Destroy()
										end
									end
								end
							end
						end
					end
				end
			else
				for I,V in pairs (game.Players:GetPlayers()) do
					if V ~= LP then
						if V.Character then
							for X,Z in pairs(V.Character:GetChildren()) do
								if Z.ClassName == 'MeshPart' or Z.ClassName == 'Part' and isInTable(BodyParts, Z.Name) then
									if Z:FindFirstChild("TotallyNotESP") then
										Z['TotallyNotESP'].Color3 = ChamsColor
									else
										if Z.Name == 'Head' then
											local headha = Instance.new("CylinderHandleAdornment",Z)
											headha.Adornee = Z
											headha.Transparency = 0
											headha.AlwaysOnTop = true
											headha.Name = "TotallyNotESP"
											headha.ZIndex = 1
											headha.Color3 = ChamsColor
											headha.Height = 1.3
										else
											local boxha = Instance.new("BoxHandleAdornment",Z)
											boxha.Adornee = Z
											boxha.Transparency = 0
											boxha.AlwaysOnTop = true
											boxha.Name = "TotallyNotESP"
											boxha.Size = Z.Size
											boxha.ZIndex = 1
											boxha.Color3 = ChamsColor
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	if Chatspam_Toggled then
		if not ChatDebounce then
			spawn(function()
				ChatDebounce = true
				while ChatDebounce do
					if Chatspam_Type == 'NIGHTHUB' then
						game.ReplicatedStorage.Events.PlayerChatted:FireServer(NIGHTHUB_Chatspam[math.random(1, #NIGHTHUB_Chatspam)], false, false, false, true)
					elseif Chatspam_Type == 'Furry' then
						game.ReplicatedStorage.Events.PlayerChatted:FireServer(Furry_Chatspam[math.random(1, #Furry_Chatspam)], false, false, false, true)
					elseif Chatspam_Type == 'Swiss' then
						game.ReplicatedStorage.Events.PlayerChatted:FireServer(Swiss_Chatspam[math.random(1, #Swiss_Chatspam)], false, false, false, true)
					elseif Chatspam_Type == 'HvH' then
						game.ReplicatedStorage.Events.PlayerChatted:FireServer(HvH_Chatspam[math.random(1, #HvH_Chatspam)], false, false, false, true)
						elseif Chatspam_Type == 'China' then
						game.ReplicatedStorage.Events.PlayerChatted:FireServer(China_Chatspam[math.random(1, #China_Chatspam)], false, false, false, true)
					end
					wait(Chatspam_Wait)
					if not Chatspam_Toggled then
						ChatDebounce = false
						break
					end
				end
			end)
		end
	end

	if AntiAim_Toggle then
		if Yaw_Type == "Custom" then
			characterrotate(CFrame.new(CustomYaw_Value, 0, 0))
		elseif Yaw_Type == "Jitter" then
			if game.Players.LocalPlayer.Character then
				game.Players.LocalPlayer.Character:WaitForChild("Humanoid").AutoRotate = false
				local spin = Instance.new('BodyAngularVelocity', game.Players.LocalPlayer.Character:FindFirstChild('HumanoidRootPart'))
				spin.AngularVelocity = Vector3.new(0, math.random(-60000, 55000), 0)
				spin.MaxTorque = Vector3.new(0, 35000, 0)
				wait()
				spin:Destroy()
			end
		elseif Yaw_Type == "Spin" then
			if game.Players.LocalPlayer.Character then
				game.Players.LocalPlayer.Character:WaitForChild("Humanoid").AutoRotate = false
				local spin = Instance.new('BodyAngularVelocity', game.Players.LocalPlayer.Character:FindFirstChild('HumanoidRootPart'))
				spin.AngularVelocity = Vector3.new(0, AntiAim_Speed * 100, 0)
				spin.MaxTorque = Vector3.new(0, 23000, 0)
				wait()
				spin:Destroy()
			end
		elseif Yaw_Type == "Back" then
			characterrotate((workspace.CurrentCamera.CFrame * backrotation).p)
		end
	end

	if ArmChams then
		if not workspace.Camera:FindFirstChild("Arms") then
			wait()
		else
			for i,v in pairs(workspace.Camera.Arms:GetDescendants()) do
				if v.Name == 'Right Arm' or v.Name == 'Left Arm' then
					if v:IsA("BasePart") then
						v.Material = Enum.Material[ArmMaterial]
						v.Color = ArmChams_Color
					end
				elseif v:IsA("SpecialMesh") then
					if v.TextureId == '' then
						v.TextureId = 'rbxassetid://0'
						v.VertexColor = convert_rgb_to_vertex(ArmChams_Color)
					end
				elseif v.Name == 'L' or v.Name == 'R' then
					v:Destroy()
				end
			end
		end
	end

	if WeaponChams then
		if not workspace.Camera:FindFirstChild("Arms") then
			wait(1)
		else
			for i,v in pairs(workspace.Camera.Arms:GetDescendants()) do
				if v:IsA("MeshPart") then
					v.Material = Enum.Material[WeaponMaterial]
					v.Color = WeaponChams_Color
				end
			end
		end
	end

	wait(1/30)
end
