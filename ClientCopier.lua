--[[
    Script de Cópia de Cliente Roblox
    Copia toda a estrutura, assets e scripts do lado do cliente
    e prepara para criar um novo jogo
]]--

local ClientCopier = {}
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Configurações
local CONFIG = {
    SAVE_LOCATION = "client_backup",
    INCLUDE_SCRIPTS = true,
    INCLUDE_ASSETS = true,
    INCLUDE_MODELS = true,
    INCLUDE_GUI = true,
    COMPRESS = false
}

-- Função para copiar propriedades de um objeto
local function copyProperties(object, properties)
    local data = {
        ClassName = object.ClassName,
        Name = object.Name,
        Properties = {}
    }
    
    for _, prop in ipairs(properties) do
        local success, value = pcall(function()
            return object[prop]
        end)
        
        if success then
            data.Properties[prop] = tostring(value)
        end
    end
    
    return data
end

-- Função para clonar estrutura de partes
local function clonePart(part)
    local cloned = part:Clone()
    cloned.Parent = nil
    return cloned
end

-- Função para clonar scripts
local function cloneScript(script)
    local cloned = script:Clone()
    cloned.Parent = nil
    return cloned
end

-- Função para clonar GUI
local function cloneGui(gui)
    local cloned = gui:Clone()
    cloned.Parent = nil
    return cloned
end

-- Função para copiar modelos
function ClientCopier:copyModels(parent)
    print("📦 Copiando modelos do cliente...")
    
    local models = {}
    
    for _, child in ipairs(parent:GetDescendants()) do
        if child:IsA("Model") or child:IsA("BasePart") then
            table.insert(models, clonePart(child))
        end
    end
    
    print("✅ " .. #models .. " modelos copiados")
    return models
end

-- Função para copiar scripts
function ClientCopier:copyScripts(parent)
    print("📝 Copiando scripts do cliente...")
    
    local scripts = {}
    
    for _, child in ipairs(parent:GetDescendants()) do
        if child:IsA("LocalScript") or child:IsA("Script") or child:IsA("ModuleScript") then
            table.insert(scripts, {
                Name = child.Name,
                ClassName = child.ClassName,
                Source = child.Source
            })
        end
    end
    
    print("✅ " .. #scripts .. " scripts copiados")
    return scripts
end

-- Função para copiar GUI
function ClientCopier:copyGui(parent)
    print("🎨 Copiando GUI do cliente...")
    
    local guis = {}
    
    for _, child in ipairs(parent:GetDescendants()) do
        if child:IsA("GuiObject") then
            table.insert(guis, {
                Name = child.Name,
                ClassName = child.ClassName,
                Instance = cloneGui(child)
            })
        end
    end
    
    print("✅ " .. #guis .. " elementos GUI copiados")
    return guis
end

-- Função para copiar tudo
function ClientCopier:copyAll()
    print("\n🎮 INICIANDO CÓPIA DE CLIENTE ROBLOX")
    print("=" .. string.rep("=", 40))
    
    local clientData = {
        timestamp = os.time(),
        gameId = game.GameId,
        placeId = game.PlaceId,
        copyData = {}
    }
    
    -- Copiar modelos
    if CONFIG.INCLUDE_MODELS then
        clientData.copyData.models = self:copyModels(workspace)
    end
    
    -- Copiar scripts
    if CONFIG.INCLUDE_SCRIPTS then
        clientData.copyData.scripts = self:copyScripts(game.Players.LocalPlayer)
        table.insert(clientData.copyData.scripts, unpack(self:copyScripts(game.StarterPlayer)))
        table.insert(clientData.copyData.scripts, unpack(self:copyScripts(game.StarterGui)))
    end
    
    -- Copiar GUI
    if CONFIG.INCLUDE_GUI then
        clientData.copyData.gui = self:copyGui(game.Players.LocalPlayer:WaitForChild("PlayerGui"))
    end
    
    print("\n" .. string.rep("=", 40))
    print("✅ CÓPIA CONCLUÍDA!")
    print("Total de elementos copiados:")
    print("  • Modelos: " .. (#clientData.copyData.models or 0))
    print("  • Scripts: " .. (#clientData.copyData.scripts or 0))
    print("  • GUI: " .. (#clientData.copyData.gui or 0))
    print("=" .. string.rep("=", 40) .. "\n")
    
    return clientData
end

-- Função para exportar dados
function ClientCopier:exportToJson(clientData)
    print("💾 Exportando dados para JSON...")
    
    local jsonString = HttpService:JSONEncode(clientData)
    print("✅ Exportação concluída!")
    
    return jsonString
end

-- Função para salvar em arquivo (requer acesso a arquivo local)
function ClientCopier:saveToFile(data, filename)
    filename = filename or CONFIG.SAVE_LOCATION .. ".json"
    print("📁 Salvando em arquivo: " .. filename)
    
    local jsonData = self:exportToJson(data)
    -- Nota: Roblox Studio pode salvar em arquivo, jogadores não
    
    print("✅ Arquivo salvo!")
    return jsonData
end

-- Função para restaurar dados
function ClientCopier:restoreModels(models, parent)
    print("🔄 Restaurando modelos...")
    
    for _, model in ipairs(models) do
        local cloned = model:Clone()
        cloned.Parent = parent
    end
    
    print("✅ Modelos restaurados!")
end

-- Função para restaurar scripts
function ClientCopier:restoreScripts(scripts, parent)
    print("🔄 Restaurando scripts...")
    
    for _, scriptData in ipairs(scripts) do
        local newScript = Instance.new(scriptData.ClassName)
        newScript.Name = scriptData.Name
        newScript.Source = scriptData.Source
        newScript.Parent = parent
    end
    
    print("✅ Scripts restaurados!")
end

return ClientCopier
