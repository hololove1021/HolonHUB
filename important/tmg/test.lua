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
mainButton.Text = "送信" 
mainButton.TextColor3 = Color3.new(1, 1, 1)
mainButton.Font = Enum.Font.SourceSansBold
mainButton.TextSize = 20
mainButton.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainButton

-- === 送信関数 ===
local function sendMessage()
	-- TextChatInputBarConfigurationを経由して送るのが最も安全で重複しにくいです
	local chatInputBar = TextChatService:FindFirstChildOfClass("TextChatInputBarConfiguration")
	local generalChannel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
	
	if generalChannel then
		generalChannel:SendAsync(responseMessage)
	end
end

-- 起動時に一度だけ実行（ロード時間を考慮して少し長めに待機）
task.delay(2, function()
	sendMessage()
end)

-- ボタンクリック時
mainButton.MouseButton1Click:Connect(function()
	sendMessage()
end)
