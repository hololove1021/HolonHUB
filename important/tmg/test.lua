local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")

-- === 設定 ===
local responseMessage = "Holon FTAP [ TEST HUB ] loaded. Made by ほろん."

-- === 送信関数 ===
local function sendMessage()
	-- RBXGeneralチャンネルを取得して送信
	local generalChannel = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")
	
	if generalChannel then
		generalChannel:SendAsync(responseMessage)
	end
end

-- 起動時に一度だけ実行（ロード時間を考慮して2秒待機）
task.delay(2, function()
	sendMessage()
end)
