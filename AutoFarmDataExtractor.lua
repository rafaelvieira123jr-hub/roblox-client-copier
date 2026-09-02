--[[
    AUTO FARM DATA EXTRACTOR - Delta Executor
    Extrai: Remote Events, Posições, ReplicatedStorage, Dados úteis
    Objetivo: Criar scripts de auto farm
]]--

local DataExtractor = {}

-- ============================================
-- 1. EXTRAIR REMOTE EVENTS
-- ============================================
function DataExtractor:extractRemoteEvents()
    print("🔌 Extrahindo Remote Events...")
    
    local remoteEvents = {}
    
    -- Procurar em ReplicatedStorage
    for _, child in ipairs(game.ReplicatedStorage:GetDescendants()) do
        if child:IsA("RemoteEvent") then
            table.insert(remoteEvents, {
                name = child.Name,
                path = child:GetFullName(),
                type = "RemoteEvent"
            })
        end
    end
    
    -- Procurar em ReplicatedFirst
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
    
    -- Procurar por NPCs, inimigos, itens
    for _, child in ipairs(workspace:GetDescendants()) do
        if child:IsA("Model") or child:IsA("BasePart") then
            local name = child.Name:lower()
            
            -- Verificar se parece ser um NPC, inimigo, item, etc
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
    
    -- Procurar por StringValues, IntValues, etc
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
    
    -- Procurar por leaderstats
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
-- 7. EXTRAIR MODELOS (Para saber estrutura)
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
-- 8. GERAR RELATÓRIO
-- ============================================
function DataExtractor:generateReport(data)
    print("\n" .. string.rep("=", 60))
    print("📊 RELATÓRIO DE EXTRAÇÃO - AUTO FARM DATA")
    print(string.rep("=", 60) .. "\n")
    
    print("📋 RESUMO:")
    print("  🔌 Remote Events: " .. #data.remoteEvents)
    print("  🔧 Remote Functions: " .. #data.remoteFunctions)
    print("  📍 Posições encontradas: " .. #data.positions)
    print("  💾 Itens ReplicatedStorage: " .. #data.replicatedStorage)
    print("  🔢 Valores/Configs: " .. #data.values)
    print("  🏗️ Modelos: " .. #data.models)
    
    print("\n" .. string.rep("-", 60))
    print("🔌 REMOTE EVENTS:")
    for i, event in ipairs(data.remoteEvents) do
        if i <= 5 then print("  " .. i .. ". " .. event.name .. " (" .. event.path .. ")") end
    end
    if #data.remoteEvents > 5 then print("  ... e mais " .. (#data.remoteEvents - 5)) end
    
    print("\n" .. string.rep("-", 60))
    print("🔧 REMOTE FUNCTIONS:")
    for i, func in ipairs(data.remoteFunctions) do
        if i <= 5 then print("  " .. i .. ". " .. func.name .. " (" .. func.path .. ")") end
    end
    if #data.remoteFunctions > 5 then print("  ... e mais " .. (#data.remoteFunctions - 5)) end
    
    print("\n" .. string.rep("-", 60))
    print("📍 POSIÇÕES IMPORTANTES:")
    for i, pos in ipairs(data.positions) do
        if i <= 5 then print("  " .. i .. ". " .. pos.name .. " -> " .. pos.position) end
    end
    if #data.positions > 5 then print("  ... e mais " .. (#data.positions - 5)) end
    
    print("\n" .. string.rep("-", 60))
    print("👤 DADOS DO PLAYER:")
    print("  Nome: " .. data.playerData.name)
    print("  UserID: " .. data.playerData.userId)
    print("  Posição: " .. data.playerData.position)
    if next(data.playerData.leaderstats) then
        print("  Stats:")
        for stat, value in pairs(data.playerData.leaderstats) do
            print("    - " .. stat .. ": " .. value)
        end
    end
    
    print("\n" .. string.rep("=", 60))
    print("✅ EXTRAÇÃO CONCLUÍDA!")
    print(string.rep("=", 60) .. "\n")
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
    
    self:generateReport(data)
    
    return data
end

-- EXECUTAR
local extractedData = DataExtractor:extract()

print("\n💡 PRÓXIMO PASSO: Use as Remote Events e Posições acima para criar seu auto farm!")
print("   Exemplo: game.ReplicatedStorage:WaitForChild('NomeDaRemote'):FireServer(args)\n")
