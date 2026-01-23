local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- test.lua থেকে ইভেন্ট সংজ্ঞা
local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents")
local SetNetworkOwner = GrabEvents:WaitForChild("SetNetworkOwner")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- লেখকের তথ্য
local AuthorName = "holon_calm"
local RobloxID = "najayou777"
local DetailIcon = "rbxassetid://7733964719"

-- লিঙ্ক সংগ্রহের জন্য সাধারণ ফাংশন (প্রমাণীকরণ এবং প্রধান স্ক্রিনে ব্যবহারযোগ্য)
local function AddDetailContent(Tab)
    Tab:AddButton({
        Name = "ইংরেজি সংস্করণ অনুলিপি করুন এবং চালু করুন",
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
            OrionLib:MakeNotification({Name = "লিঙ্ক", Content = "TikTok লিঙ্ক ক্লিপবোর্ডে অনুলিপি করা হয়েছে", Time = 3})
        end
    })
    
    Tab:AddButton({
        Name = "Discord",
        Callback = function()
            setclipboard("https://discord.gg/EHBXqgZZYN")
            OrionLib:MakeNotification({Name = "লিঙ্ক", Content = "Discord আমন্ত্রণ লিঙ্ক ক্লিপবোর্ডে অনুলিপি করা হয়েছে", Time = 3})
        end
    })
    
    Tab:AddButton({
        Name = "YouTube",
        Callback = function()
            setclipboard("https://www.youtube.com/@Holoncalm")
            OrionLib:MakeNotification({Name = "লিঙ্ক", Content = "YouTube লিঙ্ক ক্লিপবোর্ডে অনুলিপি করা হয়েছে", Time = 3})
        end
    })
    Tab:AddLabel("লেখক: " .. AuthorName)
    Tab:AddLabel("Roblox আইডি: " .. RobloxID)
end

-- BodyMover তৈরির ফাংশন
local function createBodyMovers(part)
    -- বিদ্যমান Mover থাকলে মুছে ফেলুন
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
    -- নাম থেকে "বর্তমান" খেলোয়াড়কে আবার খুঁজুন
    return Players:FindFirstChild(targetMainName) or LocalPlayer
end

-- স্বয়ংক্রিয়ভাবে প্লট অবস্থান পাওয়ার ফাংশন
local function getMyPlotCFrame()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then 
        warn("Holon HUB: ওয়ার্কস্পেসে Plots ফোল্ডার পাওয়া যায়নি")
        return nil 
    end

    local myName = LocalPlayer.Name

    for _, plot in ipairs(plots:GetChildren()) do
        -- গঠন: Plot○ -> PlotSign -> ThisPlotsOwners -> Value -> Data -> Value
        local plotSign = plot:FindFirstChild("PlotSign")
        local ownerValObj = plotSign and plotSign:FindFirstChild("ThisPlotsOwners")
        local valueFolder = ownerValObj and ownerValObj:FindFirstChild("Value")
        local dataObj = valueFolder and valueFolder:FindFirstChild("Data")

        -- Data.Value (StringValue) এর বিষয়বস্তু পরীক্ষা করুন
        if dataObj and dataObj:IsA("StringValue") then
            if dataObj.Value == myName then
                print("Holon HUB: প্লট পাওয়া গেছে! লক্ষ্য:", plot.Name)
                return plot:GetPivot() -- প্লটের কেন্দ্র স্থানাঙ্ক ফেরত দিন
            end
        end
    end
    
    warn("Holon HUB: আপনার প্লট পাওয়া যায়নি।")
    return nil
end

-- ■ 1. getMusicKeyboard ফাংশন সংশোধন (খেলনা তালিকার মতো অনুসন্ধান লজিক পরিবর্তন)
local function getMusicKeyboard()
    local myName = LocalPlayer.Name
    
    -- 1. SpawnedInToys থেকে খুঁজুন
    local spawnedToys = Workspace:FindFirstChild(myName .. "SpawnedInToys")
    if spawnedToys then
        local kb = spawnedToys:FindFirstChild("MusicKeyboard")
        if kb then return kb end
    end

    -- 2. Plots থেকে খুঁজুন
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
                    -- PlotItems ফোল্ডারের ভিতরে অনুসন্ধান করুন (startEffect উল্লেখ করে)
                    local myPlotItems = plotItems:FindFirstChild(plot.Name)
                    if myPlotItems then
                        local kb = myPlotItems:FindFirstChild("MusicKeyboard")
                        if kb then return kb end
                    end
                    -- Build এর ভিতরেও অনুসন্ধান করুন
                    local build = plot:FindFirstChild("Build")
                    local kb = build and build:FindFirstChild("MusicKeyboard")
                    if kb then return kb end
                end
            end
        end
    end

    -- 3. সম্পূর্ণ Workspace থেকে মালিকানাধীন MusicKeyboard খুঁজুন
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

-- পিয়ানো ফাংশনের জন্য ভেরিয়েবল (ফাংশনের আগে সংজ্ঞায়িত করা হয়েছে যাতে দৃশ্যমান হয়)
local pianoEnabled = false
local pianoFollowEnabled = true
local selectedSongFile = nil
local selectedSongData = nil
local pianoKeyboard = nil
local isPlayingSong = false
local pianoUpdateConnection = nil
local lastPianoCF = nil
local pianoOriginalCollisions = {}

-- পিয়ানোকে কোমরের সামনে অনুসরণ করানোর ফাংশন
local function setupPianoFollow()
    -- pianoKeyboard যদি nil হয়, আবার পান
    if not pianoKeyboard then pianoKeyboard = getMusicKeyboard() end
    if not pianoKeyboard then return end
    
    -- ইতিমধ্যে চলছে কিনা তা পরীক্ষা করুন
    if pianoUpdateConnection then return end

    -- ★সংশোধন: Main পার্ট খুঁজুন (না পাওয়া গেলে PrimaryPart)
    local mainPart = pianoKeyboard:FindFirstChild("Main", true) or pianoKeyboard.PrimaryPart
    if not mainPart then 
        warn("Holon HUB: পিয়ানোর প্রধান অংশ পাওয়া যায়নি")
        return 
    end
    print("Holon HUB: পিয়ানো সেটআপ শুরু হচ্ছে:", pianoKeyboard.Name)
    
    -- startEffect এর মতো প্রাথমিক সেটআপ
    for _, part in ipairs(pianoKeyboard:GetDescendants()) do
        if part:IsA("BasePart") then
            -- ★যোগ করা হয়েছে: মূল সংঘর্ষের বৈশিষ্ট্য সংরক্ষণ করুন
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
            -- নেটওয়ার্ক মালিকানা পান (startEffect এর পদ্ধতির সাথে মিল রেখে)
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

        -- মালিকানা বজায় রাখুন (startEffect এর পদ্ধতির সাথে মিল রেখে)
        if math.random() < 0.05 then
             pcall(function() pp:SetNetworkOwner(LocalPlayer) end)
        end

        local baseCF = root.CFrame
        local offset = CFrame.new(0, -1.5, -2) * CFrame.Angles(0, math.rad(180), 0)
        local targetCF = baseCF * offset
        ap.Position = targetCF.Position
        ao.CFrame = targetCF
    end)
    print("Holon HUB: পিয়ানো অনুসরণ শুরু হয়েছে")
end

-- পিয়ানো থামানো/মুক্ত করার ফাংশন
local function stopPiano()
    if pianoUpdateConnection then
        pianoUpdateConnection:Disconnect()
        pianoUpdateConnection = nil
    end
    if pianoKeyboard and pianoKeyboard.Parent then
        local pp = pianoKeyboard:FindFirstChild("Main", true) or pianoKeyboard.PrimaryPart
        if not pp then return end
        -- AlignPosition/Orientation মুছে ফেলুন
        for _, child in ipairs(pp:GetChildren()) do
            if child:IsA("Attachment") or child:IsA("AlignPosition") or child:IsA("AlignOrientation") then
                child:Destroy()
            end
        end
    end
    
    -- ★যোগ করা হয়েছে: সংঘর্ষের বৈশিষ্ট্য পুনরুদ্ধার করুন
    for part, canCollide in pairs(pianoOriginalCollisions) do
        if part and part.Parent then
            part.CanCollide = canCollide
        end
    end
    pianoOriginalCollisions = {} -- টেবিল পরিষ্কার করুন

    print("Holon HUB: পিয়ানো অনুসরণ বন্ধ হয়েছে")
end

-- পিয়ানো কী ম্যাপিং (ছবির লেআউটের সাথে মিলে যায়)
local pianoKeyMap = {
    -- সাদা কী
    ["1"] = "Key1C", ["2"] = "Key1D", ["3"] = "Key1E", ["4"] = "Key1F", 
    ["5"] = "Key1G", ["6"] = "Key1A", ["7"] = "Key1B", ["8"] = "Key2C",
    ["9"] = "Key2D", ["0"] = "Key2E", ["q"] = "Key2F", ["w"] = "Key2G",
    ["e"] = "Key2A", ["r"] = "Key2B", ["t"] = "Key3C",
    
    -- কালো কী
    ["f"] = "Key1Csharp", ["g"] = "Key1Dsharp", ["h"] = "Key1Fsharp",
    ["j"] = "Key1Gsharp", ["k"] = "Key1Asharp", ["l"] = "Key2Csharp",
    ["z"] = "Key2Dsharp", ["x"] = "Key2Fsharp", ["c"] = "Key2Gsharp",
    ["v"] = "Key2Asharp"
}

-- 1. পিয়ানো কী চাপার ফাংশন
local function pressPianoKey(keyName)
    -- প্রতিবার সরাসরি MusicKeyboard খুঁজুন
    local targetKeyboard = getMusicKeyboard()
    
    -- না পাওয়া গেলে প্রস্থান করুন
    if not targetKeyboard then return end

    local key = targetKeyboard:FindFirstChild(keyName, true)
    if key and key:IsA("BasePart") then
        -- নেটওয়ার্ক মালিক সেট করুন (সার্ভারকে জানান)
        SetNetworkOwner:FireServer(key, key.CFrame)
        
        -- নির্দিষ্ট অপেক্ষার সময়
        task.wait(0.15)
    end
end

-- 2. JSON থেকে গান চালানোর ফাংশন
local function playSongFromJSON(jsonData)
    if isPlayingSong then return end
    
    local songData
    local success, err = pcall(function()
        -- যদি এটি একটি স্ট্রিং হয়, ডিকোড করুন; যদি এটি একটি টেবিল হয়, তবে এটি ব্যবহার করুন
        if type(jsonData) == "string" then
            return HttpService:JSONDecode(jsonData)
        else
            return jsonData
        end
    end)
    
    if not success or type(err) ~= "table" then
        warn("JSON ডেটা লোড করতে ব্যর্থ হয়েছে")
        return
    end
    songData = err

    isPlayingSong = true
    print("পারফরম্যান্স শুরু হচ্ছে: " .. #songData .. " নোট")
    
    task.spawn(function()
        -- পারফরম্যান্স শুরু করার আগে একবার পিয়ানো খুঁজুন
        if not pianoKeyboard then pianoKeyboard = getMusicKeyboard() end
        
        for i, note in ipairs(songData) do
            -- শুধুমাত্র "বন্ধ" বোতাম টিপলে থামুন
            if not isPlayingSong then break end
            
            local rawKey = tostring(note.key)
            -- যদি JSON কী "Key" দিয়ে শুরু হয়, তবে রূপান্তর ছাড়াই এটি ব্যবহার করুন (ভুল রূপান্তর রোধ করতে)
            local keyName = rawKey
            if not string.match(rawKey, "^Key") then
                keyName = pianoKeyMap[rawKey] or rawKey
            end
            
            local delayTime = note.delay or 0.1
            
            -- পরীক্ষার মতো একই প্রক্রিয়া ব্যবহার করে চাপুন
            task.spawn(function()
                pressPianoKey(keyName)
            end)
            
            -- পরবর্তী নোট পর্যন্ত অপেক্ষা করুন
            task.wait(delayTime)
        end
        
        isPlayingSong = false
        print("পারফরম্যান্স শেষ হয়েছে")
    end)
end

-- গান প্লেব্যাক বন্ধ করুন
local function stopSong()
    isPlayingSong = false
end

--------------------------------------------------------------------------------
-- [ডেটা সংজ্ঞা] ভেক্টর পাথ / আকৃতি ডেটা
--------------------------------------------------------------------------------
local Paths = {
    -- বর্ণমালার জন্য সহজ স্ট্রোক ডেটা (A-Z, স্পেস)
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
    -- Merkaba কঠিন শীর্ষবিন্দু
    Merkaba = { 
        Vector3.new(1,1,1),Vector3.new(-1,-1,1),Vector3.new(-1,1,-1),Vector3.new(1,-1,-1),
        Vector3.new(1,1,1),Vector3.new(-1,-1,-1),Vector3.new(1,1,-1),Vector3.new(1,-1,1),
        Vector3.new(-1,1,1),Vector3.new(-1,-1,-1) 
    },
    -- পেন্টাগ্রাম
    Star = (function() local t={}; for i=0,5 do local a=math.rad(i*144+90); table.insert(t, Vector2.new(math.cos(a),math.sin(a))) end; return t end)(),
    -- বৃত্ত
    Circle = (function() local t={}; for i=0,20 do local a=math.rad(i*18); table.insert(t, Vector2.new(math.cos(a),math.sin(a))) end; return t end)(),
    MagicCircle2 = (function()
        local t = {}
        -- বাইরের বড় বৃত্ত
        for i = 0, 36 do
            local a = math.rad(i * 10)
            table.insert(t, Vector2.new(math.cos(a) * 2, math.sin(a) * 2))
        end
        -- মাঝের বৃত্ত
        for i = 0, 24 do
            local a = math.rad(i * 15)
            table.insert(t, Vector2.new(math.cos(a) * 1.5, math.sin(a) * 1.5))
        end
        -- ভিতরের বৃত্ত
        for i = 0, 18 do
            local a = math.rad(i * 20)
            table.insert(t, Vector2.new(math.cos(a), math.sin(a)))
        end
        return t
    end)(),
    
    MagicCircle3 = (function()
        local t = {}
        -- মাল্টি-লেয়ার বৃত্ত কাঠামো
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
-- [কনফিগারেশন এবং ভেরিয়েবল ব্যবস্থাপনা]
--------------------------------------------------------------------------------
local defaultConfig = {
    Wing = { Size = 30, Gap = 3.0, Speed = 6, Height = 0.5, Back = 0, Joints = 3, V_Angle = 0, Tilt = 0, Strength = 15, RootFixed = true }, -- RootFixed যোগ করা হয়েছে
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

-- ডিপ কপি হেল্পার
local function deepCopy(target)
    local copy = {}
    for k, v in pairs(target) do copy[k] = (type(v) == "table") and deepCopy(v) or v end
    return copy
end

local selectedItemName = "সব খেলনা" 
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
local isReturningToPlot = false -- প্লটে ফিরে আসার ফ্ল্যাগ (গুরুত্বপূর্ণ)

local espCache = {}
local espCfg = { Enabled = false, Names = true, Tracers = false, Hitbox = false, HitboxSize = 10, ESPColor = Color3.new(1, 0, 0), TargetOnly = false }

-- খেলোয়াড় সেটিং ভেরিয়েবল
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
-- [গণনা লজিক] প্রতিটি মোডের জন্য স্থানাঙ্ক গণনা
--------------------------------------------------------------------------------
local function getPositionForMode(mode, i, count, time)
    local c = cfg[mode] or cfg.Wing
    
    -- i হল 1 থেকে count পর্যন্ত। অনুপাত গণনা করুন।
    local ratio = (i-1) / (count > 1 and count-1 or 1)
    
    if mode == "Wing" then
    local side, idx, totalSide

    if combinedActive then
        -- [যৌথ মোড]
        -- i হল সামগ্রিক ক্রমিক সংখ্যা (1,2,3,4...), তাই শুধু বিজোড়/জোড় দ্বারা ভাগ করুন
        side = (i % 2 == 1) and -1 or 1 -- 1->বাম(-1), 2->ডান(1)
        idx = math.ceil(i / 2)          -- ১ম, ২য় হল ১ম স্তর, ৩য়, ৪র্থ হল ২য় স্তর...
        totalSide = math.ceil(count / 2)
    else
        -- [একক মোড]
        -- নিজস্ব অংশের মধ্যে ক্রমানুসারে সাজান
        side = (i % 2 == 1) and -1 or 1
        idx = math.ceil(i / 2)
        totalSide = math.ceil(count / 2)
    end

    -- পরবর্তী গণনাগুলি সাধারণ
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
        -- একটি সুন্দর পেন্টাগ্রাম আঁকার লজিক (রৈখিক ইন্টারপোলেশন)
        local totalPoints = 10 -- 5টি শীর্ষবিন্দু + 5টি উপত্যকা
        -- অ্যানিমেশন অগ্রগতি
        local cycle = (time * c.Speed * 0.2 + ratio) % 1
        local currentStep = cycle * totalPoints
        
        local idx1 = math.floor(currentStep)
        local idx2 = (idx1 + 1) % totalPoints
        local alpha = currentStep % 1 -- দুটি বিন্দুর মধ্যে কোথায় আছে

        -- তারা শীর্ষবিন্দু স্থানাঙ্ক গণনা করার স্থানীয় ফাংশন
        local function getStarPoint(i)
            -- 36 ডিগ্রি দ্বারা ঘোরান, +90 ডিগ্রি শীর্ষবিন্দুকে উপরে আনতে
            local theta = math.rad(i * 36 + 90) 
            -- জোড় সংখ্যাগুলি বাইরের (Size), বিজোড় সংখ্যাগুলি ভিতরের (Size * 0.382 -> সোনালী অনুপাতের কাছাকাছি তীক্ষ্ণতা)
            local r = (i % 2 == 0) and c.Size or (c.Size * 0.382)
            -- X উল্টানো ঘড়ির কাঁটার দিকে/বিপরীত দিকে ঘূর্ণন সামঞ্জস্য করতে পারে (এখানে এটি যেমন আছে)
            return Vector2.new(-math.cos(theta) * r, math.sin(theta) * r)
        end

        local p1 = getStarPoint(idx1)
        local p2 = getStarPoint(idx2)
        
        -- গোলাকারতা দূর করতে, দুটি গণনাকৃত বিন্দুর মধ্যে একটি সরল রেখা দিয়ে সংযুক্ত করুন (Lerp)
        local p = p1:Lerp(p2, alpha)

        -- এটিকে হার্ট মোডের মতো একই অভিযোজন করুন (উল্লম্ব)
        -- X=প্রস্থ, Y=উচ্চতা, Z=গভীরতা(স্থির)
        return Vector3.new(p.X, p.Y + c.Height, c.Back)
        
    elseif mode == "Vortex" then
        -- সমতল ঘূর্ণি
        local spiral = (i / count) * math.pi * 4 + time * c.Speed
        local dist = (i / count) * c.Size
        
        local x = math.cos(spiral) * dist
        local z = math.sin(spiral) * dist
        
        return Vector3.new(x, c.Height, z + c.Back)
        
    elseif mode == "Sphere" then
        -- গোলক স্থাপন
        local phi = math.acos(-1 + (2 * i) / count)
        local theta = math.sqrt(count * math.pi) * phi + time * c.Speed
        
        local x = c.Size * math.cos(theta) * math.sin(phi)
        local y = c.Size * math.sin(theta) * math.sin(phi)
        local z = c.Size * math.cos(phi)
        
        return Vector3.new(x, y + c.Height, z + c.Back)

    elseif mode == "Rotate" or mode == "MagicCircle" then
    -- ঘোরান/বাগুয়া: তারা বা বৃত্ত
    local shape = (mode == "MagicCircle" and (i % 2 == 0)) and Paths.Star or Paths.Circle
    local speed = c.Speed
    local totalPoints = #shape
    
    -- ★সম্পূর্ণ পুনর্লিখন
    local cycle = (time * speed * 0.1 + ratio) % 1
    local currentStep = cycle * totalPoints
    
    local idx1 = math.floor(currentStep) % totalPoints + 1
    local idx2 = (math.floor(currentStep) + 1) % totalPoints + 1
    local alpha = currentStep % 1
    
    -- নিরাপদ Lerp
    local p1 = shape[idx1]
    local p2 = shape[idx2]
    if not p1 or not p2 then return Vector3.zero end
    
    local p = p1:Lerp(p2, alpha)
    
    -- Y-অক্ষ ঘূর্ণন যোগ করুন
    local rotAngle = time * speed * 0.3
    local rotX = p.X * math.cos(rotAngle) - p.Y * math.sin(rotAngle)
    local rotY = p.X * math.sin(rotAngle) + p.Y * math.cos(rotAngle)
    
    return Vector3.new(rotX * c.Size, c.Height, rotY * c.Size + c.Back)

elseif mode == "MagicCircle2" then
    -- চিত্র 1 এর মতো রেডিয়াল ম্যাজিক সার্কেল
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
    
    -- Y-অক্ষ ঘূর্ণন
    local rotAngle = time * c.Speed * 0.2
    local rotX = p.X * math.cos(rotAngle) - p.Y * math.sin(rotAngle)
    local rotZ = p.X * math.sin(rotAngle) + p.Y * math.cos(rotAngle)
    
    -- উপরে এবং নিচে ঢেউ
    local wave = math.sin(time * c.Speed + i * 0.5) * 0.5
    
    return Vector3.new(rotX * c.Size, c.Height + wave, rotZ * c.Size + c.Back)

elseif mode == "MagicCircle3" then
    -- চিত্র 2 এর মতো উল্লম্ব বিম-স্টাইল ম্যাজিক সার্কেল
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
    
    -- ধীর ঘূর্ণন
    local rotAngle = time * c.Speed * 0.1
    local rotX = p.X * math.cos(rotAngle) - p.Y * math.sin(rotAngle)
    local rotZ = p.X * math.sin(rotAngle) + p.Y * math.cos(rotAngle)
    
    return Vector3.new(rotX * c.Size, c.Height, rotZ * c.Size + c.Back)

    elseif mode == "Pet" then
        -- সেটিংস থেকে বিভিন্ন প্যারামিটার পান
        local petCountSetting = cfg.Pet.Count or 2
        local totalFws = count -- মোট উপলব্ধ আতশবাজি
        
        -- পোষা প্রাণী প্রতি আতশবাজি গণনা করুন
        local fwsPerPet = math.floor(totalFws / petCountSetting)
        if fwsPerPet < 1 then fwsPerPet = 1 end

        -- বর্তমান আতশবাজি (i) কোন পোষা প্রাণী এবং কোন অংশ নম্বর
        local petIndex = math.ceil(i / fwsPerPet)
        local partIndexInPet = (i - 1) % fwsPerPet 
        
        -- নির্দিষ্ট সংখ্যক পোষা প্রাণীর অতিরিক্ত আতশবাজি লুকান
        if petIndex > petCountSetting then
            return Vector3.new(0, -1000, 0)
        end

        -- অংশের ভূমিকা বরাদ্দ (0:শরীর, 1:বাম ডানা, 2:ডান ডানা)
        local role = 0 
        local sideIndex = 0
        if partIndexInPet == 0 then
            role = 0 -- প্রথমটি শরীর
        elseif partIndexInPet <= math.ceil((fwsPerPet - 1) / 2) then
            role = 1 -- বাম ডানা
            sideIndex = partIndexInPet
        else
            role = 2 -- ডান ডানা
            sideIndex = partIndexInPet - math.ceil((fwsPerPet - 1) / 2)
        end

        -- পোষা প্রাণী স্থাপন নিজেই (ব্যবধান সামঞ্জস্য করতে Gap ব্যবহার করুন)
        local petSide = (petIndex % 2 == 0) and 1 or -1
        local horizontalOffset = (c.Gap or 5) + (math.floor((petIndex - 1) / 2) * 8)
        
        -- সাধারণ ভাসমান নড়াচড়া
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
            -- ডানা গণনা
            local wingSide = (role == 1) and -1 or 1
            
            -- ★এখানে ঠিক করুন: ডানার বিস্তারে (প্রস্থ) সরাসরি c.Size প্রতিফলিত করুন
            -- sideIndex (ডানার মধ্যে অংশ নম্বর) এর অনুপাতে c.Size দ্বারা ছড়িয়ে পড়ে
            local wingSpread = (sideIndex * (c.Size * 0.1)) 
            
            local flapPhase = time * c.Speed * 3 - (sideIndex * 0.3)
            local flap = math.sin(flapPhase) * 2
            
            local jointFactor = (c.Joints or 3) * 0.2
            
            return basePos + Vector3.new(
                wingSide * (1 + jointFactor + wingSpread), -- c.Size এখানে প্রয়োগ করা হয়েছে
                flap * (1 + jointFactor),
                -0.5 + (sideIndex * 0.1)
            )
        end

    elseif mode == "FloatStone" then
        -- গণনায় অ্যানিমেশন থেকে "বিশৃঙ্খলা মোতায়েন" আন্দোলন প্রবর্তন করুন
        local rTime = time * cfg[mode].Speed
        local spread = cfg[mode].Size
        
        -- একাধিক সাইন তরঙ্গ একত্রিত করে অনিয়মিত গতিপথ তৈরি করুন
        local x = math.cos(rTime + i * 1.5) * spread
        local y = math.sin(rTime * 0.7 + i) * (spread * 0.5) + cfg[mode].Height
        local z = math.sin(rTime * 1.2 + i * 2.2) * spread + cfg[mode].Back
        
        return Vector3.new(x, y, z)

-- [টেক্সট মোড গণনা লজিক উদ্ধৃতি] 

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
        
        -- অ্যানিমেশন গণনা
        local totalPoints = #path
        local speed = math.max(1, math.floor(c.Speed)) * 0.5
        local cycle = (time * speed + (i % fwsPerChar) * 0.1) % 2 
        local tP = (cycle < 1) and (cycle * (totalPoints - 1)) or ((2 - cycle) * (totalPoints - 1))
        local idx1 = math.floor(tP) + 1
        local idx2 = math.min(idx1 + 1, totalPoints)
        local p = path[idx1]:Lerp(path[idx2] or path[idx1], tP % 1)
        
        -- ★ স্বয়ংক্রিয় অক্ষর ব্যবধান সামঞ্জস্য
        -- সেট করুন যাতে আকার (c.Size) বাড়ার সাথে সাথে ব্যবধানও বাড়ে
        local charSizeScale = c.Size * 0.4
        local spacing = c.Size * 1.2 -- 1.2x ব্যবধানের সাথে স্বয়ংক্রিয় সামঞ্জস্য
        local totalWidth = (numChars - 1) * spacing
        
        -- স্থাপন গণনা (কোন উল্টানো নেই, সর্বদা সামনের দিকে মুখ করে)
        local xPos = p.X * charSizeScale * -1 -- অভিযোজন যেখানে অক্ষরের আকৃতি সঠিক দেখায়
        local yPos = p.Y * charSizeScale
        local xOffset = ((charIndex - 1) * spacing - (totalWidth / 2)) * -1
        
        return Vector3.new(xOffset + xPos, yPos + c.Height, -c.Back)

    elseif mode == "Merkaba" then
        -- Merkaba: 3D ঘূর্ণন
        local totalP = #Paths.Merkaba
        local tP = (time * c.Speed + ratio * totalP) % totalP
        local p1 = Paths.Merkaba[math.floor(tP) + 1]
        local p2 = Paths.Merkaba[(math.floor(tP) % totalP) + 1]
        
        local p = p1:Lerp(p2, tP % 1) * c.Size
        
        -- জটিল 3-অক্ষ ঘূর্ণন
        local rot = CFrame.Angles(time, time * 1.5, 0)
        return (rot * p) + Vector3.new(0, c.Height + math.sin(time * 2), c.Back)

    elseif mode == "Cube" then
        -- কিউব শীর্ষবিন্দু সংজ্ঞা
        local size = c.Size
        local v = {
            Vector3.new(size, size, size),      -- 1: উপরে-সামনে-ডান
            Vector3.new(-size, size, size),     -- 2: উপরে-সামনে-বাম
            Vector3.new(size, -size, size),     -- 3: নিচে-সামনে-ডান
            Vector3.new(-size, -size, size),    -- 4: নিচে-সামনে-বাম
            Vector3.new(size, size, -size),     -- 5: উপরে-পিছনে-ডান
            Vector3.new(-size, size, -size),    -- 6: উপরে-পিছনে-বাম
            Vector3.new(size, -size, -size),    -- 7: নিচে-পিছনে-ডান
            Vector3.new(-size, -size, -size)    -- 8: নিচে-পিছনে-বাম
        }

        -- ■ পরিবর্তন: "প্রান্ত" এর পরিবর্তে "ফেস (4-শীর্ষবিন্দু লুপ)" সংজ্ঞায়িত করুন
        local faces = {
            {v[1], v[2], v[4], v[3]}, -- সামনের লুপ
            {v[5], v[6], v[8], v[7]}, -- পিছনের লুপ
            {v[1], v[5], v[6], v[2]}, -- উপরের লুপ
            {v[3], v[7], v[8], v[4]}, -- নিচের লুপ
            {v[1], v[5], v[7], v[3]}, -- ডান লুপ
            {v[2], v[6], v[8], v[4]}  -- বাম লুপ
        }

        local numFaces = #faces
        
        -- 1. খেলনাগুলিকে ক্রমানুসারে 6টি ফেসে বরাদ্দ করুন
        local faceIdx = ((i - 1) % numFaces) + 1
        local currentFace = faces[faceIdx]

        -- 2. অগ্রগতি গণনা (লুপিং)
        local speed = c.Speed * 0.5 
        -- প্রতিটি খেলনার জন্য অবস্থান পরিবর্তন করে ওভারল্যাপিং প্রতিরোধ করুন (i * 0.25)
        local totalProgress = (time * speed) + (i * 0.25)
        
        -- 3. এটি কোন প্রান্তে (0-3) আছে এবং সেই প্রান্তের কোথায় (0.0-1.0)
        local edgeIndex = math.floor(totalProgress) % 4 + 1
        local nextEdgeIndex = (edgeIndex % 4) + 1 -- পরবর্তী শীর্ষবিন্দু
        local alpha = totalProgress % 1 -- প্রান্তে অগ্রগতি (0.0 -> 1.0)

        -- 4. স্থানাঙ্ক গণনা করুন
        local p1 = currentFace[edgeIndex]
        local p2 = currentFace[nextEdgeIndex]
        
        local pos = p1:Lerp(p2, alpha)
        
        return pos + Vector3.new(0, c.Height, c.Back)

    elseif mode == "MirrorPlayer" then
        local char = targetMain.Character
        if not char then return Vector3.new(0,0,0) end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return Vector3.new(0,0,0) end

        -- 1. R6 পার্ট সংজ্ঞা (আকার এবং নাম সেট করুন)
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
        
        -- লক্ষ্য অংশ সনাক্ত করুন
        local targetPart = char:FindFirstChild(data.name) or root

        -- 2. আকার এবং আকৃতি গণনা (এখানেই খেলনার আকৃতি তৈরি হয়)
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

        -- 3. 【এটি অবস্থান ঠিক করার জাদুকরী সূত্র】
        -- RootPart এর সাপেক্ষে আমার প্রতিটি অংশ কোথায় আছে তার অফসেট গণনা করুন
        -- PointToObjectSpace ব্যবহার করে, ইমোট ইত্যাদি দ্বারা স্থানান্তরিত অবস্থানগুলিও স্বয়ংক্রিয়ভাবে গণনা করা হয়
        local partRelativePos = root.CFrame:PointToObjectSpace(targetPart.Position)
        
        -- পিছনের দূরত্ব এবং উচ্চতা অফসেট
        local extraOffset = Vector3.new(0, c.Height, -c.Back)
        
        -- ঘূর্ণন তথ্য প্রয়োগ করুন (যদি অংশটি কাত হয়, খেলনার ফ্রেমটিও কাত হয়)
        local rotatedBoxPoint = (root.CFrame:Inverse() * targetPart.CFrame).Rotation * p

        -- সব যোগ করুন এবং ফেরত দিন
        -- [অংশ আপেক্ষিক অবস্থান] + [স্ট্রোক শীর্ষবিন্দু] + [ব্যবহারকারী সেটিং অফসেট]
        return partRelativePos + rotatedBoxPoint + extraOffset

    elseif mode == "Beam" then
        -- Y-দিক আলোর স্তম্ভ
        local ang = (i % c.Count) * (math.pi * 2 / c.Count)
        local radius = c.Size * 0.3
        
        -- বৃত্তাকার স্থাপন
        local x = math.cos(ang) * radius
        local z = math.sin(ang) * radius
        
        -- Y-অক্ষ উচ্চ-গতি প্রতিদান
        local yOsc = math.sin(time * c.Speed + (i / count) * math.pi * 2)
        local y = yOsc * c.Size
        
        return Vector3.new(x, y + c.Height, z + c.Back)

    elseif mode == "BackGuard" then
        local spread = c.Size
    
         -- প্রতিটি পাথরের জন্য এলোমেলো অবস্থান (একটি নির্দিষ্ট বীজের সাথে প্রজননযোগ্যতা নিশ্চিত করুন)
        local seed = i * 123.456
        local randomX = (math.sin(seed) * 2 - 1) * spread  -- বাম এবং ডানে ছড়িয়ে ছিটিয়ে
        local randomY = (math.cos(seed * 1.3) * 2 - 1) * (spread * 0.3) + c.Height  -- উপরে এবং নিচে ছড়িয়ে ছিটিয়ে
    
        -- পিছনে স্থাপন করা হয়েছে
        local backDistance = c.Back + math.abs(math.sin(seed * 0.7)) * spread * 0.5
    
        -- সূক্ষ্ম ভাসমান গতি
        local hover = math.sin(time * c.Speed + i * 0.5) * 0.5
    
        return Vector3.new(randomX, randomY + hover, -backDistance)
    end
    
    return Vector3.zero
end

--------------------------------------------------------------------------------
-- [প্রধান ফাংশন] প্রভাব নিয়ন্ত্রণ (শুরু / বন্ধ / আপডেট)
--------------------------------------------------------------------------------
local function stopEffect()
    isEnabled = false
    if updateConnection then 
        updateConnection:Disconnect()
        updateConnection = nil 
    end
    
    -- সংযুক্তি মুছুন এবং অ্যাঙ্কর করুন
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
    
    -- সংঘর্ষের বৈশিষ্ট্য পুনরুদ্ধার করুন
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

    -- 0. SpawnedInToys থেকে আইটেম পান (Cosmic স্টাইল)
    local spawnedToys = Workspace:FindFirstChild(myName .. "SpawnedInToys")
    if spawnedToys then
        for _, item in ipairs(spawnedToys:GetChildren()) do
            table.insert(allMyItems, item)
        end
    end

    -- 1. আমার প্লট থেকে আইটেম পান
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

    -- 2. সরাসরি Workspace থেকে আইটেম পান যা আমার মালিকানাধীন
    for _, item in ipairs(Workspace:GetChildren()) do
        local ownerValue = item:FindFirstChild("Owner") or item:FindFirstChild("PartOwner")
        if item:IsA("Model") and ownerValue and ownerValue:IsA("StringValue") and ownerValue.Value == myName and not table.find(allMyItems, item) then
             table.insert(allMyItems, item)
        end
    end

    -- 3. নির্বাচনের উপর ভিত্তি করে আইটেম ফিল্টার করুন এবং fws এ যোগ করুন
    for _, item in ipairs(allMyItems) do
        if #fws >= maxCount then break end
        if item:IsA("Model") and item.PrimaryPart and (selectedItemName == "সব খেলনা" or item.Name == selectedItemName) then
            table.insert(fws, item)
        end
    end

    -- 4. সমস্ত পাওয়া আইটেমের জন্য নেটওয়ার্ক মালিকানা নিশ্চিত করুন
    for _, item in ipairs(fws) do
        for _, part in ipairs(item:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() part:SetNetworkOwner(LocalPlayer) end)
            end
        end
    end

    if #fws == 0 then
        warn("কোন খেলনা পাওয়া যায়নি।")
        return
    end

        print(#fws .. " খেলনা ক্যাপচার করা হয়েছে। (লক্ষ্য: " .. maxCount .. ")")

   -- জোরপূর্বক নেটওয়ার্ক মালিকানা পান
    for i, model in ipairs(fws) do
        local pp = model.PrimaryPart
        
        -- সমস্ত অংশের গতিবেগ মেরে ফেলুন
        for _, d in ipairs(model:GetDescendants()) do 
            if d:IsA("BasePart") then
                d.AssemblyLinearVelocity = Vector3.zero
                d.AssemblyAngularVelocity = Vector3.zero
                pcall(function() d:SetNetworkOwner(LocalPlayer) end)
            end
        end
        
        -- শুরুতে বিস্ফোরণ রোধ করতে, গণনাকৃত প্রাথমিক অবস্থানে সরাসরি স্থাপন করুন
        if root then
            local m = combinedActive and (i <= (cfg.Combined.Mode1Count or 15) and cfg.Combined.Mode1 or cfg.Combined.Mode2) or currentMode
            local count = #fws -- প্রাপ্ত খেলনার মোট সংখ্যা
            local relIdx = (combinedActive and i > (cfg.Combined.Mode1Count or 15)) and (i - (cfg.Combined.Mode1Count or 15)) or i
            local relTotal = combinedActive and (i <= (cfg.Combined.Mode1Count or 15) and (cfg.Combined.Mode1Count or 15) or (count - (cfg.Combined.Mode1Count or 15))) or count
            
            -- শুরুর অবস্থান গণনা করতে getPositionForMode ব্যবহার করুন
            local relativePos = getPositionForMode(m, relIdx, relTotal, tick())
            pp.CFrame = root.CFrame:ToWorldSpace(CFrame.new(relativePos))
        end
        
        pp.Anchored = false -- স্থাপন শেষ হওয়ার পরে পদার্থবিদ্যা সক্ষম করুন
        pcall(function() pp:SetNetworkOwner(LocalPlayer) end)

        -- সংঘর্ষ অক্ষম করুন
        for _, d in ipairs(model:GetDescendants()) do 
            if d:IsA("BasePart") then 
                if originalCollisions[d] == nil then originalCollisions[d] = d.CanCollide end
                d.CanCollide = false
                d.CanTouch = false
                d.CanQuery = false
            end 
        end
        
        -- (সংযুক্তি এবং AlignPosition সেটিংস যেমন আছে তেমনই থাকে...)
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
        -- অনুসরণ চালু: সর্বদা বেস হিসাবে খেলোয়াড়ের সর্বশেষ স্থানাঙ্ক ব্যবহার করুন
        baseCF = rootPart.CFrame
        lastBaseCF = baseCF
    else
        -- অনুসরণ বন্ধ: যদি lastBaseCF বিদ্যমান থাকে, তবে এটি "অবশ্যই" ব্যবহার করুন
        if not lastBaseCF then
            lastBaseCF = rootPart.CFrame
        end
        baseCF = lastBaseCF
    end

    local t = tick()
    local individualRotation = CFrame.Angles(0, math.rad(GLOBAL_ANGLE), 0)

    for i, fw in ipairs(activeToys) do
        -- অতল গহ্বর পরীক্ষা
        if fw.Part.Position.Y <= -90 then
            -- যদি অতল গহ্বরে পড়ে যায়, তবে এটি অ্যাঙ্কর করুন এবং কিছুই করবেন না
            fw.Part.Anchored = true
        else
            -- অতল গহ্বরে না থাকলে শুধুমাত্র সাধারণ প্রক্রিয়াকরণ সম্পাদন করুন (চালিয়ে যাওয়ার পরিবর্তে)
            fw.Part.Anchored = false

            -- অবস্থান গণনা
            local m = combinedActive and (i <= (cfg.Combined.Mode1Count or 15) and cfg.Combined.Mode1 or cfg.Combined.Mode2) or currentMode
            local count = #activeToys
            local relIdx = (combinedActive and i > (cfg.Combined.Mode1Count or 15)) and (i - (cfg.Combined.Mode1Count or 15)) or i
            local relTotal = combinedActive and (i <= (cfg.Combined.Mode1Count or 15) and (cfg.Combined.Mode1Count or 15) or (count - (cfg.Combined.Mode1Count or 15))) or count
            
            local relativePos = getPositionForMode(m, relIdx, relTotal, t)
            local worldPos = baseCF:PointToWorldSpace(relativePos)

            -- AlignPosition (পদার্থবিদ্যা) লক্ষ্য আপডেট করুন
            fw.AP.Position = worldPos

            -- ঘূর্ণন নিয়ন্ত্রণ
            if m == "BackGuard" then
                fw.AO.CFrame = CFrame.lookAt(worldPos, baseCF.Position) * individualRotation
            elseif m == "Rotate" or m == "MagicCircle" or m == "FloatStone" or m == "Merkaba" or m == "Cube" then
                local nextPos = baseCF:PointToWorldSpace(getPositionForMode(m, relIdx, relTotal, t + 0.05))
                fw.AO.CFrame = CFrame.lookAt(worldPos, nextPos) * individualRotation
            else
                fw.AO.CFrame = baseCF * individualRotation
            end
        end -- অতল গহ্বর পরীক্ষার সমাপ্তি
    end -- লুপের সমাপ্তি
end)
end

--------------------------------------------------------------------------------
-- [সাধারণ বেস পয়েন্ট রিটার্ন ফাংশন]
--------------------------------------------------------------------------------
local selectedHouseCF = nil 
local houseCoords = {
    ["চেরি ব্লসম হাউস"] = CFrame.new(548, 123, -73),
    ["হালকা নীল বাড়ি"] = CFrame.new(509, 83, -338),
    ["বেগুনি বাড়ি"] = CFrame.new(255, -7, 449),
    ["সবুজ বাড়ি"] = CFrame.new(-534, -7, 89),
    ["গোলাপী বাড়ি"] = CFrame.new(-485, -7, -163)
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
-- [ESP এবং উপ-বৈশিষ্ট্য] আপডেট লুপ (Prometheus সামঞ্জস্যপূর্ণ সংস্করণ)
--------------------------------------------------------------------------------
-- সাধারণ ক্লিনআপ ফাংশন (প্রস্থান বা লুকানো হলে ব্যবহৃত হয়)
local function removeESP(p)
    local esp = espCache[p]
    if esp then
        if esp.H then pcall(function() esp.H:Destroy() end) end
        if esp.B then pcall(function() esp.B:Destroy() end) end
        if esp.T then 
            pcall(function() 
                esp.T.Visible = false 
                esp.T:Remove() -- Drawing অবজেক্টগুলি Remove() দিয়ে সম্পূর্ণরূপে মুছে ফেলা হয়
            end) 
        end
        espCache[p] = nil
    end
end

-- খেলোয়াড় সার্ভার ছেড়ে গেলে অবিলম্বে কার্যকর করুন
Players.PlayerRemoving:Connect(removeESP)

local function updateSubFeatures()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local char = p.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")
            
            local shouldShow = false
            local isTarget = (not espCfg.TargetOnly) or (espCfg.TargetOnly and p == targetSub)
            
            -- যদি সেটিং সক্ষম থাকে, লক্ষ্য মিলে যায় এবং জীবিত থাকে
            if espCfg.Enabled and isTarget and root and hum and hum.Health > 0 then
                shouldShow = true
            end

            local esp = espCache[p] or {}
            
            if shouldShow then
                -- 1. হাইলাইট প্রক্রিয়াকরণ
                if not esp.H or esp.H.Parent ~= char then 
                    esp.H = Instance.new("Highlight")
                    esp.H.Parent = char
                    esp.H.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
                esp.H.Enabled = true
                esp.H.FillColor = espCfg.ESPColor

                -- 2. আইকন সহ নাম প্রদর্শন (URL বিন্যাস যা নির্ভরযোগ্যভাবে কাজ করে)
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
                    -- URL বিন্যাস ব্যবহার করুন যেখানে আইকন প্রদর্শিত হয়েছিল
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

                -- 3. ট্রেসার (উন্নত সংস্করণ)
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
                        -- অফ-স্ক্রিন ট্রেসার প্রক্রিয়াকরণ (প্রয়োজন না হলে দৃশ্যমান = মিথ্যা সেট করুন)
                        esp.T.Visible = false 
                    end
                elseif esp.T then
                    esp.T.Visible = false
                end

                -- 4. হিটবক্স
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
                -- আর প্রয়োজন না হলে অবিলম্বে পরিষ্কার করুন (প্রস্থান, মৃত্যু, সেটিং বন্ধ)
                removeESP(p)
                -- এছাড়াও হিটবক্স আকার পুনরুদ্ধার করুন
                if root and root.Parent then
                    root.Size = Vector3.new(2, 2, 1)
                    root.Transparency = 1
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(updateSubFeatures)

-- খেলোয়াড় ফাংশন লুপ
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
            -- CFrame দ্বারা আন্দোলন (Cosmic Hub উল্লেখ করে)
            local extraSpeed = math.max(0, walkSpeed - 16)
            root.CFrame = root.CFrame + (hum.MoveDirection * (extraSpeed * deltaTime))
        end
        if useJumpPower then 
            hum.UseJumpPower = true
            hum.JumpPower = jumpPower
            -- UseJumpPower জোরপূর্বক মিথ্যা সেট করা হলে প্রতিব্যবস্থা (JumpHeight ব্যবহার করুন)
            if not hum.UseJumpPower then
                hum.JumpHeight = jumpPower * 0.2 -- আনুমানিক
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
            -- Cosmic স্টাইল অ্যান্টি-গ্র্যাব লুপ
            local head = char:FindFirstChild("Head")
            local isHeldVal = LocalPlayer:FindFirstChild("IsHeld")
            local isHeld = (head and head:FindFirstChild("PartOwner")) or (isHeldVal and isHeldVal.Value)
            local struggleEvt = ReplicatedStorage:FindFirstChild("CharacterEvents") and ReplicatedStorage.CharacterEvents:FindFirstChild("Struggle")

            if isHeld then
                -- ধরে রাখার সময়, অ্যাঙ্কর করুন এবং প্রতিরোধ চালিয়ে যান
                for _, p in ipairs(char:GetChildren()) do
                    if p:IsA("BasePart") then p.Anchored = true end
                end
                
                if struggleEvt then
                    struggleEvt:FireServer(LocalPlayer) -- যুক্তি যোগ করুন
                end
            else
                -- যদি ধরে না রাখা হয়, এবং অ্যান্টি-বিস্ফোরণ (র্যাগডল) অবস্থায় না থাকে, তবে আনঅ্যাঙ্কর করুন
                local isRagdolled = antiExplosion and char:FindFirstChild("Humanoid") and char.Humanoid:FindFirstChild("Ragdolled") and char.Humanoid.Ragdolled.Value
                if not isRagdolled then
                    for _, p in ipairs(char:GetChildren()) do
                        if p:IsA("BasePart") then p.Anchored = false end
                    end
                end
            end
        end
    end

    -- নোক্লিপ
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

-- অ্যান্টি-বিস্ফোরণ (র্যাগডল অ্যাঙ্কর) এবং অ্যান্টি-ফায়ার (নির্বাপণ) লুপ ফিক্সড সংস্করণ
local extOriginalCFrame = nil
local extPart = nil

task.spawn(function()
    while true do
        task.wait(0.1)
        local char = LocalPlayer.Character
        if char then
            -- অ্যান্টি-বিস্ফোরণ: র্যাগডল অ্যাঙ্কর (ফিক্স: রিলিজ প্রক্রিয়া যোগ করুন)
            if antiExplosion then
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    local rag = hum:FindFirstChild("Ragdolled")
                    if rag and rag.Value then
                        -- র্যাগডল থাকা অবস্থায় অ্যাঙ্কর করুন
                        for _, p in ipairs(char:GetChildren()) do
                            if p:IsA("BasePart") then p.Anchored = true end
                        end
                    else
                        -- র্যাগডল রিলিজ হওয়ার পরে আনঅ্যাঙ্কর করুন (চলাচলের অনুমতি দিতে)
                        for _, p in ipairs(char:GetChildren()) do
                            if p:IsA("BasePart") then p.Anchored = false end
                        end
                    end
                end
            end

            -- অ্যান্টি-ফায়ার: নির্বাপণ অংশ (ফিক্স: বেগুনি বস্তুটি তার আসল অবস্থানে ফিরিয়ে দিন)
            if antiFire then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hasFire = hrp and (hrp:FindFirstChild("FireLight") or hrp:FindFirstChild("FireParticleEmitter"))
                
                -- অংশটি শুধুমাত্র একবার পান এবং সংরক্ষণ করুন
                if not extPart then
                    local map = Workspace:FindFirstChild("Map")
                    local hole = map and map:FindFirstChild("Hole")
                    local poison = hole and hole:FindFirstChild("PoisonBigHole")
                    extPart = poison and poison:FindFirstChild("ExtinguishPart")
                    if extPart then extOriginalCFrame = extPart.CFrame end
                end
                
                if extPart then
                    if hasFire then
                        -- আগুন থাকলে, নির্বাপণ অংশটি নিজের কাছে আনুন
                        extPart.CFrame = hrp.CFrame
                    elseif extOriginalCFrame then
                        -- আগুন নিভে গেলে, এটি তার আসল অবস্থানে ফিরিয়ে দিন (বেগুনি বস্তুটি লুকান)
                        extPart.CFrame = extOriginalCFrame
                    end
                end
            end
        end
    end
end)


--------------------------------------------------------------------------------
-- [সেটিংস] সংরক্ষণ, চেহারা
--------------------------------------------------------------------------------
-- --- সেটিংস লোড ফাংশন ---
-- রিয়েল-টাইমে কনফিগারেশন ফাইলের তালিকা পাওয়ার ফাংশন
local function getConfigFileList()
    local files = {}
    if not isfolder("holon_config") then makefolder("holon_config") end
    
    for _, file in ipairs(listfiles("holon_config")) do
        if file:sub(-5) == ".json" then
            -- ফাইলের নাম পেতে পথটি সরান
            local name = file:gsub("holon_config\\", ""):gsub("holon_config/", "")
            table.insert(files, name)
        end
    end
    if #files == 0 then table.insert(files, "কোন ফাইল নেই") end
    return files
end

-- 1. cfg-এ UI আইটেম না থাকলে ত্রুটি প্রতিরোধ করুন
if not cfg.UI then
    cfg.UI = {
        Transparency = 0.1,
        BackgroundColor = Color3.fromRGB(25, 25, 25),
        AccentColor = Color3.fromRGB(128, 128, 128),
        BackgroundImage = ""
    }
end

-- রিয়েল-টাইমে UI চেহারা প্রয়োগ করার ইঞ্জিন
local function applyCustomStyle()
    -- নিরাপত্তা পরীক্ষা: cfg.UI বিদ্যমান কিনা তা নিশ্চিত করুন (পোস্ট-লোডের জন্য)
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
            
            -- সমস্ত বংশধরদের জন্য পুনরাবৃত্তিমূলকভাবে শৈলী প্রয়োগ করুন
            for _, desc in ipairs(main:GetDescendants()) do
                -- 1. সীমানা (UIStroke)
                if desc:IsA("UIStroke") then
                    desc.Color = accent
                end
                -- 2. বিভাজক লাইন ("Line" নামের ফ্রেম)
                if desc:IsA("Frame") and desc.Name == "Line" then
                    desc.BackgroundColor3 = accent
                end
                -- 3. সাইডবার এবং টপবার
                if desc:IsA("Frame") and (desc.Name == "SideBar" or desc.Name == "TopBar") then
                    desc.BackgroundColor3 = bgColor
                    desc.BackgroundTransparency = trans
                    -- হেডারের কোণগুলি গোল করুন
                    if desc.Name == "TopBar" then
                        local corner = desc:FindFirstChild("UICorner") or Instance.new("UICorner", desc)
                        corner.CornerRadius = UDim.new(0, 9)
                    end
                end
                -- 4. বোতাম এবং ট্যাব (TextButton)
                -- শুধুমাত্র যদি এটি সম্পূর্ণ স্বচ্ছ না হয় তবে প্রয়োগ করুন (অদৃশ্য হিটবক্স দেখানো এড়াতে)
                if desc:IsA("TextButton") and desc.BackgroundTransparency < 1 then
                    desc.BackgroundColor3 = bgColor
                    desc.BackgroundTransparency = trans
                end
            end
            
            -- মেইন ফ্রেমের কোণগুলিও গোল করা নিশ্চিত করুন
            local mainCorner = main:FindFirstChild("UICorner") or Instance.new("UICorner", main)
            mainCorner.CornerRadius = UDim.new(0, 9)
        
        -- পটভূমি চিত্রের রিয়েল-টাইম প্রক্রিয়াকরণ
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
-- [UI নির্মাণ] orion lib
--------------------------------------------------------------------------------
local KeyFileName = "HolonHub_Key.txt"
local CorrectKey = "holox"
local OrionUrl = "https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/source.txt"

-- [[ 1. প্রধান স্ক্রিন ফাংশন ]]
local function StartHolonHUB()
    -- মোবাইল ফিক্স: ফাংশনের ভিতরে OrionLib পুনরায় লোড করুন
    local OrionLib = loadstring(game:HttpGet(OrionUrl))()
    
    -- বিদ্যমান UI জোরপূর্বক মুছুন (ডবল প্রদর্শন প্রতিরোধ করতে)
    pcall(function()
        if game:GetService("CoreGui"):FindFirstChild("Orion") then 
            game:GetService("CoreGui").Orion:Destroy() 
        end
    end)

    local Window = OrionLib:MakeWindow({
        Name = "Holon HUB v1.3.5 (BN)",
        HidePremium = false,
        SaveConfig = false, -- ইনিশিয়ালাইজেশনে হস্তক্ষেপ রোধ করতে অক্ষম করুন
        ConfigFolder = "HolonHUB",
        IntroEnabled = true,
        IntroText = "Holon HUB লোড হয়েছে!"
    })

-- খেলোয়াড় তালিকা পাওয়ার ফাংশন
local function getPList()
    local plist = {}
    for _, p in ipairs(Players:GetPlayers()) do
        -- "DisplayName (@Username)" বিন্যাসে টেবিলে রাখুন
        table.insert(plist, p.DisplayName .. " (@" .. p.Name .. ")")
    end
    return plist
end

-- UI উপাদানগুলি পরিচালনা করার জন্য টেবিল
local UIElements = {}

-- --- TAB: MAIN ---
local MainTab = Window:MakeTab({
	Name = "প্রধান",
	Icon = "rbxassetid://7733960981"
})

-- --- TAB: PLAYER ---
local PlayerTab = Window:MakeTab({
    Name = "খেলোয়াড়",
    Icon = "rbxassetid://7743875962"
})

local MoveSec = PlayerTab:AddSection({ Name = "চলাচল" })

-- বর্তমান স্থিতি ডিফল্ট হিসাবে সেট করুন
local currentWS = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")) and LocalPlayer.Character.Humanoid.WalkSpeed or 16
walkSpeed = currentWS

UIElements.WalkSpeedSlider = MoveSec:AddSlider({
    Name = "হাঁটার গতি", Min = 16, Max = 300, Default = currentWS, Increment = 1,
    Callback = function(v) walkSpeed = v end
})

UIElements.WalkSpeedToggle = MoveSec:AddToggle({
    Name = "হাঁটার গতি সক্ষম করুন", Default = false,
    Callback = function(v) 
        useWalkSpeed = v 
    end
})

UIElements.JumpPowerSlider = MoveSec:AddSlider({
    Name = "লাফানোর শক্তি", Min = 16, Max = 300, Default = 25, Increment = 1,
    Callback = function(v) jumpPower = v end
})

UIElements.JumpPowerToggle = MoveSec:AddToggle({
    Name = "লাফানোর শক্তি সক্ষম করুন", Default = false,
    Callback = function(v) 
        useJumpPower = v 
        if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = 25
        end
    end
})

UIElements.NoclipToggle = MoveSec:AddToggle({
    Name = "নোক্লিপ (Noclip)", Default = false,
    Callback = function(v) 
        noclip = v 
        if not v and LocalPlayer.Character then
            -- ফিক্স: সমস্ত অংশ CanCollide=true সেট করলে সমস্যা হয়, তাই শুধুমাত্র প্রধান অংশগুলি ফিরিয়ে আনুন
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
    Name = "অসীম লাফ", Default = false,
    Callback = function(v) infiniteJump = v end
})

local vflyEnabled = false
local vflySpeed = 1

UIElements.VFlyToggle = MoveSec:AddToggle({
    Name = "VFly (উড়া)",
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
    Name = "VFly গতি",
    Min = 1, Max = 10, Default = 1,
    Callback = function(v) vflySpeed = v end
})

local ProtectSec = PlayerTab:AddSection({ Name = "সুরক্ষা" })

UIElements.AntiExplosionToggle = ProtectSec:AddToggle({ Name = "বিস্ফোরণ বিরোধী", Default = false, Callback = function(v) antiExplosion = v end })
UIElements.AntiFireToggle = ProtectSec:AddToggle({ Name = "আগুন বিরোধী", Default = false, Callback = function(v) antiFire = v end })
UIElements.AntiGrabToggle = ProtectSec:AddToggle({ Name = "ধরা বিরোধী", Default = false, Callback = function(v) antiGrab = v end })

local gucciConn = nil
UIElements.AntiGucciToggle = ProtectSec:AddToggle({ 
    Name = "অ্যান্টি গুচি", 
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

local PlayerViewSec = PlayerTab:AddSection({ Name = "দৃশ্য/ক্যামেরা" })

UIElements.ThirdPersonToggle = PlayerViewSec:AddToggle({
    Name = "তৃতীয় ব্যক্তি",
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
    Name = "FOV (দৃষ্টির ক্ষেত্র)",
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
	Name = "প্রভাব নিয়ন্ত্রণ"
})

-- Main target dropdown (defined as a variable)
local targetMainName = "" -- New variable to store the name
local tpDropdown = nil

local pDropMain
UIElements.MainTargetDropdown = MainSec:AddDropdown({
    Name = "প্রধান লক্ষ্য",
    Default = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")",
    Options = getPList(),
    Callback = function(v)
        -- Accurately extract the username after @ (handles underscores, etc.)
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

-- Effect enable toggle
UIElements.EffectToggle = MainSec:AddToggle({
	Name = "প্রভাব সক্ষম করুন",
	Default = false,
	Callback = function(v)
		if v then startEffect() else stopEffect() end
	end    
})

-- Mode selection dropdown
UIElements.ModeDropdown = MainSec:AddDropdown({
	Name = "মোড নির্বাচন করুন",
	Default = "Wing",
	Options = {"Wing","Heart","Star","Vortex","Sphere","Rotate","Pet","Text","MagicCircle","MagicCircle2","MagicCircle3","FloatStone","Merkaba","Cube","MirrorPlayer","Beam","BackGuard"},
	Callback = function(v)
		currentMode = v
		combinedActive = false
	end    
})

-- Control target dropdown
local itemDropdown

UIElements.ItemDropdown = MainSec:AddDropdown({
    Name = "লক্ষ্য বস্তু নির্বাচন করুন",
    Default = "None",
    Options = {"None"},
    Callback = function(v)
        selectedItemName = v
    end    
})
itemDropdown = UIElements.ItemDropdown

-- Common function to scan toy list and update dropdown
local function refreshToyList()
    detectedItems = {}
    local myName = LocalPlayer.Name
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
                        -- ★Start monitoring this folder for changes (first time only)
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
    local newValues = {"সব খেলনা"}
    for _, name in ipairs(detectedItems) do table.insert(newValues, name) end
    itemDropdown:Refresh(newValues, true)
end

MainSec:AddButton({
    Name = "খেলনা তালিকা রিফ্রেশ করুন",
    Callback = function()
        refreshToyList()
        OrionLib:MakeNotification({ Name = "আপডেট", Content = "খেলনা তালিকা পুনরায় স্ক্যান করা হয়েছে", Time = 3 })
    end
})

-- Run once on startup
task.spawn(refreshToyList)

-- Combined mode toggle
UIElements.CombinedToggle = MainSec:AddToggle({
	Name = "যৌথ মোড ব্যবহার করুন",
	Default = false,
	Callback = function(v)
		combinedActive = v
	end    
})

-- --- Animation Section ---
local AnimSec = MainTab:AddSection({
	Name = "অ্যানিমেশন"
})

AnimSec:AddButton({
	Name = "রূপান্তর ক্রম",
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
	Name = "ঢেউ (Surge)",
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
    Name = "মোড সেটিংস",
    Icon = "rbxassetid://8997386997"
})

local CombineSec = ModeSetTab:AddSection({
    Name = "যৌথ সেটিংস"
})

UIElements.CombineMode1 = CombineSec:AddDropdown({
    Name = "যৌথ: মোড ১",
    Default = "Wing",
    Options = {"Wing","Heart","Star","Vortex","Sphere","Rotate","Pet","Text","MagicCircle","MagicCircle2","MagicCircle3","FloatStone","Merkaba","Cube","MirrorPlayer","Beam","BackGuard"},
    Callback = function(v) cfg.Combined.Mode1 = v end
})

UIElements.CombineMode1Count = CombineSec:AddSlider({
    Name = "মোড ১ সংখ্যা",
    Min = 1,
    Max = 200,
    Default = 20,
    Increment = 1,
    ValueName = "items",
    Callback = function(v) cfg.Combined.Mode1Count = v end    
})

UIElements.CombineMode2 = CombineSec:AddDropdown({
    Name = "যৌথ: মোড ২",
    Default = "Rotate",
    Options = {"Wing","Heart","Star","Vortex","Sphere","Rotate","Pet","Text","MagicCircle","MagicCircle2","MagicCircle3","FloatStone","Merkaba","Cube","MirrorPlayer","Beam","BackGuard"},
    Callback = function(v) cfg.Combined.Mode2 = v end
})

UIElements.CombineMode2Count = CombineSec:AddSlider({
    Name = "মোড ২ সংখ্যা",
    Min = 1,
    Max = 200,
    Default = 10,
    Increment = 1,
    ValueName = "items",
    Callback = function(v) cfg.Combined.Mode2Count = v end    
})

-- --- Common Settings Editor (switch with dropdown) ---
local EditSec = ModeSetTab:AddSection({
    Name = "সাধারণ সেটিংস সম্পাদক"
})

local modes = {"Wing","Heart","Star","Vortex","Sphere","Rotate","Pet","Text","MagicCircle", "MagicCircle2", "MagicCircle3", "FloatStone", "Merkaba", "Cube", "MirrorPlayer", "Beam", "BackGuard"}

local currentEditMode = "Wing"
local sl_Speed, sl_Size, sl_Height, sl_Back

EditSec:AddDropdown({
    Name = "লক্ষ্য মোড সম্পাদনা করুন",
    Default = "Wing",
    Options = modes,
    Callback = function(v)
        currentEditMode = v
        -- Update slider values
        if sl_Speed then sl_Speed:Set(cfg[v].Speed or 10) end
        if sl_Size then sl_Size:Set(cfg[v].Size or 10) end
        if sl_Height then sl_Height:Set(cfg[v].Height or 0) end
        if sl_Back then sl_Back:Set(cfg[v].Back or 0) end
    end
})

sl_Speed = EditSec:AddSlider({
    Name = "গতি", Min = 0, Max = 100, Default = cfg.Wing.Speed or 10,
    Callback = function(v) cfg[currentEditMode].Speed = v end
})
sl_Size = EditSec:AddSlider({
    Name = "আকার/প্রস্থ", Min = 1, Max = 150, Default = cfg.Wing.Size or 10,
    Callback = function(v) cfg[currentEditMode].Size = v end
})
sl_Height = EditSec:AddSlider({
    Name = "উচ্চতা", Min = -50, Max = 50, Default = cfg.Wing.Height or 0,
    Callback = function(v) cfg[currentEditMode].Height = v end
})
sl_Back = EditSec:AddSlider({
    Name = "গভীরতা", Min = -50, Max = 50, Default = cfg.Wing.Back or 0,
    Callback = function(v) cfg[currentEditMode].Back = v end
})

-- --- Advanced Settings Tab (unique settings only) ---
local AdvTab = Window:MakeTab({
    Name = "উন্নত",
    Icon = "rbxassetid://7733771472"
})

for _, m in ipairs(modes) do
    -- Create sections only for modes with unique settings
    if m == "Wing" or m == "Pet" or m == "Text" or m == "MagicCircle2" or m == "MagicCircle3" or m == "MirrorPlayer" or m == "Beam" or m == "FloatStone" then
        local s = AdvTab:AddSection({ Name = m })
        
        if m == "Wing" then
            s:AddToggle({ Name = "অ্যাঙ্কর রুট (রুট ফিক্সড)", Default = cfg.Wing.RootFixed, Callback = function(v) cfg.Wing.RootFixed = v end })
            s:AddSlider({ Name = "শরীর থেকে দূরত্ব (ফাঁক)", Min = 0, Max = 50, Default = cfg.Wing.Gap or 10, Callback = function(v) cfg.Wing.Gap = v end })
            s:AddSlider({ Name = "জয়েন্টগুলি", Min = 0, Max = 10, Default = 3, Callback = function(v) cfg.Wing.Joints = v end })
            s:AddSlider({ Name = "V-কোণ (সামনে/পিছনে)", Min = -180, Max = 180, Default = 0, Callback = function(v) cfg.Wing.V_Angle = v end })
            s:AddSlider({ Name = "উল্লম্ব ঝোঁক", Min = -90, Max = 90, Default = 0, Callback = function(v) cfg.Wing.Tilt = v end })
            s:AddSlider({ Name = "ঝাপটানোর শক্তি", Min = 0, Max = 50, Default = 15, Callback = function(v) cfg.Wing.Strength = v end })
        
        elseif m == "Pet" then
            s:AddSlider({ Name = "গণনা", Min = 1, Max = 10, Default = 2, Callback = function(v) cfg.Pet.Count = v end })
            s:AddSlider({ Name = "জয়েন্টগুলি (Wiggle)", Min = 0, Max = 10, Default = 3, Callback = function(v) cfg.Pet.Joints = v end })
            s:AddSlider({ Name = "অনুভূমিক বিস্তার (ফাঁক)", Min = 1, Max = 20, Default = 13, Callback = function(v) cfg.Pet.Gap = v end })
        
        elseif m == "Text" then
            s:AddTextbox({ Name = "টেক্সট প্রদর্শন করুন", Default = "HELLO", TextDisappear = false, Callback = function(v) cfg.Text.Content = v end })
        
        elseif m == "MagicCircle2" then
            s:AddSlider({ Name = "স্তর", Min = 1, Max = 5, Default = 3, Callback = function(v) cfg.MagicCircle2.Layers = v end })
        
        elseif m == "MagicCircle3" then
            s:AddSlider({ Name = "জটিলতা", Min = 1, Max = 10, Default = 5, Callback = function(v) cfg.MagicCircle3.Complexity = v end })
        
        elseif m == "MirrorPlayer" then
            -- Orion has trouble with decimals, so display as 10x
            s:AddSlider({ Name = "স্কেল (x10)", Min = 1, Max = 100, Default = 10, Callback = function(v) cfg.MirrorPlayer.Scale = v/10 end })
            s:AddSlider({ Name = "বক্সের আকার (x10)", Min = 5, Max = 100, Default = 20, Callback = function(v) cfg.MirrorPlayer.Size = v/10 end })
            s:AddSlider({ Name = "প্রান্তের ব্যবধান ঘনত্ব (x10)", Min = 5, Max = 30, Default = 10, Callback = function(v) cfg.MirrorPlayer.EdgeSpacing = v/10 end })
        
        elseif m == "Beam" then
            s:AddSlider({ Name = "বিম গণনা", Min = 1, Max = 20, Default = 8, Callback = function(v) cfg.Beam.Count = v end })
        
        elseif m == "FloatStone" then
            s:AddToggle({ Name = "বিশৃঙ্খলা আন্দোলন", Default = false, Callback = function(v) cfg.FloatStone.Chaos = v end })
        end
    end
end

-- --- TAB: CONFIG / SETTINGS ---
local ConfigTab = Window:MakeTab({
    Name = "গ্লোবাল/সংরক্ষণ",
    Icon = "rbxassetid://10734950309"
})

local GlobalSec = ConfigTab:AddSection({
    Name = "সিস্টেম"
})

-- 1. Follow toggle
UIElements.FollowToggle = GlobalSec:AddToggle({
    Name = "খেলোয়াড় অনুসরণ করুন",
    Default = true,
    Callback = function(v)
        followPlayer = v
    end
})

-- 0,0,0 reset button
GlobalSec:AddButton({
    Name = "ওয়ার্ল্ড ০,০,০ এ প্রভাব রিসেট করুন",
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
    Name = "খেলনার অভিযোজন",
    Min = -180, Max = 180, Default = -90,
    Callback = function(v) GLOBAL_ANGLE = v end
})

UIElements.MaxToysSlider = GlobalSec:AddSlider({
    Name = "সর্বোচ্চ খেলনা ব্যবহার",
    Min = 1, Max = 200, Default = cfg.Global.MaxToys or 100,
    Callback = function(v) cfg.Global.MaxToys = v end
})

UIElements.AutoWidthToggle = GlobalSec:AddToggle({
    Name = "স্বয়ংক্রিয় প্রস্থ",
    Default = true,
    Callback = function(v) autoWidth = v end
})

-- Animation speed multiplier (processed as 10x for decimals)
UIElements.AnimSpeedSlider = GlobalSec:AddSlider({
    Name = "অ্যানিমেশন গতি",
    Min = 1, Max = 50, Default = 10,
    Callback = function(v) cfg.AnimSpeed = v/10 end
})

-- --- Home Time Limit Reset Settings ---
local ResetSec = ConfigTab:AddSection({
    Name = "হোম সময় সীমা রিসেট"
})

ResetSec:AddParagraph("বিবরণ","থাকার সময় রিসেট করতে নির্দিষ্ট বাড়িতে পর্যায়ক্রমে ফিরে যান।")

UIElements.PlotReturnToggle = ResetSec:AddToggle({
    Name = "স্বয়ংক্রিয় রিসেট সক্ষম করুন",
    Default = cfg.PlotReturn.Enabled,
    Callback = function(v)
        cfg.PlotReturn.Enabled = v
    end
})

UIElements.PlotReturnInterval = ResetSec:AddSlider({
    Name = "বিরতি (সেকেন্ড)",
    Min = 10, Max = 85, 
    -- Safe way to write
    Default = (cfg and cfg.PlotReturn and cfg.PlotReturn.Interval) or 30,
    Callback = function(v) 
        if cfg and cfg.PlotReturn then 
            cfg.PlotReturn.Interval = v 
        end 
    end
})

-- "Select House to Return to", "Sub Tab", and "Piano" below this
-- will finally be loaded.

UIElements.PlotReturnHouse = ResetSec:AddDropdown({
    Name = "ফিরে যাওয়ার জন্য বাড়ি নির্বাচন করুন",
    Default = "None",
    Options = {"চেরি ব্লসম হাউস", "হালকা নীল বাড়ি", "বেগুনি বাড়ি", "সবুজ বাড়ি", "গোলাপী বাড়ি"},
    Callback = function(v)
        selectedHouseCF = houseCoords[v]
        if selectedHouseCF then
            OrionLib:MakeNotification({
                Name = "সেটআপ সম্পূর্ণ",
                Content = v .. " কে রিসেট পয়েন্ট হিসেবে সেট করা হয়েছে",
                Time = 5
            })
        end
    end
})

-- --- Coordinate Management System ---
local CoordSec = ConfigTab:AddSection({
    Name = "স্থানাঙ্ক/অবস্থান ব্যবস্থাপনা"
})

local CoordHUD = nil
local HUDLabel = nil

CoordSec:AddToggle({
    Name = "সর্বদা একটি পৃথক উইন্ডোতে স্থানাঙ্ক প্রদর্শন করুন",
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
    Name = "বর্তমান স্থানাঙ্ক অনুলিপি করুন",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            local p = root.Position
            local posString = string.format("%d, %d, %d", math.round(p.X), math.round(p.Y), math.round(p.Z))
            setclipboard(posString)
            OrionLib:MakeNotification({
                Name = "অনুলিপি সম্পূর্ণ",
                Content = posString,
                Time = 5
            })
        end
    end
})

----- Data Management ---
local SaveSec = ConfigTab:AddSection({Name = "ডেটা ব্যবস্থাপনা (রিয়েল-টাইম আপডেট)"})

-- 1. Define dropdown as a variable (to change its content later)
local fileDropdown

fileDropdown = SaveSec:AddDropdown({
    Name = "সংরক্ষিত ফাইল নির্বাচন করুন",
    Default = "অনুগ্রহ করে নির্বাচন করুন",
    Options = getConfigFileList(),
    Callback = function(v) 
        selectedFile = v 
    end
})

-- 2. Load button (updates appearance instantly on load)
SaveSec:AddButton({
    Name = "নির্বাচিত ফাইল লোড করুন",
    Callback = function()
        if selectedFile and selectedFile ~= "কোন ফাইল নেই" then
            local path = "holon_config/" .. selectedFile
            if isfile(path) then
                local success, data = pcall(function() 
                    return HttpService:JSONDecode(readfile(path)) 
                end)
                
                if success then
                    cfg = data
                    
                    -- Restore local variables from saved settings
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
                        
                        -- ★Update UI appearance (Use Set method)
                        if UIElements.WalkSpeedSlider then UIElements.WalkSpeedSlider:Set(walkSpeed) end
                        if UIElements.WalkSpeedToggle then UIElements.WalkSpeedToggle:Set(useWalkSpeed) end
                        if UIElements.JumpPowerSlider then UIElements.JumpPowerSlider:Set(jumpPower) end
                        if UIElements.JumpPowerToggle then UIElements.JumpPowerToggle:Set(useJumpPower) end
                        if UIElements.NoclipToggle then UIElements.NoclipToggle:Set(noclip) end
                        if UIElements.InfiniteJumpToggle then UIElements.InfiniteJumpToggle:Set(infiniteJump) end
                        if UIElements.AntiExplosionToggle then UIElements.AntiExplosionToggle:Set(antiExplosion) end
                        if UIElements.AntiFireToggle then UIElements.AntiFireToggle:Set(antiFire) end
                        if UIElements.AntiGrabToggle then UIElements.AntiGrabToggle:Set(antiGrab) end
                        if UIElements.AntiGucciToggle then UIElements.AntiGucciToggle:Set(false) end -- Off for safety
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
                        
                        -- ESP Settings
                        if UIElements.EspEnabled then UIElements.EspEnabled:Set(espCfg.Enabled) end
                        if UIElements.EspTargetOnly then UIElements.EspTargetOnly:Set(espCfg.TargetOnly) end
                        if UIElements.EspNames then UIElements.EspNames:Set(espCfg.Names) end
                        if UIElements.EspTracers then UIElements.EspTracers:Set(espCfg.Tracers) end
                        if UIElements.EspHitbox then UIElements.EspHitbox:Set(espCfg.Hitbox) end
                        if UIElements.EspHitboxSize then UIElements.EspHitboxSize:Set(espCfg.HitboxSize) end
                        if UIElements.EspColor then UIElements.EspColor:Set(espCfg.ESPColor) end
                        
                        -- Combined Settings
                        if UIElements.CombineMode1 then UIElements.CombineMode1:Set(cfg.Combined.Mode1) end
                        if UIElements.CombineMode1Count then UIElements.CombineMode1Count:Set(cfg.Combined.Mode1Count) end
                        if UIElements.CombineMode2 then UIElements.CombineMode2:Set(cfg.Combined.Mode2) end
                        if UIElements.CombineMode2Count then UIElements.CombineMode2Count:Set(cfg.Combined.Mode2Count) end
                        
                        -- Restore additional items
                        vflyEnabled = s.VFlyEnabled or false
                        vflySpeed = s.VFlySpeed or 1
                        local isThirdPerson = s.ThirdPerson or false
                        local savedFOV = s.FOV or 70
                        targetMainName = s.TargetMainName or ""
                        targetSubName = s.TargetSubName or ""
                        selectedItemName = s.SelectedItemName or "All Toys"
                        pianoEnabled = s.PianoEnabled or false
                        pianoFollowEnabled = s.PianoFollowEnabled or true

                        if UIElements.VFlyToggle then UIElements.VFlyToggle:Set(vflyEnabled) end
                        if UIElements.VFlySpeedSlider then UIElements.VFlySpeedSlider:Set(vflySpeed) end
                        if UIElements.ThirdPersonToggle then UIElements.ThirdPersonToggle:Set(isThirdPerson) end
                        if UIElements.FOVSlider then UIElements.FOVSlider:Set(savedFOV) end
                        if UIElements.ItemDropdown then UIElements.ItemDropdown:Set(selectedItemName) end
                        if UIElements.PianoEnabled then UIElements.PianoEnabled:Set(pianoEnabled) end
                        if UIElements.PianoFollow then UIElements.PianoFollow:Set(pianoFollowEnabled) end

                        -- Restore target dropdowns (search from list)
                        local function restoreDropdown(dd, name)
                            if dd and name ~= "" then
                                for _, opt in ipairs(getPList()) do
                                    if opt:match("@" .. name .. "%)") then dd:Set(opt) break end
                                end
                            end
                        end
                        restoreDropdown(UIElements.MainTargetDropdown, targetMainName)
                        restoreDropdown(UIElements.SubTargetDropdown, targetSubName)
                        
                        -- ★Restore UI Settings
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

                    -- ★Update UI appearance (color, transparency, image) in real-time here
                    applyCustomStyle() 
                    OrionLib:MakeNotification({Name = "সফল", Content = selectedFile .. " প্রয়োগ করা হয়েছে", Time = 3})
                else
                    OrionLib:MakeNotification({Name = "ত্রুটি", Content = "ফাইল লোড করতে ব্যর্থ হয়েছে", Time = 3})
                end
            end
        end
    end
})

SaveSec:AddTextbox({
    Name = "নতুন সংরক্ষণ ফাইলের নাম",
    Default = "config1",
    TextDisappear = false,
    Callback = function(v) saveName = v end
})

-- 3. Save button (updates dropdown instantly on save)
SaveSec:AddButton({
    Name = "বর্তমান সেটিংস সংরক্ষণ করুন",
    Callback = function()
        if saveName and saveName ~= "" then
            if not isfolder("holon_config") then makefolder("holon_config") end
            local path = "holon_config/" .. saveName .. ".json"
            
            -- Sync local variables to cfg before saving
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
                Esp = espCfg, -- Save ESP settings table
                -- Additional save items
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
            
            -- ★This is the key: update the dropdown list immediately after saving
            fileDropdown:Refresh(getConfigFileList(), true)
            
            OrionLib:MakeNotification({
                Name = "সংরক্ষণ সম্পূর্ণ", 
                Content = saveName .. ".json সংরক্ষণ করা হয়েছে এবং তালিকা আপডেট করা হয়েছে", 
                Time = 3
            })
        end
    end
})

-- --- UI Appearance Settings ---
local UISec = ConfigTab:AddSection({Name = "UI চেহারা/রঙ সেটিংস"})

UIElements.UITransparency = UISec:AddSlider({
    Name = "UI স্বচ্ছতা",
    Min = 0, Max = 100, Default = 0,
    Callback = function(v)
        cfg.UI.Transparency = v / 100
        applyCustomStyle()
    end
})

-- From here on, cfg.UI exists, so it will be displayed without disappearing
UIElements.UIBackgroundColor = UISec:AddColorpicker({
    Name = "পটভূমির রঙ",
    Default = cfg.UI.BackgroundColor,
    Callback = function(v)
        cfg.UI.BackgroundColor = v
        applyCustomStyle()
    end
})

UIElements.UIAccentColor = UISec:AddColorpicker({
    Name = "সীমানার রঙ (অ্যাকসেন্ট)",
    Default = cfg.UI.AccentColor,
    Callback = function(v)
        cfg.UI.AccentColor = v
        applyCustomStyle()
    end
})

UIElements.UIBackgroundImage = UISec:AddTextbox({
    Name = "পটভূমি চিত্র আইডি (শুধুমাত্র সংখ্যা)",
    Default = cfg.UI.BackgroundImage,
    TextDisappear = false,
    Callback = function(v)
        local numericId = v:match("%d+")
        
        if numericId then
            cfg.UI.BackgroundImage = "rbxassetid://" .. numericId
        else
            cfg.UI.BackgroundImage = ""
        end
        
        applyCustomStyle()
    end
})

-- --- TAB: SUB FEATURES ---
local SubTab = Window:MakeTab({
    Name = "উপ-বৈশিষ্ট্য",
    Icon = "rbxassetid://10747372167"
})

-- Sub-Target Section
local SubTargetSec = SubTab:AddSection({
    Name = "উপ-লক্ষ্য"
})

-- 1. Create dropdown
local targetSubName = "" 

UIElements.SubTargetDropdown = SubTargetSec:AddDropdown({
    Name = "লক্ষ্য নির্বাচন করুন",
    Default = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")",
    Options = getPList(),
    Callback = function(v)
        -- Accurately extract the username after @
        local name = v:match("@([^)]+)")
        targetSubName = name or LocalPlayer.Name
        
        -- Immediately get the latest object as well (for compatibility with existing code)
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
    Name = "খেলোয়াড় তালিকা রিফ্রেশ করুন",
    Callback = function()
        pDropSub:Refresh(getPList(), true)
        OrionLib:MakeNotification({ Name = "আপডেট", Content = "খেলোয়াড় তালিকা আপডেট করা হয়েছে", Time = 3 })
    end
})

-- View/Camera Section
local ViewSec = SubTab:AddSection({
    Name = "দৃশ্য/ক্যামেরা"
})

ViewSec:AddToggle({
    Name = "দর্শক (Spectate)",
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

-- ESP Settings Section
local EspSec = SubTab:AddSection({
    Name = "ESP সেটিংস"
})

UIElements.EspEnabled = EspSec:AddToggle({
    Name = "ESP সক্ষম করুন",
    Default = false,
    Callback = function(v) espCfg.Enabled = v end 
})

UIElements.EspTargetOnly = EspSec:AddToggle({
    Name = "শুধুমাত্র লক্ষ্য",
    Default = false,
    Callback = function(v) espCfg.TargetOnly = v end 
})

UIElements.EspNames = EspSec:AddToggle({
    Name = "নাম দেখান",
    Default = true,
    Callback = function(v) espCfg.Names = v end 
})

UIElements.EspTracers = EspSec:AddToggle({
    Name = "ট্রেসার দেখান",
    Default = false,
    Callback = function(v) espCfg.Tracers = v end 
})

UIElements.EspHitbox = EspSec:AddToggle({
    Name = "হিটবক্স",
    Default = false,
    Callback = function(v) espCfg.Hitbox = v end 
})

UIElements.EspHitboxSize = EspSec:AddSlider({
    Name = "হিটবক্স আকার",
    Min = 2,
    Max = 20,
    Default = 10,
    Callback = function(v) espCfg.HitboxSize = v end 
})

UIElements.EspColor = EspSec:AddColorpicker({
    Name = "ESP রঙ",
    Default = Color3.new(1,0,0),
    Callback = function(v)
        espCfg.ESPColor = v
    end	  
})

local BarrierSec = SubTab:AddSection({
    Name = "বাধা ভাঙা"
})

local destroyBarrier = false
UIElements.BarrierBreak = BarrierSec:AddToggle({
    Name = "বাড়ির বাধা ভাঙুন (WIP)",
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

local ActionSec = SubTab:AddSection({ Name = "ক্রিয়া" })

local tpTargetName = ""
tpDropdown = ActionSec:AddDropdown({
    Name = "টেলিপোর্ট লক্ষ্য",
    Default = "খেলোয়াড় নির্বাচন করুন",
    Options = getPList(),
    Callback = function(v)
        tpTargetName = v:match("@([^)]+)")
    end
})

ActionSec:AddButton({
    Name = "নির্বাচিত খেলোয়াড়ের কাছে টেলিপোর্ট করুন",
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
    Name = "ব্লবম্যান কিক (স্প্যাম করুন)",
    Default = false,
    Callback = function(v)
        levitateRunning = v
        if not v then return end

        local targetName = (tpTargetName ~= "" and tpTargetName) or (targetSub and targetSub.Name)
        local target = Players:FindFirstChild(targetName)
        
        if target and target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Find Blobman
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
                -- 1. Find Remotes (Cosmic spec)
                local scriptObj = blobman:FindFirstChild("BlobmanSeatAndOwnerScript")
                local grabRemote = scriptObj and scriptObj:FindFirstChild("CreatureGrab")
                local dropRemote = scriptObj and scriptObj:FindFirstChild("CreatureDrop")

                -- 2. Find Detector and Weld/Constraint (for both left/right)
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
                    OrionLib:MakeNotification({ Name = "কার্যকর করা হচ্ছে", Content = "ব্লবম্যান হোল্ড লুপ", Time = 3 })

                    task.spawn(function()
                        while levitateRunning and blobman and blobman.Parent do
                            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                                local tRoot = target.Character.HumanoidRootPart
                                
                                -- If not yet anchored (before capture), go capture
                                if blobman.PrimaryPart and not blobman.PrimaryPart.Anchored then
                                    -- 1. Force TP to Target
                                    blobman.PrimaryPart.Anchored = false
                                    blobman:SetPrimaryPartCFrame(tRoot.CFrame)
                                    
                                    -- 2. Grab with BOTH hands
                                    if lDet and lWeld then grabRemote:FireServer(lDet, tRoot, lWeld) end
                                    if rDet and rWeld then grabRemote:FireServer(rDet, tRoot, rWeld) end
                                    
                                    task.wait(0.1)
                                    
                                    -- 3. TP Up 100 studs & Stop
                                    blobman:SetPrimaryPartCFrame(tRoot.CFrame + Vector3.new(0, 100, 0))
                                    blobman.PrimaryPart.AssemblyLinearVelocity = Vector3.zero
                                    blobman.PrimaryPart.AssemblyAngularVelocity = Vector3.zero
                                    blobman.PrimaryPart.Anchored = true
                                else
                                    -- If already anchored, maintain grab state (resend just in case)
                                    if lDet and lWeld then grabRemote:FireServer(lDet, tRoot, lWeld) end
                                    if rDet and rWeld then grabRemote:FireServer(rDet, tRoot, rWeld) end
                                end
                            end
                            task.wait(0.05)
                        end
                        
                        -- Unanchor on exit
                        if blobman and blobman.PrimaryPart then
                            blobman.PrimaryPart.Anchored = false
                        end
                    end)
                else
                    -- Display detailed error content
                    local missing = {}
                    if not grabRemote then table.insert(missing, "CreatureGrab") end
                    if not dropRemote then table.insert(missing, "CreatureDrop") end
                    if not (lDet or rDet) then table.insert(missing, "Detector") end
                    if not (lWeld or rWeld) then table.insert(missing, "Weld/Constraint") end
                    OrionLib:MakeNotification({ Name = "ত্রুটি", Content = "অনুপস্থিত: " .. table.concat(missing, ", "), Time = 5 })
                end
            else
                OrionLib:MakeNotification({ Name = "ত্রুটি", Content = "ব্লবম্যান পাওয়া যায়নি (অনুগ্রহ করে একটি খেলনা স্পন করুন)", Time = 3 })
            end
        end
    end
})

-- --- TAB: PIANO ---
local PianoTab = Window:MakeTab({
	Name = "পিয়ানো",
	Icon = "rbxassetid://7734020554"
})

local PianoControlSec = PianoTab:AddSection({
	Name = "পিয়ানো নিয়ন্ত্রণ"
})

UIElements.PianoEnabled = PianoControlSec:AddToggle({
	Name = "পিয়ানো সক্ষম করুন",
	Default = false,
	Callback = function(v)
		pianoEnabled = v
		if v then
			-- Just enable the feature. Starting follow is left to the follow toggle.
			pianoKeyboard = getMusicKeyboard()
			
			if pianoKeyboard then
				-- Start only if follow is on
				if pianoFollowEnabled then setupPianoFollow() end

				OrionLib:MakeNotification({
					Name = "পিয়ানো বৈশিষ্ট্য",
					Content = "MusicKeyboard সনাক্ত হয়েছে",
					Time = 5
				})
			else
				pianoEnabled = false
				OrionLib:MakeNotification({
					Name = "ত্রুটি",
					Content = "MusicKeyboard পাওয়া যায়নি",
					Time = 5
				})
			end
		else
			stopSong()
			stopPiano() -- Stop follow
		end
	end    
})

UIElements.PianoFollow = PianoControlSec:AddToggle({
    Name = "খেলোয়াড় অনুসরণ করুন",
    Default = true,
    Callback = function(v)
        pianoFollowEnabled = v
        -- ★Fix: Also check if pianoKeyboard is valid (has a Parent)
        if pianoEnabled and pianoKeyboard and pianoKeyboard.Parent then
            if v then
                setupPianoFollow()
            else
                stopPiano()
            end
        -- ★Add: If follow is turned on while piano is invalid, re-search and start following
        elseif pianoEnabled and v then
            pianoKeyboard = getMusicKeyboard()
            if pianoKeyboard then
                setupPianoFollow()
            end
        end
    end
})

local PianoSongSec = PianoTab:AddSection({
	Name = "গান প্লেব্যাক"
})

-- Get JSON file list
local function getSongFiles()
	local files = {}
	local targetFolder = "FTAP_Notes"
	
    -- Safely check folder (use pcall to avoid stopping on error)
    local folderExists = false
    pcall(function()
        if isfolder and isfolder(targetFolder) then
            folderExists = true
        end
    end)

    if not folderExists then
        return {"ফোল্ডার পাওয়া যায়নি"}
    end
	
	local success, allFiles = pcall(function()
		return listfiles(targetFolder)
	end)
	
	if not success or not allFiles then
		return {"অ্যাক্সেস ত্রুটি"}
	end
	
	for _, filePath in ipairs(allFiles) do
		if filePath:lower():match("%.json$") then
			local fileName = filePath:match("([^/%\\]+)$") or filePath
			table.insert(files, fileName) -- Add only the name for Orion's Dropdown
		end
	end
	
	if #files == 0 then
		return {"কোন JSON ফাইল নেই"}
	end
	
	return files
end

local songDropdown = PianoSongSec:AddDropdown({
	Name = "গান নির্বাচন করুন",
	Default = "None",
	Options = getSongFiles(),
	Callback = function(v)
		if v == "None" or v == "ফোল্ডার পাওয়া যায়নি" or v == "কোন JSON ফাইল নেই" then
			selectedSongFile = nil
			selectedSongData = nil
			return
		end
		
		-- Create full path from filename (please adjust to your environment)
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
					Name = "লোড সম্পূর্ণ",
					Content = "নোট সংখ্যা: " .. #jsonData,
					Time = 5
				})
			else
				selectedSongData = nil
			end
		end
	end    
})

PianoSongSec:AddButton({
	Name = "গানের তালিকা রিফ্রেশ করুন",
	Callback = function()
		songDropdown:Refresh(getSongFiles(), true)
		OrionLib:MakeNotification({
			Name = "আপডেট সম্পূর্ণ",
			Content = "JSON ফাইল তালিকা আপডেট করা হয়েছে",
			Time = 5
		})
	end
})

PianoSongSec:AddButton({
    Name = "নির্বাচিত গান চালান",
    Callback = function()
        -- Make the piano enable check as lenient as the "Test button"
        if not pianoKeyboard then
            pianoKeyboard = getMusicKeyboard()
        end
        
        if not pianoKeyboard then
            OrionLib:MakeNotification({Name = "ত্রুটি", Content = "MusicKeyboard পাওয়া যায়নি", Time = 5})
            return
        end
        
        if not selectedSongData then
            OrionLib:MakeNotification({Name = "ত্রুটি", Content = "অনুগ্রহ করে একটি গান নির্বাচন করুন", Time = 5})
            return
        end
        
        -- ★Fix point: Pass the data as is, without JSONEncode
        -- This allows playSongFromJSON to start the loop correctly
        playSongFromJSON(selectedSongData)
        
        -- Notification to show the button has responded
        OrionLib:MakeNotification({
            Name = "অটো-প্লে",
            Content = "প্লেব্যাক শুরু হয়েছে",
            Time = 3
        })
    end
})

PianoSongSec:AddButton({
	Name = "প্লেব্যাক বন্ধ করুন",
	Callback = function()
		stopSong()
		OrionLib:MakeNotification({
			Name = "বন্ধ",
			Content = "গানের প্লেব্যাক বন্ধ হয়েছে",
			Time = 5
		})
	end
})

local PianoManualSec = PianoTab:AddSection({
    Name = "ম্যানুয়াল অপারেশন এবং টেস্টিং"
})

-- Added under PianoManualSec
PianoManualSec:AddButton({
    Name = "পরীক্ষা: C কী টিপুন",
    Callback = function()
        if pianoKeyboard then
            local testKey = pianoKeyboard:FindFirstChild("Key1C", true)
            if testKey then
                -- Command to play sound
                SetNetworkOwner:FireServer(testKey, testKey.CFrame)
                
                --   Make notification appear immediately after wait.
                task.wait(0.1)
                
                OrionLib:MakeNotification({
                    Name = "পরীক্ষা", 
                    Content = "Key1C বাজানো হয়েছে!", 
                    Time = 2
                })
            else
                warn("Key1C পাওয়া যায়নি")
            end
        end
    end
})

local DetailTab = Window:MakeTab({Name = "বিবরণ", Icon = DetailIcon})
AddDetailContent(DetailTab)

-- Notification (on startup)
OrionLib:MakeNotification({
	Name = "Holon HUB",
	Content = "Holon HUB v1.3.5 লোড হয়েছে!",
	Time = 5
})
    -- Apply UI style on startup
    applyCustomStyle()

    -- Main screen side initialization
    OrionLib:Init()
end

if isfile(KeyFileName) and readfile(KeyFileName) == CorrectKey then
    -- If authenticated, go straight to main
    StartHolonHUB()
else
    -- If not authenticated, create authentication UI
    local OrionLib = loadstring(game:HttpGet(OrionUrl))()
    
    local AuthWindow = OrionLib:MakeWindow({
        Name = "Holon HUB | কী সিস্টেম",
        HidePremium = true,
        IntroEnabled = false
    })

    local AuthTab = AuthWindow:MakeTab({Name = "প্রমাণীকরণ", Icon = "rbxassetid://7733919526"})
    local KeyInput = ""

    AuthTab:AddTextbox({
        Name = "কী লিখুন",
        Default = "",
        TextDisappear = false, -- Changed this to false
        Callback = function(Value) 
            KeyInput = Value 
        end     
    })

    AuthTab:AddButton({
        Name = "যাচাই করুন",
        Callback = function()
            if KeyInput == CorrectKey then
                writefile(KeyFileName, CorrectKey) -- Save here
                OrionLib:MakeNotification({Name = "সফল", Content = "শুরু হচ্ছে!", Time = 2})
                task.wait(1)
                pcall(function() game.CoreGui.Orion:Destroy() end)
                task.wait(0.5)
                StartHolonHUB()
            else
                OrionLib:MakeNotification({Name = "ব্যর্থতা", Content = "ভুল কী", Time = 5})
            end
        end
    })

    AuthTab:AddButton({
        Name = "কী পান (Discord)",
        Callback = function() setclipboard("https://discord.gg/EHBXqgZZYN") end
    })

    -- Details Tab
    local AuthDetailTab = AuthWindow:MakeTab({Name = "বিবরণ", Icon = DetailIcon})
    AddDetailContent(AuthDetailTab)
    
    OrionLib:Init()
end
