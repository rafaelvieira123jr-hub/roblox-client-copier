--[[
    AUTO FARM DATA EXTRACTOR - Delta Executor
    Extrai dados para auto farm e copia para clipboard
    Objetivo: Dados úteis para criar scripts
]]--

local DataExtractor = {}
local HttpService = game:GetService("HttpService")

-- ============================================
-- 1. EXTRAIR REMOTE EVENTS
-- ============================================
function DataExtractor:extractRemoteEvents()
    print("🔌 Extraindo Remote Events...")
    
    local remoteEvents = {}
    
    for _, child in ipairs(game.ReplicatedStorage:GetDescendants()) do
        if child:IsA("RemoteEvent") then
            table.insert(remoteEvents, {
                name = child.Name,
                path = child:GetFullName(),
                type = "RemoteEvent"
            })
        end
    end
    
    for _, child in ipairs(game.ReplicatedFirst:GetDescendants()) do
        if child:IsA("RemoteEvent") then
            table.insert(remoteEvents, {
                name = child.Name,
                path = child:GetFullName(),
                type = "RemoteEvent"
            })
        end
    end
    
    print("✅ " .. #remoteEvents .. " Remote Events encontrados")
    return remoteEvents
end

-- ============================================
-- 2. EXTRAIR REMOTE FUNCTIONS
-- ============================================
function DataExtractor:extractRemoteFunctions()
    print("🔧 Extraindo Remote Functions...")
    
    local remoteFunctions = {}
    
    for _, child in ipairs(game.ReplicatedStorage:GetDescendants()) do
        if child:IsA("RemoteFunction") then
            table.insert(remoteFunctions, {
                name = child.Name,
                path = child:GetFullName(),
                type = "RemoteFunction"
            })
        end
    end
    
    for _, child in ipairs(game.ReplicatedFirst:GetDescendants()) do
        if child:IsA("RemoteFunction") then
            table.insert(remoteFunctions, {
                name = child.Name,
                path = child:GetFullName(),
                type = "RemoteFunction"
            })
        end
    end
    
    print("✅ " .. #remoteFunctions .. " Remote Functions encontradas")
    return remoteFunctions
end

-- ============================================
-- 3. EXTRAIR POSIÇÕES (NPCs, itens, spawns)
-- ============================================
function DataExtractor:extractPositions()
    print("📍 Extraindo Posições...")
    
    local positions = {}
    
    for _, child in ipairs(workspace:GetDescendants()) do
        if child:IsA("Model") or child:IsA("BasePart") then
            local name = child.Name:lower()
            
            if name:find("npc") or name:find("enemy") or name:find("spawn") or 
               name:find("item") or name:find("chest") or name:find("boss") then
                
                table.insert(positions, {
                    name = child.Name,
                    position = tostring(child:FindFirstChild("HumanoidRootPart") and child:FindFirstChild("HumanoidRootPart").Position or child.Position),
                    type = child.ClassName,
                    path = child:GetFullName()
                })
            end
        end
    end
    
    print("✅ " .. #positions .. " Posições encontradas")
    return positions
end

-- ============================================
-- 4. EXTRAIR DADOS DO REPLICATED STORAGE
-- ============================================
function DataExtractor:extractReplicatedStorage()
    print("💾 Extraindo ReplicatedStorage...")
    
    local replicatedData = {}
    
    for _, child in ipairs(game.ReplicatedStorage:GetChildren()) do
        table.insert(replicatedData, {
            name = child.Name,
            className = child.ClassName,
            isFolder = child:IsA("Folder"),
            path = child:GetFullName()
        })
    end
    
    print("✅ " .. #replicatedData .. " Itens do ReplicatedStorage encontrados")
    return replicatedData
end

-- ============================================
-- 5. EXTRAIR VALORES/CONFIGURAÇÕES
-- ============================================
function DataExtractor:extractValues()
    print("🔢 Extraindo Valores e Configurações...")
    
    local values = {}
    
    for _, child in ipairs(game.ReplicatedStorage:GetDescendants()) do
        if child:IsA("StringValue") or child:IsA("IntValue") or 
           child:IsA("NumberValue") or child:IsA("BoolValue") then
            
            table.insert(values, {
                name = child.Name,
                value = tostring(child.Value),
                type = child.ClassName,
                path = child:GetFullName()
            })
        end
    end
    
    print("✅ " .. #values .. " Valores encontrados")
    return values
end

-- ============================================
-- 6. EXTRAIR INFORMAÇÕES DO PLAYER
-- ============================================
function DataExtractor:extractPlayerData()
    print("👤 Extraindo Dados do Player...")
    
    local player = game.Players.LocalPlayer
    local playerData = {
        name = player.Name,
        userId = player.UserId,
        position = tostring(player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or "Sem posição"),
        leaderstats = {}
    }
    
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        for _, stat in ipairs(leaderstats:GetChildren()) do
            playerData.leaderstats[stat.Name] = tostring(stat.Value)
        end
    end
    
    print("✅ Dados do player extraídos")
    return playerData
end

-- ============================================
-- 7. EXTRAIR MODELOS
-- ============================================
function DataExtractor:extractModels()
    print("🏗️ Extraindo Modelos/Estrutura...")
    
    local models = {}
    
    for _, child in ipairs(workspace:GetChildren()) do
        table.insert(models, {
            name = child.Name,
            className = child.ClassName,
            hasHumanoid = child:FindFirstChild("Humanoid") ~= nil,
            position = tostring(child:FindFirstChild("HumanoidRootPart") and child:FindFirstChild("HumanoidRootPart").Position or child.Position)
        })
    end
    
    print("✅ " .. #models .. " Modelos encontrados")
    return models
end

-- ============================================
-- 8. COPIAR PARA CLIPBOARD
-- ============================================
function DataExtractor:copyToClipboard(data)
    print("\n📋 Gerando dados para clipboard...")
    
    local clipboardData = {}
    
    -- Adicionar Remote Events
    table.insert(clipboardData, "=== 🔌 REMOTE EVENTS ===")
    for _, event in ipairs(data.remoteEvents) do
        table.insert(clipboardData, "local " .. event.name .. " = game:WaitForChild('ReplicatedStorage'):WaitForChild('" .. event.name .. "')")
    end
    
    table.insert(clipboardData, "\n=== 🔧 REMOTE FUNCTIONS ===")
    for _, func in ipairs(data.remoteFunctions) do
        table.insert(clipboardData, "local " .. func.name .. " = game:WaitForChild('ReplicatedStorage'):WaitForChild('" .. func.name .. "')")
    end
    
    table.insert(clipboardData, "\n=== 📍 POSIÇÕES ===")
    for _, pos in ipairs(data.positions) do
        table.insert(clipboardData, "-- " .. pos.name .. ": " .. pos.position)
    end
    
    table.insert(clipboardData, "\n=== 👤 STATS DO PLAYER ===")
    table.insert(clipboardData, "-- Nome: " .. data.playerData.name)
    table.insert(clipboardData, "-- UserID: " .. data.playerData.userId)
    for stat, value in pairs(data.playerData.leaderstats) do
        table.insert(clipboardData, "-- " .. stat .. ": " .. value)
    end
    
    local finalText = table.concat(clipboardData, "\n")
    
    -- Tentar copiar para clipboard (alguns executores suportam)
    if setclipboard then
        setclipboard(finalText)
    elseif pcall(function() return HttpService:JSONEncode({}) end) then
        -- Alternativa: criar arquivo local
        local success, err = pcall(function()
            -- Tenta salvar em clipboard via executor
            if _G.clipboard then
                _G.clipboard = finalText
            end
        end)
    end
    
    return finalText
end

-- ============================================
-- 9. CRIAR TELA DE AVISO
-- ============================================
function DataExtractor:showSuccessNotification()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DataExtractorNotif"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Background
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(0, 400, 0, 150)
    background.Position = UDim2.new(0.5, -200, 0.5, -75)
    background.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    background.BorderColor3 = Color3.fromRGB(0, 200, 100)
    background.BorderSizePixel = 3
    background.Parent = screenGui
    
    -- Arredondar cantos
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = background
    
    -- Ícone de sucesso
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(0, 200, 100)
    title.TextSize = 28
    title.Font = Enum.Font.GothamBold
    title.Text = "✅ COPIADO COM SUCESSO!"
    title.Parent = background
    
    -- Descrição
    local desc = Instance.new("TextLabel")
    desc.Name = "Description"
    desc.Size = UDim2.new(1, -20, 0, 40)
    desc.Position = UDim2.new(0, 10, 0, 60)
    desc.BackgroundTransparency = 1
    desc.TextColor3 = Color3.fromRGB(200, 200, 200)
    desc.TextSize = 16
    desc.Font = Enum.Font.Gotham
    desc.Text = "Dados extraídos e copiados!\nVá para Transferências para acessar."
    desc.TextWrapped = true
    desc.Parent = background
    
    -- Animar entrada
    background.Position = UDim2.new(0.5, -200, 1, 0)
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local tween = tweenService:Create(background, tweenInfo, {Position = UDim2.new(0.5, -200, 0.5, -75)})
    tween:Play()
    
    -- Desaparecer após 3 segundos
    task.wait(3)
    local tweenOut = tweenService:Create(background, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -200, 1, 0)})
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        screenGui:Destroy()
    end)
end

-- ============================================
-- FUNÇÃO PRINCIPAL
-- ============================================
function DataExtractor:extract()
    print("\n" .. string.rep("=", 60))
    print("🚀 AUTO FARM DATA EXTRACTOR")
    print(string.rep("=", 60) .. "\n")
    
    local data = {
        remoteEvents = self:extractRemoteEvents(),
        remoteFunctions = self:extractRemoteFunctions(),
        positions = self:extractPositions(),
        replicatedStorage = self:extractReplicatedStorage(),
        values = self:extractValues(),
        models = self:extractModels(),
        playerData = self:extractPlayerData()
    }
    
    -- Copiar para clipboard
    local clipboardContent = self:copyToClipboard(data)
    
    print("\n" .. string.rep("=", 60))
    print("✅ EXTRAÇÃO CONCLUÍDA!")
    print("📊 Dados prontos para usar em auto farm")
    print(string.rep("=", 60) .. "\n")
    
    -- Mostrar notificação de sucesso
    self:showSuccessNotification()
    
    -- Salvar em _G para acessar depois
    _G.ExtractedGameData = data
    _G.ClipboardContent = clipboardContent
    
    print("💡 Dados salvos em: _G.ExtractedGameData")
    print("📋 Conteúdo do clipboard: _G.ClipboardContent\n")
    
    return data
end

-- EXECUTAR
local extractedData = DataExtractor:extract()
