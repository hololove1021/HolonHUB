local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- test.luaから持ってきたイベント定義
local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents")
local SetNetworkOwner = GrabEvents:WaitForChild("SetNetworkOwner")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- 作者情報の定義
local AuthorName = "holon_calm"
local RobloxID = "najayou777"
local DetailIcon = "rbxassetid://7733964719"

-- リンク集を表示する共通関数（認証画面とメイン画面で使い回せます）
local function AddDetailContent(Tab)
    Tab:AddButton({
        Name = "Copiar y lanzar versión en inglés",
        Callback = function()
            setclipboard("loadstring(game:HttpGet(\"https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/hub-en.lua\"))()")
            task.spawn(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/hub-en.lua"))()
            end)
        end
    })

    Tab:AddButton({
        Name = "TikTok",
        Callback = function()
            setclipboard("https://www.tiktok.com/@holon_calm")
            OrionLib:MakeNotification({Name = "Enlace", Content = "Enlace de TikTok copiado al portapapeles", Time = 3})
        end
    })
    
    Tab:AddButton({
        Name = "Discord",
        Callback = function()
            setclipboard("https://discord.gg/EHBXqgZZYN")
            OrionLib:MakeNotification({Name = "Enlace", Content = "Enlace de invitación de Discord copiado al portapapeles", Time = 3})
        end
    })
    
    Tab:AddButton({
        Name = "YouTube",
        Callback = function()
            setclipboard("https://www.youtube.com/@Holoncalm")
            OrionLib:MakeNotification({Name = "Enlace", Content = "Enlace de YouTube copiado al portapapeles", Time = 3})
        end
    })
    Tab:AddLabel("Autor: " .. AuthorName)
    Tab:AddLabel("ID de Roblox: " .. RobloxID)
end

-- BodyMover作成関数
local function createBodyMovers(part)
    -- 既存のMoverがあれば削除
    for _, child in ipairs(part:GetChildren()) do
        if child:IsA("BodyPosition") or child:IsA("BodyGyro") then
            child:Destroy()
        end
    end

    local bodyPosition = Instance.new("BodyPosition")
    local bodyGyro = Instance.new("BodyGyro")

    bodyPosition.P = 20000
    bodyPosition.D = 500
    bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyPosition.Parent = part

    bodyGyro.P = 3000
    bodyGyro.D = 100
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.Parent = part

    return bodyPosition, bodyGyro
end

local function getActiveTargetMain()
    if targetMainName == "" then return LocalPlayer end
    -- 名前から「今現在」のプレイヤーを探し直す
    return Players:FindFirstChild(targetMainName) or LocalPlayer
end

-- プロット位置を自動取得する関数
local function getMyPlotCFrame()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then 
        warn("Holon HUB: Carpeta Plots no encontrada en Workspace")
        return nil 
    end

    local myName = LocalPlayer.Name

    for _, plot in ipairs(plots:GetChildren()) do
        -- 教えていただいた構造: Plot○ -> PlotSign -> ThisPlotsOwners -> Value -> Data -> Value
        local plotSign = plot:FindFirstChild("PlotSign")
        local ownerValObj = plotSign and plotSign:FindFirstChild("ThisPlotsOwners")
        local valueFolder = ownerValObj and ownerValObj:FindFirstChild("Value")
        local dataObj = valueFolder and valueFolder:FindFirstChild("Data")

        -- StringValue である Data.Value の中身をチェック
        if dataObj and dataObj:IsA("StringValue") then
            if dataObj.Value == myName then
                print("Holon HUB: ¡Parcela encontrada! Objetivo:", plot.Name)
                return plot:GetPivot() -- プロットの中心座標を返す
            end
        end
    end
    
    warn("Holon HUB: Tu parcela no fue encontrada.")
    return nil
end

-- ■ 1. getMusicKeyboard 関数の修正 (おもちゃリスト同様の探索ロジックに変更)
local function getMusicKeyboard()
    local myName = LocalPlayer.Name
    
    -- 1. SpawnedInToys から探す
    local spawnedToys = Workspace:FindFirstChild(myName .. "SpawnedInToys")
    if spawnedToys then
        local kb = spawnedToys:FindFirstChild("MusicKeyboard")
        if kb then return kb end
    end

    -- 2. Plots から探す
    local plots = Workspace:FindFirstChild("Plots")
    local plotItems = Workspace:FindFirstChild("PlotItems")

    if plots and plotItems then
        for _, plot in ipairs(plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            local ownerObj = sign and (sign:FindFirstChild("ThisPlotsOwners") or sign:FindFirstChild("Owner"))
            if ownerObj then
                local val = ownerObj:FindFirstChild("Value") or ownerObj
                local data = val:FindFirstChild("Data") or val
                if (data:IsA("StringValue") and data.Value == myName) then
                    -- PlotItemsフォルダ内を検索 (startEffectを参考)
                    local myPlotItems = plotItems:FindFirstChild(plot.Name)
                    if myPlotItems then
                        local kb = myPlotItems:FindFirstChild("MusicKeyboard")
                        if kb then return kb end
                    end
                    -- 念のためBuild内も検索
                    local build = plot:FindFirstChild("Build")
                    local kb = build and build:FindFirstChild("MusicKeyboard")
                    if kb then return kb end
                end
            end
        end
    end

    -- 3. Workspace全体から所有権のある MusicKeyboard を探す
    for _, item in ipairs(Workspace:GetChildren()) do
        if item.Name == "MusicKeyboard" and item:IsA("Model") then
            local ownerValue = item:FindFirstChild("Owner") or item:FindFirstChild("PartOwner")
            if ownerValue and ownerValue:IsA("StringValue") and ownerValue.Value == myName then
                return item
            end
        end
    end

    return nil
end

-- ピアノ機能用の変数 (関数の前に定義して、関数から見えるようにする)
local pianoEnabled = false
local pianoFollowEnabled = true
local selectedSongFile = nil
local selectedSongData = nil
local pianoKeyboard = nil
local isPlayingSong = false
local pianoUpdateConnection = nil
local lastPianoCF = nil
local pianoOriginalCollisions = {}

-- ピアノを腰の前に追従させる関数
local function setupPianoFollow()
    -- pianoKeyboardがnilなら再取得
    if not pianoKeyboard then pianoKeyboard = getMusicKeyboard() end
    if not pianoKeyboard then return end
    
    -- 既に実行中の場合は何もしない
    if pianoUpdateConnection then return end

    -- ★修正: Mainパーツを探す (なければPrimaryPart)
    local mainPart = pianoKeyboard:FindFirstChild("Main", true) or pianoKeyboard.PrimaryPart
    if not mainPart then 
        warn("Holon HUB: Parte principal del piano no encontrada")
        return 
    end
    print("Holon HUB: Iniciando configuración del piano:", pianoKeyboard.Name)
    
    -- startEffect同様の初期設定
    for _, part in ipairs(pianoKeyboard:GetDescendants()) do
        if part:IsA("BasePart") then
            -- ★追加: 元の当たり判定を保存
            if pianoOriginalCollisions[part] == nil then
                pianoOriginalCollisions[part] = part.CanCollide
            end
            part.CanCollide = false
            part.CanTouch = false
            part.CanQuery = false
            part.Anchored = false
            part.Massless = true
            part.AssemblyLinearVelocity = Vector3.zero
            part.AssemblyAngularVelocity = Vector3.zero
            -- 所有権を取得 (startEffectの方式に合わせる)
            pcall(function() part:SetNetworkOwner(LocalPlayer) end)
        end
    end
    
    local pp = mainPart
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local offset = CFrame.new(0, -1.5, -2) * CFrame.Angles(0, math.rad(180), 0)
        pp.CFrame = root.CFrame * offset
    end
    
    local a0 = Instance.new("Attachment", pp)
    local ap = Instance.new("AlignPosition", pp)
    ap.Attachment0 = a0
    ap.Mode = Enum.PositionAlignmentMode.OneAttachment
    ap.MaxForce = 1e9
    ap.Responsiveness = 200
    local ao = Instance.new("AlignOrientation", pp)
    ao.Attachment0 = a0
    ao.Mode = Enum.OrientationAlignmentMode.OneAttachment
    ao.MaxTorque = 1e9
    ao.Responsiveness = 200
    
    pianoUpdateConnection = RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        if not pianoKeyboard or not pianoKeyboard.Parent then 
            stopPiano()
            return 
        end

        -- 所有権維持 (startEffectの方式に合わせる)
        if math.random() < 0.05 then
             pcall(function() pp:SetNetworkOwner(LocalPlayer) end)
        end

        local baseCF = root.CFrame
        local offset = CFrame.new(0, -1.5, -2) * CFrame.Angles(0, math.rad(180), 0)
        local targetCF = baseCF * offset
        ap.Position = targetCF.Position
        ao.CFrame = targetCF
    end)
    print("Holon HUB: Seguimiento del piano iniciado")
end

-- ピアノを停止・解放する関数
local function stopPiano()
    if pianoUpdateConnection then
        pianoUpdateConnection:Disconnect()
        pianoUpdateConnection = nil
    end
    if pianoKeyboard and pianoKeyboard.Parent then
        local pp = pianoKeyboard:FindFirstChild("Main", true) or pianoKeyboard.PrimaryPart
        if not pp then return end
        -- AlignPosition/Orientation を削除
        for _, child in ipairs(pp:GetChildren()) do
            if child:IsA("Attachment") or child:IsA("AlignPosition") or child:IsA("AlignOrientation") then
                child:Destroy()
            end
        end
    end
    
    -- ★追加: 当たり判定を元に戻す
    for part, canCollide in pairs(pianoOriginalCollisions) do
        if part and part.Parent then
            part.CanCollide = canCollide
        end
    end
    pianoOriginalCollisions = {} -- テーブルをクリア

    print("Holon HUB: Seguimiento del piano detenido")
end

-- ピアノのキーマッピング（画像の配置に対応）
local pianoKeyMap = {
    -- 白鍵
    ["1"] = "Key1C", ["2"] = "Key1D", ["3"] = "Key1E", ["4"] = "Key1F", 
    ["5"] = "Key1G", ["6"] = "Key1A", ["7"] = "Key1B", ["8"] = "Key2C",
    ["9"] = "Key2D", ["0"] = "Key2E", ["q"] = "Key2F", ["w"] = "Key2G",
    ["e"] = "Key2A", ["r"] = "Key2B", ["t"] = "Key3C",
    
    -- 黒鍵
    ["f"] = "Key1Csharp", ["g"] = "Key1Dsharp", ["h"] = "Key1Fsharp",
    ["j"] = "Key1Gsharp", ["k"] = "Key1Asharp", ["l"] = "Key2Csharp",
    ["z"] = "Key2Dsharp", ["x"] = "Key2Fsharp", ["c"] = "Key2Gsharp",
    ["v"] = "Key2Asharp"
}

-- 1. 鍵盤を叩く関数
local function pressPianoKey(keyName)
    -- 毎回直接 MusicKeyboard を探しに行く
    local targetKeyboard = getMusicKeyboard()
    
    -- 見つからなければ終了
    if not targetKeyboard then return end

    local key = targetKeyboard:FindFirstChild(keyName, true)
    if key and key:IsA("BasePart") then
        -- ネットワークオーナーの設定（サーバーへ通知）
        SetNetworkOwner:FireServer(key, key.CFrame)
        
        -- 指定の待機時間
        task.wait(0.15)
    end
end

-- 2. JSON再生関数
local function playSongFromJSON(jsonData)
    if isPlayingSong then return end
    
    local songData
    local success, err = pcall(function()
        -- 文字列ならデコード、テーブルならそのまま使う
        if type(jsonData) == "string" then
            return HttpService:JSONDecode(jsonData)
        else
            return jsonData
        end
    end)
    
    if not success or type(err) ~= "table" then
        warn("Error al cargar datos JSON")
        return
    end
    songData = err

    isPlayingSong = true
    print("Iniciando interpretación: " .. #songData .. " notas")
    
    task.spawn(function()
        -- 演奏開始前に一度だけピアノを探す
        if not pianoKeyboard then pianoKeyboard = getMusicKeyboard() end
        
        for i, note in ipairs(songData) do
            -- ボタンで「停止」を押したときだけ止まるようにする
            if not isPlayingSong then break end
            
            local rawKey = tostring(note.key)
            -- JSONのキーが "Key" で始まる場合は変換せずそのまま使う（誤変換防止）
            local keyName = rawKey
            if not string.match(rawKey, "^Key") then
                keyName = pianoKeyMap[rawKey] or rawKey
            end
            
            local delayTime = note.delay or 0.1
            
            -- テストと同じ仕組みで叩く
            task.spawn(function()
                pressPianoKey(keyName)
            end)
            
            -- 次の音まで待機
            task.wait(delayTime)
        end
        
        isPlayingSong = false
        print("Interpretación finalizada")
    end)
end

-- 曲の再生を停止
local function stopSong()
    isPlayingSong = false
end

--------------------------------------------------------------------------------
-- [データ定義] ベクターパス / 形状データ
--------------------------------------------------------------------------------
local Paths = {
    -- アルファベット (A-Z, Space) の簡易ストロークデータ
    Alpha = {
        ["A"]={Vector2.new(0,0),Vector2.new(1,2),Vector2.new(2,0),Vector2.new(1.5,1),Vector2.new(0.5,1)},
        ["B"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(1.5,2),Vector2.new(1.5,1),Vector2.new(0,1),Vector2.new(1.5,1),Vector2.new(1.5,0),Vector2.new(0,0)},
        ["C"]={Vector2.new(2,2),Vector2.new(0,2),Vector2.new(0,0),Vector2.new(2,0)},
        ["D"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(1.5,1.5),Vector2.new(1.5,0.5),Vector2.new(0,0)},
        ["E"]={Vector2.new(2,2),Vector2.new(0,2),Vector2.new(0,1),Vector2.new(1.5,1),Vector2.new(0,1),Vector2.new(0,0),Vector2.new(2,0)},
        ["F"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(2,2),Vector2.new(0,2),Vector2.new(0,1),Vector2.new(1.5,1)},
        ["G"]={Vector2.new(2,2),Vector2.new(0,2),Vector2.new(0,0),Vector2.new(2,0),Vector2.new(2,1),Vector2.new(1,1)},
        ["H"]={Vector2.new(0,2),Vector2.new(0,0),Vector2.new(0,1),Vector2.new(2,1),Vector2.new(2,2),Vector2.new(2,0)},
        ["I"]={Vector2.new(0,2),Vector2.new(2,2),Vector2.new(1,2),Vector2.new(1,0),Vector2.new(0,0),Vector2.new(2,0)},
        ["J"]={Vector2.new(0,0.5),Vector2.new(1,0),Vector2.new(2,0.5),Vector2.new(2,2)},
        ["K"]={Vector2.new(0,2),Vector2.new(0,0),Vector2.new(0,1),Vector2.new(2,2),Vector2.new(0,1),Vector2.new(2,0)},
        ["L"]={Vector2.new(0,2),Vector2.new(0,0),Vector2.new(2,0)},
        ["M"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(1,1),Vector2.new(2,2),Vector2.new(2,0)},
        ["N"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(2,0),Vector2.new(2,2)},
        ["O"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(2,2),Vector2.new(2,0),Vector2.new(0,0)},
        ["P"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(2,2),Vector2.new(2,1),Vector2.new(0,1)},
        ["Q"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(2,2),Vector2.new(2,0),Vector2.new(0,0),Vector2.new(1,0.5),Vector2.new(2,-0.5)},
        ["R"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(2,2),Vector2.new(2,1),Vector2.new(0,1),Vector2.new(2,0)},
        ["S"]={Vector2.new(2,2),Vector2.new(0,2),Vector2.new(0,1),Vector2.new(2,1),Vector2.new(2,0),Vector2.new(0,0)},
        ["T"]={Vector2.new(0,2),Vector2.new(2,2),Vector2.new(1,2),Vector2.new(1,0)},
        ["U"]={Vector2.new(0,2),Vector2.new(0,0),Vector2.new(2,0),Vector2.new(2,2)},
        ["V"]={Vector2.new(0,2),Vector2.new(1,0),Vector2.new(2,2)},
        ["W"]={Vector2.new(0,2),Vector2.new(0.5,0),Vector2.new(1,1),Vector2.new(1.5,0),Vector2.new(2,2)},
        ["X"]={Vector2.new(0,2),Vector2.new(2,0),Vector2.new(1,1),Vector2.new(0,0),Vector2.new(2,2)},
        ["Y"]={Vector2.new(0,2),Vector2.new(1,1),Vector2.new(2,2),Vector2.new(1,1),Vector2.new(1,0)},
        ["Z"]={Vector2.new(0,2),Vector2.new(2,2),Vector2.new(0,0),Vector2.new(2,0)},
        [" "]={Vector2.new(0,0), Vector2.new(0,0)}
    },
    -- マカバ (Merkaba) 立体頂点
    Merkaba = { 
        Vector3.new(1,1,1),Vector3.new(-1,-1,1),Vector3.new(-1,1,-1),Vector3.new(1,-1,-1),
        Vector3.new(1,1,1),Vector3.new(-1,-1,-1),Vector3.new(1,1,-1),Vector3.new(1,-1,1),
        Vector3.new(-1,1,1),Vector3.new(-1,-1,-1) 
    },
    -- 五芒星
    Star = (function() local t={}; for i=0,5 do local a=math.rad(i*144+90); table.insert(t, Vector2.new(math.cos(a),math.sin(a))) end; return t end)(),
    -- 円
    Circle = (function() local t={}; for i=0,20 do local a=math.rad(i*18); table.insert(t, Vector2.new(math.cos(a),math.sin(a))) end; return t end)(),
    MagicCircle2 = (function()
        local t = {}
        -- 外側の大きな円
        for i = 0, 36 do
            local a = math.rad(i * 10)
            table.insert(t, Vector2.new(math.cos(a) * 2, math.sin(a) * 2))
        end
        -- 中間の円
        for i = 0, 24 do
            local a = math.rad(i * 15)
            table.insert(t, Vector2.new(math.cos(a) * 1.5, math.sin(a) * 1.5))
        end
        -- 内側の円
        for i = 0, 18 do
            local a = math.rad(i * 20)
            table.insert(t, Vector2.new(math.cos(a), math.sin(a)))
        end
        return t
    end)(),
    
    MagicCircle3 = (function()
        local t = {}
        -- 多重円構造
        for layer = 1, 5 do
            local radius = 2.5 - (layer * 0.4)
            local points = 12 + (layer * 4)
            for i = 0, points do
                local a = math.rad((360 / points) * i)
                table.insert(t, Vector2.new(math.cos(a) * radius, math.sin(a) * radius))
            end
        end
        return t
    end)(),
}

--------------------------------------------------------------------------------
-- [コンフィグ & 変数管理]
--------------------------------------------------------------------------------
local defaultConfig = {
    Wing = { Size = 30, Gap = 3.0, Speed = 6, Height = 0.5, Back = 0, Joints = 3, V_Angle = 0, Tilt = 0, Strength = 15, RootFixed = true }, -- RootFixedを追加
    Heart = { Size = 8, Speed = 2, Height = 5, Back = 2 },
    Star = { Size = 10, Speed = 2, Height = 5, Back = 0 },
    Vortex = { Size = 12, Speed = 3, Height = 0, Back = 0 },
    Sphere = { Size = 30, Speed = 30, Height = 5, Back = 0 },
    Rotate = { Size = 15, Speed = 6, Height = 7, Back = 0 },
    Pet = { Size = 8, Speed = 2, Height = 4, Back = 12, Count = 2, Joints = 3, Gap = 13 },
    Text = { Size = 10, Speed = 5, Height = 6, Back = 2, Content = "HELLO", Mirror = false },
    MagicCircle = { Size = 12, Speed = 2, Height = -3, Back = 0 },
    MagicCircle2 = { Size = 15, Speed = 1, Height = -2, Back = 0, Layers = 3 },
    MagicCircle3 = { Size = 20, Speed = 0.5, Height = 5, Back = 0, Complexity = 5 },
    FloatStone = { Size = 10, Speed = 2, Height = 2, Back = 0, Chaos = false },
    Merkaba = { Size = 8, Speed = 2, Height = 7, Back = 0 },
    Cube = { Size = 5, Speed = 1, Height = 5, Back = 0 },
    MirrorPlayer = { Size = 30, Speed = 10, Height = 50, Back = 0, Scale = 1, EdgeSpacing = 1 },
    Beam = { Size = 60, Speed = 50, Height = 0.5, Back = 0, Count = 8 },
    BackGuard = { Size = 10, Speed = 2, Height = 2, Back = 15 },
    Combined = {Mode1 = "Wing", Mode2 = "Merkaba", Mode1Count = 15, Mode2Count = 15 },
    AnimSpeed = 1.0,
    PlotReturn = { Enabled = false, Interval = 30, PlotCFrame = nil},
    Global = { MaxToys = 30 },
}

-- Deep Copy Helper
local function deepCopy(target)
    local copy = {}
    for k, v in pairs(target) do copy[k] = (type(v) == "table") and deepCopy(v) or v end
    return copy
end

local selectedItemName = "Todos los juguetes" 
local detectedItems = {}

local cfg = deepCopy(defaultConfig)
local isEnabled, currentMode, combinedActive = false, "Wing", false
local followPlayer = true
local lastBaseCF = nil
local targetMain, targetSub = LocalPlayer, LocalPlayer
local GLOBAL_ANGLE, autoWidth = -90, true
local activeToys = {}        -- {A0, A1, AP, AO, Part}
local originalCollisions = {} -- {Part: Boolean}
local updateConnection = nil
local isReturningToPlot = false -- Plot帰還中のフラグ（重要）

local espCache = {}
local espCfg = { Enabled = false, Names = true, Tracers = false, Hitbox = false, HitboxSize = 10, ESPColor = Color3.new(1, 0, 0), TargetOnly = false }

-- プレイヤー設定用変数
local walkSpeed = 16
local jumpPower = 25
local infiniteJump = false
local useWalkSpeed = false
local useJumpPower = false
local antiExplosion = false
local noclip = false
local antiFire = false
local antiGrab = false

--------------------------------------------------------------------------------
-- [計算ロジック] 各モードの座標計算
--------------------------------------------------------------------------------
local function getPositionForMode(mode, i, count, time)
    local c = cfg[mode] or cfg.Wing
    
    -- iは1からcountまで。比率を計算
    local ratio = (i-1) / (count > 1 and count-1 or 1)
    
    if mode == "Wing" then
    local side, idx, totalSide

    if combinedActive then
        -- 【合体モード】
        -- i は全体の通し番号(1,2,3,4...)なので、そのまま奇数/偶数で分ける
        side = (i % 2 == 1) and -1 or 1 -- 1->左(-1), 2->右(1)
        idx = math.ceil(i / 2)          -- 1,2番目は1段目、3,4番目は2段目...
        totalSide = math.ceil(count / 2)
    else
        -- 【単体モード】
        -- 自分のパーツ内での順番通りに並べる
        side = (i % 2 == 1) and -1 or 1
        idx = math.ceil(i / 2)
        totalSide = math.ceil(count / 2)
    end

    -- 以降の計算は共通
    local distRatio = idx / math.max(1, totalSide)
    
    local flapPhase = time * c.Speed
    if c.Joints > 0 then
        flapPhase = flapPhase - (idx * (0.5 / math.max(1, c.Joints)))
    end

    local flap = math.sin(flapPhase) * c.Strength
    if c.RootFixed then
        flap = flap * distRatio
    end

    local horizontalOffset = c.Gap + (c.Size * distRatio)
    local pos = Vector3.new(horizontalOffset * side, flap, 0)
    
    local rotCF = CFrame.Angles(
        math.rad(c.Tilt), 
        math.rad(c.V_Angle * side), 
        0
    )
    
    return (rotCF * pos) + Vector3.new(0, c.Height, c.Back)
        
    elseif mode == "Heart" then
        local t = (ratio * math.pi * 2) + time * c.Speed
        local x = 16 * math.sin(t)^3
        local y = 13 * math.cos(t) - 5 * math.cos(2*t) - 2 * math.cos(3*t) - math.cos(4*t)
        return Vector3.new(x * c.Size * 0.1, y * c.Size * 0.1 + c.Height, c.Back)

    elseif mode == "Star" then
        -- 綺麗な五芒星を描くためのロジック（直線補間）
        local totalPoints = 10 -- 5つの頂点 + 5つの谷
        -- アニメーション進行度
        local cycle = (time * c.Speed * 0.2 + ratio) % 1
        local currentStep = cycle * totalPoints
        
        local idx1 = math.floor(currentStep)
        local idx2 = (idx1 + 1) % totalPoints
        local alpha = currentStep % 1 -- 2点間のどこにいるか

        -- 星の頂点座標を計算するローカル関数
        local function getStarPoint(i)
            -- 36度ずつ回転、+90度で頂点を真上に
            local theta = math.rad(i * 36 + 90) 
            -- 偶数は外側(Size)、奇数は内側(Size * 0.382 -> 黄金比に近い鋭さ)
            local r = (i % 2 == 0) and c.Size or (c.Size * 0.382)
            -- Xを反転させると時計回り/反時計回りが調整可能（ここではそのまま）
            return Vector2.new(-math.cos(theta) * r, math.sin(theta) * r)
        end

        local p1 = getStarPoint(idx1)
        local p2 = getStarPoint(idx2)
        
        -- 丸みを消すため、計算した2点間を直線で結ぶ(Lerp)
        local p = p1:Lerp(p2, alpha)

        -- Heartモードと同じ向き（垂直）にする
        -- X=横幅, Y=高さ(縦幅), Z=奥行き(固定)
        return Vector3.new(p.X, p.Y + c.Height, c.Back)
        
    elseif mode == "Vortex" then
        -- 平らな渦
        local spiral = (i / count) * math.pi * 4 + time * c.Speed
        local dist = (i / count) * c.Size
        
        local x = math.cos(spiral) * dist
        local z = math.sin(spiral) * dist
        
        return Vector3.new(x, c.Height, z + c.Back)
        
    elseif mode == "Sphere" then
        -- 球体配置
        local phi = math.acos(-1 + (2 * i) / count)
        local theta = math.sqrt(count * math.pi) * phi + time * c.Speed
        
        local x = c.Size * math.cos(theta) * math.sin(phi)
        local y = c.Size * math.sin(theta) * math.sin(phi)
        local z = c.Size * math.cos(phi)
        
        return Vector3.new(x, y + c.Height, z + c.Back)

    elseif mode == "Rotate" or mode == "MagicCircle" then
    -- 回転・八卦：星形または円
    local shape = (mode == "MagicCircle" and (i % 2 == 0)) and Paths.Star or Paths.Circle
    local speed = c.Speed
    local totalPoints = #shape
    
    -- ★完全に書き直し
    local cycle = (time * speed * 0.1 + ratio) % 1
    local currentStep = cycle * totalPoints
    
    local idx1 = math.floor(currentStep) % totalPoints + 1
    local idx2 = (math.floor(currentStep) + 1) % totalPoints + 1
    local alpha = currentStep % 1
    
    -- 安全なLerp
    local p1 = shape[idx1]
    local p2 = shape[idx2]
    if not p1 or not p2 then return Vector3.zero end
    
    local p = p1:Lerp(p2, alpha)
    
    -- Y軸回転を追加
    local rotAngle = time * speed * 0.3
    local rotX = p.X * math.cos(rotAngle) - p.Y * math.sin(rotAngle)
    local rotY = p.X * math.sin(rotAngle) + p.Y * math.cos(rotAngle)
    
    return Vector3.new(rotX * c.Size, c.Height, rotY * c.Size + c.Back)

elseif mode == "MagicCircle2" then
    -- 画像1のような放射状の魔法陣
    local totalPoints = #Paths.MagicCircle2
    local cycle = (time * c.Speed * 0.05 + ratio) % 1
    local currentStep = cycle * totalPoints
    
    local idx1 = math.floor(currentStep) % totalPoints + 1
    local idx2 = (math.floor(currentStep) + 1) % totalPoints + 1
    local alpha = currentStep % 1
    
    local p1 = Paths.MagicCircle2[idx1]
    local p2 = Paths.MagicCircle2[idx2]
    if not p1 or not p2 then return Vector3.zero end
    
    local p = p1:Lerp(p2, alpha)
    
    -- Y軸回転
    local rotAngle = time * c.Speed * 0.2
    local rotX = p.X * math.cos(rotAngle) - p.Y * math.sin(rotAngle)
    local rotZ = p.X * math.sin(rotAngle) + p.Y * math.cos(rotAngle)
    
    -- 上下の波動
    local wave = math.sin(time * c.Speed + i * 0.5) * 0.5
    
    return Vector3.new(rotX * c.Size, c.Height + wave, rotZ * c.Size + c.Back)

elseif mode == "MagicCircle3" then
    -- 画像2のような垂直ビーム風の魔法陣
    local totalPoints = #Paths.MagicCircle3
    local cycle = (time * c.Speed * 0.03 + ratio) % 1
    local currentStep = cycle * totalPoints
    
    local idx1 = math.floor(currentStep) % totalPoints + 1
    local idx2 = (math.floor(currentStep) + 1) % totalPoints + 1
    local alpha = currentStep % 1
    
    local p1 = Paths.MagicCircle3[idx1]
    local p2 = Paths.MagicCircle3[idx2]
    if not p1 or not p2 then return Vector3.zero end
    
    local p = p1:Lerp(p2, alpha)
    
    -- ゆっくり回転
    local rotAngle = time * c.Speed * 0.1
    local rotX = p.X * math.cos(rotAngle) - p.Y * math.sin(rotAngle)
    local rotZ = p.X * math.sin(rotAngle) + p.Y * math.cos(rotAngle)
    
    return Vector3.new(rotX * c.Size, c.Height, rotZ * c.Size + c.Back)

    elseif mode == "Pet" then
        -- 設定から各種パラメータを取得
        local petCountSetting = cfg.Pet.Count or 2
        local totalFws = count -- 使用可能な全花火数
        
        -- 1体あたりの花火数を計算
        local fwsPerPet = math.floor(totalFws / petCountSetting)
        if fwsPerPet < 1 then fwsPerPet = 1 end

        -- 現在の花火(i)が、何体目のペットの、何番目のパーツか
        local petIndex = math.ceil(i / fwsPerPet)
        local partIndexInPet = (i - 1) % fwsPerPet 
        
        -- 指定したペット数を超える余り花火は非表示
        if petIndex > petCountSetting then
            return Vector3.new(0, -1000, 0)
        end

        -- パーツの役割分担 (0:体, 1:左羽, 2:右羽)
        local role = 0 
        local sideIndex = 0
        if partIndexInPet == 0 then
            role = 0 -- 最初の1個は体
        elseif partIndexInPet <= math.ceil((fwsPerPet - 1) / 2) then
            role = 1 -- 左羽
            sideIndex = partIndexInPet
        else
            role = 2 -- 右羽
            sideIndex = partIndexInPet - math.ceil((fwsPerPet - 1) / 2)
        end

        -- ペット自体の配置（Gapを使用して間隔を調整）
        local petSide = (petIndex % 2 == 0) and 1 or -1
        local horizontalOffset = (c.Gap or 5) + (math.floor((petIndex - 1) / 2) * 8)
        
        -- 共通の浮遊ムーブ
        local hover = math.sin(time * c.Speed) * 1.2
        local bob = math.cos(time * c.Speed * 0.5) * 1
        
        local basePos = Vector3.new(
            petSide * horizontalOffset,
            c.Height + hover,
            c.Back + bob
        )

        if role == 0 then
            return basePos
        else
            -- 羽の計算
            local wingSide = (role == 1) and -1 or 1
            
            -- ★ここを修正：c.Size を羽の広がり（幅）に直接反映
            -- sideIndex（羽の中のパーツ番号）に比例して、c.Sizeの分だけ外に広がります
            local wingSpread = (sideIndex * (c.Size * 0.1)) 
            
            local flapPhase = time * c.Speed * 3 - (sideIndex * 0.3)
            local flap = math.sin(flapPhase) * 2
            
            local jointFactor = (c.Joints or 3) * 0.2
            
            return basePos + Vector3.new(
                wingSide * (1 + jointFactor + wingSpread), -- c.Sizeがここにかかる
                flap * (1 + jointFactor),
                -0.5 + (sideIndex * 0.1)
            )
        end

    elseif mode == "FloatStone" then
        -- アニメーションの「カオス展開」の動きを計算に導入
        local rTime = time * cfg[mode].Speed
        local spread = cfg[mode].Size
        
        -- 複数の正弦波を組み合わせて不規則な軌道を生成
        local x = math.cos(rTime + i * 1.5) * spread
        local y = math.sin(rTime * 0.7 + i) * (spread * 0.5) + cfg[mode].Height
        local z = math.sin(rTime * 1.2 + i * 2.2) * spread + cfg[mode].Back
        
        return Vector3.new(x, y, z)

-- [Textモードの計算ロジック抜粋] 

    elseif mode == "Text" then
        local str = cfg.Text.Content
        local chars = {}
        for char in str:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
            table.insert(chars, char)
        end
        local numChars = #chars
        if numChars == 0 then return Vector3.zero end
    
        local fwsPerChar = math.max(1, math.floor(count / numChars))
        local charIndex = math.clamp(math.ceil(i / fwsPerChar), 1, numChars)
    
        local charStr = chars[charIndex]
        local path = Paths.Alpha[charStr:upper()] or Paths.Alpha[" "]
        
        -- アニメーション計算
        local totalPoints = #path
        local speed = math.max(1, math.floor(c.Speed)) * 0.5
        local cycle = (time * speed + (i % fwsPerChar) * 0.1) % 2 
        local tP = (cycle < 1) and (cycle * (totalPoints - 1)) or ((2 - cycle) * (totalPoints - 1))
        local idx1 = math.floor(tP) + 1
        local idx2 = math.min(idx1 + 1, totalPoints)
        local p = path[idx1]:Lerp(path[idx2] or path[idx1], tP % 1)
        
        -- ★ 文字間隔の自動調節
        -- サイズ(c.Size)が大きくなれば間隔(spacing)も広がるように設定
        local charSizeScale = c.Size * 0.4
        local spacing = c.Size * 1.2 -- 1.2倍の間隔で自動調整
        local totalWidth = (numChars - 1) * spacing
        
        -- 配置計算 (反転なし、常に正面)
        local xPos = p.X * charSizeScale * -1 -- 文字の形が正しく見える向き
        local yPos = p.Y * charSizeScale
        local xOffset = ((charIndex - 1) * spacing - (totalWidth / 2)) * -1
        
        return Vector3.new(xOffset + xPos, yPos + c.Height, -c.Back)

    elseif mode == "Merkaba" then
        -- マカバ：3D回転
        local totalP = #Paths.Merkaba
        local tP = (time * c.Speed + ratio * totalP) % totalP
        local p1 = Paths.Merkaba[math.floor(tP) + 1]
        local p2 = Paths.Merkaba[(math.floor(tP) % totalP) + 1]
        
        local p = p1:Lerp(p2, tP % 1) * c.Size
        
        -- 複雑な3軸回転
        local rot = CFrame.Angles(time, time * 1.5, 0)
        return (rot * p) + Vector3.new(0, c.Height + math.sin(time * 2), c.Back)

    elseif mode == "Cube" then
        -- 立方体の頂点定義
        local size = c.Size
        local v = {
            Vector3.new(size, size, size),      -- 1: 右上前
            Vector3.new(-size, size, size),     -- 2: 左上前
            Vector3.new(size, -size, size),     -- 3: 右下前
            Vector3.new(-size, -size, size),    -- 4: 左下前
            Vector3.new(size, size, -size),     -- 5: 右上後
            Vector3.new(-size, size, -size),    -- 6: 左上後
            Vector3.new(size, -size, -size),    -- 7: 右下後
            Vector3.new(-size, -size, -size)    -- 8: 左下後
        }

        -- ■ 変更点: 「辺」ではなく「面（4頂点のループ）」を定義
        local faces = {
            {v[1], v[2], v[4], v[3]}, -- 前面ループ
            {v[5], v[6], v[8], v[7]}, -- 背面ループ
            {v[1], v[5], v[6], v[2]}, -- 上面ループ
            {v[3], v[7], v[8], v[4]}, -- 底面ループ
            {v[1], v[5], v[7], v[3]}, -- 右面ループ
            {v[2], v[6], v[8], v[4]}  -- 左面ループ
        }

        local numFaces = #faces
        
        -- 1. おもちゃを6つの面に順番に割り振る
        local faceIdx = ((i - 1) % numFaces) + 1
        local currentFace = faces[faceIdx]

        -- 2. 進行具合の計算 (周回ループ)
        local speed = c.Speed * 0.5 
        -- おもちゃごとに位置をずらす (i * 0.25) ことで重なりを防ぐ
        local totalProgress = (time * speed) + (i * 0.25)
        
        -- 3. 現在どの辺(0~3)にいるか、その辺のどこ(0.0~1.0)にいるか
        local edgeIndex = math.floor(totalProgress) % 4 + 1
        local nextEdgeIndex = (edgeIndex % 4) + 1 -- 次の頂点
        local alpha = totalProgress % 1 -- 辺の上の進捗 (0.0 -> 1.0)

        -- 4. 座標を計算
        local p1 = currentFace[edgeIndex]
        local p2 = currentFace[nextEdgeIndex]
        
        local pos = p1:Lerp(p2, alpha)
        
        return pos + Vector3.new(0, c.Height, c.Back)

    elseif mode == "MirrorPlayer" then
        local char = targetMain.Character
        if not char then return Vector3.new(0,0,0) end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return Vector3.new(0,0,0) end

        -- 1. R6パーツ定義（サイズと名前をセット）
        local bodyParts = {
            { name = "Head",      size = Vector3.new(1.2, 1.2, 1.2) },
            { name = "Torso",     size = Vector3.new(2, 2, 1) },
            { name = "Left Arm",  size = Vector3.new(1, 2, 1) },
            { name = "Right Arm", size = Vector3.new(1, 2, 1) },
            { name = "Left Leg",  size = Vector3.new(1, 2, 1) },
            { name = "Right Leg", size = Vector3.new(1, 2, 1) }
        }

        local toysPerPart = math.max(1, math.floor(count / #bodyParts))
        local partIdx = math.min(math.ceil(i / toysPerPart), #bodyParts)
        local localIdx = ((i - 1) % toysPerPart) + 1
        local data = bodyParts[partIdx]
        
        -- 対象の部位を特定
        local targetPart = char:FindFirstChild(data.name) or root

        -- 2. サイズと形状の計算（ここはおもちゃの形を作る）
        local s = data.size * c.Size * 0.5
        local t = (time * c.Speed) % 4
        local step = t % 1
        local edge = math.floor(t)
        local faceIdx = (localIdx - 1) % 6
        local p = Vector3.new(0,0,0)

        if faceIdx == 0 then p = (edge==0 and Vector3.new(-s.X+s.X*2*step,-s.Y,s.Z) or edge==1 and Vector3.new(s.X,-s.Y+s.Y*2*step,s.Z) or edge==2 and Vector3.new(s.X-s.X*2*step,s.Y,s.Z) or Vector3.new(-s.X,s.Y-s.Y*2*step,s.Z))
        elseif faceIdx == 1 then p = (edge==0 and Vector3.new(-s.X+s.X*2*step,-s.Y,-s.Z) or edge==1 and Vector3.new(s.X,-s.Y+s.Y*2*step,-s.Z) or edge==2 and Vector3.new(s.X-s.X*2*step,s.Y,-s.Z) or Vector3.new(-s.X,s.Y-s.Y*2*step,-s.Z))
        elseif faceIdx == 2 then p = (edge==0 and Vector3.new(s.X,-s.Y,-s.Z+s.Z*2*step) or edge==1 and Vector3.new(s.X,-s.Y+s.Y*2*step,s.Z) or edge==2 and Vector3.new(s.X,s.Y,s.Z-s.Z*2*step) or Vector3.new(s.X,s.Y-s.Y*2*step,-s.Z))
        elseif faceIdx == 3 then p = (edge==0 and Vector3.new(-s.X,-s.Y,-s.Z+s.Z*2*step) or edge==1 and Vector3.new(-s.X,-s.Y+s.Y*2*step,s.Z) or edge==2 and Vector3.new(-s.X,s.Y,s.Z-s.Z*2*step) or Vector3.new(-s.X,s.Y-s.Y*2*step,-s.Z))
        elseif faceIdx == 4 then p = (edge==0 and Vector3.new(-s.X+s.X*2*step,s.Y,-s.Z) or edge==1 and Vector3.new(s.X,s.Y,-s.Z+s.Z*2*step) or edge==2 and Vector3.new(s.X-s.X*2*step,s.Y,s.Z) or Vector3.new(-s.X,s.Y,s.Z-s.Z*2*step))
        else p = (edge==0 and Vector3.new(-s.X+s.X*2*step,-s.Y,-s.Z) or edge==1 and Vector3.new(s.X,-s.Y,-s.Z+s.Z*2*step) or edge==2 and Vector3.new(s.X-s.X*2*step,-s.Y,s.Z) or Vector3.new(-s.X,-s.Y,s.Z-s.Z*2*step)) end

        -- 3. 【これが「位置」を直す魔法の式】
        -- 自分の各部位が「RootPartから見てどこにいるか」というオフセットを計算
        -- PointToObjectSpace を使うことで、エモート等でズレた位置も自動計算されます
        local partRelativePos = root.CFrame:PointToObjectSpace(targetPart.Position)
        
        -- 背後距離(Back)と高さ(Height)のオフセット
        local extraOffset = Vector3.new(0, c.Height, -c.Back)
        
        -- 回転情報を適用（部位が傾けばおもちゃの枠も傾く）
        local rotatedBoxPoint = (root.CFrame:Inverse() * targetPart.CFrame).Rotation * p

        -- 全部を足して返す
        -- [部位の相対位置] + [一筆書きの頂点] + [ユーザー設定のズレ]
        return partRelativePos + rotatedBoxPoint + extraOffset

    elseif mode == "Beam" then
        -- Y方向の光の柱
        local ang = (i % c.Count) * (math.pi * 2 / c.Count)
        local radius = c.Size * 0.3
        
        -- 円周配置
        local x = math.cos(ang) * radius
        local z = math.sin(ang) * radius
        
        -- Y軸高速往復
        local yOsc = math.sin(time * c.Speed + (i / count) * math.pi * 2)
        local y = yOsc * c.Size
        
        return Vector3.new(x, y + c.Height, z + c.Back)

    elseif mode == "BackGuard" then
        local spread = c.Size
    
         -- 各石のランダム位置(固定シードで再現性確保)
        local seed = i * 123.456
        local randomX = (math.sin(seed) * 2 - 1) * spread  -- 左右にバラバラ
        local randomY = (math.cos(seed * 1.3) * 2 - 1) * (spread * 0.3) + c.Height  -- 上下にバラバラ
    
        -- 後ろ側に配置
        local backDistance = c.Back + math.abs(math.sin(seed * 0.7)) * spread * 0.5
    
        -- 微妙な浮遊動作
        local hover = math.sin(time * c.Speed + i * 0.5) * 0.5
    
        return Vector3.new(randomX, randomY + hover, -backDistance)
    end
    
    return Vector3.zero
end

--------------------------------------------------------------------------------
-- [メイン機能] エフェクト制御 (Start / Stop / Update)
--------------------------------------------------------------------------------
local function stopEffect()
    isEnabled = false
    if updateConnection then 
        updateConnection:Disconnect()
        updateConnection = nil 
    end
    
    -- アタッチメント削除 & 固定化
    for _, v in ipairs(activeToys) do
        pcall(function() 
            v.Part.Anchored = false 
            v.A0:Destroy()
            v.A1:Destroy()
            v.AP:Destroy()
            v.AO:Destroy() 
        end)
    end
    activeToys = {}
    
    -- 当たり判定復元
    for part, val in pairs(originalCollisions) do
        if part and part.Parent then 
            part.CanCollide = val 
        end
    end
    originalCollisions = {}
end

local function startEffect()
    stopEffect()
    activeToys = {}

    if not targetMain or not targetMain.Character then return end
    local root = targetMain.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local fws = {}
    local myName = LocalPlayer.Name
    
    local maxCount
    if combinedActive then
        maxCount = (cfg.Combined.Mode1Count or 15) + (cfg.Combined.Mode2Count or 15)
    else
        maxCount = cfg.Global.MaxToys or 30 
    end

    local allMyItems = {}
    local plotsFolder = Workspace:FindFirstChild("Plots")
    local plotItemsFolder = Workspace:FindFirstChild("PlotItems")

    -- 0. Get items from SpawnedInToys (Cosmic style)
    local spawnedToys = Workspace:FindFirstChild(myName .. "SpawnedInToys")
    if spawnedToys then
        for _, item in ipairs(spawnedToys:GetChildren()) do
            table.insert(allMyItems, item)
        end
    end

    -- 1. Get items from my plot
    if plotsFolder and plotItemsFolder then
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            local ownerObj = sign and (sign:FindFirstChild("ThisPlotsOwners") or sign:FindFirstChild("Owner"))
            if ownerObj then
                local val = ownerObj:FindFirstChild("Value") or ownerObj
                local data = val:FindFirstChild("Data") or val
                if (data:IsA("StringValue") and data.Value == myName) then
                    local myPlotName = plot.Name
                    local targetFolder = plotItemsFolder:FindFirstChild(myPlotName)
                    if targetFolder then
                        for _, item in ipairs(targetFolder:GetChildren()) do
                            table.insert(allMyItems, item)
                        end
                    end
                    break
                end
            end
        end
    end

    -- 2. Get items directly from Workspace that I own
    for _, item in ipairs(Workspace:GetChildren()) do
        local ownerValue = item:FindFirstChild("Owner") or item:FindFirstChild("PartOwner")
        if item:IsA("Model") and ownerValue and ownerValue:IsA("StringValue") and ownerValue.Value == myName and not table.find(allMyItems, item) then
             table.insert(allMyItems, item)
        end
    end

    -- 3. Filter items based on selection and add to fws
    for _, item in ipairs(allMyItems) do
        if #fws >= maxCount then break end
        if item:IsA("Model") and item.PrimaryPart and (selectedItemName == "Todos los juguetes" or item.Name == selectedItemName) then
            table.insert(fws, item)
        end
    end

    -- 4. Ensure network ownership for all found items
    for _, item in ipairs(fws) do
        for _, part in ipairs(item:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() part:SetNetworkOwner(LocalPlayer) end)
            end
        end
    end

    if #fws == 0 then
        warn("No se encontraron juguetes.")
        return
    end

        print(#fws .. " juguetes capturados. (Objetivo: " .. maxCount .. ")")

   -- ネットワークオーナーシップを強制的に取得
    for i, model in ipairs(fws) do
        local pp = model.PrimaryPart
        
        -- 全パーツの勢いを殺す
        for _, d in ipairs(model:GetDescendants()) do 
            if d:IsA("BasePart") then
                d.AssemblyLinearVelocity = Vector3.zero
                d.AssemblyAngularVelocity = Vector3.zero
                pcall(function() d:SetNetworkOwner(LocalPlayer) end)
            end
        end
        
        -- スタート時の爆発を防ぐため、計算上の初期位置に直接配置する
        if root then
            local m = combinedActive and (i <= (cfg.Combined.Mode1Count or 15) and cfg.Combined.Mode1 or cfg.Combined.Mode2) or currentMode
            local count = #fws -- 取得したおもちゃの総数
            local relIdx = (combinedActive and i > (cfg.Combined.Mode1Count or 15)) and (i - (cfg.Combined.Mode1Count or 15)) or i
            local relTotal = combinedActive and (i <= (cfg.Combined.Mode1Count or 15) and (cfg.Combined.Mode1Count or 15) or (count - (cfg.Combined.Mode1Count or 15))) or count
            
            -- getPositionForMode を使って開始位置を計算
            local relativePos = getPositionForMode(m, relIdx, relTotal, tick())
            pp.CFrame = root.CFrame:ToWorldSpace(CFrame.new(relativePos))
        end
        
        pp.Anchored = false -- 配置が終わってから物理を有効化
        pcall(function() pp:SetNetworkOwner(LocalPlayer) end)

        -- 当たり判定無効化
        for _, d in ipairs(model:GetDescendants()) do 
            if d:IsA("BasePart") then 
                if originalCollisions[d] == nil then originalCollisions[d] = d.CanCollide end
                d.CanCollide = false
                d.CanTouch = false
                d.CanQuery = false
            end 
        end
        
        -- (AttachmentやAlignPositionの設定はそのまま...)
        local a0 = Instance.new("Attachment", pp)
        local ap = Instance.new("AlignPosition", pp)
        ap.Attachment0 = a0
        ap.Mode = Enum.PositionAlignmentMode.OneAttachment
        ap.MaxForce = 1e9
        ap.Responsiveness = 200
        
        local ao = Instance.new("AlignOrientation", pp)
        ao.Attachment0 = a0
        ao.Mode = Enum.OrientationAlignmentMode.OneAttachment
        ao.MaxTorque = 1e9
        ao.Responsiveness = 200
        
        table.insert(activeToys, {A0=a0, AP=ap, AO=ao, Part=pp})
    end
    
    isEnabled = true

    updateConnection = RunService.RenderStepped:Connect(function()
    local char = targetMain.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local baseCF
    if followPlayer and not isReturningToPlot then
        -- 追従ON：常にプレイヤーの最新座標を基準にする
        baseCF = rootPart.CFrame
        lastBaseCF = baseCF
    else
        -- 追従OFF：lastBaseCF があればそれを「絶対」に使う
        if not lastBaseCF then
            lastBaseCF = rootPart.CFrame
        end
        baseCF = lastBaseCF
    end

    local t = tick()
    local individualRotation = CFrame.Angles(0, math.rad(GLOBAL_ANGLE), 0)

    for i, fw in ipairs(activeToys) do
        -- 奈落判定
        if fw.Part.Position.Y <= -90 then
            -- 奈落に落ちている場合は固定して何もしない
            fw.Part.Anchored = true
        else
            -- 奈落に落ちていない場合のみ、通常処理を行う (continueの代わり)
            fw.Part.Anchored = false

            -- 位置計算
            local m = combinedActive and (i <= (cfg.Combined.Mode1Count or 15) and cfg.Combined.Mode1 or cfg.Combined.Mode2) or currentMode
            local count = #activeToys
            local relIdx = (combinedActive and i > (cfg.Combined.Mode1Count or 15)) and (i - (cfg.Combined.Mode1Count or 15)) or i
            local relTotal = combinedActive and (i <= (cfg.Combined.Mode1Count or 15) and (cfg.Combined.Mode1Count or 15) or (count - (cfg.Combined.Mode1Count or 15))) or count
            
            local relativePos = getPositionForMode(m, relIdx, relTotal, t)
            local worldPos = baseCF:PointToWorldSpace(relativePos)

            -- AlignPosition(物理)の目標を更新
            fw.AP.Position = worldPos

            -- 回転制御
            if m == "BackGuard" then
                fw.AO.CFrame = CFrame.lookAt(worldPos, baseCF.Position) * individualRotation
            elseif m == "Rotate" or m == "MagicCircle" or m == "FloatStone" or m == "Merkaba" or m == "Cube" then
                local nextPos = baseCF:PointToWorldSpace(getPositionForMode(m, relIdx, relTotal, t + 0.05))
                fw.AO.CFrame = CFrame.lookAt(worldPos, nextPos) * individualRotation
            else
                fw.AO.CFrame = baseCF * individualRotation
            end
        end -- if 奈落判定の閉じ
    end -- for ループの閉じ
end)
end

--------------------------------------------------------------------------------
-- [汎用ベースポイント帰還機能]
--------------------------------------------------------------------------------
local selectedHouseCF = nil 
local houseCoords = {
    ["Casa de Cerezos"] = CFrame.new(548, 123, -73),
    ["Casa Azul Claro"] = CFrame.new(509, 83, -338),
    ["Casa Morada"] = CFrame.new(255, -7, 449),
    ["Casa Verde"] = CFrame.new(-534, -7, 89),
    ["Casa Rosa"] = CFrame.new(-485, -7, -163)
}

task.spawn(function()
    while true do
        task.wait(1)
        local isEnabled = cfg.PlotReturn.Enabled
        local interval = cfg.PlotReturn.Interval or 30
        local targetCF = selectedHouseCF
        
        if isEnabled and targetCF then
            task.wait(interval)
            if cfg.PlotReturn.Enabled and selectedHouseCF then
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    isReturningToPlot = true
                    local oldCF = root.CFrame
                    root.CFrame = selectedHouseCF
                    task.wait(0.5)
                    root.CFrame = oldCF
                    isReturningToPlot = false
                end
            end
        end
    end
end)

--------------------------------------------------------------------------------
-- [ESP & サブ機能] 更新ループ (Prometheus対応版)
--------------------------------------------------------------------------------
-- 共通のクリーンアップ関数（退出時や非表示時に使用）
local function removeESP(p)
    local esp = espCache[p]
    if esp then
        if esp.H then pcall(function() esp.H:Destroy() end) end
        if esp.B then pcall(function() esp.B:Destroy() end) end
        if esp.T then 
            pcall(function() 
                esp.T.Visible = false 
                esp.T:Remove() -- DrawingオブジェクトはRemove()で完全に消去
            end) 
        end
        espCache[p] = nil
    end
end

-- プレイヤーがサーバーを抜けた時に即座に実行
Players.PlayerRemoving:Connect(removeESP)

local function updateSubFeatures()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local char = p.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")
            
            local shouldShow = false
            local isTarget = (not espCfg.TargetOnly) or (espCfg.TargetOnly and p == targetSub)
            
            -- 設定が有効、かつターゲット一致、かつ生存している場合
            if espCfg.Enabled and isTarget and root and hum and hum.Health > 0 then
                shouldShow = true
            end

            local esp = espCache[p] or {}
            
            if shouldShow then
                -- 1. ハイライト処理
                if not esp.H or esp.H.Parent ~= char then 
                    esp.H = Instance.new("Highlight")
                    esp.H.Parent = char
                    esp.H.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
                esp.H.Enabled = true
                esp.H.FillColor = espCfg.ESPColor

                -- 2. アイコン付き名前表示 (確実に動くURL形式)
                if not esp.B or esp.B.Parent ~= root then
                    esp.B = Instance.new("BillboardGui")
                    esp.B.Parent = root
                    esp.B.Size = UDim2.new(0, 250, 0, 50)
                    esp.B.AlwaysOnTop = true
                    esp.B.ExtentsOffset = Vector3.new(0, 3, 0)

                    local frame = Instance.new("Frame", esp.B)
                    frame.Size = UDim2.new(1, 0, 1, 0)
                    frame.BackgroundTransparency = 1

                    local icon = Instance.new("ImageLabel", frame)
                    icon.Name = "Icon"
                    icon.Size = UDim2.new(0, 30, 0, 30)
                    icon.Position = UDim2.new(0, 0, 0.5, -15)
                    icon.BackgroundTransparency = 1
                    -- アイコンが表示されていた形式のURLを使用
                    icon.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. p.UserId .. "&width=420&height=420&format=png"

                    local l = Instance.new("TextLabel", frame)
                    l.Name = "NameLabel"
                    l.Size = UDim2.new(1, -35, 1, 0)
                    l.Position = UDim2.new(0, 35, 0, 0)
                    l.BackgroundTransparency = 1
                    l.TextXAlignment = Enum.TextXAlignment.Left
                    l.TextStrokeTransparency = 0
                    l.Font = Enum.Font.SourceSansBold
                    l.TextSize = 14
                    
                    esp.L = l
                    esp.I = icon
                end
                esp.B.Enabled = espCfg.Names
                esp.L.Text = p.DisplayName .. " (@" .. p.Name .. ")"
                esp.L.TextColor3 = espCfg.ESPColor

                -- 3. トレーサー (改善版)
                if espCfg.Tracers then
                    if not esp.T then
                        esp.T = Drawing.new("Line")
                        esp.T.Thickness = 1
                        esp.T.Transparency = 1
                    end
                    
                    local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                    esp.T.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    esp.T.Color = espCfg.ESPColor
                    
                    if onScreen then
                        esp.T.To = Vector2.new(screenPos.X, screenPos.Y)
                        esp.T.Visible = true
                    else
                        -- 画面外のトレーサー処理（不要な場合は visible = false に）
                        esp.T.Visible = false 
                    end
                elseif esp.T then
                    esp.T.Visible = false
                end

                -- 4. ヒットボックス
                if espCfg.Hitbox then
                    root.Size = Vector3.new(espCfg.HitboxSize, espCfg.HitboxSize, espCfg.HitboxSize)
                    root.Transparency = 0.5
                    root.Color = espCfg.ESPColor
                    root.CanCollide = false
                else
                    root.Size = Vector3.new(2, 2, 1)
                    root.Transparency = 1
                end
                espCache[p] = esp
            else
                -- 表示不要（退出・死亡・設定OFF）になったら即座にクリーンアップ
                removeESP(p)
                -- ヒットボックスのサイズも元に戻す
                if root and root.Parent then
                    root.Size = Vector3.new(2, 2, 1)
                    root.Transparency = 1
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(updateSubFeatures)

-- プレイヤー機能ループ
UserInputService.JumpRequest:Connect(function()
    if infiniteJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.Stepped:Connect(function(time, deltaTime)
    if not LocalPlayer.Character then return end
    local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if hum then
        if useWalkSpeed and root and hum.MoveDirection.Magnitude > 0 then
            -- CFrameによる移動 (Cosmic Hub参考)
            local extraSpeed = math.max(0, walkSpeed - 16)
            root.CFrame = root.CFrame + (hum.MoveDirection * (extraSpeed * deltaTime))
        end
        if useJumpPower then 
            hum.UseJumpPower = true
            hum.JumpPower = jumpPower
            -- UseJumpPowerが強制的にfalseにされる場合への対策 (JumpHeightを使用)
            if not hum.UseJumpPower then
                hum.JumpHeight = jumpPower * 0.2 -- 概算
            end
        end
    end
    
    if antiFire then
        for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("Fire") then v:Destroy() end
        end
    end
    
    if antiGrab then
        local char = LocalPlayer.Character
        if char then
            -- Cosmic style Anti-Grab Loop
            local head = char:FindFirstChild("Head")
            local isHeldVal = LocalPlayer:FindFirstChild("IsHeld")
            local isHeld = (head and head:FindFirstChild("PartOwner")) or (isHeldVal and isHeldVal.Value)
            local struggleEvt = ReplicatedStorage:FindFirstChild("CharacterEvents") and ReplicatedStorage.CharacterEvents:FindFirstChild("Struggle")

            if isHeld then
                -- 掴まれている間、固定して抵抗し続ける
                for _, p in ipairs(char:GetChildren()) do
                    if p:IsA("BasePart") then p.Anchored = true end
                end
                
                if struggleEvt then
                    struggleEvt:FireServer(LocalPlayer) -- 引数追加
                end
            else
                -- 掴まれていない、かつアンチ爆発(ラグドール)中でなければ固定解除
                local isRagdolled = antiExplosion and char:FindFirstChild("Humanoid") and char.Humanoid:FindFirstChild("Ragdolled") and char.Humanoid.Ragdolled.Value
                if not isRagdolled then
                    for _, p in ipairs(char:GetChildren()) do
                        if p:IsA("BasePart") then p.Anchored = false end
                    end
                end
            end
        end
    end

    -- Noclip
    if noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

Workspace.DescendantAdded:Connect(function(v)
    if antiExplosion and v:IsA("Explosion") then
        v.BlastPressure = 0
        v.BlastRadius = 0
        v.Visible = false
        task.wait()
        v:Destroy()
    end
end)

-- Anti-Explosion (Ragdoll Anchor) & Anti-Fire (Extinguish) Loop 修正版
local extOriginalCFrame = nil
local extPart = nil

task.spawn(function()
    while true do
        task.wait(0.1)
        local char = LocalPlayer.Character
        if char then
            -- Anti-Explosion: Ragdoll Anchor (修正: 解除処理を追加)
            if antiExplosion then
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    local rag = hum:FindFirstChild("Ragdolled")
                    if rag and rag.Value then
                        -- ラグドール中は固定
                        for _, p in ipairs(char:GetChildren()) do
                            if p:IsA("BasePart") then p.Anchored = true end
                        end
                    else
                        -- ラグドール解除後は固定解除 (動けるようにする)
                        for _, p in ipairs(char:GetChildren()) do
                            if p:IsA("BasePart") then p.Anchored = false end
                        end
                    end
                end
            end

            -- Anti-Fire: Extinguish Part (修正: 紫の物体を元の位置に戻す)
            if antiFire then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hasFire = hrp and (hrp:FindFirstChild("FireLight") or hrp:FindFirstChild("FireParticleEmitter"))
                
                -- パーツを一度だけ取得・保存
                if not extPart then
                    local map = Workspace:FindFirstChild("Map")
                    local hole = map and map:FindFirstChild("Hole")
                    local poison = hole and hole:FindFirstChild("PoisonBigHole")
                    extPart = poison and poison:FindFirstChild("ExtinguishPart")
                    if extPart then extOriginalCFrame = extPart.CFrame end
                end
                
                if extPart then
                    if hasFire then
                        -- 炎があるなら消火パーツを自分に持ってくる
                        extPart.CFrame = hrp.CFrame
                    elseif extOriginalCFrame then
                        -- 炎が消えたら元の位置に戻す (紫の物体を隠す)
                        extPart.CFrame = extOriginalCFrame
                    end
                end
            end
        end
    end
end)


--------------------------------------------------------------------------------
-- [設定]保存、見た目 
--------------------------------------------------------------------------------
-- --- 設定読み込み用関数 ---
-- 設定ファイルのリストをリアルタイムに取得する関数
local function getConfigFileList()
    local files = {}
    if not isfolder("holon_config") then makefolder("holon_config") end
    
    for _, file in ipairs(listfiles("holon_config")) do
        if file:sub(-5) == ".json" then
            -- パスを除去してファイル名だけにする
            local name = file:gsub("holon_config\\", ""):gsub("holon_config/", "")
            table.insert(files, name)
        end
    end
    if #files == 0 then table.insert(files, "Sin archivos") end
    return files
end

-- 1. cfgの中にUIの項目がない場合のエラーを防止する
if not cfg.UI then
    cfg.UI = {
        Transparency = 0.1,
        BackgroundColor = Color3.fromRGB(25, 25, 25),
        AccentColor = Color3.fromRGB(128, 128, 128),
        BackgroundImage = ""
    }
end

-- UI外観をリアルタイムに反映させるエンジン
local function applyCustomStyle()
    -- 安全策: cfg.UIが存在しない場合の初期化（ロード直後対策）
    if not cfg.UI then
        cfg.UI = {
            Transparency = 0.1,
            BackgroundColor = Color3.fromRGB(25, 25, 25),
            AccentColor = Color3.fromRGB(128, 128, 128),
            BackgroundImage = ""
        }
    end

    local gui = game:GetService("CoreGui"):FindFirstChild("OrionUI") or game:GetService("CoreGui"):FindFirstChild("Orion")
    if not gui then
        gui = LocalPlayer:FindFirstChild("PlayerGui") and (LocalPlayer.PlayerGui:FindFirstChild("OrionUI") or LocalPlayer.PlayerGui:FindFirstChild("Orion"))
    end

    if gui then
        local main = gui:FindFirstChild("Main")
        if not main then
            for _, child in ipairs(gui:GetChildren()) do
                if child:IsA("Frame") and child:FindFirstChild("TopBar") then
                    main = child
                    break
                end
            end
        end
        
        if main then
            local bgColor = cfg.UI.BackgroundColor or Color3.fromRGB(25, 25, 25)
            local trans = cfg.UI.Transparency or 0.1
            local accent = cfg.UI.AccentColor or Color3.fromRGB(128, 128, 128)
    
            main.BackgroundColor3 = bgColor
            main.BackgroundTransparency = trans
            
            -- 子要素を再帰的に探索してスタイル適用
            for _, desc in ipairs(main:GetDescendants()) do
                -- 1. 枠線 (UIStroke)
                if desc:IsA("UIStroke") then
                    desc.Color = accent
                end
                -- 2. 区切り線 (Lineという名前のFrame)
                if desc:IsA("Frame") and desc.Name == "Line" then
                    desc.BackgroundColor3 = accent
                end
                -- 3. サイドバーとトップバー
                if desc:IsA("Frame") and (desc.Name == "SideBar" or desc.Name == "TopBar") then
                    desc.BackgroundColor3 = bgColor
                    desc.BackgroundTransparency = trans
                    -- ヘッダーの角を丸くする
                    if desc.Name == "TopBar" then
                        local corner = desc:FindFirstChild("UICorner") or Instance.new("UICorner", desc)
                        corner.CornerRadius = UDim.new(0, 9)
                    end
                end
                -- 4. ボタンとタブ (TextButton)
                -- 透明でないものだけ適用（見えないヒットボックスが表示されるのを防ぐ）
                if desc:IsA("TextButton") and desc.BackgroundTransparency < 1 then
                    desc.BackgroundColor3 = bgColor
                    desc.BackgroundTransparency = trans
                end
            end
            
            -- メインフレーム自体の角も確実に丸くする
            local mainCorner = main:FindFirstChild("UICorner") or Instance.new("UICorner", main)
            mainCorner.CornerRadius = UDim.new(0, 9)
        
        -- 背景画像のリアルタイム処理
        local bgImage = main:FindFirstChild("CustomBG")
        if cfg.UI.BackgroundImage and cfg.UI.BackgroundImage ~= "" then
            if not bgImage then
                bgImage = Instance.new("ImageLabel")
                bgImage.Name = "CustomBG"
                bgImage.Parent = main
                bgImage.Size = UDim2.new(1, 0, 1, 0)
                bgImage.Position = UDim2.new(0, 0, 0, 0)
                bgImage.ZIndex = 0
                bgImage.BackgroundTransparency = 1
            end
            
            local imgId = tostring(cfg.UI.BackgroundImage)
            if not imgId:match("^rbxassetid://") then
                imgId = "rbxassetid://" .. imgId
            end
            
            bgImage.Image = imgId
            bgImage.ImageTransparency = trans
            bgImage.Visible = true
        else
            if bgImage then bgImage.Visible = false end
        end
        end
    end
end

--------------------------------------------------------------------------------
-- [UI 構築] orion lib
--------------------------------------------------------------------------------
local KeyFileName = "HolonHub_Key.txt"
local CorrectKey = "holox"
local OrionUrl = "https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/source.txt"

-- [[ 1. メイン画面の関数 ]]
local function StartHolonHUB()
    -- スマホ対策：OrionLibを関数内で読み込み直す
    local OrionLib = loadstring(game:HttpGet(OrionUrl))()
    
    -- 既存のUIを強制削除（二重表示防止）
    pcall(function()
        if game:GetService("CoreGui"):FindFirstChild("Orion") then 
            game:GetService("CoreGui").Orion:Destroy() 
        end
    end)

    local Window = OrionLib:MakeWindow({
        Name = "Holon HUB v1.3.5 (ES)",
        HidePremium = false,
        SaveConfig = false, -- 初期化時の干渉を防ぐため無効化
        ConfigFolder = "HolonHUB",
        IntroEnabled = true,
        IntroText = "¡Holon HUB v1.3.5 ha sido cargado!"
    })

-- プレイヤーリスト取得関数
local function getPList()
    local plist = {}
    for _, p in ipairs(Players:GetPlayers()) do
        -- 「表示名 (@ユーザー名)」の形式でテーブルに入れる
        table.insert(plist, p.DisplayName .. " (@" .. p.Name .. ")")
    end
    return plist
end

-- UI要素を管理するテーブル
local UIElements = {}

-- --- TAB: MAIN ---
local MainTab = Window:MakeTab({
	Name = "Principal",
	Icon = "rbxassetid://7733960981" -- 適当なアイコンIDに差し替えてください
})

-- --- TAB: PLAYER ---
local PlayerTab = Window:MakeTab({
    Name = "Jugador",
    Icon = "rbxassetid://7743875962"
})

local MoveSec = PlayerTab:AddSection({ Name = "Movimiento" })

-- 現在のステータスを初期値にする
local currentWS = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")) and LocalPlayer.Character.Humanoid.WalkSpeed or 16
walkSpeed = currentWS

UIElements.WalkSpeedSlider = MoveSec:AddSlider({
    Name = "Velocidad de caminata", Min = 16, Max = 300, Default = currentWS, Increment = 1,
    Callback = function(v) walkSpeed = v end
})

UIElements.WalkSpeedToggle = MoveSec:AddToggle({
    Name = "Activar velocidad de caminata", Default = false,
    Callback = function(v) 
        useWalkSpeed = v 
    end
})

UIElements.JumpPowerSlider = MoveSec:AddSlider({
    Name = "Fuerza de salto", Min = 16, Max = 300, Default = 25, Increment = 1,
    Callback = function(v) jumpPower = v end
})

UIElements.JumpPowerToggle = MoveSec:AddToggle({
    Name = "Activar fuerza de salto", Default = false,
    Callback = function(v) 
        useJumpPower = v 
        if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = 25
        end
    end
})

UIElements.NoclipToggle = MoveSec:AddToggle({
    Name = "Noclip", Default = false,
    Callback = function(v) 
        noclip = v 
        if not v and LocalPlayer.Character then
            -- 修正: 全パーツをCanCollide=trueにすると荒ぶるため、主要パーツのみ戻す
            local char = LocalPlayer.Character
            local partsToCollide = {"HumanoidRootPart", "Head", "Torso", "UpperTorso", "LowerTorso"}
            for _, name in ipairs(partsToCollide) do
                local p = char:FindFirstChild(name)
                if p and p:IsA("BasePart") then p.CanCollide = true end
            end
        end
    end
})

UIElements.InfiniteJumpToggle = MoveSec:AddToggle({
    Name = "Salto infinito", Default = false,
    Callback = function(v) infiniteJump = v end
})

local vflyEnabled = false
local vflySpeed = 1

UIElements.VFlyToggle = MoveSec:AddToggle({
    Name = "VFly",
    Default = false,
    Callback = function(v)
        vflyEnabled = v
        if v then
            task.spawn(function()
                local bv = Instance.new("BodyVelocity")
                bv.Name = "HolonVFly"
                bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                bv.Velocity = Vector3.zero
                
                local bg = Instance.new("BodyGyro")
                bg.Name = "HolonVFlyGyro"
                bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
                bg.P = 10000
                bg.D = 100
                
                while vflyEnabled and LocalPlayer.Character do
                    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
                    if root and hum then
                        if not root:FindFirstChild("HolonVFly") then bv.Parent = root end
                        if not root:FindFirstChild("HolonVFlyGyro") then bg.Parent = root end
                        
                        bg.CFrame = Camera.CFrame
                        
                        local moveDir = hum.MoveDirection
                        local vel = Vector3.zero
                        
                        if moveDir.Magnitude > 0 then
                            local camLook = Camera.CFrame.LookVector
                            local camRight = Camera.CFrame.RightVector
                            local camLookXZ = camLook * Vector3.new(1,0,1)
                            local camRightXZ = camRight * Vector3.new(1,0,1)
                            
                            if camLookXZ.Magnitude > 0.001 then
                                camLookXZ = camLookXZ.Unit
                                camRightXZ = camRightXZ.Unit
                                local fwd = moveDir:Dot(camLookXZ)
                                local right = moveDir:Dot(camRightXZ)
                                vel = (camLook * fwd + camRight * right) * (vflySpeed * 50)
                            else
                                vel = camLook * (moveDir.Magnitude * vflySpeed * 50)
                            end
                        end
                        
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            vel = vel + Vector3.new(0, vflySpeed * 50, 0)
                        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                            vel = vel - Vector3.new(0, vflySpeed * 50, 0)
                        end
                        
                        bv.Velocity = vel
                        
                        if not hum.Sit then
                            hum.PlatformStand = true
                        end
                    else
                        break
                    end
                    RunService.RenderStepped:Wait()
                end
                
                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.PlatformStand = false
                end
            end)
        end
    end
})

UIElements.VFlySpeedSlider = MoveSec:AddSlider({
    Name = "Velocidad VFly",
    Min = 1, Max = 10, Default = 1,
    Callback = function(v) vflySpeed = v end
})

local ProtectSec = PlayerTab:AddSection({ Name = "Protección" })

UIElements.AntiExplosionToggle = ProtectSec:AddToggle({ Name = "Anti-Explosión", Default = false, Callback = function(v) antiExplosion = v end })
UIElements.AntiFireToggle = ProtectSec:AddToggle({ Name = "Anti-Fuego", Default = false, Callback = function(v) antiFire = v end })
UIElements.AntiGrabToggle = ProtectSec:AddToggle({ Name = "Anti-Agarre", Default = false, Callback = function(v) antiGrab = v end })

local gucciConn = nil
UIElements.AntiGucciToggle = ProtectSec:AddToggle({ 
    Name = "Anti Gucci", 
    Default = false, 
    Callback = function(v) 
        if v then
            -- Cosmic Logic: Spawn Blobman far away and sit
            task.spawn(function()
                local mt = ReplicatedStorage:FindFirstChild("MenuToys")
                local st = mt and mt:FindFirstChild("SpawnToyRemoteFunction")
                if st then
                    st:InvokeServer("CreatureBlobman", CFrame.new(0, 50000, 0) * CFrame.Angles(-0.7351, 0.9028, 0.6173), Vector3.new(0, 59.667, 0))
                end
                task.wait(0.5)
                local toys = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                local blob = toys and toys:FindFirstChild("CreatureBlobman")
                if blob then
                    local head = blob:FindFirstChild("Head")
                    if head then head.CFrame = CFrame.new(0, 50000, 0); head.Anchored = true end
                    
                    local seat = blob:FindFirstChild("VehicleSeat")
                    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                    if seat and hum then seat:Sit(hum) end
                    
                    -- Ragdoll Loop (Cosmic)
                    if gucciConn then gucciConn:Disconnect() end
                    gucciConn = RunService.Heartbeat:Connect(function()
                        local ce = ReplicatedStorage:FindFirstChild("CharacterEvents")
                        local rr = ce and ce:FindFirstChild("RagdollRemote")
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if rr and hrp then rr:FireServer(hrp, 0) end
                    end)
                end
            end)
        else
            if gucciConn then gucciConn:Disconnect() gucciConn = nil end
        end
    end 
})

local PlayerViewSec = PlayerTab:AddSection({ Name = "Vista/Cámara" })

UIElements.ThirdPersonToggle = PlayerViewSec:AddToggle({
    Name = "Tercera persona",
    Default = false,
    Callback = function(v) 
        if v then
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMaxZoomDistance = 500
            LocalPlayer.CameraMinZoomDistance = 0.5
        else
            LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
            LocalPlayer.CameraMaxZoomDistance = 0.5
            LocalPlayer.CameraMinZoomDistance = 0.5
        end
    end 
})

local currentFOV = Camera.FieldOfView
UIElements.FOVSlider = PlayerViewSec:AddSlider({
    Name = "Campo de visión (FOV)",
    Min = 30,
    Max = 120,
    Default = currentFOV,
    Increment = 1,
    Callback = function(v)
        Camera.FieldOfView = v
    end    
})

-- --- MAIN SECTION ---

local MainSec = MainTab:AddSection({
	Name = "Control de efectos"
})

-- メイン対象ドロップダウン（変数として定義）
local targetMainName = "" -- 名前を保存する変数を新しく用意
local tpDropdown = nil

local pDropMain
UIElements.MainTargetDropdown = MainSec:AddDropdown({
    Name = "Objetivo principal",
    Default = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")",
    Options = getPList(),
    Callback = function(v)
        -- @以降を正確に切り出す (アンダーバー等にも対応)
        local name = v:match("@([^)]+)")
        targetMainName = name or LocalPlayer.Name
        targetMain = Players:FindFirstChild(targetMainName) or LocalPlayer
    end    
})
pDropMain = UIElements.MainTargetDropdown

Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    pDropMain:Refresh(getPList(), true)
    if tpDropdown then tpDropdown:Refresh(getPList(), true) end
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.5)
    pDropMain:Refresh(getPList(), true)
    if tpDropdown then tpDropdown:Refresh(getPList(), true) end
end)

-- エフェクト有効化トグル
UIElements.EffectToggle = MainSec:AddToggle({
	Name = "Activar efecto",
	Default = false,
	Callback = function(v)
		if v then startEffect() else stopEffect() end
	end    
})

-- モード選択ドロップダウン
UIElements.ModeDropdown = MainSec:AddDropdown({
	Name = "Seleccionar modo",
	Default = "Wing",
	Options = {"Wing","Heart","Star","Vortex","Sphere","Rotate","Pet","Text","MagicCircle","MagicCircle2","MagicCircle3","FloatStone","Merkaba","Cube","MirrorPlayer","Beam","BackGuard"},
	Callback = function(v)
		currentMode = v
		combinedActive = false
	end    
})

-- 制御対象ドロップダウン
local itemDropdown

UIElements.ItemDropdown = MainSec:AddDropdown({
    Name = "Seleccionar objeto objetivo",
    Default = "Ninguno",
    Options = {"Ninguno"},
    Callback = function(v)
        selectedItemName = v
    end    
})
itemDropdown = UIElements.ItemDropdown

-- おもちゃリストをスキャンしてドロップダウンを更新する共通関数
local function refreshToyList()
    detectedItems = {}
    local myName = LocalPlayer.Name
    local allMyItems = {}
    local plotsFolder = Workspace:FindFirstChild("Plots")
    local plotItemsFolder = Workspace:FindFirstChild("PlotItems")

    -- 0. Get items from SpawnedInToys
    local spawnedToys = Workspace:FindFirstChild(myName .. "SpawnedInToys")
    if spawnedToys then
        for _, item in ipairs(spawnedToys:GetChildren()) do
            table.insert(allMyItems, item)
        end
    end

    -- 1. Get items from my plot
    if plotsFolder and plotItemsFolder then
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            local ownerObj = sign and (sign:FindFirstChild("ThisPlotsOwners") or sign:FindFirstChild("Owner"))
            if ownerObj then
                local val = ownerObj:FindFirstChild("Value") or ownerObj
                local data = val:FindFirstChild("Data") or val
                if (data:IsA("StringValue") and data.Value == myName) then
                    local myPlotName = plot.Name
                    local targetFolder = plotItemsFolder:FindFirstChild(myPlotName)
                    if targetFolder then
                        for _, item in ipairs(targetFolder:GetChildren()) do
                            table.insert(allMyItems, item)
                        end
                        -- ★このフォルダの増減を監視開始 (初回のみ)
                        if not _G.ToyWatcher then
                            _G.ToyWatcher = true
                            targetFolder.ChildAdded:Connect(function() task.wait(0.1) refreshToyList() end)
                            targetFolder.ChildRemoved:Connect(function() task.wait(0.1) refreshToyList() end)
                        end
                    end
                    break
                end
            end
        end
    end

    -- 2. Get items directly from Workspace that I own
    for _, item in ipairs(Workspace:GetChildren()) do
        local ownerValue = item:FindFirstChild("Owner") or item:FindFirstChild("PartOwner")
        if item:IsA("Model") and ownerValue and ownerValue:IsA("StringValue") and ownerValue.Value == myName and not table.find(allMyItems, item) then
             table.insert(allMyItems, item)
        end
    end

    -- 3. Process all found items to create the name list
    for _, item in ipairs(allMyItems) do
        if item:IsA("Model") and item.PrimaryPart then
            local itemName = tostring(item.Name)
            if not table.find(detectedItems, itemName) then
                table.insert(detectedItems, itemName)
            end
        end
    end
    
    -- 4. Update dropdown
    local newValues = {"Todos los juguetes"}
    for _, name in ipairs(detectedItems) do table.insert(newValues, name) end
    itemDropdown:Refresh(newValues, true)
end

MainSec:AddButton({
    Name = "Actualizar lista de juguetes",
    Callback = function()
        refreshToyList()
        OrionLib:MakeNotification({ Name = "Actualización", Content = "Lista de juguetes reescaneada", Time = 3 })
    end
})

-- 起動時に一度実行
task.spawn(refreshToyList)

-- 合体モードトグル
UIElements.CombinedToggle = MainSec:AddToggle({
	Name = "Usar modo combinado",
	Default = false,
	Callback = function(v)
		combinedActive = v
	end    
})

-- --- アニメーションセクション ---
local AnimSec = MainTab:AddSection({
	Name = "Animación"
})

AnimSec:AddButton({
	Name = "Secuencia de transformación",
	Callback = function()
		task.spawn(function()
			local s = 1 / cfg.AnimSpeed
			currentMode = "MagicCircle"
			cfg.MagicCircle.Height = -10
			startEffect()
			for i = -10, 5, 0.5 do 
				cfg.MagicCircle.Height = i
				task.wait(0.2 * s) 
			end
			currentMode = "Merkaba"
			task.wait(6 * s)
			currentMode = "FloatStone"
			cfg.FloatStone.Chaos = true
			cfg.FloatStone.Size = 2
			for i = 2, 15, 0.5 do
				cfg.FloatStone.Size = i
				task.wait(0.05 * s)
			end
		end)
	end
})

AnimSec:AddButton({
	Name = "Oleada",
	Callback = function()
		task.spawn(function()
			local s = 1 / cfg.AnimSpeed
			currentMode = "MagicCircle"
			cfg.MagicCircle.Height = -3
			cfg.MagicCircle.Size = 5
			cfg.MagicCircle.Speed = 10
			startEffect()
			for i = 5, 30, 2 do
				cfg.MagicCircle.Size = i
				task.wait(0.09 * s)
			end
			currentMode = "Sphere"
			cfg.Sphere.Size = 30
			task.wait(1 * s)
			for i = 30, 3, 2 do
				cfg.Sphere.Size = i
				cfg.Sphere.Speed = (cfg.Sphere.Speed or 1) + 0.5
				task.wait(0.05 * s)
			end
			task.wait(0.9 * s)
			cfg.Sphere.Speed = 20
			for i = 3, 25, 3 do
				cfg.Sphere.Size = i
				task.wait(0.04 * s)
			end
			task.wait(1.5 * s)
			currentMode = "BackGuard"
			cfg.BackGuard.Back = 15
			cfg.BackGuard.Height = 5
			cfg.BackGuard.Size = 20
			cfg.BackGuard.Speed = 1
		end)
	end
})

-- --- TAB: MODE SETTINGS ---
local ModeSetTab = Window:MakeTab({
    Name = "Configuración de modo",
    Icon = "rbxassetid://8997386997"
})

local CombineSec = ModeSetTab:AddSection({
    Name = "Configuración de combinación"
})

UIElements.CombineMode1 = CombineSec:AddDropdown({
    Name = "Combinar: Modo 1",
    Default = "Wing",
    Options = {"Wing","Heart","Star","Vortex","Sphere","Rotate","Pet","Text","MagicCircle","MagicCircle2","MagicCircle3","FloatStone","Merkaba","Cube","MirrorPlayer","Beam","BackGuard"},
    Callback = function(v) cfg.Combined.Mode1 = v end
})

UIElements.CombineMode1Count = CombineSec:AddSlider({
    Name = "Cantidad Modo 1",
    Min = 1,
    Max = 200,
    Default = 20,
    Increment = 1,
    ValueName = "items",
    Callback = function(v) cfg.Combined.Mode1Count = v end    
})

UIElements.CombineMode2 = CombineSec:AddDropdown({
    Name = "Combinar: Modo 2",
    Default = "Rotate",
    Options = {"Wing","Heart","Star","Vortex","Sphere","Rotate","Pet","Text","MagicCircle","MagicCircle2","MagicCircle3","FloatStone","Merkaba","Cube","MirrorPlayer","Beam","BackGuard"},
    Callback = function(v) cfg.Combined.Mode2 = v end
})

UIElements.CombineMode2Count = CombineSec:AddSlider({
    Name = "Cantidad Modo 2",
    Min = 1,
    Max = 200,
    Default = 10,
    Increment = 1,
    ValueName = "items",
    Callback = function(v) cfg.Combined.Mode2Count = v end    
})

-- --- 共通設定エディタ (ドロップダウンで切り替え) ---
local EditSec = ModeSetTab:AddSection({
    Name = "Editor de configuración común"
})

local modes = {"Wing","Heart","Star","Vortex","Sphere","Rotate","Pet","Text","MagicCircle", "MagicCircle2", "MagicCircle3", "FloatStone", "Merkaba", "Cube", "MirrorPlayer", "Beam", "BackGuard"}

local currentEditMode = "Wing"
local sl_Speed, sl_Size, sl_Height, sl_Back

EditSec:AddDropdown({
    Name = "Editar modo objetivo",
    Default = "Wing",
    Options = modes,
    Callback = function(v)
        currentEditMode = v
        -- スライダーの値を更新
        if sl_Speed then sl_Speed:Set(cfg[v].Speed or 10) end
        if sl_Size then sl_Size:Set(cfg[v].Size or 10) end
        if sl_Height then sl_Height:Set(cfg[v].Height or 0) end
        if sl_Back then sl_Back:Set(cfg[v].Back or 0) end
    end
})

sl_Speed = EditSec:AddSlider({
    Name = "Velocidad", Min = 0, Max = 100, Default = cfg.Wing.Speed or 10,
    Callback = function(v) cfg[currentEditMode].Speed = v end
})
sl_Size = EditSec:AddSlider({
    Name = "Tamaño/Ancho", Min = 1, Max = 150, Default = cfg.Wing.Size or 10,
    Callback = function(v) cfg[currentEditMode].Size = v end
})
sl_Height = EditSec:AddSlider({
    Name = "Altura", Min = -50, Max = 50, Default = cfg.Wing.Height or 0,
    Callback = function(v) cfg[currentEditMode].Height = v end
})
sl_Back = EditSec:AddSlider({
    Name = "Profundidad", Min = -50, Max = 50, Default = cfg.Wing.Back or 0,
    Callback = function(v) cfg[currentEditMode].Back = v end
})

-- --- 詳細設定タブ (固有設定のみ) ---
local AdvTab = Window:MakeTab({
    Name = "Avanzado",
    Icon = "rbxassetid://7733771472"
})

for _, m in ipairs(modes) do
    -- 固有設定があるモードのみセクションを作成
    if m == "Wing" or m == "Pet" or m == "Text" or m == "MagicCircle2" or m == "MagicCircle3" or m == "MirrorPlayer" or m == "Beam" or m == "FloatStone" then
        local s = AdvTab:AddSection({ Name = m })
        
        if m == "Wing" then
            s:AddToggle({ Name = "Anclar raíz (Root Fixed)", Default = cfg.Wing.RootFixed, Callback = function(v) cfg.Wing.RootFixed = v end })
            s:AddSlider({ Name = "Distancia del cuerpo (Gap)", Min = 0, Max = 50, Default = cfg.Wing.Gap or 10, Callback = function(v) cfg.Wing.Gap = v end })
            s:AddSlider({ Name = "Articulaciones", Min = 0, Max = 10, Default = 3, Callback = function(v) cfg.Wing.Joints = v end })
            s:AddSlider({ Name = "Ángulo V (Adelante/Atrás)", Min = -180, Max = 180, Default = 0, Callback = function(v) cfg.Wing.V_Angle = v end })
            s:AddSlider({ Name = "Inclinación vertical", Min = -90, Max = 90, Default = 0, Callback = function(v) cfg.Wing.Tilt = v end })
            s:AddSlider({ Name = "Fuerza de aleteo", Min = 0, Max = 50, Default = 15, Callback = function(v) cfg.Wing.Strength = v end })
        
        elseif m == "Pet" then
            s:AddSlider({ Name = "Cantidad", Min = 1, Max = 10, Default = 2, Callback = function(v) cfg.Pet.Count = v end })
            s:AddSlider({ Name = "Articulaciones (Ondulación)", Min = 0, Max = 10, Default = 3, Callback = function(v) cfg.Pet.Joints = v end })
            s:AddSlider({ Name = "Dispersión horizontal (Gap)", Min = 1, Max = 20, Default = 13, Callback = function(v) cfg.Pet.Gap = v end })
        
        elseif m == "Text" then
            s:AddTextbox({ Name = "Mostrar texto", Default = "HELLO", TextDisappear = false, Callback = function(v) cfg.Text.Content = v end })
        
        elseif m == "MagicCircle2" then
            s:AddSlider({ Name = "Capas", Min = 1, Max = 5, Default = 3, Callback = function(v) cfg.MagicCircle2.Layers = v end })
        
        elseif m == "MagicCircle3" then
            s:AddSlider({ Name = "Complejidad", Min = 1, Max = 10, Default = 5, Callback = function(v) cfg.MagicCircle3.Complexity = v end })
        
        elseif m == "MirrorPlayer" then
            -- Orionは小数が苦手なので10倍で表示
            s:AddSlider({ Name = "Escala (x10)", Min = 1, Max = 100, Default = 10, Callback = function(v) cfg.MirrorPlayer.Scale = v/10 end })
            s:AddSlider({ Name = "Tamaño de caja (x10)", Min = 5, Max = 100, Default = 20, Callback = function(v) cfg.MirrorPlayer.Size = v/10 end })
            s:AddSlider({ Name = "Densidad de espaciado de bordes (x10)", Min = 5, Max = 30, Default = 10, Callback = function(v) cfg.MirrorPlayer.EdgeSpacing = v/10 end })
        
        elseif m == "Beam" then
            s:AddSlider({ Name = "Cantidad de rayos", Min = 1, Max = 20, Default = 8, Callback = function(v) cfg.Beam.Count = v end })
        
        elseif m == "FloatStone" then
            s:AddToggle({ Name = "Movimiento caótico", Default = false, Callback = function(v) cfg.FloatStone.Chaos = v end })
        end
    end
end

-- --- TAB: CONFIG / SETTINGS ---
local ConfigTab = Window:MakeTab({
    Name = "Global/Guardar",
    Icon = "rbxassetid://10734950309"
})

local GlobalSec = ConfigTab:AddSection({
    Name = "Sistema"
})

-- 1. 追従切り替え
UIElements.FollowToggle = GlobalSec:AddToggle({
    Name = "Seguir jugador",
    Default = true,
    Callback = function(v)
        followPlayer = v
    end
})

-- 0,0,0リセットボタン
GlobalSec:AddButton({
    Name = "Restablecer efecto a mundo 0,0,0",
    Callback = function()
        if not isEnabled then return end
        followPlayer = false 
        lastBaseCF = CFrame.new(0, 0, 0) 

        for i, fw in ipairs(activeToys) do
            task.spawn(function()
                fw.AP.Enabled = false 
                fw.Part.Anchored = true
                fw.Part.CFrame = CFrame.new(0, 0, 0)
                fw.AP.Position = Vector3.new(0, 0, 0) 
                fw.Part.AssemblyLinearVelocity = Vector3.zero
                
                task.wait(0.1)
                
                fw.AP.Enabled = true 
                fw.Part.Anchored = false
            end)
        end
    end
})

UIElements.OrientationSlider = GlobalSec:AddSlider({
    Name = "Orientación del juguete",
    Min = -180, Max = 180, Default = -90,
    Callback = function(v) GLOBAL_ANGLE = v end
})

UIElements.MaxToysSlider = GlobalSec:AddSlider({
    Name = "Máx. juguetes a usar",
    Min = 1, Max = 200, Default = cfg.Global.MaxToys or 100,
    Callback = function(v) cfg.Global.MaxToys = v end
})

UIElements.AutoWidthToggle = GlobalSec:AddToggle({
    Name = "Ancho automático",
    Default = true,
    Callback = function(v) autoWidth = v end
})

-- アニメ速度倍率 (小数のため10倍で処理)
UIElements.AnimSpeedSlider = GlobalSec:AddSlider({
    Name = "Velocidad de animación",
    Min = 1, Max = 50, Default = 10,
    Callback = function(v) cfg.AnimSpeed = v/10 end
})

-- --- 家制限時間リセット設定 ---
local ResetSec = ConfigTab:AddSection({
    Name = "Reinicio de límite de tiempo en casa"
})

ResetSec:AddParagraph("Descripción","Regresar periódicamente a la casa especificada por un momento para reiniciar el tiempo de estancia.")

UIElements.PlotReturnToggle = ResetSec:AddToggle({
    Name = "Activar auto-reinicio",
    Default = cfg.PlotReturn.Enabled,
    Callback = function(v)
        cfg.PlotReturn.Enabled = v
    end
})

UIElements.PlotReturnInterval = ResetSec:AddSlider({
    Name = "Intervalo (segundos)",
    Min = 10, Max = 85, 
    -- 安全な書き方に変更
    Default = (cfg and cfg.PlotReturn and cfg.PlotReturn.Interval) or 30,
    Callback = function(v) 
        if cfg and cfg.PlotReturn then 
            cfg.PlotReturn.Interval = v 
        end 
    end
})

-- この下の「帰還する家を選択」や「サブタブ」「ピアノ」が
-- これでようやく読み込まれるようになります。

UIElements.PlotReturnHouse = ResetSec:AddDropdown({
    Name = "Seleccionar casa para regresar",
    Default = "Ninguno",
    Options = {"Casa de Cerezos", "Casa Azul Claro", "Casa Morada", "Casa Verde", "Casa Rosa"},
    Callback = function(v)
        selectedHouseCF = houseCoords[v]
        if selectedHouseCF then
            OrionLib:MakeNotification({
                Name = "Configuración completa",
                Content = "Establecido " .. v .. " como punto de reinicio",
                Time = 5
            })
        end
    end
})

-- --- 座標管理システム ---
local CoordSec = ConfigTab:AddSection({
    Name = "Gestión de coordenadas/posición"
})

local CoordHUD = nil
local HUDLabel = nil

CoordSec:AddToggle({
    Name = "Mostrar siempre coordenadas en ventana separada",
    Default = false,
    Callback = function(state)
        if state then
            if not CoordHUD then
                CoordHUD = Instance.new("ScreenGui")
                CoordHUD.Name = "HolonHUD_Coords"
                CoordHUD.Parent = (game:GetService("CoreGui"):FindFirstChild("RobloxGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(0, 180, 0, 35)
                Frame.Position = UDim2.new(0.5, -90, 0.05, 0)
                Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                Frame.BackgroundTransparency = 0.4
                Frame.BorderSizePixel = 0
                Frame.Active = true
                Frame.Draggable = true 
                Frame.Parent = CoordHUD
                
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 8)
                Corner.Parent = Frame

                HUDLabel = Instance.new("TextLabel")
                HUDLabel.Size = UDim2.new(1, 0, 1, 0)
                HUDLabel.BackgroundTransparency = 1
                HUDLabel.TextColor3 = Color3.new(1, 1, 1)
                HUDLabel.Font = Enum.Font.Code
                HUDLabel.TextSize = 16
                HUDLabel.Text = "X: 0 | Y: 0 | Z: 0"
                HUDLabel.Parent = Frame
            end
            CoordHUD.Enabled = true
        else
            if CoordHUD then CoordHUD.Enabled = false end
        end
    end
})

CoordSec:AddButton({
    Name = "Copiar coordenadas actuales",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            local p = root.Position
            local posString = string.format("%d, %d, %d", math.round(p.X), math.round(p.Y), math.round(p.Z))
            setclipboard(posString)
            OrionLib:MakeNotification({
                Name = "Copia completa",
                Content = posString,
                Time = 5
            })
        end
    end
})

----- データ管理 ---
local SaveSec = ConfigTab:AddSection({Name = "Gestión de datos (Actualización en tiempo real)"})

-- 1. ドロップダウンを変数として定義（後で中身を書き換えるため）
local fileDropdown

fileDropdown = SaveSec:AddDropdown({
    Name = "Seleccionar archivo guardado",
    Default = "Por favor seleccione",
    Options = getConfigFileList(),
    Callback = function(v) 
        selectedFile = v 
    end
})

-- 2. 読み込みボタン（読み込んだ瞬間に見た目を更新）
SaveSec:AddButton({
    Name = "Cargar archivo seleccionado",
    Callback = function()
        if selectedFile and selectedFile ~= "Sin archivos" then
            local path = "holon_config/" .. selectedFile
            if isfile(path) then
                local success, data = pcall(function() 
                    return HttpService:JSONDecode(readfile(path)) 
                end)
                
                if success then
                    cfg = data
                    
                    -- 保存された設定をローカル変数に反映
                    if cfg.LocalSettings then
                        local s = cfg.LocalSettings
                        walkSpeed = s.WalkSpeed or 16
                        jumpPower = s.JumpPower or 25
                        useWalkSpeed = s.UseWalkSpeed or false
                        useJumpPower = s.UseJumpPower or false
                        infiniteJump = s.InfiniteJump or false
                        noclip = s.Noclip or false
                        antiExplosion = s.AntiExplosion or false
                        antiFire = s.AntiFire or false
                        antiGrab = s.AntiGrab or false
                        currentMode = s.CurrentMode or "Wing"
                        combinedActive = s.CombinedActive or false
                        followPlayer = s.FollowPlayer or true
                        GLOBAL_ANGLE = s.GlobalAngle or -90
                        autoWidth = s.AutoWidth or true
                        if s.Esp then espCfg = s.Esp end
                        
                        -- ★UI要素の見た目を更新 (Setメソッドを使用)
                        if UIElements.WalkSpeedSlider then UIElements.WalkSpeedSlider:Set(walkSpeed) end
                        if UIElements.WalkSpeedToggle then UIElements.WalkSpeedToggle:Set(useWalkSpeed) end
                        if UIElements.JumpPowerSlider then UIElements.JumpPowerSlider:Set(jumpPower) end
                        if UIElements.JumpPowerToggle then UIElements.JumpPowerToggle:Set(useJumpPower) end
                        if UIElements.NoclipToggle then UIElements.NoclipToggle:Set(noclip) end
                        if UIElements.InfiniteJumpToggle then UIElements.InfiniteJumpToggle:Set(infiniteJump) end
                        if UIElements.AntiExplosionToggle then UIElements.AntiExplosionToggle:Set(antiExplosion) end
                        if UIElements.AntiFireToggle then UIElements.AntiFireToggle:Set(antiFire) end
                        if UIElements.AntiGrabToggle then UIElements.AntiGrabToggle:Set(antiGrab) end
                        if UIElements.AntiGucciToggle then UIElements.AntiGucciToggle:Set(false) end -- 安全のためOFF
                        if UIElements.EffectToggle then UIElements.EffectToggle:Set(isEnabled) end
                        if UIElements.ModeDropdown then UIElements.ModeDropdown:Set(currentMode) end
                        if UIElements.CombinedToggle then UIElements.CombinedToggle:Set(combinedActive) end
                        if UIElements.FollowToggle then UIElements.FollowToggle:Set(followPlayer) end
                        if UIElements.OrientationSlider then UIElements.OrientationSlider:Set(GLOBAL_ANGLE) end
                        if UIElements.MaxToysSlider then UIElements.MaxToysSlider:Set(cfg.Global.MaxToys) end
                        if UIElements.AutoWidthToggle then UIElements.AutoWidthToggle:Set(autoWidth) end
                        if UIElements.AnimSpeedSlider then UIElements.AnimSpeedSlider:Set(cfg.AnimSpeed * 10) end
                        if UIElements.PlotReturnToggle then UIElements.PlotReturnToggle:Set(cfg.PlotReturn.Enabled) end
                        if UIElements.PlotReturnInterval then UIElements.PlotReturnInterval:Set(cfg.PlotReturn.Interval) end
                        
                        -- ESP設定の反映
                        if UIElements.EspEnabled then UIElements.EspEnabled:Set(espCfg.Enabled) end
                        if UIElements.EspTargetOnly then UIElements.EspTargetOnly:Set(espCfg.TargetOnly) end
                        if UIElements.EspNames then UIElements.EspNames:Set(espCfg.Names) end
                        if UIElements.EspTracers then UIElements.EspTracers:Set(espCfg.Tracers) end
                        if UIElements.EspHitbox then UIElements.EspHitbox:Set(espCfg.Hitbox) end
                        if UIElements.EspHitboxSize then UIElements.EspHitboxSize:Set(espCfg.HitboxSize) end
                        if UIElements.EspColor then UIElements.EspColor:Set(espCfg.ESPColor) end
                        
                        -- 合体設定の反映
                        if UIElements.CombineMode1 then UIElements.CombineMode1:Set(cfg.Combined.Mode1) end
                        if UIElements.CombineMode1Count then UIElements.CombineMode1Count:Set(cfg.Combined.Mode1Count) end
                        if UIElements.CombineMode2 then UIElements.CombineMode2:Set(cfg.Combined.Mode2) end
                        if UIElements.CombineMode2Count then UIElements.CombineMode2Count:Set(cfg.Combined.Mode2Count) end
                        
                        -- 追加項目の反映
                        vflyEnabled = s.VFlyEnabled or false
                        vflySpeed = s.VFlySpeed or 1
                        local isThirdPerson = s.ThirdPerson or false
                        local savedFOV = s.FOV or 70
                        targetMainName = s.TargetMainName or ""
                        targetSubName = s.TargetSubName or ""
                        selectedItemName = s.SelectedItemName or "Todos los juguetes"
                        pianoEnabled = s.PianoEnabled or false
                        pianoFollowEnabled = s.PianoFollowEnabled or true

                        if UIElements.VFlyToggle then UIElements.VFlyToggle:Set(vflyEnabled) end
                        if UIElements.VFlySpeedSlider then UIElements.VFlySpeedSlider:Set(vflySpeed) end
                        if UIElements.ThirdPersonToggle then UIElements.ThirdPersonToggle:Set(isThirdPerson) end
                        if UIElements.FOVSlider then UIElements.FOVSlider:Set(savedFOV) end
                        if UIElements.ItemDropdown then UIElements.ItemDropdown:Set(selectedItemName) end
                        if UIElements.PianoEnabled then UIElements.PianoEnabled:Set(pianoEnabled) end
                        if UIElements.PianoFollow then UIElements.PianoFollow:Set(pianoFollowEnabled) end

                        -- ターゲットドロップダウンの復元（リストから検索）
                        local function restoreDropdown(dd, name)
                            if dd and name ~= "" then
                                for _, opt in ipairs(getPList()) do
                                    if opt:match("@" .. name .. "%)") then dd:Set(opt) break end
                                end
                            end
                        end
                        restoreDropdown(UIElements.MainTargetDropdown, targetMainName)
                        restoreDropdown(UIElements.SubTargetDropdown, targetSubName)
                        
                        -- ★UI設定の復元
                        if not cfg.UI then
                            cfg.UI = {
                                Transparency = 0.1,
                                BackgroundColor = Color3.fromRGB(25, 25, 25),
                                AccentColor = Color3.fromRGB(128, 128, 128),
                                BackgroundImage = ""
                            }
                        end
                        
                        if UIElements.UITransparency then UIElements.UITransparency:Set((cfg.UI.Transparency or 0.1) * 100) end
                        if UIElements.UIBackgroundColor then UIElements.UIBackgroundColor:Set(cfg.UI.BackgroundColor or Color3.fromRGB(25, 25, 25)) end
                        if UIElements.UIAccentColor then UIElements.UIAccentColor:Set(cfg.UI.AccentColor or Color3.fromRGB(128, 128, 128)) end
                        if UIElements.UIBackgroundImage then UIElements.UIBackgroundImage:Set(cfg.UI.BackgroundImage or "") end
                    end

                    -- ★ここでリアルタイムにUIの見た目（カラー・透明度・画像）を更新
                    applyCustomStyle() 
                    OrionLib:MakeNotification({Name = "Éxito", Content = "Aplicado " .. selectedFile, Time = 3})
                else
                    OrionLib:MakeNotification({Name = "Error", Content = "Error al cargar el archivo", Time = 3})
                end
            end
        end
    end
})

SaveSec:AddTextbox({
    Name = "Nombre del nuevo archivo de guardado",
    Default = "config1",
    TextDisappear = false,
    Callback = function(v) saveName = v end
})

-- 3. 保存ボタン（保存した瞬間にドロップダウンを更新）
SaveSec:AddButton({
    Name = "Guardar configuración actual",
    Callback = function()
        if saveName and saveName ~= "" then
            if not isfolder("holon_config") then makefolder("holon_config") end
            local path = "holon_config/" .. saveName .. ".json"
            
            -- ローカル変数の状態をcfgに同期させてから保存
            cfg.LocalSettings = {
                WalkSpeed = walkSpeed,
                JumpPower = jumpPower,
                UseWalkSpeed = useWalkSpeed,
                UseJumpPower = useJumpPower,
                InfiniteJump = infiniteJump,
                Noclip = noclip,
                AntiExplosion = antiExplosion,
                AntiFire = antiFire,
                AntiGrab = antiGrab,
                CurrentMode = currentMode,
                CombinedActive = combinedActive,
                FollowPlayer = followPlayer,
                GlobalAngle = GLOBAL_ANGLE,
                AutoWidth = autoWidth,
                Esp = espCfg, -- ESP設定(テーブル)も保存
                -- 追加保存項目
                VFlyEnabled = vflyEnabled,
                VFlySpeed = vflySpeed,
                ThirdPerson = (LocalPlayer.CameraMode == Enum.CameraMode.Classic),
                FOV = Camera.FieldOfView,
                TargetMainName = targetMainName,
                TargetSubName = targetSubName,
                SelectedItemName = selectedItemName,
                PianoEnabled = pianoEnabled,
                PianoFollowEnabled = pianoFollowEnabled
            }

            writefile(path, HttpService:JSONEncode(cfg))
            
            -- ★ここがポイント：保存した直後にドロップダウンのリストを最新にする
            fileDropdown:Refresh(getConfigFileList(), true)
            
            OrionLib:MakeNotification({
                Name = "Guardado completo", 
                Content = "Guardado " .. saveName .. ".json y lista actualizada", 
                Time = 3
            })
        end
    end
})

-- --- UI外観設定 ---
local UISec = ConfigTab:AddSection({Name = "Configuración de apariencia/color de UI"})

UIElements.UITransparency = UISec:AddSlider({
    Name = "Transparencia de UI",
    Min = 0, Max = 100, Default = 0,
    Callback = function(v)
        cfg.UI.Transparency = v / 100
        applyCustomStyle()
    end
})

-- 以降、cfg.UI が存在するので消えずに表示されます
UIElements.UIBackgroundColor = UISec:AddColorpicker({
    Name = "Color de fondo",
    Default = cfg.UI.BackgroundColor,
    Callback = function(v)
        cfg.UI.BackgroundColor = v
        applyCustomStyle()
    end
})

UIElements.UIAccentColor = UISec:AddColorpicker({
    Name = "Color de borde (Acento)",
    Default = cfg.UI.AccentColor,
    Callback = function(v)
        cfg.UI.AccentColor = v
        applyCustomStyle()
    end
})

UIElements.UIBackgroundImage = UISec:AddTextbox({
    Name = "ID de imagen de fondo (Solo números)",
    Default = cfg.UI.BackgroundImage,
    TextDisappear = false,
    Callback = function(v)
        -- 数字以外の文字を除去して、数値のみ取り出す
        local id = v:match("%d+") 
        if id then
            -- Decal IDをImage IDとして読み込ませるためのURL形式
            -- ※Robloxの内部処理で自動変換を促す書き方です
            cfg.UI.BackgroundImage = "rbxassetid://" .. id
        else
            cfg.UI.BackgroundImage = ""
        end
        
        applyCustomStyle()
    end
})

-- --- TAB: SUB FEATURES ---
local SubTab = Window:MakeTab({
    Name = "Sub-funciones",
    Icon = "rbxassetid://10747372167"
})

-- サブターゲットセクション
local SubTargetSec = SubTab:AddSection({
    Name = "Sub-objetivo"
})

-- 1. ドロップダウンの作成
local targetSubName = "" 

UIElements.SubTargetDropdown = SubTargetSec:AddDropdown({
    Name = "Seleccionar objetivo",
    Default = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")",
    Options = getPList(),
    Callback = function(v)
        -- @以降のユーザー名を正確に切り出す
        local name = v:match("@([^)]+)")
        targetSubName = name or LocalPlayer.Name
        
        -- 即座に最新のオブジェクトも一度取得しておく（既存コードとの互換性のため）
        targetSub = Players:FindFirstChild(targetSubName) or LocalPlayer
    end    
})
pDropSub = UIElements.SubTargetDropdown

Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    pDropSub:Refresh(getPList(), true)
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.5)
    pDropSub:Refresh(getPList(), true)
end)

SubTargetSec:AddButton({
    Name = "Actualizar lista de jugadores",
    Callback = function()
        pDropSub:Refresh(getPList(), true)
        OrionLib:MakeNotification({ Name = "Actualización", Content = "Lista de jugadores actualizada", Time = 3 })
    end
})

-- 視点・カメラセクション
local ViewSec = SubTab:AddSection({
    Name = "Vista/Cámara"
})

ViewSec:AddToggle({
    Name = "Espectador",
    Default = false,
    Callback = function(v) 
        if v then 
            RunService:BindToRenderStep("Jack", Enum.RenderPriority.Camera.Value + 1, function() 
                if targetSub and targetSub.Character and targetSub.Character:FindFirstChild("Humanoid") then 
                    Camera.CameraSubject = targetSub.Character.Humanoid 
                end 
            end)
        else 
            RunService:UnbindFromRenderStep("Jack")
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                Camera.CameraSubject = LocalPlayer.Character.Humanoid 
            end
        end
    end 
})

-- ESP設定セクション
local EspSec = SubTab:AddSection({
    Name = "Configuración ESP"
})

UIElements.EspEnabled = EspSec:AddToggle({
    Name = "Activar ESP",
    Default = false,
    Callback = function(v) espCfg.Enabled = v end 
})

UIElements.EspTargetOnly = EspSec:AddToggle({
    Name = "Solo objetivo",
    Default = false,
    Callback = function(v) espCfg.TargetOnly = v end 
})

UIElements.EspNames = EspSec:AddToggle({
    Name = "Mostrar nombres",
    Default = true,
    Callback = function(v) espCfg.Names = v end 
})

UIElements.EspTracers = EspSec:AddToggle({
    Name = "Mostrar trazadores",
    Default = false,
    Callback = function(v) espCfg.Tracers = v end 
})

UIElements.EspHitbox = EspSec:AddToggle({
    Name = "Hitbox",
    Default = false,
    Callback = function(v) espCfg.Hitbox = v end 
})

UIElements.EspHitboxSize = EspSec:AddSlider({
    Name = "Tamaño de Hitbox",
    Min = 2,
    Max = 20,
    Default = 10,
    Callback = function(v) espCfg.HitboxSize = v end 
})

UIElements.EspColor = EspSec:AddColorpicker({
    Name = "Color ESP",
    Default = Color3.new(1,0,0),
    Callback = function(v)
        espCfg.ESPColor = v
    end	  
})

local BarrierSec = SubTab:AddSection({
    Name = "Romper barrera"
})

local destroyBarrier = false
UIElements.BarrierBreak = BarrierSec:AddToggle({
    Name = "Romper barrera de casa (En progreso)",
    Default = false,
    Callback = function(v)
        destroyBarrier = v
        if v then
            task.spawn(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChild("Humanoid")
                local originalWs = hum and hum.WalkSpeed or 16
                
                if hum then hum.WalkSpeed = 0 end
                
                while destroyBarrier and LocalPlayer.Character do
                    local mt = ReplicatedStorage:FindFirstChild("MenuToys")
                    local st = mt and mt:FindFirstChild("SpawnToyRemoteFunction")
                    
                    if st then
                        pcall(function()
                            st:InvokeServer("ToyOcarina", CFrame.new(184.148834, -5.54824972, 0))
                        end)
                    end
                    task.wait(1.5)
                end
                
                if hum then hum.WalkSpeed = originalWs end
            end)
        end
    end
})

local ActionSec = SubTab:AddSection({ Name = "Acciones" })

local tpTargetName = ""
tpDropdown = ActionSec:AddDropdown({
    Name = "Objetivo de teletransporte",
    Default = "Seleccionar jugador",
    Options = getPList(),
    Callback = function(v)
        tpTargetName = v:match("@([^)]+)")
    end
})

ActionSec:AddButton({
    Name = "Teletransportarse al jugador seleccionado",
    Callback = function()
        local targetName = (tpTargetName ~= "" and tpTargetName) or (targetSub and targetSub.Name)
        local target = Players:FindFirstChild(targetName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        end
    end
})

local levitateRunning = false
UIElements.BlobmanKick = ActionSec:AddToggle({
    Name = "Patada Blobman (Spamear)",
    Default = false,
    Callback = function(v)
        levitateRunning = v
        if not v then return end

        local targetName = (tpTargetName ~= "" and tpTargetName) or (targetSub and targetSub.Name)
        local target = Players:FindFirstChild(targetName)
        
        if target and target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Blobmanを探す
            local blobman = nil
            local spawned = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
            if spawned then blobman = spawned:FindFirstChild("CreatureBlobman") end
            
            if not blobman then
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj.Name == "CreatureBlobman" and obj:FindFirstChild("VehicleSeat") then
                        blobman = obj
                        break
                    end
                end
            end
            
            if blobman then
                -- 1. Remoteを探す (Cosmic仕様)
                local scriptObj = blobman:FindFirstChild("BlobmanSeatAndOwnerScript")
                local grabRemote = scriptObj and scriptObj:FindFirstChild("CreatureGrab")
                local dropRemote = scriptObj and scriptObj:FindFirstChild("CreatureDrop")

                -- 2. DetectorとWeld/Constraintを探す (左右対応)
                local lDet = blobman:FindFirstChild("LeftDetector")
                local rDet = blobman:FindFirstChild("RightDetector")
                local lWeld = lDet and (lDet:FindFirstChild("LeftWeld") or lDet:FindFirstChild("RigidConstraint"))
                local rWeld = rDet and (rDet:FindFirstChild("RightWeld") or rDet:FindFirstChild("RigidConstraint"))
                
                -- Auto Sit (Cosmic Style)
                local seat = blobman:FindFirstChild("VehicleSeat")
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                if seat and hum then
                    if seat.Occupant ~= hum then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
                        seat:Sit(hum)
                        task.wait(0.3)
                    end
                end
                
                if grabRemote and dropRemote and ((lDet and lWeld) or (rDet and rWeld)) then
                    OrionLib:MakeNotification({ Name = "Ejecutando", Content = "Bucle de agarre de Blobman", Time = 3 })

                    task.spawn(function()
                        while levitateRunning and blobman and blobman.Parent do
                            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                                local tRoot = target.Character.HumanoidRootPart
                                
                                -- まだ固定されていない（捕獲前）なら捕まえに行く
                                if blobman.PrimaryPart and not blobman.PrimaryPart.Anchored then
                                    -- 1. Force TP to Target
                                    blobman.PrimaryPart.Anchored = false
                                    blobman:SetPrimaryPartCFrame(tRoot.CFrame)
                                    
                                    -- 2. Grab with BOTH hands (両手で掴む)
                                    if lDet and lWeld then grabRemote:FireServer(lDet, tRoot, lWeld) end
                                    if rDet and rWeld then grabRemote:FireServer(rDet, tRoot, rWeld) end
                                    
                                    task.wait(0.1)
                                    
                                    -- 3. TP Up 100 studs & Stop (上空100で固定)
                                    blobman:SetPrimaryPartCFrame(tRoot.CFrame + Vector3.new(0, 100, 0))
                                    blobman.PrimaryPart.AssemblyLinearVelocity = Vector3.zero
                                    blobman.PrimaryPart.AssemblyAngularVelocity = Vector3.zero
                                    blobman.PrimaryPart.Anchored = true
                                else
                                    -- 既に固定されているなら掴み状態を維持（念のため再送信）
                                    if lDet and lWeld then grabRemote:FireServer(lDet, tRoot, lWeld) end
                                    if rDet and rWeld then grabRemote:FireServer(rDet, tRoot, rWeld) end
                                end
                            end
                            task.wait(0.05)
                        end
                        
                        -- 終了時に固定解除
                        if blobman and blobman.PrimaryPart then
                            blobman.PrimaryPart.Anchored = false
                        end
                    end)
                else
                    -- 詳細なエラー内容を表示
                    local missing = {}
                    if not grabRemote then table.insert(missing, "CreatureGrab") end
                    if not dropRemote then table.insert(missing, "CreatureDrop") end
                    if not (lDet or rDet) then table.insert(missing, "Detector") end
                    if not (lWeld or rWeld) then table.insert(missing, "Weld/Constraint") end
                    OrionLib:MakeNotification({ Name = "Error", Content = "Faltante: " .. table.concat(missing, ", "), Time = 5 })
                end
            else
                OrionLib:MakeNotification({ Name = "Error", Content = "Blobman no encontrado (Por favor genera un juguete)", Time = 3 })
            end
        end
    end
})

-- --- TAB: PIANO ---
local PianoTab = Window:MakeTab({
	Name = "Piano",
	Icon = "rbxassetid://7734020554"
})

local PianoControlSec = PianoTab:AddSection({
	Name = "Control de piano"
})

UIElements.PianoEnabled = PianoControlSec:AddToggle({
	Name = "Activar piano",
	Default = false,
	Callback = function(v)
		pianoEnabled = v
		if v then
			-- 機能を有効にするだけ。追従の開始は追従トグルに任せる
			pianoKeyboard = getMusicKeyboard()
			
			if pianoKeyboard then
				-- 追従がオンの場合のみ開始
				if pianoFollowEnabled then setupPianoFollow() end

				OrionLib:MakeNotification({
					Name = "Función de Piano",
					Content = "MusicKeyboard detectado",
					Time = 5
				})
			else
				pianoEnabled = false
				OrionLib:MakeNotification({
					Name = "Error",
					Content = "MusicKeyboard no encontrado",
					Time = 5
				})
			end
		else
			stopSong()
			stopPiano() -- 追従を停止
		end
	end    
})

UIElements.PianoFollow = PianoControlSec:AddToggle({
    Name = "Seguir jugador",
    Default = true,
    Callback = function(v)
        pianoFollowEnabled = v
        -- ★修正: pianoKeyboardが有効か(Parentを持つか)もチェックする
        if pianoEnabled and pianoKeyboard and pianoKeyboard.Parent then
            if v then
                setupPianoFollow()
            else
                stopPiano()
            end
        -- ★追加: ピアノが無効な状態で追従をオンにしたら、再検索して追従を開始
        elseif pianoEnabled and v then
            pianoKeyboard = getMusicKeyboard()
            if pianoKeyboard then
                setupPianoFollow()
            end
        end
    end
})

local PianoSongSec = PianoTab:AddSection({
	Name = "Reproducción de canción"
})

-- JSONファイル一覧を取得
local function getSongFiles()
	local files = {}
	local targetFolder = "FTAP_Notes"
	
    -- 安全にフォルダ確認 (エラーで止まらないようにpcallを使用)
    local folderExists = false
    pcall(function()
        if isfolder and isfolder(targetFolder) then
            folderExists = true
        end
    end)

    if not folderExists then
        return {"Carpeta no encontrada"}
    end
	
	local success, allFiles = pcall(function()
		return listfiles(targetFolder)
	end)
	
	if not success or not allFiles then
		return {"Error de acceso"}
	end
	
	for _, filePath in ipairs(allFiles) do
		if filePath:lower():match("%.json$") then
			local fileName = filePath:match("([^/%\\]+)$") or filePath
			table.insert(files, fileName) -- OrionのDropdown用に名前のみ追加
		end
	end
	
	if #files == 0 then
		return {"Sin archivos JSON"}
	end
	
	return files
end

local songDropdown = PianoSongSec:AddDropdown({
	Name = "Seleccionar canción",
	Default = "Ninguno",
	Options = getSongFiles(),
	Callback = function(v)
		if v == "Ninguno" or v == "Carpeta no encontrada" or v == "Sin archivos JSON" then
			selectedSongFile = nil
			selectedSongData = nil
			return
		end
		
		-- ファイル名からフルパスを作成（環境に合わせて調整してください）
		local filePath = "FTAP_Notes/" .. v
		selectedSongFile = filePath
		
		local success, fileContent = pcall(function()
			return readfile(filePath)
		end)
		
		if success then
			local decodeSuccess, jsonData = pcall(function()
				return HttpService:JSONDecode(fileContent)
			end)
			
			if decodeSuccess then
				selectedSongData = jsonData
				OrionLib:MakeNotification({
					Name = "Carga completa",
					Content = "Conteo de notas: " .. #jsonData,
					Time = 5
				})
			else
				selectedSongData = nil
			end
		end
	end    
})

PianoSongSec:AddButton({
	Name = "Actualizar lista de canciones",
	Callback = function()
		songDropdown:Refresh(getSongFiles(), true)
		OrionLib:MakeNotification({
			Name = "Actualización completa",
			Content = "Lista de archivos JSON actualizada",
			Time = 5
		})
	end
})

PianoSongSec:AddButton({
    Name = "Reproducir canción seleccionada",
    Callback = function()
        -- ピアノ有効化のチェックを「テストボタン」と同じくらい緩くします
        if not pianoKeyboard then
            pianoKeyboard = getMusicKeyboard()
        end
        
        if not pianoKeyboard then
            OrionLib:MakeNotification({Name = "Error", Content = "MusicKeyboard no encontrado", Time = 5})
            return
        end
        
        if not selectedSongData then
            OrionLib:MakeNotification({Name = "Error", Content = "Por favor seleccione una canción", Time = 5})
            return
        end
        
        -- ★修正ポイント：JSONEncodeせずに、そのままデータを渡す
        -- これで playSongFromJSON が正しくループを開始できます
        playSongFromJSON(selectedSongData)
        
        -- ボタンが反応したことを知らせる通知
        OrionLib:MakeNotification({
            Name = "Reproducción automática",
            Content = "Reproducción iniciada",
            Time = 3
        })
    end
})

PianoSongSec:AddButton({
	Name = "Detener reproducción",
	Callback = function()
		stopSong()
		OrionLib:MakeNotification({
			Name = "Detener",
			Content = "Reproducción de canción detenida",
			Time = 5
		})
	end
})

local PianoManualSec = PianoTab:AddSection({
    Name = "Operación manual y pruebas"
})

-- PianoManualSecの下に追加
PianoManualSec:AddButton({
    Name = "Prueba: Presionar tecla C",
    Callback = function()
        if pianoKeyboard then
            local testKey = pianoKeyboard:FindFirstChild("Key1C", true)
            if testKey then
                -- 音を鳴らす命令
                SetNetworkOwner:FireServer(testKey, testKey.CFrame)
                
                --   waitの後にすぐ通知が来るようにします。
                task.wait(0.1)
                
                OrionLib:MakeNotification({
                    Name = "Prueba", 
                    Content = "¡Tecla Key1C tocada!", 
                    Time = 2
                })
            else
                warn("Key1C no encontrada")
            end
        end
    end
})

local DetailTab = Window:MakeTab({Name = "Detalles", Icon = DetailIcon})
AddDetailContent(DetailTab)

-- 通知（起動時）
OrionLib:MakeNotification({
	Name = "Holon HUB",
	Content = "¡Holon HUB v1.3.5 ha sido cargado!",
	Time = 5
})
    -- 起動時にUIスタイルを適用
    applyCustomStyle()

    -- メイン画面側の初期化
    OrionLib:Init()
end

if isfile(KeyFileName) and readfile(KeyFileName) == CorrectKey then
    -- 認証済みなら即メインへ
    StartHolonHUB()
else
    -- 未認証なら認証UIを作る
    local OrionLib = loadstring(game:HttpGet(OrionUrl))()
    
    local AuthWindow = OrionLib:MakeWindow({
        Name = "Holon HUB | Sistema de Llaves",
        HidePremium = true,
        IntroEnabled = false
    })

    local AuthTab = AuthWindow:MakeTab({Name = "Autenticación", Icon = "rbxassetid://7733919526"})
    local KeyInput = ""

    AuthTab:AddTextbox({
        Name = "Ingresar llave",
        Default = "",
        TextDisappear = false, -- ここを false に変更
        Callback = function(Value) 
            KeyInput = Value 
        end     
    })

    AuthTab:AddButton({
        Name = "Autenticar",
        Callback = function()
            if KeyInput == CorrectKey then
                writefile(KeyFileName, CorrectKey) -- ここで保存
                OrionLib:MakeNotification({Name = "Éxito", Content = "¡Iniciando!", Time = 2})
                task.wait(1)
                pcall(function() game.CoreGui.Orion:Destroy() end)
                task.wait(0.5)
                StartHolonHUB()
            else
                OrionLib:MakeNotification({Name = "Fallo", Content = "Llave incorrecta", Time = 5})
            end
        end
    })

    AuthTab:AddButton({
        Name = "Obtener llave (Discord)",
        Callback = function() setclipboard("https://discord.gg/EHBXqgZZYN") end
    })

    -- 詳細タブ
    local AuthDetailTab = AuthWindow:MakeTab({Name = "Detalles", Icon = DetailIcon})
    AddDetailContent(AuthDetailTab)
    
    OrionLib:Init()
end
