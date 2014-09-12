--[[
	// FileName: ChatScript.LUA
	// Written by: SolarCrane
	// Description: Code for lua side chat on ROBLOX.
]]

--[[ CONSTANTS ]]
local FORCE_CHAT_GUI = true
local USE_PLAYER_GUI_TESTING = true
local ADMIN_LIST =
{
	'Rbadam', 'Adamintygum', 'androidtest', 'RobloxFrenchie', 'JacsksSmirkingRevenge', 'LindaPepita', 'vaiobot', 'Goddessnoob', 'effward', 'Blockhaak', 'Drewbda', '659223', 'Tone', 'fasterbuilder19', 'Zeuxcg', 'concol2',
	'ReeseMcBlox', 'Jeditkacheff', 'whkm1980', 'ChiefJustus', 'Ellissar', 'Arbolito', 'Noob007', 'Limon', 'cmed', 'hawkington', 'Tabemono', 'autoconfig', 'BrightEyes', 'Monsterinc3D', 'MrDoomBringer', 'IsolatedEvent',
	'CountOnConnor', 'Scubasomething', 'OnlyTwentyCharacters', 'LordRugdumph', 'bellavour', 'david.baszucki', 'ibanez2189', 'Sorcus', 'DeeAna00', 'TheLorekt', 'NiqueMonster', 'Thorasaur', 'MSE6', 'CorgiParade', 'Varia',
	'4runningwolves', 'pulmoesflor', 'Olive71', 'groundcontroll2', 'GuruKrish', 'Countvelcro', 'IltaLumi', 'juanjuan23', 'OstrichSized', 'jackintheblox', 'SlingshotJunkie', 'gordonrox24', 'sharpnine', 'Motornerve', 'Motornerve',
	'watchmedogood', 'jmargh', 'JayKorean', 'Foyle', 'MajorTom4321', 'Shedletsky', 'supernovacaine', 'FFJosh', 'Sickenedmonkey', 'Doughtless', 'KBUX', 'totallynothere', 'ErzaStar', 'Keith', 'Chro', 'SolarCrane', 'GloriousSalt',
	'UristMcSparks', 'ITOlaurEN', 'Malcomso', 'Stickmasterluke', 'windlight13', 'yumyumcheerios', 'Stravant', 'ByteMe', 'imaginationsensation', 'Matt.Dusek', 'Mcrtest', 'Seranok', 'maxvee', 'Coatp0cketninja', 'Screenme',
	'b1tsh1ft', 'Totbl', 'Aquabot8', 'grossinger', 'Merely', 'CDakkar', 'Siekiera', 'Robloxkidsaccount', 'flotsamthespork', 'Soggoth', 'Phil', 'OrcaSparkles', 'skullgoblin', 'RickROSStheB0SS', 'ArgonPirate', 'NobleDragon',
	'Squidcod', 'Raeglyn', 'RobloxSai', 'Briarroze', 'hawkeyebandit', 'DapperBuffalo', 'Vukota', 'swiftstone', 'Gemlocker', 'Loopylens', 'Tarabyte', 'Timobius', 'Tobotrobot', 'Foster008', 'Twberg', 'DarthVaden', 'Khanovich',
	'CodeWriter', 'VladTheFirst', 'Phaedre', 'gorroth', 'SphinxShen', 'jynj1984', 'RoboYZ', 'ZodiacZak', 'superman205', 'ConvexRumbler', 'mpliner476', 'geekndestroy', 'glewis17', 'BuckerooB',
}
local CHAT_COLORS =
{
	BrickColor.new("Bright red"),
	BrickColor.new("Bright blue"),
	BrickColor.new("Earth green"),
	BrickColor.new("Bright violet"),
	BrickColor.new("Bright orange"),
	BrickColor.new("Bright yellow"),
	BrickColor.new("Light reddish violet"),
	BrickColor.new("Brick yellow"),
}
--[[ END OF CONSTANTS ]]

--[[ SERVICES ]]
local CoreGuiService = Game:GetService('CoreGui')
local PlayersService = Game:GetService('Players')
local DebrisService = Game:GetService('Debris')
local GuiService = Game:GetService('GuiService')
local InputService = Game:GetService('UserInputService')
local StarterGui = Game:GetService('StarterGui')
local RobloxGui = CoreGuiService:WaitForChild('RobloxGui')
--[[ END OF SERVICES ]]

--[[ SCRIPT VARIABLES ]]

-- I am not fond of waiting at the top of the script here...
while PlayersService.LocalPlayer == nil do PlayersService.ChildAdded:wait() end
local Player = PlayersService.LocalPlayer
-- GuiRoot will act as the top-node for parenting GUIs
local GuiRoot = RobloxGui
if USE_PLAYER_GUI_TESTING then
	GuiRoot = Instance.new("ScreenGui")
	GuiRoot.Name = "RobloxGui"
	GuiRoot.Parent = Player:WaitForChild('PlayerGui')
end
--[[ END OF SCRIPT VARIABLES ]]

local Util = {}
do
	-- Check if we are running on a touch device
	function Util.IsTouchDevice()
		local touchEnabled = false
		pcall(function() touchEnabled = InputService.TouchEnabled end)
		return touchEnabled
	end

	function Util.IsPhone()
		if RobloxGui.AbsoluteSize.Y < 600 then
			return true
		end
		return false
	end

	function Util.Create(instanceType)
		return function(data)
			local obj = Instance.new(instanceType)
			for k, v in pairs(data) do
				if type(k) == 'number' then
					v.Parent = obj
				else
					obj[k] = v
				end
			end
			return obj
		end
	end

	function Util.Signal()
		local sig = {}

		local mSignaler = Instance.new('BindableEvent')

		local mArgData = nil
		local mArgDataCount = nil

		function sig:fire(...)
			mArgData = {...}
			mArgDataCount = select('#', ...)
			mSignaler:Fire()
		end

		function sig:connect(f)
			if not f then error("connect(nil)", 2) end
			return mSignaler.Event:connect(function()
				f(unpack(mArgData, 1, mArgDataCount))
			end)
		end

		function sig:wait()
			mSignaler.Event:wait()
			assert(mArgData, "Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.")
			return unpack(mArgData, 1, mArgDataCount)
		end

		return sig
	end

	function Util.DisconnectEvent(conn)
		if conn then
			conn:disconnect()
		end
		return nil
	end

	function Util.SetGUIInsetBounds(x, y)
		local success, _ = pcall(function() GuiService:SetGlobalGuiInset(0, x, 0, y) end)
		if not success then
			pcall(function() GuiService:SetGlobalSizeOffsetPixel(-x, -y) end) -- Legacy GUI-offset function
		end
	end

	function Util.GetPlayerByName(playerName)
		-- O(n), may be faster if I store a reverse hash from the players list; can't trust FindFirstChild in PlayersService because anything can be parented to there.
		for _, player in pairs(PlayersService:GetPlayers()) do
			if player.Name == playerName then
				return player
			end
		end
		return nil -- Found no player
	end

	-- This is a memo-izing function
	local testLabel = Instance.new('TextLabel')
	testLabel.TextWrapped = true;
	testLabel.Position = UDim2.new(1,0,1,0)
	testLabel.RobloxLocked = true
	testLabel.Parent = GuiRoot -- Note: We have to parent it to check TextBounds
	-- The TextSizeCache table looks like this Text->Font->sizeBounds->FontSize
	local TextSizeCache = {}
	function Util.GetStringTextBounds(text, font, fontSize, sizeBounds)
		-- If no sizeBounds are specified use some huge number
		sizeBounds = sizeBounds or false
		if not TextSizeCache[text] then
			TextSizeCache[text] = {}
		end
		if not TextSizeCache[text][font] then
			TextSizeCache[text][font] = {}
		end
		if not TextSizeCache[text][font][sizeBounds] then
			TextSizeCache[text][font][sizeBounds] = {}
		end
		if not TextSizeCache[text][font][sizeBounds][fontSize] then
			testLabel.Text = text
			testLabel.Font = font
			testLabel.FontSize = fontSize
			if sizeBounds then
				testLabel.TextWrapped = true;
				testLabel.Size = sizeBounds
			else
				testLabel.TextWrapped = false;
			end
			TextSizeCache[text][font][sizeBounds][fontSize] = testLabel.TextBounds
		end
		return TextSizeCache[text][font][sizeBounds][fontSize]
	end
end

local function CreateChatMessage(playerChatType, sendingPlayer, chattedMessage, receivingPlayer)
	local this = {}

	this.PlayerChatType = playerChatType
	this.SendingPlayer = sendingPlayer
	this.RawMessageContent = chattedMessage
	this.ReceivingPlayer = receivingPlayer

	function this:FormatMessage()
		local result = ""
		if this.RawMessageContent then
			local message = this.RawMessageContent
			if string.sub(message, 1, 1) == '%' then
				result = '(TEAM) ' .. string.sub(message, 2, #message)
			elseif string.sub(message, 1, 6) == '(TEAM)' then
				result = '(TEAM) ' .. string.sub(message, 7, #message)
			end
			if PlayersService.ClassicChat then
				if string.sub(message, 1, 3) == '/e ' or string.sub(message, 1, 7) == '/emote ' then
					-- don't do anything right now
				elseif FORCE_CHAT_GUI or Player.ChatMode == Enum.ChatMode.TextAndMenu then
					result = message--Chat:UpdateChat(player, message)
				elseif Player.ChatMode == Enum.ChatMode.Menu and string.sub(message, 1, 3) == '/sc' then
					result = "SafeChat Response"
					--Chat:UpdateChat(player, message)
				end
			end
		end
		return result
	end

	function this:CreateMessageGuiElement()
		local playerNameDisplayText = "[" .. (this.SendingPlayer and this.SendingPlayer.Name or "") .. "]"
		local playerNameSize = Util.GetStringTextBounds(playerNameDisplayText, Enum.Font.SourceSans, Enum.FontSize.Size12)
		local chatMessageDisplayText = this:FormatMessage()
		local chatMessageSize = Util.GetStringTextBounds(chatMessageDisplayText, Enum.Font.SourceSans, Enum.FontSize.Size12, UDim2.new(0, 400 - 5 - playerNameSize.X, 0, 1000))

		local messageContainer = Util.Create'Frame'
		{
			Name = 'MessageContainer';
			Position = UDim2.new(0, 0, 0, 0);
			ZIndex = 1;
			BackgroundColor3 = Color3.new(0, 0, 0);
			BackgroundTransparency = 1;
			RobloxLocked = true;
		};
			local userNameButton = Util.Create'TextButton'
			{
				Name = 'PlayerName';
				BackgroundTransparency = 1;
				ZIndex = 2;
				Text = playerNameDisplayText;
				TextColor3 = Color3.new(1, 1, 0.9);
				Position = UDim2.new(0, 0, 0, 0);
				TextXAlignment = Enum.TextXAlignment.Left;
				TextYAlignment = Enum.TextYAlignment.Top;
				FontSize = Enum.FontSize.Size12;
				Font = Enum.Font.SourceSans;
				Size = UDim2.new(0, playerNameSize.X, 0, playerNameSize.Y);
				RobloxLocked = true;
				Parent = messageContainer
			}

			local chatMessage = Util.Create'TextLabel'
			{
				Name = 'ChatMessage';
				Position = UDim2.new(0, playerNameSize.X + 5, 0, 0);
				Size = UDim2.new(1, -playerNameSize.X - 5, 0, chatMessageSize.Y);
				Text = chatMessageDisplayText;
				ZIndex = 1;
				BackgroundColor3 = Color3.new(0, 0, 0);
				BackgroundTransparency = 1;
				TextXAlignment = Enum.TextXAlignment.Left;
				TextYAlignment = Enum.TextYAlignment.Top;
				TextWrapped = true;
				TextColor3 = Color3.new(1, 1, 1);
				FontSize = Enum.FontSize.Size12;
				Font = Enum.Font.SourceSans;
				RobloxLocked = true;
				Parent = messageContainer;
			};
			chatMessage.Size = chatMessage.Size + UDim2.new(0, 0, 0, chatMessage.TextBounds.Y);

		messageContainer.Size = UDim2.new(1, 0, 0, math.max(chatMessage.Size.Y.Offset, userNameButton.Size.Y.Offset));
		return messageContainer
	end

	function this:IsVisible()
		if this.PlayerChatType == Enum.PlayerChatType.All or
				this.PlayerChatType == Enum.PlayerChatType.Team or
				(this.PlayerChatType == Enum.PlayerChatType.Whisper and this.ReceivingPlayer == Player) then
			return true
		end
		return false
	end

	return this
end

local function CreateChatBarWidget(settings)
	local this = {}

	-- MessageModes: {All, Team, Whisper}
	this.MessageMode = "All"
	this.TargetWhisperPlayer = nil
	this.Settings = settings

	function this:OnChatBarTextChanged()
		if this.ChatBar then
			local chatBarText = this:GetChatBarText()
			local start, finish, playerName = string.find(chatBarText, "^/w (%w+) ")
			if not start then -- if the first match didn't work, try this alternative form
				start, finish, playerName = string.find(chatBarText, "^/whisper (%w+) ")
			end
			if start and finish and playerName then
				local targetPlayer = Util.GetPlayerByName(playerName)
				if targetPlayer then --and targetPlayer ~= Player then
					this.TargetWhisperPlayer = targetPlayer
					this:SetMessageMode("Whisper")
					this:SetChatBarText("")
				end
			elseif string.sub(chatBarText, 1, 2) == "% " or string.sub(chatBarText, 1, 7) == "(TEAM) " then
				this:SetMessageMode("Team")
				this:SetChatBarText("")
			elseif string.sub(chatBarText, 1, 3) == "/a " or string.sub(chatBarText, 1, 5) == "/all " then
				this:SetMessageMode("All")
				this:SetChatBarText("")
			end
		end
	end

	function this:GetChatBarText()
		return this.ChatBar and this.ChatBar.Text or ""
	end

	function this:SetChatBarText(newText)
		if this.ChatBar then
			this.ChatBar.Text = newText
		end
	end

	function this:GetMessageMode()
		return this.MessageMode
	end

	function this:SetMessageMode(newMessageMode)
		if this.MessageMode ~= newMessageMode then
			this.MessageMode = newMessageMode
			if this.ChatModeText then
				if newMessageMode == 'Whisper' then
					-- TODO: also update this when they change players to whisper to
					local chatRecipientText = "[" .. (this.TargetWhisperPlayer and this.TargetWhisperPlayer.Name or "") .. "]"
					local chatRecipientTextBounds = Util.GetStringTextBounds(chatRecipientText, this.ChatModeText.Font, this.ChatModeText.FontSize)

					this.ChatModeText.TextColor3 = this.Settings.WhisperTextColor
					this.ChatModeText.Text = chatRecipientText
					this.ChatModeText.Size = UDim2.new(0, chatRecipientTextBounds.X, 1, 0)
				elseif newMessageMode == 'Team' then
					local chatTeamText = '[Team]'
					local chatTeamTextBounds = Util.GetStringTextBounds(chatTeamText, this.ChatModeText.Font, this.ChatModeText.FontSize)

					this.ChatModeText.TextColor3 = this.Settings.TeamTextColor
					this.ChatModeText.Text = "[Team]"
					this.ChatModeText.Size = UDim2.new(0, chatTeamTextBounds.X, 1, 0)
				else
					this.ChatModeText.Text = ""
					this.ChatModeText.Size = UDim2.new(0, 0, 1, 0)
				end
				if this.ChatBar then
					local offset = this.ChatModeText.Size.X.Offset
					this.ChatBar.Size = UDim2.new(1, -offset - 5, 1, 0)
					this.ChatBar.Position = UDim2.new(0, offset + 5, 0, 0)
				end
			end
		end
	end

	function this:FocusChatBar()
		if this.ChatBar then
			this.ChatBar:CaptureFocus()
			if self.ClickToChatButton then
				self.ClickToChatButton.Visible = false
			end
			if this.ChatModeText then
				this.ChatModeText.Visible = true
			end
			this.ChatBarChangedConn = Util.DisconnectEvent(this.ChatBarChangedConn)
			this.ChatBarChangedConn = this.ChatBar.Changed:connect(function(prop)
				if prop == "Text" then
					this:OnChatBarTextChanged()
				end
			end)
		end
	end

	function this:OnChatBarFocusLost(enterPressed)
		if self.ChatBar then
			local cText = this:GetChatBarText()
			if enterPressed and cText ~= "" then
				local currentMessageMode = this:GetMessageMode()
				-- {All, Team, Whisper}
				if currentMessageMode == 'Team' then
					pcall(function() PlayersService:TeamChat(cText) end)
				elseif currentMessageMode == 'Whisper' then
					if this.TargetWhisperPlayer then
						pcall(function() PlayersService:WhisperChat(cText, this.TargetWhisperPlayer) end)
					else
						print("Somehow we are trying to whisper to a player not in the game anymore:" , this.TargetWhisperPlayer)
					end
				elseif currentMessageMode == 'All' then
					pcall(function() PlayersService:Chat(cText) end)
				else
					Spawn(function() error("ChatScript: Unknown Message Mode of " .. tostring(currentMessageMode)) end)
				end
			end
			self.ChatBar.Text = ""
		end
		if self.ClickToChatButton then
			self.ClickToChatButton.Visible = true
		end
		if this.ChatModeText then
			this.ChatModeText.Visible = false
		end
		this.ChatBarChangedConn = Util.DisconnectEvent(this.ChatBarChangedConn)
	end

	local function CreateChatBar()
		local chatBarContainer = Util.Create'Frame'
		{
			Name = 'ChatBarContainer';
			Position = UDim2.new(0, 0, 1, 0);
			Size = UDim2.new(1, 0, 0, 20);
			ZIndex = 1;
			BackgroundColor3 = Color3.new(0, 0, 0);
			BackgroundTransparency = 0.25;
			RobloxLocked = true;
		};
			local clickToChatButton = Util.Create'TextButton'
			{
				Name = 'ClickToChat';
				Size = UDim2.new(1, 0, 1, 0);
				BackgroundTransparency = 1;
				ZIndex = 2;
				Text = 'To chat click here or press "/" key';
				TextColor3 = Color3.new(1, 1, 0.9);
				TextXAlignment = Enum.TextXAlignment.Left;
				Font = Enum.Font.SourceSans;
				FontSize = Enum.FontSize.Size12;
				RobloxLocked = true;
				Parent = chatBarContainer;
			}
			local chatBar = Util.Create'TextBox'
			{
				Name = 'ChatBar';
				Size = UDim2.new(1, 0, 1, 0);
				Text = "";
				ZIndex = 1;
				BackgroundColor3 = Color3.new(0, 0, 0);
				BackgroundTransparency = 1;
				TextXAlignment = Enum.TextXAlignment.Left;
				TextColor3 = Color3.new(1, 1, 1);
				Font = Enum.Font.SourceSans;
				FontSize = Enum.FontSize.Size12;
				ClearTextOnFocus = false;
				RobloxLocked = true;
				Parent = chatBarContainer;
			}
			local chatModeText = Util.Create'TextButton'
			{
				Name = 'ChatModeText';
				Size = UDim2.new(1, 0, 1, 0);
				BackgroundTransparency = 1;
				ZIndex = 2;
				Text = '';
				TextColor3 = this.Settings.WhisperTextColor;
				TextXAlignment = Enum.TextXAlignment.Left;
				Font = Enum.Font.SourceSans;
				FontSize = Enum.FontSize.Size12;
				RobloxLocked = true;
				Parent = chatBarContainer;
			}

		-- ChatHotKey is '/'
		GuiService:AddSpecialKey(Enum.SpecialKey.ChatHotkey)
		GuiService.SpecialKeyPressed:connect(function(key)
			if key == Enum.SpecialKey.ChatHotkey then
				this:FocusChatBar()
			end
		end)

		this.ChatBarContainer = chatBarContainer
		this.ClickToChatButton = clickToChatButton
		this.ChatBar = chatBar
		this.ChatModeText = chatModeText
		this.ChatBarContainer.Parent = GuiRoot

		this.ClickToChatButton.MouseButton1Click:connect(function() this:FocusChatBar() end)
		this.ChatBar.FocusLost:connect(function(...) this:OnChatBarFocusLost(...) end)

		Util.SetGUIInsetBounds(0, 20)
	end

	CreateChatBar()
	return this
end

local function CreateChatWindowWidget(settings)
	local this = {}
	this.Settings = settings

	function this:AddChatMessage(chatMessage)
		local isScrolledDown = this:IsScrolledDown()

		local ySize = this.MessageContainer.Size.Y.Offset
		local chatMessageElement = chatMessage:CreateMessageGuiElement()
		local chatMessageElementYSize = UDim2.new(0, 0, 0, chatMessageElement.Size.Y.Offset)

		chatMessageElement.Position = chatMessageElement.Position + UDim2.new(0, 0, 0, ySize)
		chatMessageElement.Parent = this.MessageContainer
		this.MessageContainer.Size = this.MessageContainer.Size + chatMessageElementYSize

		if isScrolledDown then
			this.ScrollingFrame.CanvasPosition = Vector2.new(0, math.max(0, this.ScrollingFrame.CanvasSize.Y.Offset - this.ScrollingFrame.AbsoluteSize.Y))
		else
			-- Raise unread message alert!
		end
	end

	function this:IsScrolledDown()
		local yCanvasSize = this.ScrollingFrame.CanvasSize.Y.Offset
		local yContainerSize = this.ScrollingFrame.AbsoluteSize.Y
		local yScrolledPosition = this.ScrollingFrame.CanvasPosition.Y
		-- Check if the messages are at the bottom
		return yCanvasSize < yContainerSize or
		       yCanvasSize - yScrolledPosition == yContainerSize
	end

	local function CreateChatWindow()
		local container = Util.Create'Frame'
		{
			Name = 'ChatWindowContainer';
			 -- Height is a multiple of chat message height, maybe keep this value at 150 and move that padding into the messageContainer
			Size = UDim2.new(0, 400, 0, 156);
			Position = UDim2.new(0, 20, 0, 50);
			ZIndex = 1;
			BackgroundColor3 = Color3.new(0, 0, 0);
			BackgroundTransparency = 1;
			RobloxLocked = true;
		};
			local scrollingFrame = Util.Create'ScrollingFrame'
			{
				Name = 'ChatWindow';
				Size = UDim2.new(1, 0, 1, 0);
				CanvasSize = UDim2.new(1, 0, 0, 0);
				Position = UDim2.new(0, 0, 0, 0);
				ZIndex = 1;
				BackgroundColor3 = Color3.new(0, 0, 0);
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				ScrollingEnabled = false;
				RobloxLocked = true;
				Parent = container;
			};
				local messageContainer = Util.Create'Frame'
				{
					Name = 'MessageContainer';
					Size = UDim2.new(1, 0, 0, 0);
					Position = UDim2.new(0, 0, 0, 0);
					ZIndex = 1;
					BackgroundColor3 = Color3.new(0, 0, 0);
					BackgroundTransparency = 1;
					RobloxLocked = true;
					Parent = scrollingFrame
				};

		-- This is some trickery we are doing to make the first chat messages appear at the bottom and go towards the top.
		local function OnChatWindowResize(prop)
			if prop == 'AbsoluteSize' then
				scrollingFrame.CanvasSize = messageContainer.Size
				if messageContainer.AbsoluteSize.Y < scrollingFrame.AbsoluteSize.Y then
					messageContainer.Position = UDim2.new(0, 0, 1, -scrollingFrame.CanvasSize.Y.Offset)
				else
					messageContainer.Position = UDim2.new(0, 0, 0, 0)
				end
			end
		end

		messageContainer.Changed:connect(OnChatWindowResize)
		scrollingFrame.Changed:connect(OnChatWindowResize)



		this.ChatContainer = container
		this.ScrollingFrame = scrollingFrame
		this.MessageContainer = messageContainer
		this.ChatContainer.Parent = GuiRoot

		-- TODO: Finish this move hover over code and background darkening code...
		this.MouseEnterFrameConn = this.ChatContainer.MouseEnter:connect(function()
			local lastMoveTime = tick()
			this.MouseMoveFrameConn = Util.DisconnectEvent(this.MouseMoveFrameConn)
			this.MouseMoveFrameConn = this.ChatContainer.MouseMoved:connect(function()
				local thisMove = tick()
				lastMoveTime = thisMove
				wait(1.5)
				if lastMoveTime == thisMove then
					this.ChatContainer.BackgroundTransparency = 0.65
				end
			end)
		end)

		this.MouseLeaveFrameConn = this.ChatContainer.MouseLeave:connect(function()
			this.MouseLeaveFrameConn = Util.DisconnectEvent(this.MouseLeaveFrameConn)
			this.MouseMoveFrameConn = Util.DisconnectEvent(this.MouseMoveFrameConn)
		end)
	end

	CreateChatWindow()

	return this
end


local function CreateChat()
	local this = {}

	this.MessageHistory = {}
	this.Settings =
	{
		WhisperTextColor = Color3.new(77/255, 139/255, 255/255);
		TeamTextColor = Color3.new(230/255, 207/255, 0);
	}

	function this:OnCoreGuiChanged(coreGuiType, enabled)
		if coreGuiType == Enum.CoreGuiType.Chat or coreGuiType == Enum.CoreGuiType.All then
			if not Util:IsTouchDevice() then
				if enabled then
					-- Reserve bottom 20 pixels for our chat bar
					Util.SetGUIInsetBounds(0, 20)
				else
					Util.SetGUIInsetBounds(0, 0)
				end
			end
		end
	end

	-- This event has 4 callback arguments
	-- Enum.PlayerChatType.{All|Team|Whisper}, chatPlayer, message, targetPlayer
	function this:OnPlayerChatted(playerChatType, sendingPlayer, chattedMessage, receivingPlayer)
		local newChatMessage = CreateChatMessage(playerChatType, sendingPlayer, chattedMessage, receivingPlayer)
		table.insert(this.MessageHistory, newChatMessage)

		if this.ChatWindowWidget then
			this.ChatWindowWidget:AddChatMessage(newChatMessage)
		end
	end

	function this:OnPlayerAdded()
		this.PlayerChattedConn = Util.DisconnectEvent(this.PlayerChattedConn)
		this.PlayerChattedConn = PlayersService.PlayerChatted:connect(function(...)
			this:OnPlayerChatted(...)
		end)
	end

	function this:CreateTouchDeviceChatButton()
		return Util.Create'ImageButton'
		{
			Name = 'TouchDeviceChatButton';
			Size = UDim2.new(0, 128, 0, 32);
			Position = UDim2.new(0, 88, 0, 0);
			BackgroundTransparency = 1.0;
			Image = 'http://www.roblox.com/asset/?id=97078724';
			RobloxLocked = true;
		};
	end

	function this:PrintHelp()
		--TODO: make this show up in gui and not output
		print("Help")
		print("Chat Commands:")
		print("Whisper Chat: /w [Player] or /whisper [Player]")
		print("Team Chat: % ")
		print("All Chat: /a or /all")
	end

	function this:CreateGUI()
		local mobileChatButton = this:CreateTouchDeviceChatButton()
		mobileChatButton.Parent = GuiRoot

		local success, useLuaChat = pcall(function() return GuiService.UseLuaChat end)
		if (success and useLuaChat) or FORCE_CHAT_GUI then
			-- TODO: eventually we will make multiple chat window frames
			-- Settings is a table, which makes it a pointing and is kosher to pass by reference
			this.ChatWindowWidget = CreateChatWindowWidget(this.Settings)
			this.ChatBarWidget = CreateChatBarWidget(this.Settings)
		end
	end

	function this:Initialize()
		pcall(function()
			this:CoreGuiChanged(Enum.CoreGuiType.Chat, StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat))
			this.CoreGuiChangedConn = Util.DisconnectEvent(this.CoreGuiChangedConn)
			this.CoreGuiChangedConn = StarterGui.CoreGuiChangedSignal:connect(
				function(coreGuiType,enabled)
					this:CoreGuiChanged(coreGuiType,enabled)
				end)
		end)

		this:OnPlayerAdded()
		-- Upsettingly, it seems everytime a player is added, you have to redo the connection
		-- NOTE: PlayerAdded only fires on the server, hence ChildAdded is used here
		PlayersService.ChildAdded:connect(function()
			this:OnPlayerAdded()
		end)

		this:CreateGUI()
	end

	return this
end


-- Run the script
do
	local ChatInstance = CreateChat()
	ChatInstance:Initialize()
end
