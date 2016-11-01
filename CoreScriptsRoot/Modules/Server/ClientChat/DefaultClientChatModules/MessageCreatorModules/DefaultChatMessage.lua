--	// FileName: DefaultChatMessage.lua
--	// Written by: TheGamer101
--	// Description: Create a message label for a standard chat message.

local MESSAGE_TYPE = "Message"

local clientChatModules = script.Parent.Parent
local ChatSettings = require(clientChatModules:WaitForChild("ChatSettings"))
local util = require(script.Parent:WaitForChild("Util"))

function CreateMessageLabel(messageData)

	local fromSpeaker = messageData.FromSpeaker
	local message = messageData.Message

	local extraData = messageData.ExtraData or {}
	local useFont = extraData.Font or ChatSettings.DefaultFont
	local useTextSize = extraData.TextSize or ChatSettings.ChatWindowTextSize
	local useNameColor = extraData.NameColor or ChatSettings.DefaultNameColor

	local useChatColor = extraData.ChatColor or ChatSettings.DefaultMessageColor

	local formatUseName = string.format("[%s]:", fromSpeaker)
	local speakerNameSize = util:GetStringTextBounds(formatUseName, useFont, useTextSize)
	local numNeededSpaces = util:GetNumberOfSpaces(formatUseName, useFont, useTextSize) + 1
	local numNeededUnderscore = util:GetNumberOfUnderscores(message, useFont, useTextSize)

	local tempMessage = string.rep(" ", numNeededSpaces) .. string.rep("_", numNeededUnderscore)
	if messageData.IsFiltered then
		tempMessage = string.rep(" ", numNeededSpaces) .. messageData.Message
	end
	local BaseFrame, BaseMessage = util:CreateBaseMessage(tempMessage, useFont, useTextSize, useChatColor)
	local NameButton = util:AddNameButtonToBaseMessage(BaseMessage, useNameColor, formatUseName)

	local function UpdateTextFunction(newMessageObject)
		BaseMessage.Text = string.rep(" ", numNeededSpaces) .. newMessageObject.Message
	end

	local function GetHeightFunction()
		return util:GetMessageHeight(BaseMessage, BaseFrame)
	end

	local AnimParams = {}
	AnimParams.Text_TargetTransparency = 0
	AnimParams.Text_CurrentTransparency = 0
	AnimParams.Text_NormalizedExptValue = 1
	AnimParams.TextStroke_TargetTransparency = 0.75
	AnimParams.TextStroke_CurrentTransparency = 0.75
	AnimParams.TextStroke_NormalizedExptValue = 1

	local function FadeInFunction(duration, CurveUtil)
		AnimParams.Text_TargetTransparency = 0
		AnimParams.TextStroke_TargetTransparency = 0.75
		AnimParams.Text_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(duration)
		AnimParams.TextStroke_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(duration)
	end

	local function FadeOutFunction(duration, CurveUtil)
		AnimParams.Text_TargetTransparency = 1
		AnimParams.TextStroke_TargetTransparency = 1
		AnimParams.Text_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(duration)
		AnimParams.TextStroke_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(duration)
	end

	local function AnimGuiObjects()
		BaseMessage.TextTransparency = AnimParams.Text_CurrentTransparency
		NameButton.TextTransparency = AnimParams.Text_CurrentTransparency

		BaseMessage.TextStrokeTransparency = AnimParams.TextStroke_CurrentTransparency
		NameButton.TextStrokeTransparency = AnimParams.TextStroke_CurrentTransparency
	end

	local function UpdateAnimFunction(dtScale, CurveUtil)
		AnimParams.Text_CurrentTransparency = CurveUtil:Expt(
				AnimParams.Text_CurrentTransparency,
				AnimParams.Text_TargetTransparency,
				AnimParams.Text_NormalizedExptValue,
				dtScale
		)
		AnimParams.TextStroke_CurrentTransparency = CurveUtil:Expt(
				AnimParams.TextStroke_CurrentTransparency,
				AnimParams.TextStroke_TargetTransparency,
				AnimParams.TextStroke_NormalizedExptValue,
				dtScale
		)

		AnimGuiObjects()
	end

	return {
		[util.KEY_BASE_FRAME] = BaseFrame,
		[util.KEY_UPDATE_TEXT_FUNC] = UpdateTextFunction,
		[util.KEY_GET_HEIGHT] = GetHeightFunction,
		[util.KEY_FADE_IN] = FadeInFunction,
		[util.KEY_FADE_OUT] = FadeOutFunction,
		[util.KEY_UPDATE_ANIMATION] = UpdateAnimFunction
	}
end

return {
	[util.KEY_MESSAGE_TYPE] = MESSAGE_TYPE,
	[util.KEY_CREATOR_FUNCTION] = CreateMessageLabel
}
