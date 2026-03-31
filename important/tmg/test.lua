local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- === 設定 ===
local responseMessage = "Holon FTAP [ TEST HUB ] loaded. Made by ほろん."

-- === UIの作成 ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoChatControl"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainButton = Instance.new("TextButton")
mainButton.Size = UDim2.new(0, 150, 0, 50)
mainButton.Position = UDim2.new(0.5, -75, 0, 50)
mainButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
mainButton.Text = "送信完了" -- 起動時に送るので表記を変更
mainButton.TextColor3 = Color3.new(1, 1, 1)
mainButton.Font = Enum.Font.SourceSansBold
mainButton.TextSize = 20
mainButton.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainButton

-- === 実行処理 ===
local function sendInitialChat()
	-- チャットチャネルが準備できるまで少し待機
	local channel = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")
	
	if channel then
		task.wait(1) -- ロード完了待ち
		channel:SendAsync(responseMessage)
	end
end

-- 起動時に実行
task.spawn(sendInitialChat)

-- ボタンを押した時にも再送できるように設定
mainButton.MouseButton1Click:Connect(function()
	local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
	if channel then
		channel:SendAsync(responseMessage)
	end
end)
