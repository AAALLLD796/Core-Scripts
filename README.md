print("Welcome, User")
print("Loaded Assets 32ms")
print("V2 UNLOCKED")

local ScreenGui = Instance.new("ScreenGui")
local main = Instance.new("Frame")
local title = Instance.new("TextLabel")
local ClickTP = Instance.new("TextButton")
local InfiniteYield = Instance.new("TextButton")
local InsaneReach = Instance.new("TextButton")
local FPS = Instance.new("TextLabel")

--Properties:

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

main.Name = "main"
main.Parent = ScreenGui
main.BackgroundColor3 = Color3.fromRGB(71, 71, 71)
main.Position = UDim2.new(0.0389294401, 0, 0.538767397, 0)
main.Size = UDim2.new(0, 257, 0, 144)
main.Draggable = true
main.Active = true
main.Visible = true

title.Name = "title"
title.Parent = main
title.BackgroundColor3 = Color3.fromRGB(71, 71, 71)
title.BorderColor3 = Color3.fromRGB(71, 71, 71)
title.Size = UDim2.new(0, 257, 0, 16)
title.Font = Enum.Font.SourceSansBold
title.Text = "Fling Things And People V2"
title.TextColor3 = Color3.fromRGB(0, 0, 0)
title.TextSize = 14.000

ClickTP.Name = "ClickTP"
ClickTP.Parent = main
ClickTP.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ClickTP.Position = UDim2.new(0, 0, 0.111111112, 0)
ClickTP.Size = UDim2.new(0, 92, 0, 114)
ClickTP.Font = Enum.Font.SourceSansBold
ClickTP.Text = "CTRL-Click TP"
ClickTP.TextColor3 = Color3.fromRGB(255, 255, 255)
ClickTP.TextSize = 14.000
ClickTP.TextWrapped = true
ClickTP.MouseButton1Down:connect(function()
	local Plr = game:GetService("Players").LocalPlayer local Mouse = Plr:GetMouse()

	Mouse.Button1Down:connect( function() if not game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then return end if not Mouse.Target then return end Plr.Character:MoveTo(Mouse.Hit.p) end )
end)

InfiniteYield.Name = "Infinite Yield"
InfiniteYield.Parent = main
InfiniteYield.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
InfiniteYield.Position = UDim2.new(0.357976645, 0, 0.111111112, 0)
InfiniteYield.Size = UDim2.new(0, 83, 0, 114)
InfiniteYield.Font = Enum.Font.SourceSansBold
InfiniteYield.Text = "Infinite Yield"
InfiniteYield.TextColor3 = Color3.fromRGB(255, 255, 255)
InfiniteYield.TextSize = 14.000
InfiniteYield.TextWrapped = true
InfiniteYield.MouseButton1Down:connect(function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

InsaneReach.Name = "Insane Reach"
InsaneReach.Parent = main
InsaneReach.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
InsaneReach.Position = UDim2.new(0.680933833, 0, 0.111111112, 0)
InsaneReach.Size = UDim2.new(0, 82, 0, 114)
InsaneReach.Font = Enum.Font.SourceSansBold
InsaneReach.Text = "Insane Reach"
InsaneReach.TextColor3 = Color3.fromRGB(255, 255, 255)
InsaneReach.TextSize = 12.000
InsaneReach.TextWrapped = true
InsaneReach.MouseButton1Down:connect(function()
	--[[ Variables ]]
	local PS = game:GetService("Players")
	local LocalPlayer = PS.LocalPlayer
	local GameMt = getrawmetatable(game)
	setreadonly(GameMt, false)
	local OldIndex = GameMt.__index

	GameMt.__index = function(Self, Key)
		if not checkcaller() and Self then
			if Key == "WalkSpeed" then
				return 16
			elseif Key == "JumpPower" then
				return 24
			end
		end

		return OldIndex(Self, Key)
	end

	LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed = 28

	function Int()
		for i,v in pairs(debug.getregistry()) do

			if type(v) == "function" and not is_synapse_function(v) then
				local Values = debug.getupvalues(v)
				for a,b in pairs(Values) do
					if type(b) == "number" and b == 20 then
						debug.setupvalue(v, a, 30)
					end
				end

				local Constants = debug.getconstants(v)
				for Number,Value in pairs(Constants) do
					if type(Value) == "number" then
						if Value == 100 then
							debug.setconstant(v, Number, 1000)
							print("Set new Magnitude limit!")
						end
						if Value == 750 then
							debug.setconstant(v, Number, 1350)
							print("Set new throw limit!")
						end
					end
				end
			end

		end

		spawn(function()
			while wait() do
				if LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
					LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").JumpPower = 24
					LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").WalkSpeed = 28
				elseif not LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
					break
				end
			end
		end)

	end

	Int()

	LocalPlayer.CharacterAdded:Connect(function()
		repeat wait() until LocalPlayer.Character
		repeat wait() until LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
		repeat wait() until LocalPlayer.Character:FindFirstChild("GrabbingScript")
		Int()
	end)

	print("Better reach and faster speed loaded!")
end)

FPS.Name = "FPS"
FPS.Parent = main
FPS.BackgroundColor3 = Color3.fromRGB(71, 71, 71)
FPS.Position = UDim2.new(0, 0, 0.902777791, 0)
FPS.Size = UDim2.new(0, 257, 0, 14)
FPS.Font = Enum.Font.SourceSansBold
FPS.Text = "FPS: N/A"
FPS.TextColor3 = Color3.fromRGB(0, 0, 0)
FPS.TextSize = 14.000

-- Scripts:

local function UQZOSH_fake_script() -- FPS.LocalScript 
	local script = Instance.new('LocalScript', FPS)

	local frames = 0
	
	game:GetService("RunService").RenderStepped:Connect(function()
		frames += 1
	end)
	
	while wait(1) do
		script.Parent.Text = "FPS: " .. frames
		frames = 0
	end
end
coroutine.wrap(UQZOSH_fake_script)()