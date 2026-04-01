local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")

-- === 設定 ===
local responseMessage = "Holon FTAP [ TEST HUB ] loaded. Made by ほろん."
local scriptUrl = "https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/language/hub-jp.lua"

-- === 送信関数 ===
local function sendMessage()
	-- RBXGeneralチャンネルを取得して送信
	local textChannels = TextChatService:FindFirstChild("TextChannels")
	if textChannels then
		local generalChannel = textChannels:FindFirstChild("RBXGeneral")
		if generalChannel then
			generalChannel:SendAsync(responseMessage)
		end
	end
end

-- === メイン処理 ===
task.delay(2, function()
	-- チャットメッセージの送信
	sendMessage()
	
	-- 外部スクリプトの実行
	local success, err = pcall(function()
		loadstring(game:HttpGet(scriptUrl))()
	end)
	
	if not success then
		warn("スクリプトの読み込みに失敗しました: " .. tostring(err))
	end
end)
